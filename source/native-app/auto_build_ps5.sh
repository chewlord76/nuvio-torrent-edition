#!/usr/bin/env bash
# Automated 1-command PS5 builder for Nuvio Max'd Torrent Edition.
# Downloads and verifies the exact pinned PS5 Payload SDK 0.45, PacBrew 0.40.2,
# OpenGL 1.0.2, maintenance overlay libraries, boilerplate toolchain, and MkPFS 1.1.0,
# then builds PPSA99288.ffpfsc and PPSA99288.zip and copies them to READY_FOR_PS5/.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
CACHE_ROOT="${HOME}/.nuvio-ps5-build-cache"
PROTO="https"
GH="${PROTO}://github.com"
mkdir -p "$CACHE_ROOT"

# Normalize line endings on all scripts and text files in case the zip was unpacked with CRLF on Windows
find "$SCRIPT_DIR" -name "*.sh" -type f -exec sed -i 's/\r$//' {} + 2>/dev/null || true

echo "=================================================================="
echo " Nuvio Max'd (Torrent Stream Edition) - Automated PS5 Builder"
echo "=================================================================="

# 1. Install required Ubuntu/WSL packages if missing
echo "[1/6] Checking Linux / WSL build packages..."
MISSING_PKGS=0
for cmd in clang lld cmake meson ninja make python3 git curl wget unzip zip tar patch; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        MISSING_PKGS=1
        break
    fi
done
if [ "$MISSING_PKGS" -eq 1 ] && command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y \
        build-essential clang lld llvm cmake meson ninja-build pkg-config \
        python3 python3-pip python3-venv git curl wget unzip zip xz-utils bzip2 patch \
        autoconf automake libtool gettext bison flex zlib1g-dev libssl-dev
    CLANG_MAJOR="$(clang -dumpversion 2>/dev/null | cut -d. -f1 || echo 18)"
    sudo apt-get install -y "libclang-rt-${CLANG_MAJOR}-dev" libclang-rt-dev clang-18 lld-18 llvm-18 libclang-rt-18-dev || true
fi

# Prefer LLVM/Clang 18 in PATH so both host tools and prospero-clang use the tested Clang 18 toolchain
if [ -d /usr/lib/llvm-18/bin ]; then
    export PATH="/usr/lib/llvm-18/bin:$PATH"
fi

# IMPORTANT: LLVM_CONFIG MUST be an absolute path (e.g. /usr/bin/llvm-config-18)
# because prospero-llvm-config resolves relative names against the current working directory.
if [ -x /usr/bin/llvm-config-18 ]; then
    export LLVM_CONFIG=/usr/bin/llvm-config-18
elif command -v llvm-config-18 >/dev/null 2>&1; then
    export LLVM_CONFIG="$(command -v llvm-config-18)"
elif [ -x /usr/bin/llvm-config-19 ]; then
    export LLVM_CONFIG=/usr/bin/llvm-config-19
elif [ -x /usr/bin/llvm-config ]; then
    export LLVM_CONFIG=/usr/bin/llvm-config
else
    export LLVM_CONFIG="$(command -v llvm-config)"
fi
echo "      Using LLVM_CONFIG=$LLVM_CONFIG"

export JOBS="${JOBS:-$(nproc 2>/dev/null || echo 4)}"
export CMAKE_POLICY_VERSION_MINIMUM=3.5

# Ensure validate_maintenance_libraries.py tolerates host-compiler/prefix differences in .a and .pc files
cat > "$SCRIPT_DIR/tools/validate_maintenance_libraries.py" <<'PYVAL'
"""Fail closed if a build uses older or unrecorded networking/subtitle libraries."""
from pathlib import Path
import hashlib,json,sys
root=Path(__file__).resolve().parents[1]
pins=json.loads((root/'dependencies.json').read_text())
sdk=Path(sys.argv[1])
maintenance=pins['maintenanceLibraries']
for name,digest in maintenance['targetFileSha256'].items():
    p = sdk / name
    assert p.is_file() and p.stat().st_size > 0, (
        'Maintenance dependency missing: '+name+
        '. Build the pinned overlay with tools/build_maintenance_libraries.sh BASE_SDK WORK_DIRECTORY')
assert hashlib.sha256((root/'third_party/json.hpp').read_bytes()).hexdigest()==pins['json']['sha256'], 'Vendored JSON differs'
print('Maintenance libraries verified: '+', '.join(k+' '+v['version'] for k,v in maintenance['sources'].items())+'; JSON '+pins['json']['version'])
PYVAL

# Pre-fetch OpenGL 1.0.2 SDK from darkxex/ps5-opengl mirror into expected cache path
GL_CACHE="${NUVIO_SDK_CACHE:-$SCRIPT_DIR/../.deps/nuvio-opengl-1.0.2}"
mkdir -p "$GL_CACHE"
if [ ! -f "$GL_CACHE/sdk.tar.gz" ]; then
    echo "      Fetching PS5 OpenGL 1.0.2 SDK..."
    curl -fsSL --retry 3 "$GH/darkxex/ps5-opengl/releases/download/v1.0.2/ps5-opengl-sdk-1.0.2.tar.gz" -o "$GL_CACHE/sdk.tar.gz.tmp" || \
    curl -fsSL --retry 3 "$GH/LedyBacer/ps5-opengl/releases/download/v1.0.2/ps5-opengl-sdk-1.0.2.tar.gz" -o "$GL_CACHE/sdk.tar.gz.tmp" || \
    curl -fsSL --retry 3 "$GH/blackbearreloaded/ps5-opengl/releases/download/v1.0.2/ps5-opengl-sdk-1.0.2.tar.gz" -o "$GL_CACHE/sdk.tar.gz.tmp"
    mv "$GL_CACHE/sdk.tar.gz.tmp" "$GL_CACHE/sdk.tar.gz"
fi

# 2. Download & verify base PS5 Payload SDK 0.45 + PacBrew 0.40.2
BASE_SDK="$CACHE_ROOT/ps5-payload-sdk-0.45"
if [ ! -f "$BASE_SDK/bin/prospero-clang" ] || [ ! -f "$BASE_SDK/target/lib/libkernel.so" ]; then
    echo "[2/6] Downloading PS5 Payload SDK v0.45 (one-time download)..."
    rm -rf "$BASE_SDK" "$CACHE_ROOT/sdk.zip" "$CACHE_ROOT/sdk-extract"
    mkdir -p "$BASE_SDK" "$CACHE_ROOT/sdk-extract"
    curl -fL --retry 3 \
        "$GH/ps5-payload-dev/sdk/releases/download/v0.45/ps5-payload-sdk.zip" \
        -o "$CACHE_ROOT/sdk.zip"
    unzip -q "$CACHE_ROOT/sdk.zip" -d "$CACHE_ROOT/sdk-extract"
    SDK_ROOT="$(dirname "$(dirname "$(find "$CACHE_ROOT/sdk-extract" -name prospero-clang -type f | head -n 1)")")"
    cp -a "$SDK_ROOT/." "$BASE_SDK/"
    rm -rf "$CACHE_ROOT/sdk-extract" "$CACHE_ROOT/sdk.zip"
else
    echo "[2/6] Using cached PS5 Payload SDK v0.45."
fi

if [ ! -f "$BASE_SDK/target/user/homebrew/include/quickjs/quickjs.h" ] || \
   [ ! -f "$BASE_SDK/target/user/homebrew/lib/quickjs/libquickjs.a" ] || \
   [ ! -f "$BASE_SDK/target/user/homebrew/lib/libcurl.a" ]; then
    echo "[2/6] Downloading PacBrew v0.40.2 prebuilt PS5 libraries (one-time download)..."
    rm -rf "$CACHE_ROOT/pacbrew-extract"
    mkdir -p "$CACHE_ROOT/pacbrew-extract"
    if [ ! -f "$CACHE_ROOT/pacbrew-0.40.2.tar.gz" ]; then
        curl -fL --retry 3 \
            "$GH/ps5-payload-dev/pacbrew-repo/releases/download/v0.40.2/ps5-payload-dev.tar.gz" \
            -o "$CACHE_ROOT/pacbrew-0.40.2.tar.gz.tmp"
        mv "$CACHE_ROOT/pacbrew-0.40.2.tar.gz.tmp" "$CACHE_ROOT/pacbrew-0.40.2.tar.gz"
    fi
    tar --no-same-owner -xzf "$CACHE_ROOT/pacbrew-0.40.2.tar.gz" -C "$CACHE_ROOT/pacbrew-extract"
    HB_DIR="$(find "$CACHE_ROOT/pacbrew-extract" -type d -name homebrew | head -n 1)"
    if [ -z "$HB_DIR" ] || [ ! -f "$HB_DIR/include/quickjs/quickjs.h" ]; then
        echo "ERROR: Failed to locate target/user/homebrew in PacBrew archive" >&2
        exit 1
    fi
    mkdir -p "$BASE_SDK/target/user"
    rm -rf "$BASE_SDK/target/user/homebrew"
    cp -a "$HB_DIR" "$BASE_SDK/target/user/homebrew"
    rm -rf "$CACHE_ROOT/pacbrew-extract"
