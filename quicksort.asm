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
.macro SWAP(Ra, Rb, RTMP1, RTMP2) LD(Ra, 0, RTMP1) LD(Rb, 0, RTMP2) ST(RTMP1, 0, Rb) ST(RTMP2, 0, Ra)

|; Swap the content of two position in an array
|;   Ra : adress of the arrray
|;   Rb : index of element 1 to swap
|;   Rc : index of element 2 to swap
|;   Rtmp1, Rtmp2 : tempory register to do the swap
.macro SWAPARR(Ra, Rb, Rc, RTMP1, RTMP2) PUSH(Rb) PUSH(Rc) ADDR(Ra, Rb, Rb) ADDR(Ra, Rc, Rc) SWAP(Rb, Rc, RTMP1, RTMP2) POP(Rc) POP(Rb)


|; Quicksort(array, size):
|;  Sort the given array using the quicksort algorithm
|;  @param array Address of array[0] in the DRAM
|;  @param size  Number of elements in the array
quicksort:
  PUSH(LP)
  PUSH(BP)
  MOVE(SP, BP)
  PUSH(R1) PUSH(R2)
  PUSH(R3) PUSH(R4)
  
  LD(BP, -16, R1)               |; Reg(R1) <- array
  LD(BP, -12, R2)               |; Reg(R2) <- size

  CMPLEC(R2, 1, R0)             |; R0 <- (size <= 1)
  BT(R0, quick_sort_end)        |; JMP(end) if (size <= 1)

  DIVC(R2, 2, R0)               |; R0 <-  size / 2
  SUBC(R0, 1, R0)               |; R0 <- (size / 2) - 1

                                |; arguments partition 
  PUSH(R1)                      |;   array             => array
  PUSH(R2)                      |;   size              => size
  PUSH(R0)                      |;   (size / 2) - 1    => pivot pos
|;.breakpoint
  CALL(quick_sort_partition, 3) |; R0 <- new pivot pos
  MOVE(R0, R3)                  |; R3 <- new pivot pos

                                |; arguments quicksort SORT THE LEFT SUBARRAY
  PUSH(R1)                      |;   array             => array
  PUSH(R3)                      |;   new pivot pos     => size
|;.breakpoint
  CALL(quicksort, 2)
.breakpoint
  ADDC(R3, 1, R4)         
  ADDR(R1, R4, R4)              |; R4 <- array + pivot + 1 ADDRESS
  SUB(R2, R3, R0)
  SUBC(R0, 1, R0)               |; R0 <- size - pivot - 1
  
                                |; arguments quicksort SORT THE RIGTH SUBARRAY
  PUSH(R4)                      |;   array + pivot + 1 => array ADDRESS
  PUSH(R0)                      |;   size - pivot - 1  => size  
.breakpoint
  CALL(quicksort, 2)

quick_sort_end:
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()

|; Quicksort_partition(array, size, pivot):
|;  
|;  @param array      Address of array[0] in the DRAM
|;  @param size       Number of elements in the array
|;  @param pivot pos  Position of the pivot in the array
|;  @return  small + 1 in R0, new pivot position 
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

  SWAPARR(R1, R3, R2, R4, R5)       |; Swap pivot with the end of the array
  LDARR(R1, R2, R6)                 |; R6 <- pivot_val = array[size - 1]
  CMOVE(-1, R7)                     |; R7 <- small 
  CMOVE(-1, R8)                     |; R8 <- current

quick_sort_partition_loop:
  CMPLT(R8, R2, R0)                 |; R0 <- (current < size - 1)
  BF(R0, quick_sort_partition_2)    |; JMP(_2) if not R0  (quit loop)
  ADDC(R8, 1, R8)                   |; current ++
  
  LDARR(R1, R8, R0)                 |; R0 <- array[current]
  ADDC(R6, 1, R4)
  CMPLT(R0, R4, R0)                 |; R0 <- (array[current] <= pivot_val)
  BF(R0, quick_sort_partition_loop) |; JMP(loop) if not R0 (do not make the if bloc)

                                    |; if (array[current] <= pivot_val) :
  ADDC(R7, 1, R7)                   |; small ++
  SWAPARR(R1, R8, R7, R4, R5)       |; swap(array + current, array + small)
  BR(quick_sort_partition_loop)
quick_sort_partition_2:
  ADDC(R7, 1, R0)
  SWAPARR(R1, R0, R2, R4, R5)       |; swap(array + small + 1, array + size - 1)
  
  ADDC(R7, 1, R0)                   |; returned value : small + 1

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


