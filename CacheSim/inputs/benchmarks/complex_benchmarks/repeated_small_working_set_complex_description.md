# repeated_small_working_set_complex

Repeats 8 loads from the same 32-byte memory block for 1024 iterations.

Purpose:
- Strong temporal locality.
- Verifies that reused data remains in cache.
- Useful as a high-hit-rate benchmark.

Expected behavior:
- First access to the block misses.
- Most later data accesses should hit.
- Very high data-cache hit rate.
