*******************************************************
* EA subroutine
* Purpose: Generate EA
*         Addresses used: 
*            D5 must contain 6 bits of EA 
*            D6 contains contains <data> in hex
*            D2 will be used to store mode
*            D3 will be used to store Register
*            A4 - Buffer for printing  
***************************************************
REGISTER_NUM  DC.W        $000,$001,$010,$011,$100,$101,$110,$111

MODE000       EQU         $000                   * MODE Dn
MODE001       EQU         $001                   * MODE An
MODE010       EQU         $010                   * MODE (An)
MODE011       EQU         $011                   * MODE (An)+
MODE100       EQU         $100                   * MODE -(An)
MODE111       EQU         $111                   * ABSOLUTE AND IMMIDIATE DATA ADDRESSING

STATE         DC.B        0                      ; USED TO FLAG  BAD OR GOOD STATE
BAD_FLAG      EQU         1

***** ASCII VALUES FOR EA CHARACTERS**************
D                       EQU      $44
A                       EQU      $41
OPEN_PARENTHESIS        EQU      $28
CLOSED_PARENTHESIS      EQU      $29
PLUS_SIGN               EQU      $2B
MINUS_SIGN              EQU      $2D
HASH_TAG                EQU      $23
PERCENT_SIGN            EQU      $25


EA_SR           CLR, D4           ; SHIFTING QUANTITY
                CLR, D3           ; STORES REGISTER NUMBER
                CLR, D2           ; STORES MODE NUMBER
                MOVE.L D6,D7      
                LSR.L  #3,D7      ;REMOVE THE REGISTER
                MOVE.L D7,D2      ; COPY THE MODE TO D2
                MOVE.L D6,D7
                MOVE.B  #29,D4
                ASL.L   D4, D7    ; REMOVE MODE
                ASR.L   D4,D7     ; RESTORE THE REGISTER TO ITS ORIGINAL PLACE
                MOVE.L  D7,D3

                
                CMP.W       #MODE000,D2              
                BEQ         DATA_REGISTER                 
                CMP.W       #MODE001,D2               
                BEQ         ADDRESS_REGISTER                 
                CMP.W       #MODE010,D2               
                BEQ         ADDRESS_REGISTER_DIRECT               
                CMP.W       #MODE011,D2               
                BEQ         ADDRESS_REGISTER_INCREMENT             
                CMP.W       #MODE100,D2              
                BEQ         ADDRESS_REGISTER_DECREMENT              
                CMP.W       #MODE111,D2              
                BEQ         ABSOLUTE_IMMIDIATE_ADRRESSING                
                MOVE.B      #BAD_FLAG,STATE               
                JMP         EA_FINISH              
                
DATA_REGISTER   JSR      REGISTER_NUMBER_TO_DECIMAL   ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                MOVE.B   #D,(A4)+
                MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                JMP      EA_FINISH
                    

ADDRESS_REGISTER REGISTER_NUM,A2                       ;LOAD THE REGISTERS TO A2
                 JSR      REGISTER_NUMBER_TO_DECIMAL   ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                 MOVE.B   #A,(A4)+
                 MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                 JMP      EA_FINISH

                 
ADDRESS_REGISTER_DIRECT JSR      REGISTER_NUMBER_TO_DECIMAL   ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                        MOVE.B   #OPEN_PARENTHESIS,(A4)+
                        MOVE.B   #A,(A4)+
                        MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                        MOVE.B   #CLOSED_PARENTHESIS,(A4)+
                        JMP      EA_FINISH


ADDRESS_REGISTER_INCREMENT JSR      REGISTER_NUMBER_TO_DECIMAL   ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                           MOVE.B   #OPEN_PARENTHESIS,(A4)+
                           MOVE.B   #A,(A4)+
                           MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,(A4)+
                           MOVE.B   #PLUS_SIGN,(A4)
                           JMP      EA_FINISH


ADDRESS_REGISTER_DECREMENT JSR      REGISTER_NUMBER_TO_DECIMAL   ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL AND 
                           MOVE.B   #MINUS_SIGN,(A4)+
                           MOVE.B   #OPEN_PARENTHESIS,(A4)+
                           MOVE.B   #A,(A4)+
                           MOVE.B   D5,(A4)+                    ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,(A4)+
                           JMP      EA_FINISH


ABSOLUTE_IMMIDIATE_ADRRESSING JSR      REGISTER_NUMBER_TO_DECIMAL
                               


REGISTER_NUMBER_TO_DECIMAL CMP.W       (A2)+,D3
                           BEQ         R_N_T_D_FINISH                ;RETURN TO SUBROUTINE
                           ADDQ.W      #1,D5
                           BRA         REGISTER_NUMBER_TO_DECIMAL
 
R_N_T_D_FINISH    RTS


