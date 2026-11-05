<h1 align="center">Nuvio: Torrent Edition for PlayStation 5</h1>

<p align="center">
  <strong>The Ultimate Native BitTorrent Streaming Media Center for Jailbroken PS5 consoles.</strong><br>
  <em>Engineered and maintained by <strong>chewlord76</strong>.</em>
</p>

<p align="center">
  <a href="https://github.com/chewlord76/nuvio-torrent-edition/releases/latest"><img src="https://img.shields.io/github/v/release/chewlord76/nuvio-torrent-edition?color=7b5bf5&label=Release&style=flat-square" alt="Latest Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square" alt="License: GPLv3"></a>
  <a href="https://github.com/chewlord76/nuvio-torrent-edition"><img src="https://img.shields.io/badge/Platform-PS5%20(Prospero)-success?style=flat-square" alt="Platform: PS5"></a>
</p>

---

## ⚡ Overview

**Nuvio: Torrent Edition** is a groundbreaking, fully autonomous media streaming client created natively for the PlayStation 5. Unlike traditional console streaming players that rely on external companion servers, Debrid subscriptions, or separate computers running helper scripts, **Nuvio Torrent Edition features an integrated, high-performance C++ BitTorrent streaming engine running directly inside the PS5 application process**.

From ultra-high-bitrate 80+ GB 4K Blu-ray REMUXes to lightweight web releases, Nuvio Torrent Edition streams torrents and magnet links sequentially with instantaneous startup buffering, hardware-accelerated GPU rendering, and automatic HDR/SDR color pipelines.

---

## 🚀 Key Features

### 🧲 Integrated Native BitTorrent Streaming Engine
* **Zero Companion Dependency**: Stream torrents and magnets completely standalone on your console. No PC, Docker container, or cloud debrid account required.
* **Intelligent Sequential Readahead**: High-throughput memory-buffered sequential streaming pipeline designed specifically to support 40–100+ Mbps 4K UHD REMUX streams.
* **Demand-Driven Piece Prioritization**: Pieces requested by the video reader are assigned immediate `#0` priority at the front of the swarm request queue, preventing playback starvation.
* **Endgame Block Dispatching**: Eliminates slow-peer bottlenecks by concurrently scheduling pending pieces across active peers when approaching buffer thresholds.
* **Protected Container Eviction**: Vital container metadata, indices, and stream headers are locked into cache, shielding them from eviction under heavy memory pressure.

### 🌐 High-Speed Swarm Discovery & Routing
* **Direct Numerical IP DHT Bootstrapping**: Direct socket routing into the global BitTorrent DHT network, completely circumventing console DNS lookup lag and ISP/router adblockers.
* **Instant Peer Acquisition**: Initiates peer searches immediately upon handshaking the first live DHT node.
* **Parallel Tracker Announcers**: Asynchronous UDP/HTTP tracker worker threads with resilient connection pooling.
* **Tracker/PEX Routing Exchange**: Discovered tracker peers and Peer Exchange (PEX) nodes are instantly fed back into the DHT routing table for exponential swarm expansion.

### 📱 Local Web Drop Companion Server
* **Built-in HTTP Server (`:8088`)**: A lightweight web server runs directly on your PS5 (`http://<ps5-ip>:8088`).
* **One-Click Mobile/PC Casting**: Scan the on-screen QR code with your phone or open the link on your PC to instantly drop `.torrent` files or paste magnet links straight to your TV.

### 💾 Storage & USB Torrent Discovery
* **Automatic Drive Scanning**: Automatically discovers local `.torrent` files on any connected USB storage (`/mnt/usb0` through `/mnt/usb7`) and internal console storage (`/data/torrents/`, `/data/`).
* **Visual Management Hub**: Browse discovered files, review multi-file torrent layouts, select specific audio/video streams, or launch default features.
* **Resume & Playback History**: Remembers your exact watch progress across sessions with quick **Resume** and **Play from beginning** controls.

### 🎨 Visuals & Color Pipeline
* **4K UHD & 60/120 Hz GPU Output**: True native-resolution rendering via Prospero AGC and OpenGL 4.6 shaders with hardware YUV conversion.
* **Fast-Start Probe Optimization**: Capped container probing with universal quick-probe prevents demuxers from scanning 80+ GB file tails, launching 4K playback in seconds.
* **Automatic HDR-to-SDR Tone Mapping**: If your TV or PS5 video output is in SDR mode (`0x80290003`), playback gracefully routes through high-precision ITU-R BT.1886 PQ luminance tone mapping and sRGB gamut compression.
* **Native HDR10 Pass-Through**: Full 10-bit Rec.2020 HDR10 scanout support on HDR-configured displays.

