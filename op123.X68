*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
    
    ** ***************************************
    ** Verify for MOVE or MOVEA
    **
    ** MOVE:  If opID = 1,2,3 & DstMod = 0,2-7
    ** MOVEA: If opID =   2,3 & DstMod = 1
    **
    ** Size: opID = 1: Byte; opID = 2: Long; opID = 3: Word
    **
    *****************************************
    
Word              DC.W     $0000                   * 16 bit instruction Word
ID                DC.B     $00                     * First 4 bit value ID
DstReg            DC.B     $FF                     * Destination Register Value
DstMod            DC.B     $FF                     * Destination Mode Value
SrcReg            DC.B     $FF                     * Source Register Value
SrcMod            DC.B     $FF                     * Source Register Mode
PtrNam            DC.L     $00000000               * Pointer to full text name
ValSiz            DC.B     $FF                     * Instruction size value $FF=Not set, 1=Byte, 2=Word, 3=Long

Nam_MOVE          DC.B     'MOVE',0                
Nam_MOVEA         DC.B     'MOVEA',0               
SizB              DC.B     '.B',0                  
SizW              DC.B     '.W',0                  
SizL              DC.B     '.L',0 
Err               DC.B     $01                     * Error byte                  


START             
    
    * grab ID (first 4 bits), use D3, D4 as temp
    MOVE.W  Word, D3                  
    MOVE.B  #12,D4
    LSR.W   D4,D3                       
    MOVE.B  D3, ID

    * grab DestReg (next 3 bits)
    MOVE.W  Word, D3
    MOVE.B  #4, D4
    LSL.W   D4, D3                     
    MOVE.B  #13,D4
    LSR.W   D4,D3                       
    MOVE.B  D3, DstReg

    * grab DestMod (next 3 bits)
    MOVE.W  Word, D3                  
    MOVE.B  #7, D4
    LSL.W   D4, D3                      
    MOVE.B  #13,D4
    LSR.W   D4,D3                       
    MOVE.B  D3, DstMod

    * grab SrcReg (next 3 bits)
    MOVE.W  Word, D3                  
    MOVE.B  #10, D4
    LSL.W   D4, D3                      
    MOVE.B  #13,D4
    LSR.W   D4,D3                       
    MOVE.B  D3, SrcMod
    
    * grab SrcMod (next 3 bits)
    MOVE.W  Word, D3                  
    MOVE.B  #13, D4
    LSL.W   D4, D3                      
    MOVE.B  #13,D4
    LSR.W   D4,D3                       
    MOVE.B  D3, SrcReg


    * check if MOVE or MOVEA using DestMod
    CMP.B   #1, DstMod                  * DestMod == 1: MOVEA
    BEQ     DS_MOVEA                  
    BRA     DS_MOVE                     * Else: MOVE
    
DS_MOVE        
    LEA     Nam_MOVE,A3
    MOVE.L  A3,PtrNam                   * Display name points to name
    BRA     CMP_SIZE

DS_MOVEA        
    CMP.B   #1, ID
    BEQ     ERROR                       * MOVEA cannot have ID = 1
    LEA     Nam_MOVEA,A3
    MOVE.L  A3,PtrNam                   * Display name points to name
    BRA     CMP_SIZE
    
CMP_SIZE   
    CMP.B   #1, ID                    
    BEQ     SIZE_B
    CMP.B   #3, ID                    
    BEQ     SIZE_W
    CMP.B   #2, ID                   
    BEQ     SIZE_L
    

SIZE_B        
    MOVE.B  #0,ValSiz                 * Set size to 0=Byte
    BRA     CHECK_SRCMOD
    
SIZE_W         
    MOVE.B  #1,ValSiz                 * Set size to 1=Word
    BRA     CHECK_SRCMOD
    
SIZE_L         
    MOVE.B  #2,ValSiz                 * Set size to 2=Long
    BRA     CHECK_SRCMOD

CHECK_SRCMOD
    CMP.B   #7, SrcMod                * Check if source mode is 7
    BEQ     CHECK_SRCREG              * Check source register
    BRA     Fn_ID3_ChkDstMod           * Source not 7, now check destination Mod
    
CHECK_SRCREG    
    CMP.B   #0, opSrcReg                 * Check is source register is 0
    BEQ     Fn_ID3_DtaSrcWrd            * Load next word
    CMP.B   #1, opSrcReg                * Check if source register is 1
    BEQ     Fn_ID3_DtaSrcLng            * Load next long
    CMP.B   #4, opSrcReg                * Check if source register is 4 (immediate value)
    BEQ     Fn_ID3_DtaSrcImd            * Load first word into word one
    BRA     FN_ID3_Error                * Invalid register value

ERROR
    MOVE.B  #2, ERR                   * Error 0 = A-OK; 1 = DATA; 2 = Invalid EA
    RTS

DONE
     MOVE.B  #0, ERR                   * Clear error flag 
     RTS


    END    START        ; last line of source   

                

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