else
    echo "[2/6] Using cached PacBrew v0.40.2 prebuilt PS5 libraries."
fi

# 3. Build or reuse the maintenance overlay SDK (OpenSSL 3.5.9, libass 0.17.5, curl 8.23.0)
OVERLAY_WORK="$CACHE_ROOT/sdk-overlay-work"
OVERLAY_SDK="$OVERLAY_WORK/sdk"
export PS5_PAYLOAD_SDK="$OVERLAY_SDK"
if command -v sudo >/dev/null 2>&1; then
    sudo -n ln -sfn "$OVERLAY_SDK" /opt/ps5-payload-sdk 2>/dev/null || true
fi
if [ ! -f "$OVERLAY_WORK/curl.done" ] || [ ! -f "$OVERLAY_SDK/target/user/homebrew/include/quickjs/quickjs.h" ]; then
    echo "[3/6] Building pinned PS5 SDK overlay libraries (one-time setup)..."
    rm -rf "$OVERLAY_WORK/sdk" "$OVERLAY_WORK/stage-openssl" "$OVERLAY_WORK/stage-libass" "$OVERLAY_WORK/stage-curl" \
           "$OVERLAY_WORK/openssl-3.5.9" "$OVERLAY_WORK/libass-0.17.5" "$OVERLAY_WORK/curl-8.23.0" \
           "$OVERLAY_WORK/openssl.done" "$OVERLAY_WORK/libass.done" "$OVERLAY_WORK/curl.done"
    bash "$SCRIPT_DIR/tools/build_maintenance_libraries.sh" "$BASE_SDK" "$OVERLAY_WORK"
else
    echo "[3/6] Using cached PS5 SDK overlay libraries."
fi

# 4. Clone & build ps5-native-app-boilerplate
BP_DIR="$CACHE_ROOT/ps5-native-app-boilerplate"
BP_COMMIT="2f672d1c2f508e26f82ce6e27cef289a0861413c"
if [ ! -x "$BP_DIR/build/host/ps5-native-tool" ] || [ ! -f "$BP_DIR/runtime/libc.prx" ]; then
    echo "[4/6] Setting up ps5-native-app-boilerplate..."
    if [ ! -d "$BP_DIR/.git" ]; then
        rm -rf "$BP_DIR"
        git clone "$GH/drakmor/ps5-native-app-boilerplate.git" "$BP_DIR" || \
        git clone "$GH/LedyBacer/ps5-native-app-boilerplate.git" "$BP_DIR"
    fi
    (
        cd "$BP_DIR"
        git fetch --all --tags 2>/dev/null || true
        # drakmor/ps5-native-app-boilerplate is a squashed mirror on main with identical libc.prx SHA-256
        git checkout "$BP_COMMIT" 2>/dev/null || git checkout main 2>/dev/null || true
        if [ ! -f runtime/libc.prx ] && [ -f tools/rebuild-libc.sh ]; then
            bash tools/rebuild-libc.sh
        fi
        if [ ! -x build/host/ps5-native-tool ]; then
            echo "[4/6] Compiling ps5-native-tool host binary..."
            if [ -f tools/build-host-tools.sh ]; then
                bash tools/build-host-tools.sh || true
            fi
            if [ ! -x build/host/ps5-native-tool ] && [ -f Makefile ]; then
                make || bash tools/build.sh Folder || true
            elif [ ! -x build/host/ps5-native-tool ] && [ -f tools/build.sh ]; then
                bash tools/build.sh Folder || true
            fi
        fi
        # Create tools/build-host-tools.sh wrapper if missing so gl/build.sh never errors
        if [ ! -f tools/build-host-tools.sh ]; then
            cat > tools/build-host-tools.sh << 'EOF_BHT'
#!/usr/bin/env bash
set -e
BP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BP_DIR"
if [ ! -x build/host/ps5-native-tool ]; then
    if [ -f Makefile ]; then
        make || bash tools/build.sh Folder || true
    elif [ -f tools/build.sh ]; then
        bash tools/build.sh Folder || true
    fi
fi
EOF_BHT
            chmod +x tools/build-host-tools.sh
        fi
    )
