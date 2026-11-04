import subprocess
import os

b = "/home/gutig/.nuvio-ps5-build-cache/build-work/app"
sdk = "/home/gutig/.nuvio-ps5-build-cache/sdk-overlay-work/sdk"
bp = "/home/gutig/.nuvio-ps5-build-cache/ps5-native-app-boilerplate"
native = "/mnt/c/Users/compu/Downloads/Nuvio-maxd-torrent-edition/source/native-app/native"
gl = "/mnt/c/Users/compu/Downloads/Nuvio-maxd-torrent-edition/source/.deps/nuvio-opengl-1.0.2"

with open("/tmp/test-symbols.map", "w") as f:
    f.write("{\n    local:\n        *;\n};\n")

# Let's inspect what command was run or read the objects from b
print("Testing version script with local: *;")
