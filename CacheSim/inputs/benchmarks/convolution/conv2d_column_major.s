.text

# 2D convolution benchmark: column-major traversal
# Image size: 32 x 32 words
# Kernel size: 3 x 3
# Output size: 30 x 30 words
# Input base address:  0x10000000
# Output base address: 0x10010000
# Same computation as the row-major version, but the traversal order is different.
# The inner loop moves down rows, so memory accesses have larger strides.

    addiu $8, $0, 30        # $8 = number of output columns to process
    lui   $10, 0x1000       # $10 = input base address 0x10000000
    lui   $11, 0x1001       # $11 = output base address 0x10010000
    addu  $12, $10, $0      # $12 = current input column pointer
    addu  $13, $11, $0      # $13 = current output column pointer

col_outer_loop:
    addiu $9, $0, 30        # $9 = number of output rows to process
    addu  $14, $12, $0      # $14 = current input cell pointer for this column
    addu  $15, $13, $0      # $15 = current output pointer for this column

row_inner_loop:
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

    addiu $14, $14, 128     # move input pointer to next row, same column
    addiu $15, $15, 120     # move output pointer to next row, same column
    addiu $9, $9, -1        # decrement row counter
    bne   $9, $0, row_inner_loop # repeat until all rows are done

    addiu $12, $12, 4       # move input column pointer to next column
    addiu $13, $13, 4       # move output column pointer to next column
    addiu $8, $8, -1        # decrement column counter
    bne   $8, $0, col_outer_loop # repeat until all columns are done

    addiu $2, $0, 10        # prepare exit syscall
    syscall                 # stop simulation
