.include beta.uasm

CMOVE(stack__, SP)          |; Initialize stack pointer (SP) 
MOVE(SP, BP)                |; Initialize base of frame pointer (BP)
BR(main__)                  |; Go to 'main' code segment

array_size=10

array__:
    STORAGE(array_size)     |; Reserve space for storage

main__:
    CMOVE(array__, R1)      |; Reg[R1] <- Address of array[0]
    CMOVE(array_size, R2)   |; Reg[R2] <- Array size
    PUSH(R1)                |; Push parameter 1: array 
    PUSH(R2)                |; Push parameter 2: size
    CALL(fill__)
    CALL(random_shuffle__)
.breakpoint
    CALL(bubblesort)        |; or use CALL(quicksort) for testing your quicksort
    DEALLOCATE(2)

end__:
    .breakpoint
    HALT()

.include bubblesort.asm     |; .include quicksort.asm for testing your quicksort
.include util.asm

LONG(0xDEADCAFE)            |; 0xDEADCAFE constant indicates the base of the stack
stack__: 
    STORAGE(1024)
