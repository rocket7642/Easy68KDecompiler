* Assumptions
*   D3 - contation a copy of instruction's 16 bits 

* Used
*   D4 - for storing instruction's bits
*   D7 - counter

* TODO: 
*  1.     main loop should reset local variables
*  2.     I/O - PRINT_DATA - for an illegal instruction. prints 1000    DATA    $WXYZ 
*                            $WXYZ is the hexadecimal number that couldn't be decoded
*  3.     PRINT_MOVEQ
*  4.     Main loop should clear the memory for mode and register variabels 


* ADDQ  0101 DDD 0 SS MMM RRR   

* MOVEQ 0111 RRR 0 DDDDDDDD     for RRR - DEST_REG; for DDDDDDDD - DATA_FIELD



* ADD   1101 RRR PPP MMM RRR 

* ADDA  1101 RRR PPP MMM RRR 



* after we stored the instruction's 16bits into a variable - Data

    JMP COMPARE_GROUPS      * go to group comparison 
    

******************** Commands Subrutins ********************

READ_BITS
    CLR.L   D7
    CLR.L   D4
    MOVE.B  Bits,D7
    
LOOP_READ_BITS    
    CMP.B   #0,D7           * counter
    BEQ     RETURN
    
    LSL.W   #1,D4           * make space for new bit
    LSL.W   #1,D3          

    BCS     SET             * if 1, then branch to SET
    SUBI.B  #1,D7          
    JMP     LOOP_READ_BITS
SET
    ADD.W   #%0001,D4       * adds 1 to the final destination (D4) 
    SUBI.B  #1, D7
    JMP     LOOP_READ_BITS  
    



COMPARE_GROUPS              * comapres the 4 bits of the instruction
    MOVE.B  #4,Bits         
    JSR     READ_BITS       * get the first 4 bits and store it in D4
    
    CMP.W   #%0000,D4       * 0000 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      * if equal, goes to PRINT_DATA ?
    
    CMP.W   #%0001,D4      
    BEQ     CHECK_MOVE_B    * if equal, goes to CHECK_MOVE.B
    
    CMP.W   #%0010,D4      
    BEQ     COMPARE_0010    * if equal, goes to COMPARE_0010 for MOVE.L and MOVEA.L
    
    CMP.W   #%0011,D4      
    BEQ     COMPARE_0011    * if equal, goes to COMPARE_0011 for MOVE.W and MOVEA.W
    
    CMP.W   #%0100,D4      
    BEQ     COMPARE_0100    * if equal, goes to COMPARE_0100 for NOP, MOVEM, LEA, NOT, JSR, RTS
    
    CMP.W   #%0101,D4      
    BEQ     CHECK_ADDQ      * if equal, goes to CHECK_ADDQ
    
    CMP.W   #%0110,D4      
    BEQ     COMPARE_0110    * if equal, goes to COMPARE_0110 for Bcc(BGT, BLE, BEQ) and BRA
    
    CMP.W   #%0111,D4      
    BEQ     CHECK_MOVEQ     * if equal, goes to CHECK_MOVEQ
    
    CMP.W   #%1000,D4      
    BEQ     CHECK_OR        * if equal, goes to CHECK_OR
    
    CMP.W   #%1001,D4      
    BEQ     CHECK_SUB       * if equal, goes to CHECK_SUB
    
    CMP.W   #%1010,D4       * 1010 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      * if equal, goes to PRINT_DATA ?
    
    CMP.W   #%1011,D4       * 1011 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      * if equal, goes to PRINT_DATA ?
    
    CMP.W   #%1100,D4      
    BEQ     CHECK_AND       * if equal, goes to CHECK_AND
    
    CMP.W   #%1101,D4      
    BEQ     COMPARE_1101    * if equal, goes to COMPARE_1101 for ADD and ADDA
    
    CMP.W   #%1110,D4      
    BEQ     COMPARE_1110    * if equal, goes to COMPARE_1110 for LSL, LSR, ASR, ASL, ROL, ROR
    
    CMP.W   #%1111,D4       * 1111 - ILLEGAL INSTRUCTION
    BEQ     PRINT_DATA      * if equal, goes to PRINT_DATA ?
    
    
