*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program
    LEA     (A0),A0
    LEA     (A5),A0
    LEA     (A7),A0
    LEA     (A0),A7
    LEA     (A5),A7
    LEA     (A7),A7
    NOT.B     D0
      NOT.W     (A1)
      NOT.W     -(A1)
      NOT.W     (A1)+
      *NOT.W     $1234
      *NOT.L     $12345678
      MOVEQ     #$0,D0
    MOVEQ     #$12,D0
    MOVEQ     #$FF,D0
    RTS
    NOP
    RTS
    JSR       (A0)
    JSR       $1234
    MOVEM.W   A1-A7,-(A1)
    MOVEM.L   D1-D7,-(A1)
    NOP
    JSR       $12345678
    JSR       label1
    JSR       label2
    JSR       label3
    NOP
    RTS
label1
    NOP
    RTS
    LEA       $12,A0
    LEA       $1234,A0
    LEA       $12345678,A0
label2
    MOVEQ     #$0,D0
    MOVEQ     #$12,D0
    MOVEQ     #$FF,D0
label3
    MOVEM.W   A1-A7,$12
    MOVEM.L   D1-D7,$12
    MOVEM.W   A1/D7,$12

    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
