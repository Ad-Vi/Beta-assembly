|; compute to adresse at index Ri of Array Ra
|;   Ra : adress of the array
|;   Ri : index
|;   Ro : final address at index Ri RESULT
.macro ADDR(Ra, Ri, Ro) MULC(Ri, 4, Ro) ADD(Ra, Ro, Ro)

|; Load a value from index Ri of Array Ra in Ro
|;   Ra : adress of the array
|;   Ri : index
|;   Ro : contains the ith of the array RESULT
.macro LDARR(Ra, Ri, Ro) ADDR(Ra, Ri, Ro) LD(Ro, 0, Ro)

|; Swap the content of two registers
|;   Ra : element Reg(Ra) to swap with element Reg(Rb)
|;   Rb : element Reg(Rb) to swap with element Reg(Ra)
|;   Rtmp1, Rtmp2 : tempory register to do the swap
.macro SWAP(RA, RB, RTMP1, RTMP2) LD(RA, 0, RTMP1) LD(RB, 0, RTMP2) ST(RTMP1, 0, RB) ST(RTMP2, 0, RA)

|; Swap the content of two position in an array
|;   Ra : adress of the arrray
|;   Rb : index of element 1 to swap
|;   Rc : index of element 2 to swap
|;   Rtmp1, Rtmp2 : tempory register to do the swap
.macro SWAPARR(Ra, Rb, Rc, RTMP1, RTMP2) ADDR(Ra, Rb, RTMP1) ADDR(Ra, Rc, RTMP2) SWAP(RTMP1, RTMP2, Rb, Rc)


quick_sort_partition:
  PUSH(LP)
  PUSH(BP)
  MOVE(SP, BP)
  PUSH(R1) PUSH(R2)
  PUSH(R3) PUSH(R4)
  PUSH(R5) PUSH(R6)
  PUSH(R7) PUSH(R8)
  LD(BP, -20, R1)                   |; Reg(R1) <- array
  LD(BP, -16, R2)            
  SUBC(R2, 1, R2)                   |; Reg(R2) <- size - 1
  LD(BP, -12, R3)                   |; Reg(R3) <- pivot pos

  ADDR(R1, R3, R4)                   |; R4 <- array + pivot pos ADDRESS
  ADDR(R1, R2, R5)                   |; R5 <- array + size - 1  ADDRESS
  SWAP(R4, R5, R6, R0)              
  SWAPARR(R1, R3, R2, R4, R5)       |; Swap pivot with the end of the array

  LDARR(R1, R2, R6)                 |; R6 <- pivot_val = array[size - 1]
  CMOVE(-1, R7)                     |; R7 <- small 
  MOVE(R31, R8)                     |; R8 <- current

quick_sort_partition_loop:
  CMPLT(R8, R2, R0)                 |; R0 <- (current < size - 1)
  BF(R0, quick_sort_partition_2)    |; JMP(_2) if not R0  (quit loop)
  ADDC(R8, 1, R8)                   |; current ++
  
  LDARR(R1, R8, R0)                 |; R0 <- array[current]
  CMPLE(R0, R6, R0)                 |; R0 <- (array[current] <= pivot_val)
  BF(R0, quick_sort_partition_loop) |; JMP(loop) if not R0 (do not make the if bloc)

                                    |; if (array[current] <= pivot_val) :
  ADDC(R7, 1, R7)                   |; small ++

  ADDR(R1, R8, R4)                   |; R4 <- array + current ADDRESS
  ADDR(R1, R7, R5)                   |; R5 <- array + small   ADDRESS
  SWAP(R4, R5, R6, R0)              |; swap(array + current, array + small)

  SWAPARR(R1, R8, R7, R4, R5)
quick_sort_partition_2:
  ADDC(R7, 1, R0)
  ADDR(R1, R0, R4)                   |; R4 <- array + small + 1 ADDRESS
  ADDR(R1, R2, R5)                   |; R5 <- array + size - 1  ADDRESS
  SWAP(R4, R5, R6, R0)              |; swap(array + small + 1, array + size - 1)

  SWAPARR(R1, R0, R2, R4, R5)
  ADDC(R7, 1, R0)                   |; R0 <- small + 1 => returned value

quick_sort_partition_end:
  POP(R8)
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