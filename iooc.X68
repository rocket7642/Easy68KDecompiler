*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
CR      EQU     $0D
LF      EQU     $0A     
START:  ORG    $1000     ; first instruction of program

* Put program code here
    MOVE.L #0,D2
    BRA LOADDATAONE
    
* TODO: a welcome message with format message 
    
LOADDATAONE
    LEA      MESSAGEFIRSTADRESS,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14    
    
    LEA     INPUT,A1
    MOVE.B  #2,D0 *takes the string of what the user enters
    TRAP    #15
    
    CLR.L   D0
    
    * TODO: check if the input if odd - invalid input
    

    
    MOVE.B  #0,D5
    
    MOVE.B (A1)+,$A000
    MOVE.B (A1)+,$A010
    MOVE.B (A1)+,$A020
    MOVE.B (A1)+,$A030
    MOVE.B (A1)+,$A040
    MOVE.B (A1)+,$A050
    MOVE.B (A1)+,$A060
    MOVE.B (A1)+,$A070
    
    BRA VAL1

LOADDATATWO    
    LEA      MESSAGESECONDADRESS,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14    
    
    MOVE.B  #2,D0 *takes the string of what the user enters
    TRAP    #15
    
    MOVE.B  #0,D5
    
    MOVE.B (A1)+,$A000
    MOVE.B (A1)+,$A010
    MOVE.B (A1)+,$A020
    MOVE.B (A1)+,$A030
    MOVE.B (A1)+,$A040
    MOVE.B (A1)+,$A050
    MOVE.B (A1)+,$A060
    MOVE.B (A1)+,$A070
    
    BRA VAL1

    
VAL1    
    MOVE.B $A000,D4
    BRA STARTCHECK
VAL2    MOVE.B D4,$A000
    MOVE.B $A010,D4
    BRA STARTCHECK
VAL3    MOVE.B D4,$A010
    MOVE.B $A020,D4
    BRA STARTCHECK
VAL4    MOVE.B D4,$A020
    MOVE.B $A030,D4
    BRA STARTCHECK
VAL5    MOVE.B D4,$A030
    MOVE.B $A040,D4
    BRA STARTCHECK
VAL6    MOVE.B D4,$A040
    MOVE.B $A050,D4
    BRA STARTCHECK
VAL7    MOVE.B D4,$A050
    MOVE.B $A060,D4
    BRA STARTCHECK
VAL8    MOVE.B D4,$A060
    MOVE.B $A070,D4
    BRA STARTCHECK
  
STARTCHECK  
    CMP.B   #48,D4
    BLT INVALID
    CMP.B   #48,D4
    BEQ INTSUB
    CMP.B   #48,D4
    BGT INT2
    

INT2 
    
    CMP.B   #57,D4
    BLT INTSUB
    CMP.B   #57,D4
    BEQ INTSUB
    CMP.B   #57,D4
    BGT CHAR1
    
INTSUB 
    SUB.B #$30,D4
    BRA     DONE

CHAR1 
    
    CMP.B   #65,D4
    BLT INVALID
    CMP.B   #65,D4
    BEQ CHARSUB
    CMP.B   #65,D4
    BGT CHAR2
    
CHAR2 
    
    CMP.B   #70,D4
    BLT CHARSUB
    CMP.B   #70,D4
    BEQ CHARSUB
    CMP.B   #70,D4
    BGT INVALID
    
CHARSUB 
    SUB.B #$37,D4
    BRA DONE
    
INVALID 
    LEA BADVAL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     ENTRYLOOP
    
ENTRYLOOP
    CMP.B #0,D2
    BEQ LOADDATAONE
    CMP.B #1,D2
    BEQ LOADDATATWO
    RTS
    
DONE    ADD.B #1,D5
        CMP.B #0,D5
        BEQ VAL1
        CMP.B #1,D5
        BEQ VAL2
        CMP.B #2,D5
        BEQ VAL3
        CMP.B #3,D5
        BEQ VAL4
        CMP.B #4,D5
        BEQ VAL5
        CMP.B #5,D5
        BEQ VAL6
        CMP.B #6,D5
        BEQ VAL7
        CMP.B #7,D5
        BEQ VAL8
        CMP.B #8,D5
        BEQ EXIT
        
        BRA     STARTCHECK



EXIT    MOVE.B D4,$A070
    
    CLR.L D4
    ADD.B $A000,D4
    LSL.L #4,D4
    ADD.B $A010,D4
    LSL.L #4,D4
    ADD.B $A020,D4
    LSL.L #4,D4
    ADD.B $A030,D4
    LSL.L #4,D4
    ADD.B $A040,D4
    LSL.L #4,D4
    ADD.B $A050,D4
    LSL.L #4,D4
    ADD.B $A060,D4
    LSL.L #4,D4
    ADD.B $A070,D4
    
    MOVE.L D4,D7
    CLR D4
    CMP.B #1,D2
    BEQ STOREADRESSES
    MOVE.L D7,D6
    MOVE.B #1,D2
    MOVE.L #0,D5
    BRA LOADDATATWO
    
;---------------------------------------------------------

STOREADRESSES
    MOVE.L  D7,ENDINGADDRESS
    MOVE.L  D6,STARTINGADDRESS
    CLR     D7
    MOVE.L   ENDINGADDRESS,A7
    MOVE.L   STARTINGADDRESS,A6
    JMP     MEMORYGRABBER
    
MEMORYGRABBER
    CMPA.L  ENDINGADDRESS,A6
    BGT     ENDING 
    
     CMP.B   #25,CYCLECOUNTER * TODO: IMPLEMENT PAGEBREAK
     BEQ     PAGEBREAK
     ADD.B   #1,CYCLECOUNTER
    
    JSR     CLEARMR      * CLEAR MODES AND REGISTERS
    
    MOVE.L      A6,CURRENTADDRESS   
    MOVE.L      CURRENTADDRESS,D1
    MOVE.B      #16,D2
    MOVE.B      #15,D0     ; moves #14 into data register D0
    TRAP        #15  
    LEA      CLRSPOT,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15  
    
    MOVE.W      (A6)+, D3   * copy instruction's 16 bits into D3
    MOVE.W      D3, COMMANDDATA
 
    BRA         COMPARE_GROUPS
    
    BRA MEMORYGRABBER
    
