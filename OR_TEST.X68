*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program

      OR.B     D1,D2
      OR.B     D1,(A1)
      OR.B     D1,(A1)+
      OR.B     D1,-(A1)
      OR.B     (A1),D1
      OR.B     (A1)+,D1
      OR.B     -(A1),D1
      OR.W     D1,D2
      OR.W     D1,(A1)
      OR.W     D1,(A1)+
      OR.W     D1,-(A1)
      OR.W     (A1),D1
      OR.W     (A1)+,D1
      OR.W     -(A1),D1
      OR.L     D1,D2
      OR.L     D1,(A1)
      OR.L     D1,(A1)+
      OR.L     D1,-(A1)
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
