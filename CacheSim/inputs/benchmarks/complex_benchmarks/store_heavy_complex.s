.text

    addiu $8, $0, 4096      # loop counter = 4096 stores
    lui   $10, 0x1000       # base address = 0x10000000
    addiu $12, $0, 123      # value to store

loop:
    sw    $12, 0($10)       # store current value
    addiu $12, $12, 1       # change value
    addiu $10, $10, 4       # move to next word
    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall
