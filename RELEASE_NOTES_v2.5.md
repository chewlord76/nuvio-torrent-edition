# 👑 Nuvio with Torrents v2.5 — The Sovereign Rebirth & Pure Streaming Renaissance

> ### ⚡ The Ultimate Autonomous Console Streaming Architecture
> Conceived, engineered, and brought to life by **chewlord76**, **Release 2.5** marks the dawn of a new era for PlayStation 5 homebrew entertainment: the official launch of **Nuvio with Torrents**. 
> 
> This monumental release completely purges all external author influences, nagging update prompts, and donation screens to deliver a pure, distraction-free console media powerhouse. Coupled with a revolutionary AI-generated brand identity, instant seek recovery, true piece-by-piece buffering tracking, and full 10-bit Rec.2020 HDR10 scanout, **Nuvio with Torrents** stands as the definitive sovereign streaming solution for the PS5.

---

### 🌟 Monumental Innovations & Crown Achievements (v2.5)

#### 🛡️ Complete Sovereign Rebranding & Distraction-Free Console UX
* **Total Elimination of Upstream Promos & Donation Nags**: Eradicated all author donation screens, Ko-fi links, QR code modals, and external links. The interface is now 100% clean, professional, and focused purely on entertainment.
* **Abolished Startup Update Dialogs**: No more *"Where did you install the app from?"* or persistent *"New release available"* nagging on boot. The app launches immediately into your media library without interruption.
* **Bespoke AI-Generated Brand Identity**: Designed with an ultra-sleek, modern console dashboard emblem combining frosted glassmorphic play controls with luminous cyan and electric blue torrent waves on deep obsidian navy. Includes high-resolution 512×512 PS5 home screen icons and matching in-app assets.

#### ⏩ Mastered Seeking Architecture (Instant Timeline Traversal)
* **Demolished Seek Deadlock**: Fixed the critical underlying seek failure (`Operation not permitted`) where skipping forward or backward caused player starvation and frozen buffering. 
* **Instant Queue Flush & Re-Anchor**: Timeline jumps now instantly retire stale decode packets, reset the player seek gate, and re-anchor the BitTorrent engine directly onto the target piece, resuming smooth playback within seconds.
* **Sane Post-Seek Buffer Horizon**: Replaced inadequate 0.5s refill thresholds with a robust 2.5s post-seek buffer cushion, guaranteeing steady momentum without stutter.

#### 📊 True Piece-by-Piece Buffering Progress & Live Swarm HUD
* **The End of the Blind "0% Buffering" Stall**: Buffering percentage no longer stays frozen at 0.0%. Implemented exact byte-level tracking across required piece blocks in `TorrentStream` (`wait_progress`), delivering an accurate, live progress bar while the swarm fills the playhead.
* **1-Second Continuous HUD Telemetry**: Overhauled player stats polling to update every second during active playback. Stale `0.0 MB/s` readouts are eliminated—active download speeds, connected seeds, swarm peers, and buffer status reflect live reality.
* **2 MB TCP Socket Buffer Fabric**: Upgraded network socket buffers to 2 MB with `TCP_NODELAY`, providing the necessary bandwidth runway for fiber and gigabit seedboxes to deliver sustained 30–50+ MB/s transfers.

#### 🌈 Verified True 10-Bit Rec.2020 HDR10 Scanout
* **Low-Level Kernel Handshake Triumph**: Fixed the elusive PS5 kernel rejection error (`0x80290003`). Native application profile flags (`attribute: 0x62000000`, `attribute3: 0x40040`) grant authentic 10-bit Rec.2020 PQ scanout framebuffers directly to modern OLED and HDR TVs.
* **Automatic ITU-R BT.1886 Tone-Mapping**: Compatible SDR fallback ensures non-HDR displays receive high-precision gamut mapping with rich contrast and zero color banding.

#### ⚡ Massive Multi-Piece Lookahead Pipelining
* **Up to 32 Pieces in Flight**: The sequential engine concurrent pipeline continuously pre-fetches pieces $N+1, N+2, N+3...$ across high-speed swarm peers, effortlessly sustaining monster 80+ GB 4K Blu-ray REMUX streams at full line rate.

---

### 📦 Installation Packages & Downloads

| Package File | File Size | Recommended Method |
| :--- | :--- | :--- |
| **`PPSA99288.ffpfsc`** | **44.5 MB** | **ShadowMount+ 1.7**: Mount package directly from USB or internal storage (`/data/`). |
| **`PPSA99288.zip`** | **42.2 MB** | **Itemzflow Game Manager**: Unzip and extract to `/user/app/PPSA99288/`. |

---

### 🕹️ Quick Controls & Navigation Guide

* **Cross (✕)**: Play / Select Stream
* **Square (□)**: Dedicated Stream Operations Menu:
  * **Resume Playback**: Pick up seamlessly where you left off.
  * **Play From Beginning**: Instantly reset timestamp to Piece 0.
  * **Select File**: Browse and play individual files inside multi-file packs.
* **Options**: Audio Track, Subtitle, & Playback Quality Menu
* **Web Drop**: Access `http://<PS5-IP>:8088` from your phone or PC browser to paste magnets or upload `.torrent` files directly.

---

*Title ID: `PPSA99288` · Built for Prospero AGC · Tested and fully operational on PS5 Retail Firmware 13.60+*
*(Conceived, architected, and brought to life by chewlord76).*
