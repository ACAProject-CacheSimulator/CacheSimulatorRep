.text

    addiu $8, $0, 80        # loop counter = 80 stores
    lui   $10, 0x1000       # base address = 0x10000000
    addiu $12, $0, 123      # value to store

loop:
    sw    $12, 0($10)       # store value at current address
    addiu $10, $10, 4       # move to next word
    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat until counter = 0

    addiu $2, $0, 10        # exit syscall
    syscall