PAGEBREAK
    LEA      USERPAGEBREAK,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA     INPUT,A1
    MOVE.B  #2,D0 *takes the string of what the user enters
    TRAP    #15
    
    
;-------------------------- OP CODE SECTION -------------------------------

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

    CMP.W   #%0001,D4      
    *BEQ     CHECK_MOVE_B    * if equal, goes to CHECK_MOVE.B
    
    CMP.W   #%0010,D4      
    *BEQ     COMPARE_0010    * if equal, goes to COMPARE_0010 for MOVE.L and MOVEA.L
    
    CMP.W   #%0011,D4      
    *BEQ     COMPARE_0011    * if equal, goes to COMPARE_0011 for MOVE.W and MOVEA.W
    
    CMP.W   #%0100,D4      
    BEQ     COMPARE_0100    * if equal, goes to COMPARE_0100 for NOP, MOVEM, LEA, NOT, JSR, RTS
    
    CMP.W   #%0101,D4      
    BEQ     CHECK_ADDQ      * if equal, goes to CHECK_ADDQ
    
    CMP.W   #%0110,D4      
    *BEQ     COMPARE_0110    * if equal, goes to COMPARE_0110 for Bcc(BGT, BLE, BEQ) and BRA
    
    CMP.W   #%0111,D4      
    BEQ     CHECK_MOVEQ     * if equal, goes to CHECK_MOVEQ
    
    CMP.W   #%1000,D4      
    *BEQ     CHECK_OR        * if equal, goes to CHECK_OR
    
    CMP.W   #%1001,D4      
    *BEQ     CHECK_SUB       * if equal, goes to CHECK_SUB
    
    CMP.W   #%1100,D4      
    *BEQ     CHECK_AND       * if equal, goes to CHECK_AND
    
    CMP.W   #%1101,D4      
    BEQ     COMPARE_1101    * if equal, goes to COMPARE_1101 for ADD and ADDA
    
    CMP.W   #%1110,D4      
    *BEQ     COMPARE_1110    * if equal, goes to COMPARE_1110 for LSL, LSR, ASR, ASL, ROL, ROR
    
    BNE     PRINT_DATA      * all other instructions are not supported 




*************************** NOP, MOVEM, LEA, NOT, JSR, RTS ***************************

COMPARE_0100
    BTST.L  #$0C,D3             * compare bit 8 for LEA
    BNE     CHECK_LEA
    
    MOVE.B  #4,Bits
    JSR     READ_BITS
    
    CMP.W   #%0110,D4
    BEQ     CHECK_NOT           * goes to NOT
    
    CMP.W   #%1000,D4
    BEQ     CHECK_MOVEM_1000       * goes to MOVEM_1000
    
    CMP.W   #%1100,D4       
    BEQ     CHECK_MOVEM_1100       * goes to MOVEM_1100
    
    CMP.W   #%1110,D4
    BEQ     CHECK_NOP_JSR_RTS             * goes to compare for 1110 (NOP,JSR,RTS)
    
    BNE     PRINT_DATA




CHECK_LEA
    MOVE.B  #3,Bits  
    JSR     READ_BITS 
    MOVE.B  D4,DEST_REG  

    MOVE.B  #3,Bits
    JSR     READ_BITS
    CMP.B   #7,D4               * if mode = 111 = continue
    BNE     PRINT_DATA

    MOVE.B  #3,Bits
    JSR     READ_BITS 
    MOVE.B  D4,SRC_MODE           

    MOVE.B  #3,Bits 
    JSR     READ_BITS 
    MOVE.B  D4,SRC_REG 
    
    *MOVE.B  #3,CmdIndex         
	JSR		CHECK_SOURCE 				* Check Source Mode
	
	CMP.B   #$F,SrcMode         * If SrcMode is invalid
    BEQ     PRINT_DATA
	
	CMP.B   #$2,SrcMode         * If SrcMode is 010 = '(An)'
    BEQ     PRINTLEA    	
	
	CMP.B   #$7,SrcMode         * If SrcMode is 111 + 000 = (XXX).W
    BEQ     PRINTLEA    
	
	CMP.B   #$8,SrcMode         * If SrcMode is 111 + 001 = (XXX).L
    BEQ     PRINTLEA
        	
	MOVE.B  #1,INVALID_EA	
    BRA     PRINTLEA    
    *TODO: WHEN PRINTJSR CHECK IF THIS FLAG IS 1 -> PRINT 'INVALID EA

    
CHECK_NOT 
    * TODO : TEST
    MOVE.B  #2,Bits             
    JSR     READ_BITS             
    MOVE.B  D4,SIZE_BIT               * Stores size 
    
    JSR     SETSIZE2             * set correct size for printing
    
    CMP.B   #%11,D4             * Compare the size bits to 00, 01, 10 (b,w,l)
    BEQ     PRINT_DATA          * Else, If 11 size invalid
    
    MOVE.B  #3,Bits       
    JSR     READ_BITS       
    MOVE.B  D4,DEST_MODE             

    MOVE.B  #3,Bits       
    JSR     READ_BITS
    MOVE.B  D4,DEST_REG             
    
    *MOVE.B  #2,CmdIndex 
	JSR		CHECK_DESTINATION				* Check Destination Mode

	CMP.B   #$F,DstMode         * If DstMode is invalid
    BEQ     PRINT_DATA  	

    CMP.B   #$E,DstMode         * If DstMode is invalid EA
    MOVE.B  #1,INVALID_EA           	* FLAG FOR INVALID EA
	*TODO: WHEN PRINTJSR CHECK IF THIS FLAG IS 1 -> PRINT 'INVALID EA

	CMP.B   #$1,DstMode         * If DstMode is 001 = 'An'
    MOVE.B  #1,INVALID_EA           	* FLAG FOR INVALID EA
	
	CMP.B   #$B,DstMode         * If DstMode is 111 + 100 = #<data>
    MOVE.B  #1,INVALID_EA           	* FLAG FOR INVALID EA
	BRA		PRINTNOT

