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
    
    * TODO: check if the input if odd - invalid imput
    

    
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
    
    * TODO: CLEAR MODES AND REGISTERS
    
    MOVE.L      A1,CURRENTADDRESS   
   * MOVEA.L     CURRENTADDRESS,D1
    MOVE.W      (A1)+, D3   * copy instruction's 16 bits into D3
    MOVE.W      D3, COMMANDDATA
 
    JMP         COMPARE_GROUPS
    
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
    *BEQ     COMPARE_0100    * if equal, goes to COMPARE_0100 for NOP, MOVEM, LEA, NOT, JSR, RTS
    
    CMP.W   #%0101,D4      
    *BEQ     CHECK_ADDQ      * if equal, goes to CHECK_ADDQ
    
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
    *BEQ     COMPARE_1101    * if equal, goes to COMPARE_1101 for ADD and ADDA
    
    CMP.W   #%1110,D4      
    *BEQ     COMPARE_1110    * if equal, goes to COMPARE_1110 for LSL, LSR, ASR, ASL, ROL, ROR
    
    BNE     PRINT_DATA      * all other instructions are not supported 






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
    MOVE.B  #4,SizeSplit
    BRA     PRINTMOVEQ         * TODO: check the name I/O; call EA from PRINT_MOVEQ FOR DEST_REG 


********************  PRINT  ******************** 
PRINT_MOVEQ     
    * print address 
    LEA CLRSPOT,A1      * print space
    MOVE.B   #14,D0   
    TRAP     #15      

    LEA     PMOVEQ,A1   * print "MOVEQ" text
    MOVE.B  #14,D0
    TRAP    #15

    * NO size spit for MOVEQ
    
    LEA     CLRSPOT,A1      * print space
    MOVE.B  #14,D0     
    TRAP    #15        
    
    LEA     HASH,A1    * print hash
    MOVEQ   #14,D0
    TRAP    #15
    
    CLR.L   D6              * take data (DATA_FIELD) and check if the value is negative
    MOVE.B  DATA_FIELD,D6    
    JSR     CHECK_DATA_NEG
    
    
    LEA     DOLLARSIGN,A1    * print dollar sign
    MOVEQ   #14,D0
    TRAP    #15

    * TODO print byte data

    
    LEA     DOLLARSIGN,A1    * print coma
    MOVEQ   #14,D0
    TRAP    #15
    
    * TODO take register (DEST_REG) and print Effective address 
    



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

PRINTNOP    LEA PNOP,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    
    BRA     MEMORYGRABBER

PRINTMOVEM  LEA PMOVEM,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

PRINTLEA    LEA PLEA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

PRINTNOT    LEA PNOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

PRINTJSR    LEA PJSR,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT

PRINTRTS    LEA PRTS,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    
    BRA     MEMORYGRABBER
    
                ;ADDQ SECTION
PRINTADDQ LEA PADDQ,A1
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
    
    BRA SIZESPLIT

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
                
PRINTADD LEA PADD,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT
    
PRINTADDA LEA PADDA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     SIZESPLIT
    
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
SIZESPLIT   CMP #1,SizeValue
    BEQ PRINTB
    CMP #2,SizeValue
    BEQ PRINTW
    CMP #3,SizeValue
    BEQ PRINTL
    BRA PRINTNONE ; go to EA/DN section
    
PRINTL LEA PL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN

PRINTW      LEA PW,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN

PRINTB  LEA PB,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN
    
PRINTNONE  LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA EADN
    
EADNTRANSFER
    BRA jump to other code

                ;PRINT EA/DN
EADN 
    CLR     D7
    CMP.B   #0,D7
    BEQ     PRINTNOTRAIL
    CMP.B   #1,D7
    BEQ     PRINTONETRAIL 
    CMP.B   #2,D7
    BEQ     PRINTTWOTRAIL
    
    RTS     MEMORYGRABBER
    
PRINTONETRAIL 
    LEA Source,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA COMA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    JSR EA
    BRA     MEMORYGRABBER

PRINTTWOTRAIL 
    LEA Source,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    JSR EA
    LEA COMA,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    JSR EA
    BRA     MEMORYGRABBER
    
PRINTNOTRAIL 
    
    BRA     MEMORYGRABBER

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

*************    
    
    
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
USERPAGEBREAK DC.B 'Please Press enter',0,CR,LF
BADVAL DC.B    'Number out of range of acceptable values ',CR,LF,0
MESSAGEFIRSTADRESS DC.B    'Please enter starting memory adress: ',0 
MESSAGESECONDADRESS DC.B    'Please enter ending memory adress: ',0 
FINALMESSAGE    DC.B    'END OF THE PROGRAM',0
CLEAR DC.B      '',CR,LF,0

        ;the collection of actual command lines to print
CommandPrinter    DS.B 1 #0
CommandDetail    DS.B 1 #0
PMOVE DC.B      'MOVE',0
PMOVEM DC.B      'MOVEM ',0
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
SizeValue           DS.B 1 #0
PB DC.B      '.B ',0
PW DC.B      '.W ',0
PL DC.B      '.L ',0

;----- ADDED FOR THE OP CODE PART

DEST_REG        DC.B    0

SRC_MODE        DC.B    0
SRC_REG         DC.B    0

TEMP_MODE       DC.B    0
TEMP_REG        DC.B    0

DATA_FIELD      DC.B    0
SIZE            DC.B    0


HASH            DC.B    '#',0
CLRSPOT         DC.B    ' ',0
NEG             DC.B    '-',0
DOLLARSIGN      DC.B    '$',0
COMA            DC.B    ',',0

    
    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
