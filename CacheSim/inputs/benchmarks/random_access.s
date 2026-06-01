.text

    addiu $8, $0, 10        # loop counter = 10 iterations
    lui   $10, 0x1000       # base address = 0x10000000

loop:
    lw    $11, 12($10)      # A[3]
    lw    $12, 200($10)     # A[50]
    lw    $13, 28($10)      # A[7]
    lw    $14, 364($10)     # A[91]
    lw    $15, 48($10)      # A[12]
    lw    $16, 520($10)     # A[130]
    lw    $17, 96($10)      # A[24]
    lw    $18, 748($10)     # A[187]

    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall