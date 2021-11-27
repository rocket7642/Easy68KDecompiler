; Used
;   D4 - for storing instruction's bits
;   D7 - ?

; TODO: 
;  1.     main loop should reset local variables
;  2.     I/O - PRINT_DATA - for an illegal instruction. prints 1000    DATA    $WXYZ 
;                            $WXYZ is the hexadecimal number that couldn't be decoded








; after we stored the instruction's 16bits into a variable - Data

    JMP COMPARE_GROUPS      ; go to group comparison 
    

; ----- Commands Subrutins ----- ;

COMPARE_GROUPS              ; comapres the 4 bits of the instruction
    MOVE.B  #4, Bits         
    JSR     READ_BITS       ; get the first 4 bits and store it in D4
    
    CMP.W   #%0000, D4      ; 0000 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      ; if equal, goes to PRINT_DATA ?
    
    CMP.W   #%0001, D4      
    BEQ     CHECK_0001      ; if equal, goes to CHECK_0001 for MOVE.B
    
    CMP.W   #%0010, D4      
    BEQ     COMPARE_0010    ; if equal, goes to COMPARE_0010 for MOVE.L and MOVEA.L
    
    CMP.W   #%0011, D4      
    BEQ     COMPARE_0011    ; if equal, goes to COMPARE_0011 for MOVE.W and MOVEA.W
    
    CMP.W   #%0100, D4      
    BEQ     COMPARE_0100    ; if equal, goes to COMPARE_0100 for NOP, MOVEM, LEA, NOT, JSR, RTS
    
    CMP.W   #%0101, D4      
    BEQ     CHECK_0101      ; if equal, goes to CHECK_0101 for ADDQ
    
    CMP.W   #%0110, D4      
    BEQ     COMPARE_0110    ; if equal, goes to CHECK_0110 for Bcc(BGT, BLE, BEQ) and BRA
    
    CMP.W   #%0111, D4      
    BEQ     CHECK_0111      ; if equal, goes to CHECK_0111 for MOVEQ
    
    CMP.W   #%1000, D4      
    BEQ     CHECK_1000      ; if equal, goes to CHECK_1000 for OR
    
    CMP.W   #%1001, D4      
    BEQ     CHECK_1001      ; if equal, goes to CHECK_1001 for SUB
    
    CMP.W   #%1010, D4      ; 1010 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      ; if equal, goes to PRINT_DATA ?
    
    CMP.W   #%1011, D4      ; 1011 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      ; if equal, goes to PRINT_DATA ?
    
    CMP.W   #%1100, D4      
    BEQ     CHECK_1100      ; if equal, goes to CHECK_1100 for AND
    
    CMP.W   #%1101, D4      
    BEQ     COMPARE_1101    ; if equal, goes to COMPARE_1101 for ADD and ADDA
    
    CMP.W   #%1110, D4      
    BEQ     COMPARE_1110    ; if equal, goes to COMPARE_1110 for LSL, LSR, ASR, ASL, ROL, ROR
    
    CMP.W   #%1111, D4      ; 1111 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      ; if equal, goes to PRINT_DATA ?
    
    
READ_BITS
    CLR.L   D7
    CLR.L   D4
    MOVE.B  Bits, D7
    
LOOP_READ_BITS    
    CMP.B   #0, D7          ; counter
    BEQ     RETURN
    
    LSL.W   #1, D4          ; make space for new bit
    LSL.W   #1, D3          

    BCS     SET             ; if 1, then branch to SET
    SUBI.B  #1, D7          
    JMP     LOOP_READ_BITS
SET
    ADD.W   #%0001, D4      ; adds 1 to the final destination (D4) 
    SUBI.B  #1, D7
    JMP     LOOP_READ_BITS  
    
    
; ----- Other commads ----- ;
RETURN
    RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