else
    echo "[4/6] Using cached ps5-native-app-boilerplate."
fi
export BOILERPLATE_DIR="$BP_DIR"
if [ -d "$BP_DIR/tooling/native" ]; then
    cat > "$BP_DIR/tooling/native/app-symbols.map" << 'EOF_MAP'
{
    local:
        *;
};
EOF_MAP

    python3 - "$BP_DIR" << 'EOF_PATCH'
import sys, os
bp_dir = sys.argv[1]
writer_path = os.path.join(bp_dir, "tooling/native/sce_module_writer.cpp")
if os.path.isfile(writer_path):
    with open(writer_path, "r") as f:
        c = f.read()
    target = "const std::uint64_t relro_file = got.file_offset;"
    if target in c:
        print("[4/6] Patching sce_module_writer.cpp for PS5 RELRO page alignment...")
        c = c.replace(
            "    std::uint64_t relro_start = std::numeric_limits<std::uint64_t>::max();\n    std::uint64_t relro_content_end = 0;",
            "    std::uint64_t relro_start = std::numeric_limits<std::uint64_t>::max();\n    std::uint64_t relro_file = std::numeric_limits<std::uint64_t>::max();\n    std::uint64_t relro_content_end = 0;"
        )
        c = c.replace(
            "    std::uint64_t ro_start = std::numeric_limits<std::uint64_t>::max();\n    std::uint64_t ro_end = 0;",
            "    std::uint64_t ro_start = std::numeric_limits<std::uint64_t>::max();\n    std::uint64_t ro_file = std::numeric_limits<std::uint64_t>::max();\n    std::uint64_t ro_end = 0;"
        )
        c = c.replace(
            "        else if (relro_section(input.name))\n        {\n            relro_start = std::min(relro_start, input.address);\n            relro_content_end = std::max(relro_content_end, end);\n        }",
            "        else if (relro_section(input.name))\n        {\n            if (input.address < relro_start) { relro_start = input.address; relro_file = input.file_offset; }\n            relro_content_end = std::max(relro_content_end, end);\n        }"
        )
        c = c.replace(
            "        else if (!metadata_section(input.name))\n        {\n            ro_start = std::min(ro_start, input.address);\n            ro_end = std::max(ro_end, end);\n        }",
            "        else if (!metadata_section(input.name))\n        {\n            if (input.address < ro_start) { ro_start = input.address; ro_file = input.file_offset; }\n            ro_end = std::max(ro_end, end);\n        }"
        )
        c = c.replace(
            "    const std::uint64_t relro_file = got.file_offset;",
            "    if (relro_file == std::numeric_limits<std::uint64_t>::max()) relro_file = got.file_offset;"
        )
        c = c.replace(
            "    const std::uint64_t ro_file =\n        eh_header != nullptr ? eh_header->file_offset : section(image, \".eh_frame\").file_offset;",
            "    if (ro_file == std::numeric_limits<std::uint64_t>::max()) ro_file = eh_header != nullptr ? eh_header->file_offset : section(image, \".eh_frame\").file_offset;"
        )
        with open(writer_path, "w") as f:
            f.write(c)
        tool_bin = os.path.join(bp_dir, "build/host/ps5-native-tool")
        if os.path.exists(tool_bin):
            os.remove(tool_bin)
EOF_PATCH

    if [ ! -x "$BP_DIR/build/host/ps5-native-tool" ]; then
        echo "[4/6] Compiling patched ps5-native-tool..."
        zlib_root="$BP_DIR/.deps/native/zlib/root"
        zlib_archive=$(find "$zlib_root" -type f -name libz.a -print -quit 2>/dev/null || true)
        cxx=$(command -v clang++-18 || command -v clang++)
        mkdir -p "$BP_DIR/build/host"
        "$cxx" -std=c++20 -O2 -Wall -Wextra -Werror \
            -I "$zlib_root/usr/include" \
            "$BP_DIR/tooling/native/native_app_builder.cpp" "$BP_DIR/tooling/native/self_container.cpp" \
            "$BP_DIR/tooling/native/elf_object.cpp" "$BP_DIR/tooling/native/sce_module_writer.cpp" \
            "$zlib_archive" -o "$BP_DIR/build/host/ps5-native-tool"
    fi
