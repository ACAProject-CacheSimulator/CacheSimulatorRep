# streaming_array_complex

Performs 2048 sequential loads from memory starting at 0x10000000.

Purpose:
- Strong spatial locality.
- Good for block size and cache size experiments.
- Larger than the simple streaming benchmark, so cache effects are clearer.

Expected behavior:
- Approximately one data-cache miss per cache block.
- Larger block sizes should reduce miss rate.
