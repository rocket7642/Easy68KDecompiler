*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program

    MOVEQ   #$CC,D6
    
    ADDQ.L  #$1,(A0)
    ADDQ.L  #$8,(A0)
    ADDQ.W  #$1,$12
    
    MOVEQ   #$0,D0
    MOVEQ   #$12,D0
    MOVEQ   #$FF,D0
    
    LSR     $1000
    ROR.B   #4,D4
    ROL     $3000
    ASR.L   #6,D7
    ASL.W   D3,D5
    ROR.L   D4,D5
    
    OR.B     D1,D2
    OR.B     D1,(A1)
    OR.W     D1,(A1)+
    OR.W     D1,-(A1)
    OR.L     (A1),D1
    OR.L     (A1)+,D1
    OR.L     -(A1),D1

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