CHECK_MOVEM_1000 
    * TODO : TEST WITH EA 
    MOVE.B  #1,Bits
    JSR     READ_BITS
    CMP.B   #%1,D4
    BNE     PRINT_DATA
    
    MOVE.B  #1,Bits
    JSR     READ_BITS
    MOVE.B  D4,SIZE_BIT
    
    JSR     SETSIZE1

    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,TEMP_MODE
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,TEMP_REG
    
    JSR     CHECK_TEMP
    JSR     CHECK_XBIT
    
    CMP.B   #$F,TempMode        * If TempMode is invalid
    BEQ     PRINT_DATA           	* Print DATA instead

    CMP.B   #$E,TempMode        * If TempMode is invalid EA
  *  BEQ     SETINVEA          	* 
    MOVE.B  #1,INVALID_EA
   *TODO: WHEN PRINTJSR CHECK IF THIS FLAG IS 1 -> PRINT 'INVALID EA

    CMP.B   #$2,TempMode        * If TempMode is 010 = '(An)'
    BEQ     PRINTMOVEM           	

    CMP.B   #$7,TempMode        * If TempMode is 111 + 000 = (XXX).W
    BEQ     PRINTMOVEM	 

    CMP.B   #$8,TempMode        * If TempMode is 111 + 001 = (XXX).L
    BEQ     PRINTMOVEM	 
               
    CMP.B   #$4,DstMode         * If DstMode is 100 = '-(An)'
    BEQ     PRINTMOVEM	 

    CMP.B   #$3,SrcMode         * If SrcMode is 011 = '(An)+'
    BEQ     PRINTMOVEM	 
   * BRA     SETINVEA
    
CHECK_MOVEM_1100     
    MOVE.B      #1,XBIT
    

CHECK_NOP_JSR_RTS   *   NOP, JSR, RTS   *
    MOVE.B  #2,Bits
    JSR     READ_BITS
    
    CMP.B   #%10,D4
    BEQ     CHECK_JSR           * goes to JSR
    
    CMP.B   #%01,D4 
    BEQ     CHECK_NOP_RTS       * goes to NOP and RTS

    BNE     PRINT_DATA

CHECK_JSR       * TODO: TEST

    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,DEST_MODE
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,DEST_REG
    
    *MOVE.B  #4,INDEX
    JSR     CHECK_DESTINATION
    
    CMP.B   #$F,DstMode         * if invalid print DATA
    BEQ     PRINT_DATA
    
    CMP.B   #$2,DstMode         * if DstMode 010        
    BEQ     PRINTJSR
    
    CMP.B   #$7,DstMode         * if DstMode 111 + 000
    BEQ     PRINTJSR
    
    CMP.B   #$8,DstMode         * if DstMode 111 + 001
    BEQ     PRINTJSR
    
    MOVE.B  #1,INVALID_EA      * sets flag that EA is invalid 
    *TODO: WHEN PRINTJSR CHECK IF THIS FLAG IS 1 -> PRINT 'INVALID EA
    BRA     PRINTJSR
    
CHECK_NOP_RTS
    MOVE.B  #6,Bits
    JSR READ_BITS
    
    CMP.B   #%110001,D4
    BEQ     PRINTNOP            
    
    CMP.B   #%110101,D4
    BEQ     PRINTRTS       
        
    BNE     PRINT_DATA

************************** ADDQ ***************************
CHECK_ADDQ
    MOVE.B  #3,Bits 
    JSR     READ_BITS
    MOVE.B  D4,DATA_FIELD
    
    JSR     FORMAT_DATA     
    
    MOVE.B  #1,Bits
    JSR     READ_BITS
    CMP.B   #0,D4               * if not equal to 0 - ILLEGAL INSTRUCTION
    BNE     PRINT_DATA          * goes to PRINT_DATA

    MOVE.B  #2,Bits
    JSR     READ_BITS
    MOVE.B  D4,SIZE_BIT             * store size into SIZE
    CMP.B   #%11,SIZE_BIT           * cannot be #%11
    BEQ     PRINT_DATA
    JSR     SETSIZE2            * for printing 

    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,DEST_MODE        * store the effective address MODE in DEST_MODE
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,DEST_REG         * store the effective address REGISTER in DEST_REG
    
   * MOVE.B  #6,INDEX
    JSR     CHECK_DESTINATION    
    
    CMP.B   #$F,DEST_MODE       * if destination mode is invalid
    BEQ     PRINT_DATA         
    
 *   CMP.B   #$E,DEST_MODE       * if destination mode is invalid EA
 *   BEQ     INVALID_EA          * TODO 
    
 *   CMP.B   #$B,DEST_MODE       * if destination mode 111+100 = #<data>
 *   BEQ     INVALID_EA         * TODO
    
    BRA     PRINTADDQ          * TODO: check the name I/O; check what need EA 

************************** ADD, ADDA **********************
COMPARE_1101    * ADD and ADDA 
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
    
    MOVE.B  #%000,TEMP_MODE * sets TEMP_MODE to #%000
    JSR     CHECK_XBIT
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,TEMP_MODE    * reads and stores 3 bits in TEMP_MODE
    
    MOVE.B  #3,Bits
    JSR     READ_BITS
    MOVE.B  D4,TEMP_REG    * reads and stores 3 bits in TEMP_REG    
    
    MOVE.B  #7,INDEX
  *  JSR     CHECK_TEMP              * TODO:  
    CMP.B   #$F, Temp_Mode
    BEQ     PRINT_DATA
    CMP.B   #$E,Temp_Mode    
    BEQ     INVALID_EA              * TODO
    
    JMP     CHECK_ADD
    
CHECK_ADD
    CMP.B   #%00,SIZE
    BNE     CCHECK_ADD  
    CMP.B   #$1,Temp_Mode       * if Temp_Mode is invalid
    BEQ     INVALID_EA              * TODO 
CCHECK_ADD
    BRA     PRINTADD               * TODO: check the name I/O; check what need EA


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
    
   * MOVE.B  #8,INDEX
   * JSR     CHECK_SOURCE                   * TODO:
   * CMP.B   #$F,SrcMode
   * BEQ     PRINT_DATA
   * CMP.B   #$E,SrcMode
   * BEQ     INVALID_EA                  * TODO 
    
    BRA     PRINTADDA                  * TODO: check the name I/O; check what need EA
    
    
    
    



