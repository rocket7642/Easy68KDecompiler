*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $9000
START:                  ; first instruction of program
    MOVEQ   #$CC,D6
    NOP
    RTS
    JSR       (A0)
    JSR       $1234
    JSR       $12345678
    ADDQ.L  #$1,(A0)
    ADDQ.L  #$8,(A0)
    ADDQ.W  #$1,$12
    NOP
    MOVEQ   #$0,D0
    MOVEQ   #$12,D0
    MOVEQ   #$FF,D0
    
    LEA     (A0),A0
    LEA     (A5),A0
    LEA     (A7),A0
    LEA     (A0),A7
    LEA     (A5),A7
    LEA     (A7),A7
    
    LEA       $12,A0
    LEA       $1234,A1
    LEA       $12345678,A2
    
    NOT.B     D0
    NOT.W     (A1)
    NOT.W     -(A1)
    NOT.W     (A1)+
    NOT.W     $1234
    NOT.L     $12345678

    NOP
    JSR       label1
    NOP
    RTS

    ADD.B     D1,D2
    ADD.B     D1,(A1)
    ADD.B     D1,(A1)+
    ADD.W     D1,-(A1)
    ADD.W     (A1),D1
    ADD.L     (A1),D1
    ADD.L     (A1)+,D1
    ADD.L     -(A1),D1
    ADD.W     (A1),D1
    NOP
    RTS
    ADDA.W        D1,A2
    ADDA.W        (A1),A3
    ADDA.W        (A1)+,A4
    ADDA.W        -(A1),A5
    ADDA.L        D1,A2
    ADDA.L        (A1),A3
    ADDA.L        (A1)+,A4
    ADDA.L        -(A1),A5
    ADDA.W    $12,A2
    ADDA.W    $1234,A2
    ADDA.W    $12345678,A2
   * ADDA.W    #$1234,A2
    ADDA.L    $12,A2
    ADDA.L    $1234,A2
    ADDA.L    $12345678,A2
   * ADDA.L    #$12345678,A2
    
    AND.B     D1,D2
    AND.B     D1,(A1)
    AND.W     D1,(A1)+
    AND.W     D1,-(A1)
    AND.L     (A1),D1
    AND.L     (A1)+,D1
    AND.B     -(A1),D1
    AND.W     -(A1),D1

    SUB.B     D1,D2
    SUB.B     D1,(A1)
    SUB.W     D1,(A1)+
    SUB.L     -(A1),D1 
    SUB.B     (A1)+,D1
    SUB.W     (A1)+,D1
    
    OR.W     (A1),D1
    OR.B     D1,(A1)+
    OR.B     D1,-(A1)
    OR.L     D1,D2
    OR.W     D1,D2
    OR.W     D1,(A1)
    OR.W     (A1)+,D1
    OR.W     -(A1),D1
    OR.L     D1,(A1)
    OR.L     -(A1),D1
      
    LSR     $1000
    ROR.B   #4,D4
    ROL     $3000
    ASR.L   #6,D7
    ASL.W   D3,D5
    ROR.L   D4,D5
    
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL     (A1)
    LSL     (A1)+
    LSL     -(A1)
    LSL.L     D1,D2
    LSR.B     D1,D2
    LSR.W     D1,D2
    LSR     (A1)
    LSR     (A1)+
    LSR     -(A1)
    LSR.L     D1,D2    
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR     (A1)
    ASR     (A1)+
    ASR     -(A1)
    ASR.L     D1,D2
    ASL.B     D1,D2
    ASL.W     D1,D2
    ASL     (A1)
    ASL     (A1)+
    ASL     -(A1)
    ASL.L     D1,D2

label1
    NOP
    RTS
    LEA       $12,A0
    LEA       $1234,A0
    LEA       $12345678,A0

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
