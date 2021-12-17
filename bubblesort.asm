|; compute to adresse at index Ri of Array Ra
|;   Ra : adress of the array
|;   Ri : index
|;   Ro : final address at index Ri RESULT
.macro ADDR(Ra, Ri, Ro) MULC(Ri, 4, Ro) ADD (Ra, Ro, Ro)

|; Load a value from index Ri of Array Ra in Ro
|;   Ra : adress of the array
|;   Ri : index
|;   Ro : contains the ith of the array RESULT
.macro LDARR(Ra, Ri, Ro) ADDR(Ra, Ri, Ro) LD(Ro, 0, Ro)

|; Swap the content of two registers
|;   Ra : element Reg(Ra) to swap with element Reg(Rb)
|;   Rb : element Reg(Rb) to swap with element Reg(Ra)
|;   Rtmp1, Rtmp2 : tempory register to do the swap
.macro SWAP(Ra, Rb, RTMP1, RTMP2) LD(Ra, 0, RTMP1) LD(Rb, 0, RTMP2) ST(RTMP1, 0, Rb) ST(RTMP2, 0, Ra)

|; Bubblesort(array, size):
|;  Sort the given array using the Bubblesort algorithm
|;  @param array Address of array[0] in the DRAM
|;  @param size  Number of elements in the array
bubblesort:
  PUSH(LP)
  PUSH(BP)
  MOVE(SP, BP)
  PUSH(R1) PUSH(R2)
  PUSH(R3) PUSH(R4)
  PUSH(R5) PUSH(R6) PUSH(R7)
  LD(BP, -16, R1)             |; Reg(R1) <- array
  LD(BP, -12, R2)             
  SUBC(R2, 1, R2)             |; Reg(R2) <- size - 1
  MOVE(R31, R3)               |; Reg(R3) <- i

bubble_sort_loop_i:
  CMPLT(R3, R2, R0)           |; R0 <- (i < size - 1)
  BF(R0, bubble_sort_end)     |; Jmp(end) if not R0 (quit loop_i)
  MOVE(R31, R4)               |; Reg(R4) <- j

bubble_sort_loop_j:
  SUB(R2, R3, R5)
  CMPLT(R4, R5, R0)           |; R0 <- (j < size - 1 - i)
  BF(R0, bubble_sort_loop_i_2)|; Jmp(loop_i_2) if not R0 (quit loop_j)
  LDARR(R1, R4, R5)           |; R5 <- array[j] 
  ADDC(R4, 1, R4)             |; j ++
  LDARR(R1, R4, R6)           |; R6 <- array[j+1]
  CMPLT(R6, R5, R0)           |; R0 <- (array[j+1] < array[j])
.breakpoint
  BT(R0, bubble_sort_swap)    |; Jmp(swap) if R0
  BR(bubble_sort_loop_j)

bubble_sort_loop_i_2:
  ADDC(R3, 1, R3)             |; i ++
  BR(bubble_sort_loop_i)      |; Jmp(start of loop_i)

bubble_sort_swap:
  ADDR(R1, R4, R5)            |; R5 <- Address of array(j+1) 
  SUBC(R4, 1, R0)
  ADDR(R1, R0, R6)            |; R6 <- Address of array(j) 
  SWAP(R5, R6, R0, R7)        |; swap adresses of array[j] and array[j+1]
.breakpoint
  BR(bubble_sort_loop_j)

bubble_sort_end:
  POP(R7)
  POP(R6)
  POP(R5)
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()