************************** MOVEQ ********************************
CHECK_MOVEQ
    MOVE.B  #3,Bits         * read next 3 bits
    JSR     READ_BITS       * store them in D4
    MOVE.B  D4,DEST_REG     * move register value (used in EA)
    MOVE.B DEST_REG,D2
    MOVE.B #%000,D3
    
    MOVE.B  #1,Bits         * read the next bit into D4
    JSR     READ_BITS
    CMP.B   #0,D4           * if not equal to 0 - ILLEGAL INSTRUCTION
    BNE     PRINT_DATA      * goes to PRINT_DATA ?
    
    MOVE.B  #8,Bits        
    JSR     READ_BITS
    MOVE.L  D4,DATA_FIELD         * moves data value to DATA_FIELD
    
    MOVE.B  #%111,SRC_MODE  * 
    MOVE.B  #%100,SRC_REG   * 
    MOVE.B  #4,SizeSplit
    BRA     PRINTMOVEQ         * TODO: check the name I/O; call EA from PRINT_MOVEQ FOR DEST_REG 



;---------------------------------------------------------

PRINT
    CMP.B #1,CommandPrinter
    ;BEQ PRINTMOVEB
    CMP.B #2,CommandPrinter
    ;BEQ PRINTMOVELSPLIT
    CMP.B #3,CommandPrinter
    ;BEQ PRINTMOVEWSPLIT
    CMP.B #4,CommandPrinter
    ;BEQ PRINTSETONESPLIT
    CMP.B #5,CommandPrinter
    ;BEQ PRINTADDQ
    CMP.B #6,CommandPrinter
    ;BEQ PRINTSETTWOSPLIT
    CMP.B #7,CommandPrinter
    ;BEQ PRINTMOVEQ
    CMP.B #8,CommandPrinter
    ;BEQ PRINTOR
    CMP.B #9,CommandPrinter
    ;BEQ PRINTSUB
    CMP.B #12,CommandPrinter
    ;BEQ PRINTAND
    CMP.B #13,CommandPrinter
    ;BEQ PRINTSETADDSPLIT
    CMP.B #14,CommandPrinter
    ;BEQ PRINTSETTHIRDSPLIT
    


 ;Make base commands for later use with size.
                ;MOVE SECTION
PRINTMOVE LEA PMOVE,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT
    
PRINTMOVEA LEA PMOVEA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT
    
                ;FIRST SET OF COMMANDS
PRINTSETONESPLIT 
    CMP.B #0,CommandDetail
    BEQ PRINTNOP
    CMP.B #1,CommandDetail
    BEQ PRINTMOVEM
    CMP.B #2,CommandDetail
    BEQ PRINTLEA
    CMP.B #3,CommandDetail
    BEQ PRINTNOT
    CMP.B #4,CommandDetail
    BEQ PRINTJSR
    BRA PRINTRTS

PRINTNOP    
    LEA PNOP,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     
    TRAP     #15
    *BRA     MEMORYGRABBER
    BRA SIZESPLIT
PRINTMOVEM  
    LEA     PMOVEM,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT
    
    * NOTES 

    * CMP.B   #1,INVELID_EA      * it's just a flag that I use for the invalid EA
    * BEQ     PRTINVEA

    * If X bit is 0 Register -> Memory
    * 
    * Else, Memory -> register

PRINTLEA    
    LEA PLEA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

PRINTNOT    
    LEA PNOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

PRINTJSR    
    LEA PJSR,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     
    TRAP     #15
    BRA     SIZESPLIT
   * BRA     MEMORYGRABBER

PRINTRTS    
    LEA PRTS,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     
    TRAP     #15
    *BRA     MEMORYGRABBER
    BRA     SIZESPLIT
    
                ;ADDQ SECTION
PRINTADDQ 
    LEA PADDQ,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

                ;SECOND SET OF COMMANDS
PRINTSETTWOSPLIT
    CMP.B #0,CommandDetail
    BEQ PRINTBGT
    CMP.B #1,CommandDetail
    BEQ PRINTBEQ
    CMP.B #2,CommandDetail
    BEQ PRINTBLE
    BRA PRINTBRA
    
PRINTBGT LEA PBGT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTBEQ LEA PBEQ,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTBLE LEA PBLE,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTBRA LEA PBRA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT
    
                ;MOVEQ SECTION
PRINTMOVEQ 
    LEA PMOVEQ,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15
    LEA DOLLARSIGN,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15    
    MOVE.L      DATA_FIELD,D1
    MOVE.B      #16,D2
    MOVE.B      #15,D0     ; moves #14 into data register D0
    TRAP        #15 
    LEA COMA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15
    MOVE.B #0,D7
    MOVE.L #%000,D2
    MOVE.B DEST_REG,D3
    BRA EADN

                ;OR SECTION
PRINTOR LEA POR,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

                ;SUB SECTION
PRINTSUB LEA PSUB,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

                ;AND SECTION
PRINTAND LEA PAND,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

                ;ADD SPLIT
PRINTSETADDSPLIT 
    CMP #0,CommandDetail   
    BEQ PRINTADD     
    BRA PRINTADDA       
                
PRINTADD 
    LEA PADD,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15

    *BRA     SIZESPLIT
    BRA     MEMORYGRABBER
    
PRINTADDA LEA PADDA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15

    *BRA     SIZESPLIT
    BRA     MEMORYGRABBER
    
                ;THIRD GROUP SPLIT
PRINTSETTHIRDSPLIT 
    CMP #0,CommandDetail   
    BEQ PRINTLSL
    CMP #1,CommandDetail   
    BEQ PRINTLSR
    CMP #2,CommandDetail   
    BEQ PRINTASR
    CMP #3,CommandDetail   
    BEQ PRINTASL
    CMP #4,CommandDetail   
    BEQ PRINTROL
    BRA PRINTROR  
    
PRINTLSL LEA PLSL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTLSR LEA PLSR,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTASR LEA PLEA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTASL LEA PASL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTROL LEA PROL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT

PRINTROR LEA PROR,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA SIZESPLIT



                ;SIZE PRINTER
SIZESPLIT   
    CMP.B #1,SizeValue
    BEQ PRINTB
    CMP.B #2,SizeValue
    BEQ PRINTW
    CMP.B #3,SizeValue
    BEQ PRINTL
    BRA PRINTNONE ; go to EA/DN section
    
PRINTL LEA PL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN

PRINTW      
    LEA     PW,A1
    MOVE.B  #14,D0     ; moves #14 into data register D0
    TRAP    #15       ; Displays message via trap 14
    BRA     EADN

PRINTB  LEA PB,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN
    
PRINTNONE  LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN
    
EADNTRANSFER
    ;BRA jump to other code

                ;PRINT EA/DN
