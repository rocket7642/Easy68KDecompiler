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
    ** MOVE:  If ID = 1,2,3 & DstMod = 0,2-7
    ** MOVEA: If ID =   2,3 & DstMod = 1
    **
    ** Size: ID = 1: Byte; ID = 2: Long; ID = 3: Word
    **
    *****************************************
COMMANDDATA       DC.W     $0000                   * 16 bit instruction Word
SizeValue         DC.B     $FF                     * Instruction size value $FF=Not set, 1=Byte, 2=Word, 3=Long
OpName            DC.B     $00                     * 0 = MOVE, 1 = MOVEA


Word              DC.W     $0000                   * 16 bit instruction Word
ID                DC.B     $00                     * First 4 bit value ID
DstReg            DC.B     $FF                     * Destination Register Value D3
DstMod            DC.B     $FF                     * Destination Mode Value D2
SrcReg            DC.B     $FF                     * Source Register Value D3 JUMP EA_start
SrcMod            DC.B     $FF                     * Source Register Mode D2

opDta1            DC.L     $00000000               * Data value one (most likely source)
opDta1T           DC.B     $FF                     * Data value one type ($FF not set, 0=byte, 1=word, 2=long)
opDta2            DC.L     $00000000               * Data value two (most likely destination)
opDta2T           DC.B     $FF                     * Data value two type ($FF not set, 0=byte, 1=word, 2=long)
               
Err               DC.B     $01                     * Error byte, 1 = OK, 0 = Error                 

Comma             DC.B     ',', 0

CHECK_MOVE

    MOVE.W COMMANDDATA, Word  * grab 16 bit instruction from main           
    
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
    MOVE.B  #0,OpName                   * OpName = 0 for MOVE
    BRA     CMP_SIZE

DS_MOVEA        
    CMP.B   #1, ID
    BEQ     ERROR                       * MOVEA cannot have ID = 1
    MOVE.B  #01,OpName                  * OpName = 1 for MOVEA
    BRA     CMP_SIZE
    
CMP_SIZE   
    CMP.B   #1, ID                    
    BEQ     SIZE_B
    CMP.B   #3, ID                    
    BEQ     SIZE_W
    CMP.B   #2, ID                   
    BEQ     SIZE_L
    

SIZE_B        
    MOVE.B  #1,SizeValue                 * Set size to 1=Byte
    BRA     CHECK_SRCMOD
    
SIZE_W         
    MOVE.B  #2,SizeValue                 * Set size to 2=Word
    BRA     CHECK_SRCMOD
    
SIZE_L         
    MOVE.B  #3,SizeValue                 * Set size to 3=Long
    BRA     CHECK_SRCMOD

CHECK_SRCMOD
    CMP.B   #7, SrcMod                * Check if source mode is 7
    BEQ     CHECK_SRCREG              * Check source register
    BRA     CHECK_DESTMOD             * Source not 7, now check destination Mod
    
CHECK_SRCREG    
    CMP.B   #0, SrcReg                * Check is source register is 0
    BEQ     DtaSrcWrd                 * Load next word
    CMP.B   #1, SrcReg                * Check if source register is 1
    BEQ     DtaSrcLng                 * Load next long
    CMP.B   #4, SrcReg                * Check if source register is 4 (immediate value)
    BEQ     DtaSrcImd                 * Load first word into word one
    BRA     ERROR                     * Invalid register value

DtaSrcImd    
    CMP.B   #1, ID                    * ID = 1 - size is byte
    BEQ     DtaSrcImdB                * Load next byte
    CMP.B   #2, ID                    * ID = 2 - size is word
    BEQ     DtaSrcImdW                * Load next word
    CMP.B   #3, ID                    * ID = 3 - size is long
    BEQ     DtaSrcImdL                * Load next long
    BRA     ERROR                     * Invalid opID (this should never happen)  
    
    
DtaSrcImdB   
    CLR.L   D3
    MOVE.W  (A2)+,D3
    MOVE.L  D3,opDta1
    MOVE.B  #3, opDta1T               * Set Data 1 type as 0=Byte
    BRA     CHECK_DESTMOD             * Check destination mode

DtaSrcImdW  
    CLR.L   D3
    MOVE.W  (A2)+,D3
    MOVE.L  D3,opDta1
    MOVE.B  #3, opDta1T               * Set Data 1 type as 1=Word
    BRA     CHECK_DESTMOD             * Check destination mode

DtaSrcImdL   
    CLR.L   D3
    MOVE.L  (A2)+,D3
    MOVE.L  D3,opDta1
    MOVE.B  #3, opDta1T               * Set Data 1 type as 2=Long
    BRA     CHECK_DESTMOD             * Check destination mode

DtaSrcWrd    
    CLR.L   D3
    MOVE.W  (A2)+,D3
    MOVE.L  D3,opDta1
    MOVE.B  #1, opDta1T               * Set Data 1 type as 1=Word
    BRA     CHECK_DESTMOD             * Check destination mode

DtaSrcLng                        
    CLR.L   D3
    MOVE.L  (A2)+,D3
    MOVE.L  D3,opDta1
    MOVE.B  #2, opDta1T               * Set Data 1 type as 2=Long
    BRA     CHECK_DESTMOD             * Check destination mode

CHECK_DESTMOD
    CMP.B   #7, DstMod                * Check if destination mode is 7
    BEQ     CEHCK_DESTREG             * Check destination register
    BRA     DONE                      * Destination not 7, done with data
                    
CEHCK_DESTREG    
    CMP.B   #0, DstReg                * Check if destination register is 0
    BEQ     DtaDstWrd                 * Load next word
    CMP.B   #1, DstReg                * Check if destination register is 1
    BEQ     DtaDstLng                 * Load next long
    BRA     ERROR                     * Invalid registration Mode

DtaDstWrd    
    CLR.L   D3
    MOVE.W  (A2)+,D3
    MOVE.L  D3,opDta2
    MOVE.B  #1, opDta2T               * Set Data2 type as 1=Word
    BRA     DONE
    
DtaDstLng    
    CLR.L   D3
    MOVE.L  (A2)+,D3
    MOVE.L  D3,opDta2
    MOVE.B  #2, opDta2T               * Set Data2 type as 2=Long
    BRA     DONE

ERROR
    MOVE.B  #0, ERR                  * Error 1 = A-OK; 0 = Invalid EA
    RTS

DONE
     MOVE.B  #1, ERR                 * Clear error flag
     CMP.B   #0, OpName              * 0 = OpName for MOVE
     BEQ     PRINTMOVE
     CMP.B   #1, OpName              * 1 = OpName for MOVEA
     BEQ     PRINTMOVEA
     BRA     SIZESPLIT               * Print size, variable SizeValue has to be set
     
     * EA Part
     CLR     D2                      * Source to EA
     CLR     D3
     MOVE.B  SrcMod, D2
     MOVE.B  SrcReg, D3
     BRA     EA_start
     
     LEA     Comma, A1                * Print comma
     MOVE.B  #14, D0
     TRAP    #15
     
     CLR     D2                       * Destination to EA
     CLR     D3
     MOVE.B  DstMod, D2
     MOVE.B  DstReg, D3
     BRA     EA_start
     
     RTS


    END    CHECK_MOVE ; last line of source   

                



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
