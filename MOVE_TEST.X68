*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program

* Put program code here

    *MOVE.B      #19,(A1)
    *MOVE.W      #1982,(A1)+
    *MOVE.L      #12,-(A1)
    *MOVE.B      #19,D3
    MOVE.L      #12,D2
    MOVE.W      #1982,D1

    *MOVE.W      #$19AA,D1 
        
    *MOVEA.L      #18,A7

    *MOVEA.W      #199,A5


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
