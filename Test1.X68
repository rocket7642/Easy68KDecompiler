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

    

* Put variables and constants here

    MOVE.L #$AABBCCDD,EAOne
    MOVE.L #$11223344,EATwo

PRINTMOVEB LEA PMOVE,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    MOVE.B  #0,D1
    BRA     SIZESPLIT

SIZESPLIT   CMP #0,D1
    BEQ PRINTB
    CMP #1,D1
    BEQ PRINTW
    CMP #2,D1
    BEQ PRINTL
    BRA VALUEPASSEDLOOP

PRINTL LEA PL,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA VALUEPASSEDLOOP

PRINTW      LEA PW,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA VALUEPASSEDLOOP

PRINTB  LEA PB,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    BRA VALUEPASSEDLOOP
    
VALUEPASSEDLOOP 
    CMP.B #0,D7
    BEQ PRINTDATAONE
    CMP.B #1,D7
    BEQ PRINTDATATWO
    BRA    END

PRINTDATAONE MOVE.L EAOne,D1
    MOVE.B #16,D2
    MOVE.B   #15,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15  
    ADD.B #1,D7
    BRA VALUEPASSEDLOOP    
    
PRINTDATATWO MOVE.L EATwo,D1
    MOVE.B #16,D2
    MOVE.B   #15,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA CLRSPOT,A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15  
    ADD.B #1,D7
    BRA VALUEPASSEDLOOP

END    
    SIMHALT             ; halt simulator
    
PMOVE DC.B      'MOVE.',0
PB DC.B      'B ',0
PW DC.B      'W ',0
PL DC.B      'L ',0
EAOne DS.L 1 
EATwo DS.L 1 
CLRSPOT DC.B ' ',0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