EADN 
    CMP.B   #0,D7
    BEQ     PRINTNOTRAIL
    CMP.B   #1,D7
    BEQ     PRINTONETRAIL 
    CMP.B   #2,D7
    BEQ     PRINTTWOTRAIL
    
    RTS     MEMORYGRABBER
    
PRINTONETRAIL 
    JSR EA_Start
    LEA      CLEAR,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA MEMORYGRABBER

PRINTTWOTRAIL 
    JSR EA_Start
    JSR EA_Start
    LEA      CLEAR,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA MEMORYGRABBER
    
PRINTNOTRAIL 
    JSR EA_Start
    LEA      CLEAR,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA MEMORYGRABBER

CLOSINGSTATEMENTS     
    LEA      CLEAR,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
   
STOP    
    MOVE.B #9,D0        ; moves #9 into data register D0
    TRAP     #15       ; halt simulator via trap 9


;----------------------------- ADDED THIS FOR THE MEMORYGRABBER (MAIN LOOP) 
ENDING 
    LEA     FINALMESSAGE,A1     * Prints End of Program message
    MOVE.B  #14,D0
    TRAP    #15

    SIMHALT             ; halt simulator
    
    
    
;----------------------------- ADDED THIS FOR OP CODE PART 
********* CHECK DESTINATION ***********
CHECK_DESTINATION
	MOVE.B  #$F,DstMode
	
	CMP.B   #7,DEST_MODE             * if mode = 111 = either word or long depending on register 
    BEQ     CHECK_DEST_REG             * Checks registers
	
	CMP.B   #5,DEST_MODE            * if mode = 101 = (d16,An)
    BEQ     R_CHECK_DEST	* Print DATA instead 
	
	CMP.B   #6,DEST_MODE             * if mode = 110 = (d8,An,Xn)
    BEQ     R_CHECK_DEST	* Print DATA instead
	
	MOVE.B  DEST_MODE,DstMode
	RTS
CHECK_DEST_REG
	CMP.B   #2,DEST_REG             * if DEST_REG = 010
    BEQ     R_CHECK_DEST

    CMP.B   #3,DEST_REG         * if DEST_REG = 011
    BEQ     R_CHECK_DEST
	
	CMP.B   #5,DEST_REG             * if DEST_REG = 101
    BGE     RETURN
	
	MOVE.B  DEST_MODE,DstMode
	CLR.L   D6
	MOVE.B  DEST_REG,D6
	ADD.B   D6,DstMode
    RTS
R_CHECK_DEST
    MOVE.B  #$E,DstMode
    RTS

********* CHECK TEMP ***********
CHECK_TEMP

    MOVE.B  #$F,TempMode
	
	CMP.B   #7,TEMP_MODE             * if mode = 111 = either word or long depending on register 
    BEQ     CHECK_TEMP_REG      * Checks registers

	CMP.B   #5,TEMP_MODE             * if mode = 101 = (d16,An)
    BEQ     R_CHECK_TEMP	* 
	
	CMP.B   #6,TEMP_MODE             * if mode = 110 = (d8,An,Xn)
    BEQ     R_CHECK_TEMP	* 
	
	MOVE.B  TEMP_MODE,TempMode
	RTS
CHECK_TEMP_REG
	CMP.B   #2,TEMP_REG             * if RRRT = 010 = (d16,PC)
    BEQ     R_CHECK_TEMP

    CMP.B   #3,TEMP_REG             * if RRRT = 011 = (d8,PC,Xn)
    BEQ     R_CHECK_TEMP
	
	CMP.B   #5,TEMP_REG             * if RRRT = 101
    BEQ     RETURN
	
	MOVE.B  TEMP_MODE,TempMode
	CLR.L   D6
	MOVE.B  TEMP_REG,D6
	ADD.B   D6,TempMode
    RTS
R_CHECK_TEMP
    MOVE.B  #$E,TempMode
    RTS
    
******************** CHECK_SOURCE ******************** 
CHECK_SOURCE    * TODO
    MOVE.B  #$F,SrcMode
	
	CMP.B   #7,SRC_MODE         * if mode = 111 = either word or long depending on register 
    BEQ     CHECK_SOURCE_REG    * Checks registers

	CMP.B   #5,SRC_MODE     * if mode = 101 = (d16,An)
    BEQ     R_CHECK_SOURCE 
	
	CMP.B   #6,SRC_MODE     * if mode = 110 = (d8,An,Xn)
    BEQ     R_CHECK_SOURCE 
	
	MOVE.B  SRC_MODE,SrcMode
	RTS
CHECK_SOURCE_REG
	CMP.B   #2,SRC_REG             * if RRRS = 010
    BEQ     R_CHECK_SOURCE

    CMP.B   #3,SRC_REG          * if RRRS = 011
    BEQ     R_CHECK_SOURCE
	
	CMP.B   #5,SRC_REG      * if RRRS = 101
    BGE     RETURN
	
	MOVE.B  SRC_MODE,SrcMode
	CLR.L   D6
	MOVE.B  SRC_REG,D6
	ADD.B   D6,SrcMode
    RTS
R_CHECK_SOURCE
    MOVE.B  #$E,SrcMode
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
    JSR     CHECK_DESTINATION   * TODO: EA part of checking Destination
    RTS
TEMP_TO_SRC
    MOVE.B  TEMP_REG,SRC_REG
    MOVE.B  TEMP_MODE,SRC_MODE
    JSR     CHECK_SOURCE                 
    RTS
  
******************** OTHER COMMANDS ********************
RETURN
    RTS

FORMAT_DATA
    CMP.B   #0,DATA_FIELD
    BNE     RETURN
	MOVE.B  #8,DATA_FIELD
	RTS

CHECK_DATA_NEG
    CMP.B   #128,D6
    BEQ     PRINT_NEG
    RTS
    
PRINT_NEG
    LEA     NEG,A1      * print "-"
    MOVE.B  #14,D0
    TRAP    #15
    RTS

PRINT_DATA
    LEA     PDATA,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     CLRSPOT,A1      * print space
    MOVE.B  #14,D0     
    TRAP    #15 
    
    * TODO: PRINT #$
    * TODO: PRINT COMMANDDATA 
    RTS
    
* SET SIZE FOR SIZESPLIT    
SETSIZE1
    CMP.B   #%0,SIZE_BIT
    BEQ     SETSIZEW
    CMP.B   #%1,SIZE_BIT
    BEQ     SETSIZEL
    RTS
