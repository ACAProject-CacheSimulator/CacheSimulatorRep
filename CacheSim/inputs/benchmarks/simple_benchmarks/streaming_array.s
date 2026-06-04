# streaming_array.s
# Benchmark 1: Sequential Streaming Access
#
# Purpose:
# This benchmark tests spatial locality in the data cache.
# It sequentially loads 80 words from memory starting at address 0x10000000.
# Since each word is 4 bytes and the default cache block size is 32 bytes,
# one cache block contains 8 words. Therefore, for a 32-byte block size,
# we expect about 1 data-cache miss every 8 loads.
#
# Expected behavior with default D-cache block size = 32 bytes:
# - 80 data-cache accesses
# - Approximately 10 data-cache misses
# - Approximately 70 data-cache hits
#
# Registers used:
# $8  = loop counter
# $10 = current memory address
# $11 = loaded value
# $2  = syscall code

.text
main:
    addiu $8, $0, 80        # counter = 80 sequential word accesses
    lui   $10, 0x1000       # base address = 0x10000000

loop:
    lw    $11, 0($10)       # load word from current address
    addiu $10, $10, 4       # move to next word
    addiu $8, $8, -1        # decrement counter
    bne   $8, $0, loop      # repeat until counter reaches zero

    addiu $2, $0, 10        # syscall code 10 = exit
    syscall                 # terminate program
