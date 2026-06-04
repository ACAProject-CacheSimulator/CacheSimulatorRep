.text

    addiu $8, $0, 1024      # loop counter = 1024 iterations
    lui   $10, 0x1000       # base address = 0x10000000
    addiu $9, $0, 0         # accumulator = 0

loop:
    lw    $11, 0($10)       # repeated working-set load
    addu  $9, $9, $11        # use loaded value
    lw    $12, 4($10)       # repeated working-set load
    addu  $9, $9, $12        # use loaded value
    lw    $13, 8($10)       # repeated working-set load
    addu  $9, $9, $13        # use loaded value
    lw    $14, 12($10)       # repeated working-set load
    addu  $9, $9, $14        # use loaded value
    lw    $15, 16($10)       # repeated working-set load
    addu  $9, $9, $15        # use loaded value
    lw    $16, 20($10)       # repeated working-set load
    addu  $9, $9, $16        # use loaded value
    lw    $17, 24($10)       # repeated working-set load
    addu  $9, $9, $17        # use loaded value
    lw    $18, 28($10)       # repeated working-set load
    addu  $9, $9, $18        # use loaded value
    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall
