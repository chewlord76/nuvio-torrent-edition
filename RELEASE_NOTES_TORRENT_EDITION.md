# Nuvio (Torrent Edition) v1.0.0.7 for PlayStation 5

> **Notice**: This project is simply a custom fork/build of Nuvio Max'd for PS5, nothing else. It incorporates a standalone native BitTorrent streaming engine directly on the console so you can stream torrent and magnet links without requiring any external companion server, debrid account, or secondary PC.

---

### Highlights & Release Notes (v1.0.0.7)

* **Eliminated 4K REMUX Buffering Stalls & 0.00 MB/s Download Freeze**:
  * **Uncapped Swarm Readahead**: Removed the artificial 31-piece budget ceiling (`budget / 2`) in the sequential readahead calculator that stalled downloads after caching 512 MB. Readahead now seamlessly buffers up to the full cache boundary (up to 4 GB).
  * **Demand-Driven Piece Prioritization**: Reader-requested pieces are assigned immediate top priority (`#0`) at the head of the wanted list, ensuring instant peer block scheduling when the player reaches a new section of the stream.
  * **Endgame Block Dispatching**: Prevents stalled or slow peers from holding up critical pieces required by the player, issuing concurrent block requests when a reader is waiting.
  * **Protected Swarm Recovery**: `recover_stalled_torrent` no longer triggers while active payload data is streaming ($> 200\text{ KB/s}$ or active in the last 10s), preventing the sudden drop of fast peer connections. Recovered peers reconnect immediately without punitive ban timeouts.
  * **4K Buffer Optimization**: Lowered initial start buffer requirement for ultra-high-bitrate REMUXes ($\ge 40\text{ Mbps}$) from 15 seconds (~150 MB compressed) to 3.5 seconds, and decoupled buffer progress from empty compressed audio queues. Playback starts smoothly once 2.5 seconds are buffered.

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

* **Seamless HDR-to-SDR Tone-Mapping Fallback**:
  * When a TV/monitor or PS5 video configuration rejects the raw 10-bit HDR scanout framebuffer (`0x80290003`), or when encountering HDR10+ / Dolby Vision streams, playback seamlessly falls back to high-fidelity BT.1886 luminance tone mapping and sRGB gamut compression.

* **Built-in Web Drop Companion Server**:
  * Web Drop server running at `http://<ps5-ip>:8088`. Drop `.torrent` files or paste magnet links from any phone or PC on your home Wi-Fi straight to the PS5.

* **100% Native Retail PS5 Compatibility**:
  * Resolves ELF segment page alignment issues on retail firmware 13.60+.
  * Eliminates startup heap corruption crashes in settings initialization.

---

### Installation

* **For ShadowMount+ 1.7**: Copy `PPSA99288.ffpfsc` to your USB drive or `/data/` and mount it.
* **For Itemzflow**: Download and extract `PPSA99288.zip` to `/user/app/PPSA99288/`.