SETSIZE2
    CMP.B   #%00,SIZE_BIT
    BEQ     SETSIZEB
    CMP.B   #%01,SIZE_BIT
    BEQ     SETSIZEW
    CMP.B   #%10,SIZE_BIT
    BEQ     SETSIZEL
SETSIZEB
    MOVE.B  #1,SizeValue
    RTS
SETSIZEW
    MOVE.B  #2,SizeValue 
    RTS
SETSIZEL
    MOVE.B  #3,SizeValue
    RTS
    
*SETINVEA
    *MOVE.B  #1,INVALID_EA
    *RTS     
    
CLEARMR
    MOVE.B  #0,DEST_REG 
    MOVE.B  #0,DEST_MODE
    MOVE.B  #0,SRC_MODE
    MOVE.B  #0,SRC_REG
    MOVE.B  #0,TEMP_MODE
    MOVE.B  #0,TEMP_REG 
    MOVE.B  #0,SIZE_BIT
    MOVE.B  #0,SizeValue
    RTS  
*************    

*******************************************************
* EA subroutine
* Purpose: Generate EA
*         Addresses used: 
*            D2 FOR MODE
*            D3 FOR REGISTER
*            D5 HOLDS DECIMAL VALUE OF THE REGISTER 
*            D1 FOR PRINTING
*            A6 MIMICKS INSTRUCTION BUFFER
*            D7 DATA FOR ABSOLUTE, IMMIDIATE ADDRESSING  
***************************************************

EA_start        jmp        REGISTER_NUMBER_TO_DECIMAL

Continue_EA     CMP.W       #MODE000,D2             
                BEQ         DATA_REGISTER                 
                CMP.W       #MODE001,D2               
                BEQ         ADDRESS_REGISTER                 
                CMP.W       #MODE010,D2              
                BEQ         ADDRESS_REGISTER_DIRECT               
                CMP.W       #MODE011,D2              
                BEQ         ADDRESS_REGISTER_INCREMENT             
                CMP.W       #MODE100,D2          
                BEQ         ADDRESS_REGISTER_DECREMENT              
                CMP.W       #MODE111,D2          
                BEQ         ABSOLUTE_IMMIDIATE_ADRRESSING                
                MOVE.B      #BAD_FLAG,STATE               
                BRA         EA_FINISH              
                
DATA_REGISTER                         ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                MOVE.B   #D,D1
                MOVE.B  #6,D0
                TRAP    #15
                ADDI.L   #$30,D5
                MOVE.B   D5,D1
                MOVE.B  #6,D0
                TRAP    #15                  ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                BRA      EA_FINISH
                    

ADDRESS_REGISTER MOVE.B  #A,D1                      ;LOAD THE REGISTERS TO A6
                 MOVE.B  #6,D0
                 TRAP    #15
                 ADDI.L   #$30,D5
                 MOVE.B   D5,D1
                 MOVE.B  #6,D0
                 TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                 BRA      EA_FINISH

                 
ADDRESS_REGISTER_DIRECT                                 ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                        MOVE.B   #OPEN_PARENTHESIS,D1
                        MOVE.B   #6,D0
                        TRAP     #15
                        MOVE.B   #A,D1
                        MOVE.B  #6,D0
                        TRAP    #15
                        ADDI.L   #$30,D5
                        MOVE.B   D5,D1
                        MOVE.B  #6,D0
                        TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                        MOVE.B   #CLOSED_PARENTHESIS,D1
                        MOVE.B  #6,D0
                        TRAP    #15
                        BRA      EA_FINISH


ADDRESS_REGISTER_INCREMENT                                ; THE BINARY NUMBER IN D3 TO DECIMAL
                           MOVE.B   #OPEN_PARENTHESIS,D1
                           MOVE.B   #6,D0
                           TRAP     #15
                           MOVE.B   #A,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           ADDI.L   #$30,D5
                           MOVE.B   D5,D1
                           MOVE.B  #6,D0
                           TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           MOVE.B   #PLUS_SIGN,(A4)+
                           MOVE.B  #6,D0
                           TRAP    #15
                           BRA      EA_FINISH


ADDRESS_REGISTER_DECREMENT                                ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL AND 
                           MOVE.B   #MINUS_SIGN,D1
                           MOVE.B   #6,D0
                           TRAP        #15
                           MOVE.B   #OPEN_PARENTHESIS,D1
                           MOVE.B   #6,D0
                           TRAP     #15
                           MOVE.B   #A,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           ADDI.L   #$30,D5
                           MOVE.B   D5,D1
                           MOVE.B  #6,D0
                           TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           BRA      EA_FINISH

ABSOLUTE_IMMIDIATE_ADRRESSING 
                              BRA  CONTINUE_A_I_A
                              
                              
CONTINUE_A_I_A                
                              CMP.B       #4,D5                ; CHECK FOR IMMIDIATE DATA
                              BEQ         IMMIDIATE_REGISTER                
                              CMP.B       #0,D5                ; WORD ADDRESSING
                              BEQ         WORD_ADDRESSING                
                              CMP.B       #1,D5                ; LONG ADDRESSIN 
                              BEQ         LONG_ADDRESSING              
                              MOVE.B      #BAD_FLAG,STATE              
                              BRA         EA_FINISH                * jump to end   
                              
                              
IMMIDIATE_REGISTER            MOVE.B #HASH_TAG,D1
                              MOVE.B #6,D0
                              TRAP   #15
                              CMP.B #1,SIZE   ;BYTE
                              BEQ   GETBYTE
                              CMP.B #2,SIZE   ;BYTE
                              BEQ   GETWORD
                              CMP.B #3,SIZE   ;BYTE
                              BEQ   GETLONG
                              BRA   GETLONG
                              

WORD_ADDRESSING              MOVE.B #DOLLAR_SIGN,D1
                             MOVE.B #6,D0
                             TRAP  #15
                             MOVE.W  (A6)+,D7
                             BRA   PRINT_WORD
                             BRA   EA_FINISH

LONG_ADDRESSING              MOVE.B #DOLLAR_SIGN,D1
                             MOVE.B #6,D0
                             TRAP  #15
                             MOVE.L  (A6)+,D7
                             BRA   PRINT_LONG
                             BRA   EA_FINISH                            

GETBYTE      
                MOVE.B   (A6)+,D7    
                BMI     ADD_NEGATIVE
                BRA     PRINT_BRANCHING
