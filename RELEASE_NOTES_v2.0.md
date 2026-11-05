# 🚀 Nuvio (Torrent Edition) v2.0 — The Ultra-High Bitrate 4K Concurrency Revolution

> ### 👑 The Zenith of Standalone Console Streaming Architecture
> Architected, engineered, and brought to life by **chewlord76**, **Release 2.0** represents a historic architectural milestone in PlayStation 5 homebrew engineering. By breaking through the fundamental throughput barriers of legacy BitTorrent streaming implementations, **chewlord76** has transformed the PS5 into an uncompromising, enterprise-grade 4K UHD Blu-ray REMUX powerhouse—streaming massive 80GB+ high-bitrate films directly from peer swarms with zero external servers, zero transcoding, and zero compromise.

---

### 🌟 Monumental Innovations & Crown Achievements (v2.0)

#### ⚡ Massive Multi-Piece Lookahead Pipelining (The End of Piece-Boundary Stutter)
* **Demolished Single-Piece Serialization**: Legacy streaming architectures forced the download pipeline to stall on a single piece whenever playback demand surged (`1 active` bottleneck). **chewlord76** has completely dismantled this barrier: the engine now maintains a continuous, multi-lane concurrent pipeline with **up to 32 pieces in flight simultaneously** across the swarm.
* **Full-Bandwidth Peer Saturation**: When high-speed peers complete blocks for the urgent playhead, they no longer sit idle—they immediately surge forward to pre-fetch pieces $N+1$, $N+2$, $N+3$, and beyond, priming a multi-gigabyte lookahead buffer that keeps the player completely saturated at full line rate.
* **16-Piece Eager Priority Window**: `refresh_wanted()` now dynamically injects a high-priority 16-piece lookahead window directly behind the active playhead, guaranteeing that the decoder always has a continuous runway of verified chunks.

#### 🌈 Verified True 10-Bit Rec.2020 HDR10 Output
* **Low-Level Kernel Handshake Triumph**: Fixed the elusive PS5 kernel rejection error (`0x80290003`). Native application profile flags (`attribute: 0x62000000`, `attribute3: 0x40040`) inform the PS5 OS display manager to grant genuine 10-bit Rec.2020 PQ scanout framebuffers directly to modern OLED and HDR TVs.
* **Stunning Visual Precision**: Dolby Vision Profile 7/8 fallbacks and high-luminance BT.2020 masterings render with breath-taking dynamic range, deep specular highlights, and zero color banding.

#### 🛡️ Startup Buffer Cushion Integrity & Anti-Starvation Guard
* **Abolished Premature Scanout Stalls**: Eradicated the aggressive 2.5-second startup bypass that prematurely ignited video scanout before the pipeline had established adequate swarm momentum.
* **Adaptive Bitrate Pre-Buffering**: For monster 70–100+ Mbit/s 4K streams, the player now enforces an adaptive startup cushion (4.0–5.0 seconds), guaranteeing that playback glides forward effortlessly without stalling out in the first seconds of viewing.
* **Deepened Peer Request Windows**: Upgraded base in-flight request queues from 16 to 32–64 blocks per peer, allowing fiber and gigabit seedboxes to deliver 20–40+ MB/s directly to the PS5.

#### 🌐 Dynamic Swarm Aggression & Peer Candidate Pooling
* **Fast-Track Candidate Reconnects**: Shortened peer candidate refill intervals to 2 seconds and lowered reconnect backoffs from 60s+ down to 10–15s when swarms are ramping up, driving active peer counts upward rapidly.
* **Tolerant TCP Handshaking**: Expanded connection timeouts to 6.0 seconds to accommodate high-latency seedboxes and international peers without premature drops.
* **Intelligent Reader Upkeep**: Overhauled recovery heuristics to recognize that ultra-high bitrate 4K streams require multi-megabyte throughput—preventing the engine from prematurely settling into low-bandwidth complacency.

---

### 📦 Installation Packages & Downloads

| Package File | File Size | Recommended Method |
| :--- | :--- | :--- |
| **`PPSA99288.ffpfsc`** | **46.4 MB** | **ShadowMount+ 1.7**: Mount package directly from USB or internal storage (`/data/`). |
| **`PPSA99288.zip`** | **44.1 MB** | **Itemzflow Game Manager**: Unzip and extract to `/user/app/PPSA99288/`. |

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
*(Core concept inspired by upstream open source media tools; completely re-engineered into a bare-metal PS5 native torrent powerhouse by chewlord76).*
