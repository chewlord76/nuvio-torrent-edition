# Nuvio with Torrents — Antigravity Project Instructions

## Project Overview
This repository contains **Nuvio with Torrents**, the sovereign, bare-metal BitTorrent streaming media player for jailbroken PlayStation 5 consoles (Prospero), engineered and architected by **chewlord76**.

From now on, all development in this workspace is **SOLELY focused on Nuvio with Torrents**.

---

## Core Guidelines & Architectural Principles

### 1. App Identity & Rebranding
* **App Name**: `Nuvio with Torrents` (Title ID: `PPSA99288`).
* **Zero Upstream Dev Influence in GUI**: Maintain complete independence. Strictly no donation screens, Ko-fi links, QR modals, or persistent startup update prompts.
* **Console-First Experience**: Clean, instant boot into the media center with zero modal interruptions.

### 2. Standalone Streaming Engine
* **Native C++ Engine**: High-throughput sequential BitTorrent engine running directly inside the PS5 application process (`bt::Engine`).
* **Multi-Piece Lookahead Pipelining**: Up to 32 pieces in flight across the swarm to support sustained 80+ GB 4K Blu-ray REMUX streaming at line rate.
* **Seeking & Buffering Integrity**: Always preserve the instantaneous seek gate recovery (queue flush & target piece re-anchor) and true piece-by-piece buffering progress accounting (`wait_progress`).
* **Live Telemetry**: Keep the 1-second real-time stats polling active (speeds, seeds, peers, buffer cushion).

### 3. Display & Audio Pipeline
* **10-Bit Rec.2020 HDR10**: Direct kernel handshake (`attribute: 0x62000000`, `attribute3: 0x40040`) for authentic HDR10 scanout.
* **Automatic Tone-Mapping**: ITU-R BT.1886 PQ luminance mapping fallback for SDR displays.
* **Audio**: Multi-channel PCM 16-bit, surround downmix, and 50–300% boost.

### 4. GitHub & Release Policy
* **Repository**: Private repository at `chewlord76/nuvio-with-torrents`.
* **Releases**: Whenever GitHub releases are requested by the user:
  * Craft grandiose, celebratory release notes highlighting chewlord76's architectural work.
  * Always build and attach both verified package formats:
    * `READY_FOR_PS5/PPSA99288.ffpfsc` (for ShadowMount+ 1.7)
    * `READY_FOR_PS5/PPSA99288.zip` (for Itemzflow Game Manager)
* **Local Operations**: By default, do not push to GitHub unless explicitly instructed by the user.

### 5. Build Commands
* **Build Script**: Located at `source/native-app/auto_build_ps5.sh`.
* **Build Execution**: Run inside WSL from `source/native-app`:
  ```bash
  wsl bash -c "cd /mnt/c/Users/compu/Downloads/Nuvio-with-torrents/source/native-app && bash auto_build_ps5.sh"
  ```
* **Output Staging**: Output images and folders automatically populate `READY_FOR_PS5/`.
