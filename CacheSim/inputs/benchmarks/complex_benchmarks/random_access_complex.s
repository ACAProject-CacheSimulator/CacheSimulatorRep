.text

    addiu $8, $0, 256       # loop counter = 256 iterations
    lui   $10, 0x1000       # base address = 0x10000000
    addiu $9, $0, 0         # accumulator = 0

loop:
    lw    $11, 12($10)       # pseudo-random offset
    addu  $9, $9, $11        # use loaded value
    lw    $12, 200($10)       # pseudo-random offset
    addu  $9, $9, $12        # use loaded value
    lw    $13, 28($10)       # pseudo-random offset
    addu  $9, $9, $13        # use loaded value
    lw    $14, 364($10)       # pseudo-random offset
    addu  $9, $9, $14        # use loaded value
    lw    $15, 48($10)       # pseudo-random offset
    addu  $9, $9, $15        # use loaded value
    lw    $16, 520($10)       # pseudo-random offset
    addu  $9, $9, $16        # use loaded value
    lw    $17, 96($10)       # pseudo-random offset
    addu  $9, $9, $17        # use loaded value
    lw    $18, 748($10)       # pseudo-random offset
    addu  $9, $9, $18        # use loaded value
    lw    $11, 1024($10)       # pseudo-random offset
    addu  $9, $9, $11        # use loaded value
    lw    $12, 156($10)       # pseudo-random offset
    addu  $9, $9, $12        # use loaded value
    lw    $13, 2048($10)       # pseudo-random offset
    addu  $9, $9, $13        # use loaded value
    lw    $14, 308($10)       # pseudo-random offset
    addu  $9, $9, $14        # use loaded value
    lw    $15, 4096($10)       # pseudo-random offset
    addu  $9, $9, $15        # use loaded value
    lw    $16, 772($10)       # pseudo-random offset
    addu  $9, $9, $16        # use loaded value
    lw    $17, 6144($10)       # pseudo-random offset
    addu  $9, $9, $17        # use loaded value
    lw    $18, 124($10)       # pseudo-random offset
    addu  $9, $9, $18        # use loaded value
    lw    $11, 8192($10)       # pseudo-random offset
    addu  $9, $9, $11        # use loaded value
    lw    $12, 288($10)       # pseudo-random offset
    addu  $9, $9, $12        # use loaded value
    lw    $13, 12288($10)       # pseudo-random offset
    addu  $9, $9, $13        # use loaded value
    lw    $14, 452($10)       # pseudo-random offset
    addu  $9, $9, $14        # use loaded value
    lw    $15, 16380($10)       # pseudo-random offset
    addu  $9, $9, $15        # use loaded value
    lw    $16, 700($10)       # pseudo-random offset
    addu  $9, $9, $16        # use loaded value
    lw    $17, 64($10)       # pseudo-random offset
    addu  $9, $9, $17        # use loaded value
    lw    $18, 3000($10)       # pseudo-random offset
    addu  $9, $9, $18        # use loaded value
    lw    $11, 12000($10)       # pseudo-random offset
    addu  $9, $9, $11        # use loaded value
    lw    $12, 88($10)       # pseudo-random offset
    addu  $9, $9, $12        # use loaded value
    lw    $13, 6000($10)       # pseudo-random offset
    addu  $9, $9, $13        # use loaded value
    lw    $14, 144($10)       # pseudo-random offset
    addu  $9, $9, $14        # use loaded value
    lw    $15, 10000($10)       # pseudo-random offset
    addu  $9, $9, $15        # use loaded value
    lw    $16, 340($10)       # pseudo-random offset
    addu  $9, $9, $16        # use loaded value
    lw    $17, 14000($10)       # pseudo-random offset
    addu  $9, $9, $17        # use loaded value
    lw    $18, 220($10)       # pseudo-random offset
    addu  $9, $9, $18        # use loaded value
    addiu $8, $8, -1        # counter--
    bne   $8, $0, loop      # repeat

    addiu $2, $0, 10        # exit syscall
    syscall