GETWORD                
                MOVE.W   (A6)+,D7
                BMI     ADD_NEGATIVE
                BRA     PRINT_BRANCHING
GETLONG                
                
                MOVE.L   (A6)+,D7
                BMI     ADD_NEGATIVE
                BRA     PRINT_BRANCHING
                
ADD_NEGATIVE    MOVE.B #MINUS_SIGN,D1
                MOVE.B #6,D1
                TRAP   #15
                BRA    PRINT_BRANCHING


PRINT_BRANCHING  CMP.B #1,SIZE   ;BYTE
                BEQ    PRINT_BYTE    
                CMP.B #2,SIZE   ;WORD
                BEQ    PRINT_WORD
                CMP.B  #3,SIZE  ;LONG
                BEQ    PRINT_LONG
                BRA    PRINT_BRANCHING




                
**** BYTE DATA PRINTING***********************
PRINT_BYTE     CLR     D1                  ; CLEAR ANY LEFT BITS
               

               CMP.L   #$F,D7              
               BLE     BYTE_ONE_LOOP                  
               BRA     READ_BYTE

BYTE_ONE_LOOP
                MOVE.B  #1,NUMBER_OF_HEX  
                BRA     READ_BYTE
    
READ_BYTE                           
    CMP.B   #0,NUMBER_OF_HEX               
    BEQ     COPYBYTE
    
    MOVE.B  #$30,D1             
    MOVE.B  #6,D0               
    TRAP    #15

    SUBI.B  #1,NUMBER_OF_HEX     ; MINUS ONE           
    BRA     READ_BYTE           ; LOOP
    
COPYBYTE
    MOVE.L  D7,D1               ; COPY DATA 
    MOVE.B  #16,D2              ; CONVERT THE BASE TO 16
    MOVE.B  #15,D0              ; Display the unsigned number in D1.L converted to number base (2 through 36) contained in D2.B.
    TRAP    #15
    MOVE.B  #0,NUMBER_OF_HEX
    BRA  EA_FINISH





******PRINT WORD DATA******************
PRINT_WORD   CLR     D1                  ; CLEAR ANY LEFT BITS
               

               CMP.L   #$F,D7              
               BLE     WORD_ONE_LOOP
               CMP.L   #$FF,D7              
               BLE     WORD_TWO_LOOP
               CMP.L   #$FFF,D7              
               BLE     WORD_THREE_LOOP                  
               BRA     READ_WORD

WORD_ONE_LOOP
                MOVE.B  #1,NUMBER_OF_HEX  
                BRA     READ_WORD
                
WORD_TWO_LOOP
                MOVE.B  #2,NUMBER_OF_HEX  
                BRA     READ_WORD
                
WORD_THREE_LOOP
                MOVE.B  #3,NUMBER_OF_HEX  
                BRA     READ_WORD                
    
READ_WORD                           
    CMP.B   #0,NUMBER_OF_HEX               
    BEQ     COPYWORD
    
    MOVE.B  #$30,D1             
    MOVE.B  #6,D0               
    TRAP    #15

    SUBI.B  #1,NUMBER_OF_HEX              
    BRA     READ_WORD                   ; LOOP

COPYWORD
    MOVE.L  D7,D1               ; COPY DATA 
    MOVE.B  #16,D2              ; CONVERT THE BASE TO 16
    MOVE.B  #15,D0              ; Display the unsigned number in D1.L converted to number base (2 through 36) contained in D2.B.
    TRAP    #15
    MOVE.B  #0,NUMBER_OF_HEX
    BRA  EA_FINISH

****************PRINT LONG DATA*****************
PRINT_LONG      CLR     D1                  ; CLEAR ANY LEFT BITS
               

               CMP.L   #$F,D7              
               BLE     LONG_ONE_LOOP
               CMP.L   #$FF,D7              
               BLE     LONG_TWO_LOOP
               CMP.L   #$FFF,D7              
               BLE     LONG_THREE_LOOP
               CMP.L   #$FFFF,D7              
               BLE     LONG_FOUR_LOOP
               CMP.L   #$FFFFF,D7              
               BLE     LONG_FIVE_LOOP
               CMP.L   #$FFFFFF,D7              
               BLE     LONG_SIX_LOOP
               CMP.L   #$FFFFFFF,D7              
               BLE     LONG_SEVEN_LOOP                  
               BRA     READ_LONG

LONG_ONE_LOOP
                MOVE.B  #1,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_TWO_LOOP
                MOVE.B  #2,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_THREE_LOOP
                MOVE.B  #3,NUMBER_OF_HEX  
                BRA     READ_LONG                
LONG_FOUR_LOOP
                MOVE.B  #4,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_FIVE_LOOP
                MOVE.B  #5,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_SIX_LOOP
                MOVE.B  #6,NUMBER_OF_HEX  
                BRA     READ_LONG
LONG_SEVEN_LOOP
                MOVE.B  #7,NUMBER_OF_HEX  
                BRA     READ_LONG

     
READ_LONG                           
    CMP.B   #0,NUMBER_OF_HEX               
    BEQ     COPYLONG
    MOVE.B  #$30,D1             
    MOVE.B  #6,D0               
    TRAP    #15

    SUBI.B  #1,NUMBER_OF_HEX               
    BRA     READ_LONG                   ; LOOP

COPYLONG
    MOVE.L  D7,D1               ; COPY DATA 
    MOVE.B  #16,D2              ; USIGN BASE TO 16
    MOVE.B  #15,D0              ; Display the unsigned number in D1.L converted to number base (2 through 36) contained in D2.B.
    TRAP    #15
    MOVE.B  #0,NUMBER_OF_HEX
    BRA  EA_FINISH

  







EA_FINISH      RTS




************************************************
*Subroutine: REGISTER_NUMBER_TO_DECIMAL 
*            CONVERT BINARY NUMBER IN D3 TO DECIMAL AND STORES IN D5
************************************************
REGISTER_NUMBER_TO_DECIMAL 
                           CMP.W       #REG_0,D3
                           BEQ         RG0
                           CMP.W       #REG_1,D3
                           BEQ         RG1
                           CMP.W       #REG_2,D3
                           BEQ         RG2
                           CMP.W       #REG_3,D3
                           BEQ         RG3
                           CMP.W       #REG_4,D3
                           BEQ         RG4
                           CMP.W       #REG_5,D3
                           BEQ         RG5
                           CMP.W       #REG_6,D3
                           BEQ         RG6
                           CMP.W       #REG_7,D3
                           BEQ         RG7
                           MOVE.B      #BAD_FLAG,STATE
                           JMP         CONTINUE_EA
 
