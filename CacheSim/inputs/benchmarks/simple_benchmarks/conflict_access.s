.text

    addiu $8, $0, 10        # loop counter = 10 iterations
    lui   $10, 0x1000       # base address = 0x10000000

loop:
    lw    $11, 0($10)       # base + 0x0000

    lui   $12, 0x1000
    ori   $12, $12, 0x2000
    lw    $13, 0($12)       # base + 0x2000

    lui   $12, 0x1000
    ori   $12, $12, 0x4000
    lw    $13, 0($12)       # base + 0x4000

    lui   $12, 0x1000
    ori   $12, $12, 0x6000
    lw    $13, 0($12)       # base + 0x6000

    lui   $12, 0x1000
    ori   $12, $12, 0x8000
    lw    $13, 0($12)       # base + 0x8000

    lui   $12, 0x1000
    ori   $12, $12, 0xA000
    lw    $13, 0($12)       # base + 0xA000

    lui   $12, 0x1000
    ori   $12, $12, 0xC000
    lw    $13, 0($12)       # base + 0xC000

    lui   $12, 0x1000
    ori   $12, $12, 0xE000
    lw    $13, 0($12)       # base + 0xE000

    lui   $12, 0x1001
    lw    $13, 0($12)       # base + 0x10000 = 0x10010000

    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall