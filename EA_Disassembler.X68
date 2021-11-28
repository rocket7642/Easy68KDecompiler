*-----------------------------------------------------------
* Title      : EA
* Written by :ABDIRAHMAN HASSAN
* Date       : 
* Description: Generate EFFECTIVE ADDRESS
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

     MOVE.B #%111,D2
     MOVE.B #%001,D3
     
     movea.l print_buffer,A4
     lea    word,A2
     MOVE.B #3,SIZE
     JSR    EA_START
     
     
     move.b #9,d0
     trap #15

*******************************************************
* EA subroutine
* Purpose: Generate EA
*         Addresses used: 
*            D2 FOR MODE
*            D3 FOR REGISTER
*            D5 HOLDS DECIMAL VALUE OF THE REGISTER 
*            D1 FOR PRINTING
*            A2 MIMICKS INSTRUCTION BUFFER
*            D7 DATA FOR ABSOLUTE, IMMIDIATE ADDRESSING  
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
word          DC.L        $8000
SIZE          DC.B        0

NUMBER_OF_HEX DC.B        0

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
                MOVE.B   #D,D1
                MOVE.B  #6,D0
                TRAP    #15
                ADDI.L   #$30,D5
                MOVE.B   D5,D1
                MOVE.B  #6,D0
                TRAP    #15                  ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                BRA      EA_FINISH
                    

ADDRESS_REGISTER MOVE.B  #A,D1                      ;LOAD THE REGISTERS TO A2
                 MOVE.B  #6,D0
                 TRAP    #15
                 ADDI.L   #$30,D5
                 MOVE.B   D5,D1
                 MOVE.B  #6,D0
                 TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                 BRA      EA_FINISH

                 
ADDRESS_REGISTER_DIRECT                                 ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL
                        MOVE.B   #OPEN_PARENTHESIS,D1
                        MOVE.B   #6,D0
                        TRAP     #15
                        MOVE.B   #A,D1
                        MOVE.B  #6,D0
                        TRAP    #15
                        ADDI.L   #$30,D5
                        MOVE.B   D5,D1
                        MOVE.B  #6,D0
                        TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                        MOVE.B   #CLOSED_PARENTHESIS,D1
                        MOVE.B  #6,D0
                        TRAP    #15
                        BRA      EA_FINISH


ADDRESS_REGISTER_INCREMENT                                ; THE BINARY NUMBER IN D3 TO DECIMAL
                           MOVE.B   #OPEN_PARENTHESIS,D1
                           MOVE.B   #6,D0
                           TRAP     #15
                           MOVE.B   #A,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           ADDI.L   #$30,D5
                           MOVE.B   D5,D1
                           MOVE.B  #6,D0
                           TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           MOVE.B   #PLUS_SIGN,(A4)+
                           MOVE.B  #6,D0
                           TRAP    #15
                           BRA      EA_FINISH


ADDRESS_REGISTER_DECREMENT                                ; CONVERTS THE BINARY NUMBER IN D3 TO DECIMAL AND 
                           MOVE.B   #MINUS_SIGN,D1
                           MOVE.B   #6,D0
                           TRAP        #15
                           MOVE.B   #OPEN_PARENTHESIS,D1
                           MOVE.B   #6,D0
                           TRAP     #15
                           MOVE.B   #A,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           ADDI.L   #$30,D5
                           MOVE.B   D5,D1
                           MOVE.B  #6,D0
                           TRAP    #15                     ;DECIMAL FORM OF THE REGISTER TO PRINTING BUFFER
                           MOVE.B   #CLOSED_PARENTHESIS,D1
                           MOVE.B  #6,D0
                           TRAP    #15
                           BRA      EA_FINISH

ABSOLUTE_IMMIDIATE_ADRRESSING 
                              BRA  CONTINUE_A_I_A
                              
                              
CONTINUE_A_I_A                
                              CMP.B       #4,D5                ; CHECK FOR IMMIDIATE DATA
                              BEQ         IMMIDIATE_REGISTER                
                              CMP.B       #0,D5                ; WORD ADDRESSING
                              BEQ         WORD_ADDRESSING                
                              CMP.B       #1,D5                ; LONG ADDRESSIN 
                              BEQ         LONG_ADDRESSING              
                              MOVE.B      #BAD_FLAG,STATE              
                              BRA         EA_FINISH                * jump to end   
                              
                              
IMMIDIATE_REGISTER            MOVE.B #HASH_TAG,D1
                              MOVE.B #6,D0
                              TRAP   #15
                              CMP.B #1,SIZE   ;BYTE
                              BEQ   GETBYTE
                              CMP.B #2,SIZE   ;BYTE
                              BEQ   GETWORD
                              CMP.B #3,SIZE   ;BYTE
                              BEQ   GETLONG
                              BRA   GETLONG
                              

WORD_ADDRESSING              MOVE.B #DOLLAR_SIGN,D1
                             MOVE.B #6,D0
                             TRAP  #15
                             MOVE.W  (A2)+,D7
                             BRA   PRINT_WORD
                             BRA   EA_FINISH

LONG_ADDRESSING              MOVE.B #DOLLAR_SIGN,D1
                             MOVE.B #6,D0
                             TRAP  #15
                             MOVE.L  (A2)+,D7
                             BRA   PRINT_LONG
                             BRA   EA_FINISH                            

GETBYTE      
                MOVE.B   (A2)+,D7    
                BMI     ADD_NEGATIVE
                BRA     PRINT_BRANCHING
GETWORD                
                MOVE.W   (A2)+,D7
                BMI     ADD_NEGATIVE
                BRA     PRINT_BRANCHING