RG0    MOVE.B   #0,D5
       JMP      Continue_EA
RG1    MOVE.B   #1,D5
       JMP      Continue_EA
RG2    MOVE.B   #2,D5
       JMP      Continue_EA
RG3    MOVE.B   #3,D5
       JMP      Continue_EA
RG4    MOVE.B   #4,D5
       JMP      Continue_EA
RG5    MOVE.B   #5,D5
       JMP      Continue_EA
RG6    MOVE.B   #6,D5
       JMP      Continue_EA
RG7    MOVE.B   #7,D5
       JMP      Continue_EA 
    
;------------------------------------------------
    
Float   DS.L 1 #0

ValOne    DS.B 1 #0
ValTwo    DS.B 1 #0
ValThree    DS.B 1 #0
ValFour    DS.B 1 #0
ValFive    DS.B 1 #0
ValSix    DS.B 1 #0
ValSeven    DS.B 1 #0
ValEight    DS.B 1 #0

Addsum DS.W 1 #0
CarryBit DS.B 1 #0   

Trailers DS.B 1 #0
Source DS.L 1 #0
Destination DS.L 1 #0

        ;generic command lines
USERPAGEBREAK DC.B 'Please Press enter',CR,LF,0
BADVAL DC.B    'Number out of range of acceptable values ',CR,LF,0
MESSAGEFIRSTADRESS DC.B    'Please enter starting memory adress: ',0 
MESSAGESECONDADRESS DC.B    'Please enter ending memory adress: ',0 
FINALMESSAGE    DC.B    'END OF THE PROGRAM',0
CLEAR DC.B      ' ',CR,LF,0

        ;the collection of actual command lines to print
CommandPrinter    DS.B 1 #0
CommandDetail    DS.B 1 #0
PMOVE DC.B      'MOVE',0
PMOVEM DC.B      'MOVEM',0
PMOVEA DC.B      'MOVEA',0
PMOVEQ DC.B      'MOVEQ ',0
PNOP DC.B      'NOP',0
PLEA DC.B      'LEA',0
PNOT DC.B      'NOT',0
PJSR DC.B      'JSR',0
PRTS DC.B      'RTS',0
PBGT DC.B      'BGT',0
PBEQ DC.B      'BEQ',0
PBLE DC.B      'BLE',0
PBRA DC.B      'BRA',0
POR DC.B      'OR',0
PSUB DC.B      'SUB',0
PAND DC.B      'AND',0
PADD DC.B      'ADD',0
PADDA DC.B      'ADDA',0
PADDQ DC.B      'ADDQ',0
PLSL DC.B      'LSL',0
PLSR DC.B      'LSR',0
PASR DC.B      'ASR',0
PASL DC.B      'ASL',0
PROL DC.B      'ROL',0
PROR DC.B      'ROR',0

PDATA   DC.B    'DATA',0

INPUT   DC.B    0

STARTINGADDRESS     DC.L 0
CURRENTADDRESS      DC.L 0
ENDINGADDRESS       DC.L 0
CYCLECOUNTER
COMMANDDATA         DC.W 0
Bits                DC.B 0

        ;the sizes to print
SizeValue           DC.B 0
PB DC.B      '.B ',0
PW DC.B      '.W ',0
PL DC.B      '.L ',0

;----- ADDED FOR THE OP CODE PART

DEST_REG        DC.B    0
DEST_MODE       DC.B    0

SRC_MODE        DC.B    0
SRC_REG         DC.B    0

TEMP_MODE       DC.B    0
TEMP_REG        DC.B    0

DATA_FIELD      DC.L    0
SIZE            DC.B    0
SIZE_BIT        DC.B    0

HASH            DC.B    '#',0
CLRSPOT         DC.B    ' ',0
NEG             DC.B    '-',0
DOLLARSIGN      DC.B    '$',0
COMA            DC.B    ',',0

INDEX           DC.B    0

XBIT            DC.B    0
INVALID_EA      DC.B    0

DstMode         DC.B    0
TempMode        DC.B    0
SrcMode         DC.B    0

;------ ADDED FOR EA CODE PART

REG_0  EQU         %000
REG_1  EQU         %001
REG_2  EQU         %010
REG_3  EQU         %011
REG_4  EQU         %100
REG_5  EQU         %101
REG_6  EQU         %110
REG_7  EQU         %111

MODE000       EQU         %000                   * MODE Dn
MODE001       EQU         %001                   * MODE An
MODE010       EQU         %010                   * MODE (An)
MODE011       EQU         %011                   * MODE (An)+
MODE100       EQU         %100                   * MODE -(An)
MODE111       EQU         %111                   * ABSOLUTE AND IMMIDIATE DATA ADDRESSING

STATE         DC.B        0                      ; USED TO FLAG  BAD OR GOOD STATE
BAD_FLAG      EQU         1
word          DC.L        $8000
SIZE_IL       DS.L        1             ;SIZE ISOLATION
DR            DS.L        1             ;DIRECTION ISOLATION
G14_TYPE      DS.L        1             ; GROUP 14 TYPE 
IR_IL         DS.L        1             ; DATA REGISTER OR IMMIDIATE DATA FOR GROUP 14
S_COUNT       DS.L        1             ; STORES SHIFT COUNT
sRN           DS.B       1             ;SOURCE REGISTER FOR SHIFTING MODES
DRN           DS.B       1             ; DESTINATION REGISTER FOR SHIFTING MODES
NUMBER_OF_HEX DC.B        0
dRG           DS.B        1
dMODE         DS.B        1
sRG           DS.B        1

print_buffer  DC.l       $100

***** ASCII VALUES FOR EA CHARACTERS**************
D                       EQU      $44
A                       EQU      $41
OPEN_PARENTHESIS        EQU      $28
DOLLAR_SIGN             EQU      $24
CLOSED_PARENTHESIS      EQU      $29
PLUS_SIGN               EQU      $2B
MINUS_SIGN              EQU      $2D
HASH_TAG                EQU      $23
PERCENT_SIGN            EQU      $25


    
    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
