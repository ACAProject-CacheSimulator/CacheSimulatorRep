# repeated_small_working_sets.s 
# Benchmark 2: Repeated Small Working Set
#
# Purpose: 
# This benchmark tests temporal locality: the same data reused many times.
# This is important because many real programs repeatedly access the same variables, 
# arrays, stack locations, or loop data. A cache should perform very well in this case.
# If your cache is working correctly, this benchmark should produce a very high hit rate after the initial cold miss.
#
# Expected behavior with default D-cache block size = 32 bytes:
#
# Assume:
# Block size = 32 bytes
# Word size = 4 bytes
#
# Then one cache block contains:
# 32 / 4 = 8 words
#
# If the benchmark repeatedly accesses only 4 words:
# A[0], A[1], A[2], A[3]
# then all of them are inside the same 32-byte block.
#
# So if the benchmark performs 80 total loads:
# D-cache accesses: 80
# D-cache misses: about 1
# D-cache hits: about 79
# 
# This is different from the streaming benchmark, where every new block caused another miss.
3 This benchmark should show a better hit rate than streaming access.

.text

    addiu $8, $0, 20        # loop counter = 20
    lui   $10, 0x1000       # base address = 0x10000000

loop:
    lw    $11, 0($10)       # A[0]
    lw    $12, 4($10)       # A[1]
    lw    $13, 8($10)       # A[2]
    lw    $14, 12($10)      # A[3]

    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat loop

    addiu $2, $0, 10        # exit syscall
    syscall