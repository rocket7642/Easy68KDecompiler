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

    MOVE.L D7,ENDINGADDRESS
    MOVE.L D6,STARTINGADDRESS
    CLR D7
    LEA.L ENDINGADDRESS,A7
    LEA.L STARTINGADDRESS,A6
    
MEMORYGRABBER
    CMPA.L ENDINGADDRESS,A6
    BGT ENDING 
    
    CMP.B #25,D7
    BEQ PAGEBREAK
    ADD.B #1,D7
    
    MOVE.L A1,CURRENTADDRESS
    MOVEA.L CURRENTADDRESS,D1
    MOVE.B #16,D2
    MOVE.B   #15,D0     ; moves #14 into data register D0
    TRAP     #15  

    MOVE.W (A6)+,D6
    MOVE.W D6,COMMANDDATA
    
    
    
    BRA MEMORYGRABBER

PAGEBREAK
    LEA      USERPAGEBREAK,A1 ; Loads MESSAGE into adress at A1
    MOVE.B   #14,D0     ; moves #14 into data register D0
    TRAP     #15       ; Displays message via trap 14
    LEA     INPUT,A1
    MOVE.B  #2,D0 *takes the string of what the user enters
    TRAP    #15

ENDING
    SIMHALT           ; halt simulator

* Put variables and constants here

USERPAGEBREAK DC.B 'Please Press enter',0,CR,LF
COMMANDDATA DC.W 1
STARTINGADDRESS DC.L 1
CURRENTADDRESS DC.L 1
ENDINGADDRESS DC.L 1
CYCLECOUNTER

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
