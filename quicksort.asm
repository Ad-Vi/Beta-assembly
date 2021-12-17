.include quick_sort_partition.asm
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
  PUSH(R0)                      |;   (size / 2) - 1    => pivot pos
  PUSH(R2)                      |;   size              => size
  PUSH(R1)                      |;   array             => array
|;.breakpoint
  CALL(quick_sort_partition, 3) |; R0 <- new pivot pos
  MOVE(R0, R3)                  |; R3 <- new pivot pos

                                |; arguments quicksort SORT THE LEFT SUBARRAY
  PUSH(R3)                      |;   new pivot pos     => size
  PUSH(R1)                      |;   array             => array
|;.breakpoint
  CALL(quicksort, 2)

  ADD(R1, R3, R4)         
  ADDC(R4, 1, R4)               |; R4 <- array + pivot + 1
  SUB(R2, R3, R0)
  SUBC(R0, 1, R0)               |; R0 <- size - pivot - 1
  
                                |; arguments quicksort SORT THE RIGTH SUBARRAY
  PUSH(R0)                      |;   size - pivot - 1  => size  
|;.breakpoint
  PUSH(R4)                      |;   array + pivot + 1 => array
  CALL(quicksort, 2)


quick_sort_end:
  POP(R4)
  POP(R3)
  POP(R2)
  POP(R1)
  POP(BP)
  POP(LP)
  RTN()