GETLONG                
                
                MOVE.L   (A2)+,D7
                BMI     ADD_NEGATIVE
                BRA     PRINT_BRANCHING
                
ADD_NEGATIVE    MOVE.B #MINUS_SIGN,D1
                MOVE.B #6,D1
                TRAP   #15
                BRA    PRINT_BRANCHING


PRINT_BRANCHING  CMP.B #1,SIZE   ;BYTE
                BEQ    PRINT_BYTE    
                CMP.B #2,SIZE   ;WORD
                BEQ    PRINT_WORD
                CMP.B  #3,SIZE  ;LONG
                BEQ    PRINT_LONG
                BRA    PRINT_BRANCHING




                
**** BYTE DATA PRINTING***********************
PRINT_BYTE     CLR     D1                  ; CLEAR ANY LEFT BITS
               

               CMP.L   #$F,D7              
               BLE     BYTE_ONE_LOOP                  
               BRA     READ_BYTE

BYTE_ONE_LOOP
                MOVE.B  #1,NUMBER_OF_HEX  
                BRA     READ_BYTE
    
READ_BYTE                           
    CMP.B   #0,NUMBER_OF_HEX               
    BEQ     COPYBYTE
    
    MOVE.B  #$30,D1             
    MOVE.B  #6,D0               
    TRAP    #15

    SUBI.B  #1,NUMBER_OF_HEX     ; MINUS ONE           
    BRA     READ_BYTE           ; LOOP
    
COPYBYTE
    MOVE.L  D7,D1               ; COPY DATA 
    MOVE.B  #16,D2              ; CONVERT THE BASE TO 16
    MOVE.B  #15,D0              ; Display the unsigned number in D1.L converted to number base (2 through 36) contained in D2.B.
    TRAP    #15
    MOVE.B  #0,NUMBER_OF_HEX
    BRA  EA_FINISH





******PRINT WORD DATA******************
PRINT_WORD   CLR     D1                  ; CLEAR ANY LEFT BITS
               

               CMP.L   #$F,D7              
               BLE     WORD_ONE_LOOP
               CMP.L   #$FF,D7              
               BLE     WORD_TWO_LOOP
               CMP.L   #$FFF,D7              
               BLE     WORD_THREE_LOOP                  
               BRA     READ_WORD

WORD_ONE_LOOP
                MOVE.B  #1,NUMBER_OF_HEX  
                BRA     READ_WORD
                
WORD_TWO_LOOP
                MOVE.B  #2,NUMBER_OF_HEX  
                BRA     READ_WORD
                
WORD_THREE_LOOP
                MOVE.B  #3,NUMBER_OF_HEX  
                BRA     READ_WORD                
    
READ_WORD                           
    CMP.B   #0,NUMBER_OF_HEX               
    BEQ     COPYWORD
    
    MOVE.B  #$30,D1             
    MOVE.B  #6,D0               
    TRAP    #15

    SUBI.B  #1,NUMBER_OF_HEX              
    BRA     READ_WORD                   ; LOOP

COPYWORD
    MOVE.L  D7,D1               ; COPY DATA 
    MOVE.B  #16,D2              ; CONVERT THE BASE TO 16
    MOVE.B  #15,D0              ; Display the unsigned number in D1.L converted to number base (2 through 36) contained in D2.B.
    TRAP    #15
    MOVE.B  #0,NUMBER_OF_HEX
    BRA  EA_FINISH

****************PRINT LONG DATA*****************
PRINT_LONG      CLR     D1                  ; CLEAR ANY LEFT BITS
               

               CMP.L   #$F,D7              
               BLE     LONG_ONE_LOOP
               CMP.L   #$FF,D7              
               BLE     LONG_TWO_LOOP
               CMP.L   #$FFF,D7              
               BLE     LONG_THREE_LOOP
               CMP.L   #$FFFF,D7              
               BLE     LONG_FOUR_LOOP
               CMP.L   #$FFFFF,D7              
               BLE     LONG_FIVE_LOOP
               CMP.L   #$FFFFFF,D7              
               BLE     LONG_SIX_LOOP
               CMP.L   #$FFFFFFF,D7              
               BLE     LONG_SEVEN_LOOP                  
               BRA     READ_LONG

LONG_ONE_LOOP
                MOVE.B  #1,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_TWO_LOOP
                MOVE.B  #2,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_THREE_LOOP
                MOVE.B  #3,NUMBER_OF_HEX  
                BRA     READ_LONG                
LONG_FOUR_LOOP
                MOVE.B  #4,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_FIVE_LOOP
                MOVE.B  #5,NUMBER_OF_HEX  
                BRA     READ_LONG
                
LONG_SIX_LOOP
                MOVE.B  #6,NUMBER_OF_HEX  
                BRA     READ_LONG
LONG_SEVEN_LOOP
                MOVE.B  #7,NUMBER_OF_HEX  
                BRA     READ_LONG

     
READ_LONG                           
    CMP.B   #0,NUMBER_OF_HEX               
    BEQ     COPYLONG
    MOVE.B  #$30,D1             
    MOVE.B  #6,D0               
    TRAP    #15

    SUBI.B  #1,NUMBER_OF_HEX               
    BRA     READ_LONG                   ; LOOP

COPYLONG
    MOVE.L  D7,D1               ; COPY DATA 
    MOVE.B  #16,D2              ; USIGN BASE TO 16
    MOVE.B  #15,D0              ; Display the unsigned number in D1.L converted to number base (2 through 36) contained in D2.B.
    TRAP    #15
    MOVE.B  #0,NUMBER_OF_HEX
    BRA  EA_FINISH

  







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