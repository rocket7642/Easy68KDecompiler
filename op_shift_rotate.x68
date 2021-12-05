*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START: 

                 ; first instruction of program
******************************************
*        THE GROUP 14
*        LS,AS AND ROTATION
*        
******************************************
COMPARE_1110 
            CLR D5     ;STORING ISOLATED BITS
            MOVE.L   D4,SIZE_IL
            AND.L    #$00C0,SIZE_IL   ;ISOLATE THE SIZE 
            MOVE.L   SIZE_IL,D5
            LSR.L    #6,D5            ;NORMALIZE
            MOVE.B   D5,SIZE          ;SAVE THE SIZE
            CMP.B    #%11,D5    
            BEQ      G14_MEMS         ;MEMORY SHIFTING
            MOVE.L   D4,G14_TYPE      
            AND.L    #$0014,G14_TYPE  ; ISOLATE THE TYPE
            CLR     D5
            MOVE.L  G14_TYPE,D5
            LSR.L   #3,D5
            CMP.B   #%001,D5
            BEQ     G_LS    ;LOGICAL SHIFTS
            CMP.B   #%011,D5
            BEQ     G_RO    ;ROTAIONS
            CMP.B   #%000,D5
            BEQ     G_AS    ;ARITHMATIC SHIFTS
            
            MOVE.B #1,BAD_FLAG
            JMP   PR_BAD_DATA   ; PRINT BAD DATA   
        
            
G_LS               ;GROUP LOGICAL SHIFT
     CLR   D5
     MOVE.L D4,IR_IL
     AND.L  #$0020,IR_IL
     MOVE.L  IR_IL,D5
     LSR.L   #5,D5
     CMP.B   #$1,D5
     BEQ     GLS_EA    ; L SHIFT WITH DATA REGISTER AS SOURCE
     CLR D5
     MOVE.L  D4,D5
     AND.L  #$0100,D5
     LSR.L  #8,D5
     MOVE.L  D5,DR
     CLR D5
     MOVE.L  D4,D5
     AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
     LSR.L   #8,D5
     LSR.L   #1,D5
     CMP.L   #7,D5
     BGT     PR_BAD_DATA   ; THE NUMBER SHOULD NOT BE GREATER 7  
     CMP.L   #0,D5
     BLT     PR_BAD_DATA    ;THE COUNT IS LESS, 0 IS FOR EIGHT  
     MOVE.L  D5,S_COUNT
     CLR     D5
     MOVE.L  D4,D5
     AND.L   #$0007,D5
     MOVE.B   D5,dRN
     BRA      PR_LS             
     
GLS_EA 
     CLR D5
     MOVE.L  D4,D5
     AND.L  #$0100,D5
     LSR.L  #8,D5
     MOVE.L  D5,DR     ;DIRECTION
     CLR D5
     MOVE.L  D4,D5
     AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
     LSR.L   #8,D5
     LSR.L   #1,D5
     CMP.L   #7,D5
     BGT     PR_BAD_DATA   ; THE NUMBER SHOULD NOT BE GREATER 7  
     CMP.L   #0,D5
     BLT     PR_BAD_DATA    ;THE COUNT IS LESS, 0 IS FOR EIGHT  
     MOVE.L  D5,sRN          ; SOURCE REGISTER NUMBER BITS 
     CLR     D5
     MOVE.L   D4,D5
     AND.L   #$0007,D5
     MOVE.B   D5,dRN         ; DESTINATION REGISTER FOR
     BRA      PR_G_LS_EA      ;LS WITH EFFECTIVE ADDRESSING       
                
       

G_RO            ;GROUP ROTATION
     CLR   D5
     MOVE.L D4,IR_IL
     AND.L  #$0020,IR_IL
     MOVE.L  IR_IL,D5
     LSR.L   #5,D5
     CMP.B   #$1,D5
     BEQ     GRO_EA    ;SHIFT IS WITH DATA REGISTER
     CLR D5
     MOVE.L D4,D5
     AND.L  #$0100,D5
     LSR.L  #8,D5
     MOVE.L  D5,DR
     CLR D5
     MOVE.L  D4,D5
     AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
     LSR.L   #8,D5
     LSR.L   #1,D5
     CMP.L   #7,D5
     BGT     PR_BAD_DATA   ; THE NUMBER SHOULD NOT BE GREATER 7  
     CMP.L   #0,D5
     BLT     PR_BAD_DATA    ;THE COUNT IS LESS, 0 IS FOR EIGHT  
     MOVE.L  D5,S_COUNT
     CLR    D5
     MOVE.L   D4,D5
     AND.L   #$0007,D5
     MOVE.B  D5,dRN
     BRA     PR_RO          ; PRINT ROTION 

GRO_EA 
     CLR D5
     MOVE.L  D4,D5
     AND.L  #$0100,D5
     LSR.L  #8,D5
     MOVE.L  D5,DR     ;DIRECTION
     CLR D5
     MOVE.L  D4,D5
     AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
     LSR.L   #8,D5
     LSR.L   #1,D5
     CMP.L   #7,D5
     BGT     PR_BAD_DATA   ; THE NUMBER SHOULD NOT BE GREATER 7  
     CMP.L   #0,D5
     BLT     PR_BAD_DATA    ;THE COUNT IS LESS, 0 IS FOR EIGHT  
     MOVE.L  D5,sRN          ; SOURCE REGISTER NUMBER BITS 
     CLR     D5
     MOVE.L   D4,D5
     AND.L   #$0007,D5
     MOVE.B   D5,dRN         ; DESTINATION REGISTER FOR
     BRA      PR_G_RO_EA      ;LS WITH EFFECTIVE ADDRESSING  



G_AS         ;GROUP ARITHMATIC SHIFT
     CLR   D5
     MOVE.L D4,IR_IL
     AND.L  #$0020,IR_IL
     MOVE.L  IR_IL,D5
     LSR.L   #5,D5
     CMP.B   #$1,D5
     BEQ     GAS_EA    ;SHIFT IS WITH DATA REGISTER
     CLR D5
     MOVE.L D4,D5
     AND.L  #$0100,D5
     LSR.L  #8,D5
     MOVE.L  D5,DR
     CLR D5
     MOVE.L  D4,D5
     AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
     LSR.L   #8,D5
     LSR.L   #1,D5
     CMP.L   #7,D5
     BGT     PR_BAD_DATA   ; THE NUMBER SHOULD NOT BE GREATER 7  
     CMP.L   #0,D5
     BLT     PR_BAD_DATA    ;THE COUNT IS LESS, 0 IS FOR EIGHT  
     MOVE.L  D5,S_COUNT
     CLR    D5
     MOVE.L   D4,D5
     AND.L   #$0007,D5
     MOVE.B   D5,dMODE
     BRA     PR_AS ; PRINT ROTION 

GAS_EA    ;SHIFT IS WITH DATA REGISTER
     CLR D5
     MOVE.L  D4,D5
     AND.L  #$0100,D5
     LSR.L  #8,D5
     MOVE.L  D5,DR     ;DIRECTION
     CLR D5
     MOVE.L  D4,D5
     AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
     LSR.L   #8,D5
     LSR.L   #1,D5
     CMP.L   #7,D5
     BGT     PR_BAD_DATA   ; THE NUMBER SHOULD NOT BE GREATER 7  
     CMP.L   #0,D5
     BLT     PR_BAD_DATA    ;THE COUNT IS LESS, 0 IS FOR EIGHT  
     MOVE.L  D5,sRN          ; SOURCE REGISTER NUMBER BITS 
     CLR     D5
     MOVE.L   D4,D5
     AND.L   #$0007,D5
     MOVE.B   D5,dRN         ; DESTINATION REGISTER FOR
     BRA      PR_G_AS_EA      ;LS WITH EFFECTIVE ADDRESSING             

G14_MEMS 
       CLR D5
       MOVE.L  D4,D5
       AND.L   #$0E00,D5  ;ISOLATE THE SHIFT COUNT
       LSR.L   #8,D5
       LSR.L   #1,D5
       CMP.B   #%001,D5
       BEQ     G14_MEMS_LS   ;MEMORY SHIFT WITH LOGICAL SHIFT
       CMP.B   #%011,D5
       BEQ     G14_MEMS_RO   ;MEMORY ROTATION
       CMP.B   #%000,D5
       BEQ     G14_MEMS_AS   ; MEMORY ARITHMATIC SHIFT 

G14_MEMS_LS 
           CLR D5
           MOVE.L  D4,D5
           AND.L  #$0100,D5
           LSR.L  #8,D5
           MOVE.L  D5,DR     ;DIRECTION
           CLR D5
           MOVE.L D4,D5
           AND.L  #$0034,D5
           LSR.L  #3,D5
           MOVE.B  D5,dMODE     ;DESTINATION MODE
           CLR D5
           MOVE.L D4,D5
           AND.L  #$0007,D5
           CMP.B  #%000,dMODE   ;MODE 000 IS NOT ALLOWED
           BEQ    PR_BAD_DATA
           CMP.B   #%001,dMODE   ;MODE 001 IS NOT ALLOWED
           BEQ     PR_BAD_DATA
           MOVE.B  D5,dRG     ;DESTINATION REG
           CMP.B   #%111,dMODE   ;IF MODE 111 CHECK IF THE ID IS IMMIDIATE
           BEQ     CHECK_ID_LS 
           BRA     PR_G14_MEMS_LS             
           

              
 

G14_MEMS_RO
           CLR D5
           MOVE.L  D4,D5
           AND.L  #$0100,D5
           LSR.L  #8,D5
           MOVE.L  D5,DR     ;DIRECTION
           CLR D5
           MOVE.L D4,D5
           AND.L  #$0034,D5
           LSR.L  #3,D5
           MOVE.B  D5,dMODE     ;DESTINATION MODE
           CLR D5
           MOVE.L D4,D5
           AND.L  #$0007,D5
           CMP.B  #%000,dMODE   ;MODE 000 IS NOT ALLOWED
           BEQ    PR_BAD_DATA
           CMP.B   #%001,dMODE   ;MODE 001 IS NOT ALLOWED
           BEQ     PR_BAD_DATA
           MOVE.B  D5,dRG     ;DESTINATION REG
           CMP.B   #%111,dMODE   ;IF MODE 111 CHECK IF THE ID IS IMMIDIATE
           BEQ     CHECK_ID_RO 
           BRA     PR_G14_MEMS_RO  

G14_MEMS_AS
           CLR D5
           MOVE.L  D4,D5
           AND.L  #$0100,D5
           LSR.L  #8,D5
           MOVE.L  D5,DR     ;DIRECTION
           CLR D5
           MOVE.L D4,D5
           AND.L  #$0034,D5
           LSR.L  #3,D5
           MOVE.B  D5,dMODE     ;DESTINATION MODE
           CLR D5
           MOVE.L D4,D5
           AND.L  #$0007,D5
           CMP.B  #%000,dMODE   ;MODE 000 IS NOT ALLOWED
           BEQ    PR_BAD_DATA
           CMP.B   #%001,dMODE   ;MODE 001 IS NOT ALLOWED
           BEQ     PR_BAD_DATA
           MOVE.B  D5,dRG     ;DESTINATION REG
           CMP.B   #%111,dMODE   ;IF MODE 111 CHECK IF THE IT IMMIDIATE
           BEQ     CHECK_ID_AS 
           BRA     PR_G14_MEMS_AS                       
           


CHECK_ID_AS  CMP.B #$4,dRG
             BEQ   PR_BAD_DATA
             BRA     PR_G14_MEMS_AS
             
CHECK_ID_RO  CMP.B #$4,dRG
             BEQ   PR_BAD_DATA
             BRA     PR_G14_MEMS_RO
  
CHECK_ID_LS  CMP.B #$4,dRG
             BEQ   PR_BAD_DATA
             BRA    PR_G14_MEMS_LS                             
PR_G14_MEMS_AS
             
     CMP.B #$0,DR 
     BEQ   PR_ASR_MEM   ;MEM RIGHT SHIFT
    
    *******PRINT ASL*******
     LEA       PASL,A1   MEM LEFT SHIF
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 
     CLR D3
     CLR D2
     MOVE.B  dMODE,D3
     MOVE.B  dRN,D2
     JSR     EA_START
     
PR_ASR_MEM   ;MEM RIGHT SHIFT
     LEA       PASR,A1   MEM RIGHT SHIF
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 
     CLR D3
     CLR D2
     MOVE.B  dMODE,D3
     MOVE.B  dRN,D2
     JSR     EA_START

             

PR_G14_MEMS_LS 
     CMP.B #$0,DR 
     BEQ   PR_LSR_MEM   ;LOGICAL MEM RIGHT SHIFT
    
    *******PRINT ASL*******
     LEA       PLSL,A1   MEM LEFT SHIF
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 
     CLR D3
     CLR D2
     MOVE.B  dMODE,D3
     MOVE.B  dRN,D2
     JSR     EA_START
     
PR_LSR_MEM   ;LOGICAL MEM RIGHT SHIFT
     LEA       PLSR,A1   MEM RIGHT SHIF
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 
     CLR D3
     CLR D2
     MOVE.B  dMODE,D3
     MOVE.B  dRN,D2
     JSR     EA_START

PR_G14_MEMS_RO
     CMP.B #$0,DR 
     BEQ   PR_ROR_MEM   ;ROTATE MEM RIGHT 
    
    *******PRINT ASL*******
     LEA       PROL,A1   ROTATE MEM LEFT SHIF
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 
     CLR D3
     CLR D2
     MOVE.B  dMODE,D3
     MOVE.B  dRN,D2
     JSR     EA_START

PR_ROR_MEM   ;ROTATE MEM RIGHT 
     LEA       PROR,A1   ROTATE MEM RIGHT SHIF
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 
     CLR D3
     CLR D2
     MOVE.B  dMODE,D3
     MOVE.B  dRN,D2
     JSR     EA_START



PR_G_AS_EA
          CMP.B #$0,DR 
          BEQ   PR_ASR_EA   ;RIGHT SHIFT WITH DATA REGISTER
     
          *******PRINT LSL*******
          LEA       PASL,A1
          MOVE.B   #14,D0     ; moves #14 into data register D0
          TRAP     #15 
          JSR      SIZEPRINT
          MOVE.B  #%000,D3     ; mode data register
          MOVE.B  sRN,D2       ; source register number
          JSR     EA_START
          LEA      COMMA,A1
          MOVE.B   #14,D0
          TRAP     #15
          CLR D3
          CLR D2
          MOVE.B  #%000,D3      ; mode data register
          MOVE.B  dRN,D2        ; destination register
          JSR     EA_START
        
PR_ASR_EA          ;RIGHT ASR SHIFT WITH DATA REGISTER
         LEA       PASR,A1
        MOVE.B   #14,D0     ; moves #14 into data register D0
        TRAP     #15 
        JSR      SIZEPRINT
        MOVE.B  #%000,D3     ; mode data register
        MOVE.B  sRN,D2       ; source register number
        JSR     EA_START
        LEA      COMMA,A1
        MOVE.B   #14,D0
        TRAP     #15
        CLR D3
        CLR D2
        MOVE.B  #%000,D3      ; mode data register
        MOVE.B  dRN,D2        ; destination register
        JSR     EA_START

PR_G_LS_EA
          CMP.B #$0,DR 
          BEQ   PR_LSR_EA   ;RIGHT SHIFT WITH DATA REGISTER
     
        *******PRINT LSL*******
        LEA       PLSL,A1
        MOVE.B   #14,D0     ; moves #14 into data register D0
        TRAP     #15 
        JSR      SIZEPRINT
        MOVE.B  #%000,D3     ; mode data register
        MOVE.B  sRN,D2       ; source register number
        JSR     EA_START
        LEA      COMMA,A1
        MOVE.B   #14,D0
        TRAP     #15
        CLR D3
        CLR D2
        MOVE.B  #%000,D3      ; mode data register
        MOVE.B  dRN,D2        ; destination register
        JSR     EA_START
        
PR_LSR_EA          ;RIGHT SHIFT WITH DATA REGISTER
         LEA       PLSR,A1
        MOVE.B   #14,D0     ; moves #14 into data register D0
        TRAP     #15 
        JSR      SIZEPRINT
        MOVE.B  #%000,D3     ; mode data register
        MOVE.B  sRN,D2       ; source register number
        JSR     EA_START
        LEA      COMMA,A1
        MOVE.B   #14,D0
        TRAP     #15
        CLR D3
        CLR D2
        MOVE.B  #%000,D3      ; mode data register
        MOVE.B  dRN,D2        ; destination register
        JSR     EA_START

PR_G_RO_EA 
        
         CMP.B #$0,DR 
          BEQ   PR_ROR_EA   ;ROTATE RIGHT WITH DATA REGISTER
     
        *******PRINT LSL*******
        LEA       PROL,A1
        MOVE.B   #14,D0     ; moves #14 into data register D0
        TRAP     #15 
        JSR      SIZEPRINT
        MOVE.B  #%000,D3     ; mode data register
        MOVE.B  sRN,D2       ; source register number
        JSR     EA_START
        LEA      COMMA,A1
        MOVE.B   #14,D0
        TRAP     #15
        CLR D3
        CLR D2
        MOVE.B  #%000,D3      ; mode data register
        MOVE.B  dRN,D2        ; destination register
        JSR     EA_START
        
PR_ROR_EA           ;ROTATE RIGHT WITH DATA REGISTER
        LEA       PROR,A1
        MOVE.B   #14,D0     ; moves #14 into data register D0
        TRAP     #15 
        JSR      SIZEPRINT
        MOVE.B  #%000,D3     ; mode data register
        MOVE.B  sRN,D2       ; source register number
        JSR     EA_START
        LEA      COMMA,A1
        MOVE.B   #14,D0
        TRAP     #15
        CLR D3
        CLR D2
        MOVE.B  #%000,D3      ; mode data register
        MOVE.B  dRN,D2        ; destination register
        JSR     EA_START


PR_RO  
     CMP.B #$0,DR 
     BEQ   PR_ROR   ; RIGHT ROTATION
    
    *******PRINT ASL*******
     LEA       PROL,A1
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 

     JSR      SIZEPRINT
    
     ADDI.L   #30,S_COUNT
     MOVE.B   S_COUNT,D1
    MOVE.B   #6,D0
    TRAP     #15
    LEA      COMMA,A1
    MOVE.B   #14,D0
    TRAP     #15
    CLR D3
    CLR D2
    MOVE.B  #%000,D3
    MOVE.B  dRN,D2
    JSR     EA_START

PR_AS 
     CMP.B #$0,DR 
     BEQ   PR_ASR   ;RIGHT SHIFT
    
    *******PRINT ASL*******
     LEA       PASL,A1
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 

     JSR      SIZEPRINT
    
     ADDI.L   #30,S_COUNT
     MOVE.B   S_COUNT,D1
    MOVE.B   #6,D0
    TRAP     #15
    LEA      COMMA,A1
    MOVE.B   #14,D0
    TRAP     #15
    CLR D3
    CLR D2
    MOVE.B  #%000,D3
    MOVE.B  dRN,D2
    JSR     EA_START
           
PR_BAD_DATA           
                        
PR_LS 
    CMP.B #$0,DR 
    BEQ   PR_LSR   ;RIGHT SHIFT
    
    *******PRINT LSL*******
     LEA       PLSL,A1
     MOVE.B   #14,D0     ; moves #14 into data register D0
     TRAP     #15 

    JSR      SIZEPRINT
    
    ADDI.L   #30,S_COUNT
    MOVE.B   S_COUNT,D1
    MOVE.B   #6,D0
    TRAP     #15
    LEA      COMMA,A1
    MOVE.B   #14,D0
    TRAP     #15
    CLR D3
    CLR D2
    MOVE.B  #%000,D3
    MOVE.B  dRN,D2
    JSR     EA_START
          
PR_LSR LEA   PLSL,A1
      MOVE.B   #14,D0     ; moves #14 into data register D0
      TRAP     #15       ; Displays message via trap 14 
      JSR      SIZEPRINT
      ADDI.L   #30,S_COUNT
      MOVE.B   S_COUNT,D1
      MOVE.B   #6,D0
      TRAP     #15
      LEA      COMMA,A1
      MOVE.B   #14,D0
      TRAP     #15
      CLR D3
      CLR D2
      MOVE.B #%000,D3
      MOVE.B  dRN,D2
      JSR   EA_START
      
PR_ASR LEA   PASL,A1
      MOVE.B   #14,D0     ; moves #14 into data register D0
      TRAP     #15       ; Displays message via trap 14
      JSR      SIZEPRINT
      ADDI.L   #30,S_COUNT
      MOVE.B   S_COUNT,D1
      MOVE.B   #6,D0
      TRAP     #15
      LEA      COMMA,A1
      MOVE.B   #14,D0
      TRAP     #15
      CLR D3
      CLR D2
      MOVE.B #%000,D3
      MOVE.B  dRN,D2
      JSR   EA_START
      
PR_ROR LEA   PROR,A1
      MOVE.B   #14,D0     ; moves #14 into data register D0
      TRAP     #15       ; Displays message via trap 14
      JSR      SIZEPRINT
      ADDI.L   #30,S_COUNT
      MOVE.B   S_COUNT,D1
      MOVE.B   #6,D0
      TRAP     #15
      LEA      COMMA,A1
      MOVE.B   #14,D0
      TRAP     #15
      CLR D3
      CLR D2
      MOVE.B #%000,D3
      MOVE.B  dRN,D2
      JSR   EA_START



*******************PRINTING SIZE******************          
SIZEPRINT 
     CMP.B  #$0,SIZE
     BEQ   PRB
     CMP.B  #$1,SIZE
     BEQ   PRW
     CMP.B  #$1,SIZE
     BEQ   PRL

PRB   LEA PB,A1
      MOVE.B #14,D0
      TRAP #15
      RTS

PRW   LEA PW,A1
      MOVE.B #14,D0
      TRAP #15
      RTS 

PRL   LEA PL,A1
      MOVE.B #14,D0
      TRAP #15
      RTS     
    
    
    
            
    

    END    START        ; last line of source