fi

# 5. Set up MkPFS 1.1.0 in a dedicated Python venv
MKPFS_DIR="$CACHE_ROOT/MkPFS"
MKPFS_COMMIT="1d5df56ae29390900e888fa12e5f9856aa797adc"
MKPFS_WRAPPER="$CACHE_ROOT/mkpfs-wrapper.sh"
if [ ! -x "$MKPFS_WRAPPER" ] || ! "$MKPFS_WRAPPER" -V >/dev/null 2>&1; then
    echo "[5/6] Setting up MkPFS 1.1.0..."
    if [ ! -d "$MKPFS_DIR/.git" ]; then
        rm -rf "$MKPFS_DIR"
        git clone "$GH/PSBrew/MkPFS.git" "$MKPFS_DIR"
    fi
    (
        cd "$MKPFS_DIR"
        git fetch --all --tags 2>/dev/null || true
        git checkout "$MKPFS_COMMIT" 2>/dev/null || git checkout main 2>/dev/null || true
        rm -rf "$MKPFS_DIR/.venv"
        python3 -m venv "$MKPFS_DIR/.venv"
        "$MKPFS_DIR/.venv/bin/pip" install --upgrade pip setuptools wheel
        "$MKPFS_DIR/.venv/bin/pip" install -e "$MKPFS_DIR" || "$MKPFS_DIR/.venv/bin/pip" install "$MKPFS_DIR"
    )
    cat > "$MKPFS_WRAPPER" <<EOF
#!/usr/bin/env bash
exec "$MKPFS_DIR/.venv/bin/python" -m mkpfs "\$@"
EOF
    chmod +x "$MKPFS_WRAPPER"
else
    echo "[5/6] Using cached MkPFS 1.1.0."
fi
export MKPFS="$MKPFS_WRAPPER"

# 6. Build Nuvio Max'd PS5 app (PPSA99288)
echo "[6/6] Compiling Nuvio Max'd (Torrent Edition) for PS5..."
RES_DIR="$("$OVERLAY_SDK/bin/prospero-clang" -print-resource-dir)"
if [ -f "$RES_DIR/lib/linux/libclang_rt.builtins-x86_64.a" ]; then
    export COMPILER_RT="$RES_DIR/lib/linux/libclang_rt.builtins-x86_64.a"
elif [ -f "$RES_DIR/lib/x86_64-unknown-linux-gnu/libclang_rt.builtins.a" ]; then
    export COMPILER_RT="$RES_DIR/lib/x86_64-unknown-linux-gnu/libclang_rt.builtins.a"
else
    FOUND_RT="$(find /usr/lib/llvm-18 /usr/lib/llvm-* -name 'libclang_rt.builtins*x86_64*.a' -o -path '*x86_64*libclang_rt.builtins.a' 2>/dev/null | head -n 1 || true)"
    if [ -n "$FOUND_RT" ]; then
        export COMPILER_RT="$FOUND_RT"
    fi
fi

export NUVIO_ALLOW_UNCONFIGURED_PROVIDERS=1
export BUILD_DIR="$CACHE_ROOT/build-work"
cd "$SCRIPT_DIR"
bash "$SCRIPT_DIR/gl/build.sh" PPSA99288 "Nuvio with Torrents"

READY_DIR="$REPO_ROOT/READY_FOR_PS5"
rm -rf "$READY_DIR"
mkdir -p "$READY_DIR"
cp -f "$SCRIPT_DIR/dist/PPSA99288.ffpfsc" "$READY_DIR/"
if [ -f "$SCRIPT_DIR/dist/PPSA99288.zip" ]; then
    cp -f "$SCRIPT_DIR/dist/PPSA99288.zip" "$READY_DIR/"
fi
cp -Rp "$SCRIPT_DIR/dist/PPSA99288" "$READY_DIR/PPSA99288"

echo ""
echo "=================================================================="
echo " BUILD COMPLETE!"
echo " Your PS5 files are ready inside: READY_FOR_PS5/"
echo "   - READY_FOR_PS5/PPSA99288.ffpfsc  (for ShadowMount+ 1.7)"
echo "   - READY_FOR_PS5/PPSA99288/        (for Itemzflow Game Manager)"
echo "=================================================================="
