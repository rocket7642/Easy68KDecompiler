*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; testing instruction 

     MOVE.B #%111,D2
     MOVE.B #%100,D3
     movea.l print_buffer,A4
     lea    word,A3
     JSR    EA_START
     
     move.b #3,d0
     trap #15
     
     move.b #9,d0
     trap #15

*******************************************************
* EA subroutine
* Purpose: Generate EA
*         Addresses used:  
*            A3 contains contains <data> in hex
*            D2 contains store mode
*            D3 contains Register
*            A4 - Buffer for printing  
***************************************************
REG_0  EQU         %000
REG_1  EQU         %001
REG_2  EQU         %010
REG_3  EQU         %011
REG_4  EQU         %100
REG_5  EQU         %101
REG_6  EQU         %110
REG_7  EQU         %111

MODE000       EQU         %000                   * MODE Dn
MODE001       EQU         %001                   * MODE An
MODE010       EQU         %010                   * MODE (An)
MODE011       EQU         %011                   * MODE (An)+
MODE100       EQU         %100                   * MODE -(An)
MODE111       EQU         %111                   * ABSOLUTE AND IMMIDIATE DATA ADDRESSING

STATE         DC.B        0                      ; USED TO FLAG  BAD OR GOOD STATE
BAD_FLAG      EQU         1
word          DC.W       '34343631'

NUMBER_OF_HEX DC.B        4

print_buffer  DC.l       $100

***** ASCII VALUES FOR EA CHARACTERS**************
D                       EQU      $44
A                       EQU      $41
OPEN_PARENTHESIS        EQU      $28
DOLLAR_SIGN             EQU      $24
CLOSED_PARENTHESIS      EQU      $29
PLUS_SIGN               EQU      $2B
MINUS_SIGN              EQU      $2D
HASH_TAG                EQU      $23
PERCENT_SIGN            EQU      $25


EA_start        jmp        REGISTER_NUMBER_TO_DECIMAL

Continue_EA            
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
                BRA         EA_FINISH              
                
DATA_REGISTER                         ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                MOVE.B   #D,(A4)+
                ADDI.L   #$30,D5
                MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                BRA      EA_FINISH
                    

ADDRESS_REGISTER                       ;LOAD THE REGISTERS TO A2
                 MOVE.B   #A,(A4)+
                 ADDI.L   #$30,D5
                 MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                 BRA      EA_FINISH

                 
ADDRESS_REGISTER_DIRECT                                 ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                        MOVE.B   #OPEN_PARENTHESIS,(A4)+
                        MOVE.B   #A,(A4)+
                        ADDI.L   #$30,D5
                        MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                        MOVE.B   #CLOSED_PARENTHESIS,(A4)+
                        BRA      EA_FINISH


ADDRESS_REGISTER_INCREMENT                                ; THE BINARY NUMBER IN D3 TO DECIMAL
                           MOVE.B   #OPEN_PARENTHESIS,(A4)+
                           MOVE.B   #A,(A4)+
                           ADDI.L   #$30,D5
                           MOVE.B   D5,(A4)+                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,(A4)+
                           MOVE.B   #PLUS_SIGN,(A4)+
                           BRA      EA_FINISH


ADDRESS_REGISTER_DECREMENT                                ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL AND 
                           MOVE.B   #MINUS_SIGN,(A4)+
                           MOVE.B   #OPEN_PARENTHESIS,(A4)+
                           MOVE.B   #A,(A4)+
                           ADDI.L   #$30,D5
                           MOVE.B   D5,(A4)+                    ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,(A4)+
                           BRA      EA_FINISH

***********************************************************
* Absolutle addressing and immidiate needs little work 
* After the trailing data is converted to ASCII, need one more function to append the values to the printing buffer
***********************************************************
ABSOLUTE_IMMIDIATE_ADRRESSING 
                              JMP  HEX_TO_ASCII
                              
                              
CONTINUE_A_I_A                
                              CMP.B       #4,D5                ; CHECK FOR IMMIDIATE DATA
                              BEQ         IMMIDIATE_REGISTER                
                              CMP.B       #0,D5                ; WORD ADDRESSING
                              BEQ         WORD_ADDRESSING                
                              CMP.B       #1,D5                ; LONG ADDRESSIN 
                              BEQ         LONG_ADDRESSING              
                              MOVE.B      #BAD_FLAG,STATE              
                              BRA         EA_FINISH                * jump to end   
                              
                              
IMMIDIATE_REGISTER            MOVE.B #HASH_TAG,(A4)+
                              BRA   ADD_ASCII_TO_PRINT_BUFFER
                              BRA   EA_FINISH
                              

WORD_ADDRESSING              MOVE.B #DOLLAR_SIGN,(A4)+
                             BRA   ADD_ASCII_TO_PRINT_BUFFER
                             BRA    EA_FINISH

LONG_ADDRESSING              MOVE.B #DOLLAR_SIGN,(A4)+
                             BRA   ADD_ASCII_TO_PRINT_BUFFER
                             BRA    EA_FINISH                              


ADD_ASCII_TO_PRINT_BUFFER

* SUBROUTINE: 
*            Convert Hex value in D6 to ASCII code for priting  *
*            Address used: 
*             D7 - COPYING STORING HEX VALUES
*        NOT TOO CONFIDENT ABOUT THE THIS FUNCTION EITHER
HEX_TO_ASCII    cmp.b #0,NUMBER_OF_HEX
                beq   Hex_Conversion_Done
                sub.B #1,NUMBER_OF_HEX
                lsl.l #4,D7
                move.b (A3)+,D2
        
                CMP.B  #$39,D2
                BLE    NUMBER_CONVERSION
                SUB.L #$37,D2
                ADD.L D2,d7
                BRA  HEX_TO_ASCII
                
**********If the char is number. convert it********               
NUMBER_CONVERSION   SUB.L  #$30,d2
                    ADD.L d2,d7
                    BRA HEX_TO_ASCII

Hex_Conversion_Done  MOVE.B  #8,NUMBER_OF_HEX
                     JMP CONTINUE_A_I_A



EA_FINISH      RTS




************************************************
*Subroutine: REGISTER_NUMBER_TO_DECIMAL 
*            CONVERT BINARY NUMBER IN D3 TO DECIMAL AND STORES IN D5
************************************************
REGISTER_NUMBER_TO_DECIMAL 
                           CMP.W       #REG_0,D3
                           BEQ         RG0
                           CMP.W       #REG_1,D3
                           BEQ         RG1
                           CMP.W       #REG_2,D3
                           BEQ         RG2
                           CMP.W       #REG_3,D3
                           BEQ         RG3
                           CMP.W       #REG_4,D3
                           BEQ         RG4
                           CMP.W       #REG_5,D3
                           BEQ         RG5
                           CMP.W       #REG_6,D3
                           BEQ         RG6
                           CMP.W       #REG_7,D3
                           BEQ         RG7
                           MOVE.B      #BAD_FLAG,STATE
                           JMP         CONTINUE_EA
 
RG0    MOVE.B   #0,D5
       JMP      Continue_EA
RG1    MOVE.B   #1,D5
       JMP      Continue_EA
RG2    MOVE.B   #2,D5
       JMP      Continue_EA
RG3    MOVE.B   #3,D5
       JMP      Continue_EA
RG4    MOVE.B   #4,D5
       JMP      Continue_EA
RG5    MOVE.B   #5,D5
       JMP      Continue_EA
RG6    MOVE.B   #6,D5
       JMP      Continue_EA
RG7    MOVE.B   #7,D5
       JMP      Continue_EA 


    END    START        ; last line of source

