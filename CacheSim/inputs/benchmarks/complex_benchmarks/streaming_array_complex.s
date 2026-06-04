.text

    addiu $8, $0, 2048      # loop counter = 2048 sequential loads
    lui   $10, 0x1000       # base address = 0x10000000
    addiu $12, $0, 0        # accumulator = 0

loop:
    lw    $11, 0($10)       # load current word
    addu  $12, $12, $11     # use loaded value
    addiu $10, $10, 4       # move to next word
    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall
