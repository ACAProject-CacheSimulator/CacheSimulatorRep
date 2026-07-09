.text

    # Large 2D convolution benchmark: row-major traversal
    # Input image: 128 x 128 words = 64 KB
    # Output image: 126 x 126 words = about 62 KB
    # Kernel: simplified 3x3 all-ones filter
    # This version processes the image row by row.

    addiu $21, $0, 2        # repeat the convolution 2 times

repeat_loop:
    lui   $10, 0x1000       # $10 = input base address 0x10000000
    lui   $11, 0x1004       # $11 = output base address 0x10040000
    addiu $12, $0, 126      # $12 = number of output rows

row_loop:
    addiu $13, $0, 126      # $13 = number of output columns
    addu  $14, $10, $0      # $14 = pointer to current input window
    addu  $15, $11, $0      # $15 = pointer to current output position

col_loop:
    lw    $16, 0($14)       # load input[i][j]
    lw    $17, 4($14)       # load input[i][j+1]
    lw    $18, 8($14)       # load input[i][j+2]
    lw    $19, 512($14)     # load input[i+1][j]
    lw    $20, 516($14)     # load input[i+1][j+1]
    lw    $22, 520($14)     # load input[i+1][j+2]
    lw    $23, 1024($14)    # load input[i+2][j]
    lw    $24, 1028($14)    # load input[i+2][j+1]
    lw    $25, 1032($14)    # load input[i+2][j+2]

    addu  $16, $16, $17     # accumulate 3x3 values
    addu  $16, $16, $18
    addu  $16, $16, $19
    addu  $16, $16, $20
    addu  $16, $16, $22
    addu  $16, $16, $23
    addu  $16, $16, $24
    addu  $16, $16, $25

    sw    $16, 0($15)       # store output[i][j]

    addiu $14, $14, 4       # move to next column in input
    addiu $15, $15, 4       # move to next column in output
    addiu $13, $13, -1      # column counter--
    bne   $13, $0, col_loop # continue current row

    addiu $10, $10, 512     # move input pointer to next row
    addiu $11, $11, 504     # move output pointer to next row
    addiu $12, $12, -1      # row counter--
    bne   $12, $0, row_loop # continue next row

    addiu $21, $21, -1      # repeat counter--
    bne   $21, $0, repeat_loop

    addiu $2, $0, 10        # exit syscall
    syscall
