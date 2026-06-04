# conflict_access_complex

Repeatedly accesses 16 memory blocks separated by 0x2000 bytes.

Purpose:
- Stresses conflict misses.
- Highlights associativity effects.
- Useful for replacement policy experiments.

Expected behavior:
- Low associativity caches should suffer many conflict misses.
- Higher associativity should improve IPC.
- 16-way associativity should perform much better for this pattern.
