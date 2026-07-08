.text

# 2D convolution benchmark: row-major traversal
# Image size: 32 x 32 words
# Kernel size: 3 x 3
# Output size: 30 x 30 words
# Input base address:  0x10000000
# Output base address: 0x10010000
# The kernel is equivalent to all ones, so each output is the sum of 9 neighboring pixels.

    addiu $8, $0, 30        # $8 = number of output rows to process
    lui   $10, 0x1000       # $10 = input base address 0x10000000
    lui   $11, 0x1001       # $11 = output base address 0x10010000
    addu  $12, $10, $0      # $12 = current input row pointer
    addu  $13, $11, $0      # $13 = current output row pointer

row_loop:
    addiu $9, $0, 30        # $9 = number of output columns to process
    addu  $14, $12, $0      # $14 = current input cell pointer for this row
    addu  $15, $13, $0      # $15 = current output pointer for this row

col_loop:
    lw    $17, 0($14)       # load input[i][j]
    lw    $18, 4($14)       # load input[i][j+1]
    lw    $19, 8($14)       # load input[i][j+2]
    lw    $20, 128($14)     # load input[i+1][j]
    lw    $21, 132($14)     # load input[i+1][j+1]
    lw    $22, 136($14)     # load input[i+1][j+2]
    lw    $23, 256($14)     # load input[i+2][j]
    lw    $24, 260($14)     # load input[i+2][j+1]
    lw    $25, 264($14)     # load input[i+2][j+2]

    addu  $16, $17, $18     # sum = first two values
    addu  $16, $16, $19     # add third value
    addu  $16, $16, $20     # add fourth value
    addu  $16, $16, $21     # add fifth value
    addu  $16, $16, $22     # add sixth value
    addu  $16, $16, $23     # add seventh value
    addu  $16, $16, $24     # add eighth value
    addu  $16, $16, $25     # add ninth value

    sw    $16, 0($15)       # store output[i][j]

    addiu $14, $14, 4       # move input pointer to next column
    addiu $15, $15, 4       # move output pointer to next column
    addiu $9, $9, -1        # decrement column counter
    bne   $9, $0, col_loop  # repeat until all columns are done

    addiu $12, $12, 128     # move input row pointer to next image row
    addiu $13, $13, 120     # move output row pointer to next output row
    addiu $8, $8, -1        # decrement row counter
    bne   $8, $0, row_loop  # repeat until all rows are done

    addiu $2, $0, 10        # prepare exit syscall
    syscall                 # stop simulation
