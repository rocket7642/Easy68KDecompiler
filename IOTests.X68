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
    
LOADDATAONE
    LEA      MESSAGEFIRSTADRESS,A1 ; Loads MESSAGE into adress at A1
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

    
VAL1    MOVE.B $A000,D4
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
    
INTSUB SUB.B #$30,D4
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
    
CHARSUB SUB.B #$37,D4
    BRA DONE
    
INVALID LEA BADVAL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA     STOP
    
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

ENTRYLOOP

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
    BEQ CLOSINGSTATEMENTS
    MOVE.L D7,D6
    ADD.B #1,D2
    MOVE.L #0,D5
    BRA LOADDATATWO

PRINT
    CMP.B #1,CommandPrinter
    BEQ PRINTMOVEB
    CMP.B #2,CommandPrinter
    BEQ PRINTMOVEL
    CMP.B #3,CommandPrinter
    BEQ PRINTMOVEW
    CMP.B #4,CommandPrinter
    BEQ PRINTSETONE
    CMP.B #5,CommandPrinter
    BEQ PRINTADDQ
    CMP.B #6,CommandPrinter
    BEQ PRINTSETTWO
    CMP.B #7,CommandPrinter
    BEQ PRINTSETTHREE
    CMP.B #8,CommandPrinter
    BEQ PRINTOR
    CMP.B #9,CommandPrinter
    BEQ PRINTSUB
    CMP.B #12,CommandPrinter
    BEQ PRINTAND
    CMP.B #13,CommandPrinter
    BEQ PRINTSETADD
    CMP.B #14,CommandPrinter
    BEQ PRINTSETROTATE

PRINTMOVEB

PRINTMOVEL

PRINTMOVEW

PRINTSETONE

PRINTADDQ

PRINTSETTWO

PRINTSETTHREE

PRINTOR

PRINTSUB

PRINTAND

PRINTSETADD

PRINTSETROTATE



CLOSINGSTATEMENTS     
    LEA      CLEAR,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
   
STOP    MOVE.B #9,D0        ; moves #9 into data register D0
    TRAP     #15       ; halt simulator via trap 9

    SIMHALT             ; halt simulator
    
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

        ;generic command lines
BADVAL DC.B    'Number out of range of acceptable values ',CR,LF,0
MESSAGEFIRSTADRESS DC.B    'Please enter starting memory adress: ',0 
MESSAGESECONDADRESS DC.B    'Please enter ending memory adress: ',0 
CLEAR DC.B      '',CR,LF,0

        ;the collection of actual command lines to print
CommandPrinter    DS.B 1 #0
CommandDetail    DS.B 1 #0
PMOVE DC.B      'MOVE.',0
PMOVEM DC.B      'MOVEM ',0
PMOVEA DC.B      'MOVEA.',0
PMOVEQ DC.B      'MOVEQ ',0
PNOP DC.B      'NOP.',0
PLEA DC.B      'LEA.',0
PNOT DC.B      'NOT ',0
PJSR DC.B      'JSR ',0
PRTS DC.B      'RTS ',0
PBGT DC.B      'BGT ',0
PBEQ DC.B      'BEQ ',0
PBLE DC.B      'BLE ',0
PBRA DC.B      'BRA ',0
POR DC.B      'OR ',0
PSUB DC.B      'SUB.',0
PAND DC.B      'AND.',0
PADD DC.B      'ADD.',0
PADDA DC.B      'ADDA.',0
PADDQ DC.B      'ADDQ ',0
PLSL DC.B      'LSL.',0
PLSR DC.B      'LSR.',0
PASR DC.B      'ASR.',0
PASL DC.B      'ASL.',0
PROL DC.B      'ROL.',0
PROR DC.B      'ROR.',0


        ;the sizes to print
SizeValue    DS.B 1 #0
PB DC.B      'B ',0
PW DC.B      'W ',0
PL DC.B      'L ',0

    
    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