******************** COMPARE WITHIN THE GROUP ********************
COMPARE_0100
    * TODO - check for LEA
    
    MOVE.B  #4,Bits
    JSR     READ_BITS
    
    CMP.W   #%0110,D4
    BEQ     CHECK_NOT           * goes to NOT
    
    CMP.W   #%1000,D4
    BEQ     CHECK_MOVEM_0       * goes to MOVEM0
    
    CMP.W   #%1100,D4       
    BEQ     CHECK_MOVEM_1       * goes to MOVEM1
    
    CMP.W   #%1110,D4
    BEQ     CHECK_NOP_JSR_RTS             * goes to compare for 1110 (NOP,JSR,RTS)
    BNE     PRINT_DATA
    
    

COMPARE_1101
    MOVE.B  #3,Bits
    JSR     READ_BITS       * reads and stores 3 bits in RRRT - temp register
    MOVE.B  D4,TEMP_REG
    
    MOVE.B  #1,Bits
    JSR     READ_BITS       * reads and stores 1 bit in XBit
    MOVE.B  D4,XBit
    
    MOVE.B  #2,Bits
    JSR     READ_BITS       * reads and stores 2 bits in SIZE
    MOVE.B  D4,SIZE
    
    MOVE.B  #%001,TEMP_MODE * sets TEMP_MODE to #%001 
    CMP.B   #%11,SIZE 
    BEQ     CHECK_ADDA      * if SIZE_FIELD is #%11 equals branches to CHECK_ADDA
    
    MOVE.B  #%000,TEMP_MODE * sets TEMP_MODEto #%000
    JSR     CHECK_XBIT
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,TEMP_MODE    * reads and stores 3 bits in TEMP_MODE
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,TEMP_REG    * reads and stores 3 bits in TEMP_REG    
    
    MOVE.B  #7,Command_Index
    JSR     CHECK_TEMP              * TODO: EA 
    CMP.B   #$F, Temp_Mode
    BEQ     PRINT_DATA
    CMP.B   #$E,Temp_Mode    
    BEQ     INVALID_EA              * TODO
    
    JMP     CHECK_ADD
    



************************************************** 


CHECK_NOT * TODO

CHECK_MOVEM_0 * TODO

CHECK_MOVEM_1 * TODO




*   NOP, JSR, RTS   *
CHECK_NOP_JSR_RTS 
    MOVE.B  #2,Bits
    JSR READ_BITS
    
    CMP.B   #%10,D4
    BEQ     CHECK_JSR           * goes to JSR
    
    CMP.B   #%01,D4 
    BEQ     CHECK_NOP_RTS       * goes to NOP and RTS
    BNE     PRINT_DATA

CHECK_JSR

CHECK_NOP_RTS
    MOVE.B  #6,Bits
    JSR READ_BITS
    
    CMP.B   #%110001,D4
    BEQ     PRINT_NOP           * TODO: check the name I/O; no EA calls 
    
    CMP.B   #%110101,D4
    BEQ     PRINT_RTS           * TODO: check the name I/O; no EA calls
    BNE     PRINT_DATA

CHECK_ADD
    CMP.B   #%00,SIZE
    BNE     CCHECK_ADD  
    CMP.B   #$1,Temp_Mode       * if Temp_Mode is invalid
    BEQ     INVALID_EA              * TODO 
CCHECK_ADD
    BRA     PRINT_ADD               * TODO: check the name I/O; check what need EA


CHECK_ADDA
    MOVE.B  #%01,SIZE
    CMP.B   #%0,XBIT
    BEQ     CCHECK_ADDA
    MOVE.B  #%10,SIZE
CCHECK_ADDA
    MOVE.B  TEMP_REG,DEST_REG
    MOVE.B  TEMP_MODE,DEST_MODE     * set MOVE_DEST to 'An'
    MOVE.B  #$1,DstMode
    
    MOVE.B  #3,Bits        
    JSR     READ_BITS
    MOVE.B  D4,SRC_MODE    
    
    MOVE.B  #3,Bits        
    JSR     READ_BITS
    MOVE.B  D4,SRC_REG
    
    MOVE.B  #8,Command_Index
    JSR     CHECK_SRC                   * TODO: EA (store in SrcMode)
    CMP.B   #$F,SrcMode
    BEQ     PRINT_DATA
    CMP.B   #$E,SrcMode
    BEQ     INVALID_EA                  * TODO 
    BRA     PRINT_ADDA                  * TODO: check the name I/O; check what need EA
    
    
    
    
