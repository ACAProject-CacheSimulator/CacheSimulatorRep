# store_heavy_complex

Performs 4096 sequential stores starting at 0x10000000.

Purpose:
- Tests store behavior.
- Tests dirty bits.
- Useful for observing dirty evictions with small cache sizes.

Expected behavior:
- Sequential store pattern behaves similarly to streaming.
- Blocks touched by stores become dirty.
- Dirty evictions become more visible when cache size is small.
