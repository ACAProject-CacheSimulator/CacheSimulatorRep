# random_access_complex

Repeatedly accesses 32 non-sequential memory offsets for 256 iterations.

Purpose:
- Weak spatial locality.
- Good for cache size and block size experiments.
- Useful for replacement policy comparison.

Expected behavior:
- Higher miss rate than repeated working set.
- Larger caches may help if they retain the scattered working set.
- Very large blocks may not help as much as in streaming access.
