*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program

    ADD.B     D1,D2
      ADD.B     D1,(A1)
      ADD.B     D1,(A1)+
      ADD.B     D1,-(A1)
      ADD.B     (A1),D1
      ADD.B     (A1)+,D1
      ADD.B     -(A1),D1
      ADD.W     D1,D2
      ADD.W     D1,(A1)
      ADD.W     D1,(A1)+
      ADD.W     D1,-(A1)
      ADD.W     (A1),D1
      ADD.W     (A1)+,D1
      ADD.W     -(A1),D1
      ADD.L     D1,D2
      ADD.L     D1,(A1)
      ADD.L     D1,(A1)+
      ADD.L     D1,-(A1)
      ADD.L     (A1),D1
      ADD.L     (A1)+,D1
      ADD.L     -(A1),D1
      
      ADDA.W        D1,A2
      ADDA.W        (A1),A2
      ADDA.W        (A1)+,A2
      ADDA.W        -(A1),A2
      ADDA.L        D1,A2
      ADDA.L        (A1),A2
      ADDA.L        (A1)+,A2
      ADDA.L        -(A1),A2
      
      ADDA.W    $12,A2
      ADDA.W    $1234,A2
      ADDA.W    $12345678,A2
      ADDA.W    #$1234,A2
      ADDA.L    $12,A2
      ADDA.L    $1234,A2
      ADDA.L    $12345678,A2
      ADDA.L    #$12345678,A2

    
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
