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
    
    MOVE.L D4,D6
    CLR D4
    CMP.B #1,D2
    BEQ CLOSINGSTATEMENTS
    MOVE.L D6,D7
    ADD.B #1,D2
    MOVE.L #0,D5
    BRA LOADDATATWO

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

BADVAL DC.B    'Number out of range of acceptable values ',CR,LF,0
MESSAGEFIRSTADRESS DC.B    'Please enter starting memory adress: ',0 
NEGATIVE DC.B   'Sign is: -',CR,LF,0
MESSAGESECONDADRESS DC.B    'Please enter starting memory adress: ',0 
POSITIVE DC.B   'Sign is: +',CR,LF,0
CLEAR DC.B      '',CR,LF,0
POWER DC.B      'Exponent is: ',CR,LF,0
MANTRA DC.B     'Mantissa is: ',CR,LF,0
    
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
