.text

    addiu $8, $0, 128       # loop counter = 128 iterations
    addiu $9, $0, 0         # accumulator = 0

loop:
    lui   $12, 0x1000
    lw    $13, 0($12)       # conflict address 0x10000000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0x2000
    lw    $13, 0($12)       # conflict address 0x10002000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0x4000
    lw    $13, 0($12)       # conflict address 0x10004000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0x6000
    lw    $13, 0($12)       # conflict address 0x10006000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0x8000
    lw    $13, 0($12)       # conflict address 0x10008000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0xa000
    lw    $13, 0($12)       # conflict address 0x1000a000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0xc000
    lw    $13, 0($12)       # conflict address 0x1000c000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1000
    ori   $12, $12, 0xe000
    lw    $13, 0($12)       # conflict address 0x1000e000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    lw    $13, 0($12)       # conflict address 0x10010000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0x2000
    lw    $13, 0($12)       # conflict address 0x10012000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0x4000
    lw    $13, 0($12)       # conflict address 0x10014000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0x6000
    lw    $13, 0($12)       # conflict address 0x10016000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0x8000
    lw    $13, 0($12)       # conflict address 0x10018000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0xa000
    lw    $13, 0($12)       # conflict address 0x1001a000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0xc000
    lw    $13, 0($12)       # conflict address 0x1001c000
    addu  $9, $9, $13       # use loaded value
    lui   $12, 0x1001
    ori   $12, $12, 0xe000
    lw    $13, 0($12)       # conflict address 0x1001e000
    addu  $9, $9, $13       # use loaded value
    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall
