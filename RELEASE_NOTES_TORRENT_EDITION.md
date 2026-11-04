# Nuvio (Torrent Edition) v1.0.0.5 for PlayStation 5

> **Notice**: This project is a custom fork/build of Nuvio Max'd for PS5, nothing else. It incorporates a standalone native BitTorrent streaming engine directly on the console.

---

### Highlights & New Features

* **Embedded Native BitTorrent Streaming Engine**:
  * Streams torrents and magnet links directly on the PS5 without requiring a separate PC, node server, or Debrid subscription.
  * Smart piece prioritization and adaptive readahead buffering.

* **High-Speed Peer & Swarm Discovery**:
  * Direct numerical IP bootstrap routing for the BitTorrent DHT network, completely bypassing DNS lookup latency and router adblockers.
  * Search threshold lowered so peer search kicks off immediately upon connecting to the first live DHT node.
  * 8 parallel tracker worker threads with optimized UDP transaction timeouts.
  * Live tracker and PEX peers are automatically fed into the DHT routing table.

* **Seamless HDR-to-SDR Tone-Mapping Fallback**:
  * When a TV/monitor or PS5 video configuration rejects the raw 10-bit HDR scanout framebuffer (`0x80290003`), or when encountering HDR10+ / Dolby Vision streams, playback no longer stops or crashes with an error.
  * The app seamlessly falls back to its built-in high-fidelity BT.1886 luminance tone mapper (`toSdr(pq(pqSignal))`) and continues playing in SDR color without interruption.

* **Built-in Web Drop Companion Server**:
  * Web Drop server running at `http://<ps5-ip>:8088`. Drop `.torrent` files or paste magnet links from any phone or PC on your home Wi-Fi straight to the PS5.

* **100% Native Retail PS5 Compatibility**:
  * Resolves ELF segment page alignment issues on retail firmware 13.60+.
  * Eliminates startup heap corruption crashes in settings initialization.

---

### Installation

* **For ShadowMount+ 1.7**: Copy `PPSA99288.ffpfsc` to your USB drive or `/data/` and mount it.
* **For Itemzflow**: Download and extract `PPSA99288.zip` to `/user/app/PPSA99288/`.