### 🔊 Advanced Audio & Subtitles
* **Multi-Format Audio**: Multi-channel PCM 16-bit output, surround sound mixing, configurable PCM boost (50–300%), and millisecond-accurate audio delay adjustment.
* **Advanced Subtitle Shaping**: Real-time rendering of styled ASS/SSA, SRT, and PGS bitmap subtitles with customizable fonts, colors, scaling, and offset controls.

---

## 📥 Installation

### Requirements
* A PlayStation 5 console running compatible homebrew-enabled firmware (target: 13.60+).
* An active payload environment with **ShadowMount+** (1.7+) or **Itemzflow Game Manager**.

### Download Latest Release

Grab the latest ready-to-run packages from the [Releases](https://github.com/chewlord76/nuvio-torrent-edition/releases/latest) section:

| Package Format | Best For | Installation Instructions |
| --- | --- | --- |
| **`PPSA99288.ffpfsc`** | **ShadowMount+ 1.7** | Copy the `.ffpfsc` image file onto your USB drive or into `/data/` on the PS5. Open ShadowMount+ and mount the image. |
| **`PPSA99288.zip`** | **Itemzflow** | Download and extract `PPSA99288.zip`. Copy the unzipped `PPSA99288` directory to `/user/app/PPSA99288/` on your console. |

> **Note**: Title ID is **`PPSA99288`**. Always preserve your app data directory when updating.

---

## 🎮 How to Stream Torrents

### Method 1: Web Drop (Easiest)
1. Launch **Nuvio (Torrent Edition)** on your PS5.
2. Go to the **Torrents** tab in the sidebar and click **Phone / PC Web Drop (QR Code)**.
3. Scan the QR code with your phone or navigate to `http://<your-ps5-ip>:8088` in your browser.
4. Drag-and-drop any `.torrent` file or paste a magnet link. Playback will begin on your PS5 immediately!

### Method 2: USB Drive / Local Storage
1. Copy `.torrent` files onto any USB flash drive or external SSD.
2. Plug the USB drive into your PS5.
3. Navigate to the **Torrents** tab. Your files will be cataloged under **Local .torrent files**.
4. Press **Cross (X)** to stream immediately, or **Square** to select individual files inside the torrent.

### Method 3: Direct Magnet Link Entry
1. Select **Enter Magnet or .torrent URL** from the Torrents hub.
2. Paste or type any `magnet:?xt=urn:btih:...` link or 40-character info-hash.

---

## 🛠️ Controls Quick Reference

| Button | Action |
| --- | --- |
| **Cross (X)** | Select / Play stream / Confirm |
| **Circle (O)** | Back / Cancel / Stop playback |
| **Square (□)** | Stream Options: Resume, Play from beginning, Select file, Remove |
| **Triangle (△)** | Quick Search / Paste Magnet / Filter |
| **L1 / R1** | Switch view filters (All Sources, Local Files, Recent Streams) |
| **D-Pad Left / Right** | Jump backward / forward (configurable intervals) |
| **D-Pad Up / Down** | Show player controls, audio tracks, and chapter selection |

---

## 🏗️ Building from Source

Builds are compiled inside a Linux environment (Ubuntu 22.04+ or WSL2 on Windows) using LLVM/Clang and the PS5 Open SDK toolchain.

```bash
# Clone the repository
git clone https://github.com/chewlord76/nuvio-torrent-edition.git
cd nuvio-torrent-edition/source/native-app

# Run the automated PS5 build script
bash auto_build_ps5.sh
```

Compiled binaries and package images will be output automatically into `READY_FOR_PS5/`.

---

## 📜 Credits & License

* **Project Lead & Torrent Engine Architecture:** Developed and maintained by **chewlord76**.
* **Base Application:** Forked from the open-source Nuvio Max'd base (upstream by HandshakeHackin).
* **Core Libraries:** Powered by FFmpeg, libvlc, and Prospero AGC.
* **License:** Distributed under the **[GNU General Public License v3.0](LICENSE)**.
