# Nuvio (Torrent Edition) v1.0.0.8 for PlayStation 5 (Final Release)

> **Notice**: This project is a custom fork/build of Nuvio Max'd for PS5. It incorporates a standalone native BitTorrent streaming engine directly on the console so you can stream torrent and magnet links without requiring any external companion server, debrid account, or secondary PC.

---

### Highlights & Release Notes (v1.0.0.8 - Final Release)

* **Universal Fast-Start for 80GB+ 4K REMUXes (M2TS / MKV / MP4)**:
  * **Eliminated Tail-Seeking Stalls on M2TS Blu-ray REMUXes**: Fixed an issue where raw MPEG-TS (`.m2ts`) Blu-ray disc files forced FFmpeg to seek to piece #20,567 at the tail of an 86 GB stream to calculate duration. All torrent streams now utilize universal quick-probe mode (`seekable = 0`, probesize capped to 2 MB), allowing 80+ GB files to start playback within seconds.
  * **Accurate Launch Stepper UI**: Fixed the UI getting visually stuck on *"Connecting to peers"* while the engine was already downloading payload data at high speeds. The stepper now advances immediately to *"Filling the buffer"* as soon as peers connect and transfer blocks.
  * **Container Header Cache Safeguard**: Eviction routines now protect critical container metadata and index pieces (`first_file`, `last`) from cache recycling under memory pressure.
  * **Native Engine Routing**: Enforced torrent streams to stay strictly on the high-performance native pipeline.

* **Eliminated 4K REMUX Buffering Stalls & 0.00 MB/s Download Freeze**:
  * **Uncapped Swarm Readahead**: Removed the artificial 31-piece budget ceiling (`budget / 2`) in the sequential readahead calculator that stalled downloads after caching 512 MB. Readahead now seamlessly buffers up to the full cache boundary (up to 4 GB).
  * **Demand-Driven Piece Prioritization**: Reader-requested pieces are assigned immediate top priority (`#0`) at the head of the wanted list, ensuring instant peer block scheduling when the player reaches a new section of the stream.
  * **Endgame Block Dispatching**: Prevents stalled or slow peers from holding up critical pieces required by the player, issuing concurrent block requests when a reader is waiting.
  * **Protected Swarm Recovery**: `recover_stalled_torrent` no longer triggers while active payload data is streaming ($> 200\text{ KB/s}$ or active in the last 10s), preventing the sudden drop of fast peer connections. Recovered peers reconnect immediately without punitive ban timeouts.
  * **4K Buffer Optimization**: Lowered initial start buffer requirement for ultra-high-bitrate REMUXes ($\ge 40\text{ Mbps}$) from 15 seconds (~150 MB compressed) to 3.5 seconds, and decoupled buffer progress from empty compressed audio queues. Playback starts smoothly once 2.5 seconds are buffered.

* **Seamless HDR-to-SDR Tone-Mapping Fallback & Native HDR10 Guide**:
  * When a TV/monitor or PS5 video output is configured in SDR (`0x80290003` / `SCE_VIDEO_OUT_ERROR_INVALID_VALUE`), Nuvio gracefully catches the kernel scanout rejection and switches to built-in ITU-R BT.1886 tone mapping (10-bit HDR $\rightarrow$ 8-bit SDR) instead of crashing.
  * To enable native uncompressed HDR10 scanout: set PS5 *Settings $\rightarrow$ Screen and Video $\rightarrow$ HDR* to *Always On* / *On When Supported*, and ensure your TV's HDMI port has *Enhanced Format* / *Deep Color* enabled.

---

### Highlights (v1.0.0.6)

* **HEVC Playback Crash Resolution**:
  * Fixed fatal signal/abort (`std::system_error: thread constructor failed, errno 35 EAGAIN`) by strictly throttling DHT bootstrap resolution to at most 1 active resolver at a time.
  * Optimized FFmpeg HEVC multithreading to 4 dedicated frame-threads (`FF_THREAD_FRAME`), preventing thread multiplication and stack exhaustion on 4K 60fps streams.
  * Resilient POSIX thread stack allocator with graceful step-down (4MB -> 2MB -> 1MB -> 512KB -> 256KB).

---

### Highlights (v1.0.0.5)

* **Embedded Native BitTorrent Streaming Engine**:
  * Streams torrents and magnet links directly on the PS5 without requiring a separate PC, node server, or Debrid subscription.
  * Smart piece prioritization and adaptive readahead buffering.

* **High-Speed Peer & Swarm Discovery**:
  * Direct numerical IP bootstrap routing for the BitTorrent DHT network, completely bypassing DNS lookup latency and router adblockers.
  * Search threshold lowered so peer search kicks off immediately upon connecting to the first live DHT node.
  * Parallel tracker worker threads with optimized UDP transaction timeouts.
  * Live tracker and PEX peers are automatically fed into the DHT routing table.

* **Built-in Web Drop Companion Server**:
  * Web Drop server running at `http://<ps5-ip>:8088`. Drop `.torrent` files or paste magnet links from any phone or PC on your home Wi-Fi straight to the PS5.

* **100% Native Retail PS5 Compatibility**:
  * Resolves ELF segment page alignment issues on retail firmware 13.60+.
  * Eliminates startup heap corruption crashes in settings initialization.

---

### Installation

* **For ShadowMount+ 1.7**: Copy `PPSA99288.ffpfsc` to your USB drive or `/data/` and mount it.
* **For Itemzflow**: Download and extract `PPSA99288.zip` to `/user/app/PPSA99288/`.