CHECK_ADDQ
    MOVE.B  #3,Bits             * read next 3 bits
    JSR     READ_BITS           * store them in D4
    MOVE.B  D4,DATA_FIELD       * move data value
    
    JSR     FORMAT_DATA_FIELD     
    
    MOVE.B  #1,Bits             * read the next bit into D4
    JSR     READ_BITS
    CMP.B   #0,D4               * if not equal to 0 - ILLEGAL INSTRUCTION
    BNE     PRINT_DATA          * goes to PRINT_DATA ?

    MOVE.B  #2,Bits             * read the next bits into D4
    JSR     READ_BITS
    MOVE.B  D4,SIZE             * store size into SIZE
    CMP.B   #%11,SIZE           * cannot be #%11
    BEQ     PRINT_DATA

    MOVE.B  #3,Bits             * read the next bits into D4
    JSR     READ_BITS
    MOVE.B  D4,DEST_MODE        * store the effective address MODE in DEST_MODE
    
    MOVE.B  #3,Bits             * read the next bits into D4
    JSR     READ_BITS
    MOVE.B  D4,DEST_REG         * store the effective address REGISTER in DEST_REG
    
    MOVE.B  #6,Command_Index
    JSR     CHECK_DEST_MODE     * TODO: EA
    
    CMP.B   #$F,DEST_MODE       * if destination mode is invalid
    BEQ     PRINT_DATA         
    
    CMP.B   #$E,DEST_MODE       * if destination mode is invalid EA
    BEQ     INVALID_EA          * TODO 
    
    CMP.B   #$B,DEST_MODE       * if destination mode 111+100 = #<data>
    BEQ     INVALID_EA
    
    BRA     PRINT_ADDQ          * TODO: check the name I/O; check what need EA 
    

CHECK_MOVEQ
    MOVE.B  #3,Bits         * read next 3 bits
    JSR     READ_BITS       * store them in D4
    MOVE.B  D4,DEST_REG     * move register value
    
    MOVE.B  #1,Bits         * read the next bit into D4
    JSR     READ_BITS
    CMP.B   #0,D4           * if not equal to 0 - ILLEGAL INSTRUCTION
    BNE     PRINT_DATA      * goes to PRINT_DATA ?
    
    MOVE.B  #8,Bits        
    JSR     READ_BITS
    MOVE.B  D4,DATA_FIELD         * moves data value to DATA_FIELD
    
    MOVE.B  #%111,SRC_MODE  * 
    MOVE.B  #%100,SRC_REG   * 
    
    BRA     PRINT_MOVEQ         * TODO: check the name I/O; call EA from PRINT_MOVEQ FOR DEST_REG 

    
******************** OTHER COMMANDS ********************
RETURN
    RTS

FORMAT_DATA
    CMP.B   #0,DATA_FIELD
    BNE     RETURN
	MOVE.B  #8,DATA_FIELD
	RTS

******************** XBIT ********************
CHECK_XBIT      
    CMP.B   #%0,XBit
    BEQ     TEMP_TO_DEST    * if XBit equls #%0, set TEMP_REG and TEMP_MODE to DEST_REG and DEST_MODE
    BNE     TEMP_TO_SRC     * else set TEMP_REG and TEMP_MODE to SRC_REG and SRC_MODE
    RTS
TEMP_TO_DEST
    MOVE.B  TEMP_REG,DEST_REG
    MOVE.B  TEMP_MODE,DEST_MODE
    JSR     CHKDST                  * TODO: EA part of checking Destination
    RTS
TEMP_TO_SRC
    MOVE.B  TEMP_REG,SRC_REG
    MOVE.B  TEMP_MODE,SRC_MODE
    JSR     CHKSRC                  * TODO: EA part of checking Source
    RTS
            

********************  VARIABLES ******************** 

DEST_REG        DC.B    0

SRC_MODE        DC.B    0
SRC_REG         DC.B    0

TEMP_MODE       DC.B    0
TEMP_REG        DC.B    0

DATA_FIELD      DC.B    0
SIZE            DC.B    0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
