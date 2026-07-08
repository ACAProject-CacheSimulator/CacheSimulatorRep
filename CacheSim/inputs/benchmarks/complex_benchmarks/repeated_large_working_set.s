.text

    addiu $20, $0, 8        # outer loop counter = 8 passes over the same array
    addiu $9,  $0, 0        # accumulator = 0

outer_loop:
    addiu $8,  $0, 2048     # inner loop counter = 2048 words
    lui   $10, 0x1000       # reset base address = 0x10000000 at each pass

inner_loop:
    lw    $11, 0($10)       # load current word from the working set
    addu  $9,  $9, $11      # use the loaded value so the load is not useless
    addiu $10, $10, 4       # move to the next word
    addiu $8,  $8, -1       # inner counter--
    bne   $8,  $0, inner_loop

    addiu $20, $20, -1      # outer counter--
    bne   $20, $0, outer_loop

    addiu $2, $0, 10        # exit syscall
    syscall
