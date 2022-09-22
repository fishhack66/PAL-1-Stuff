;
;              6 5 0 2   D I S A S S E M B L E R
;
;               BY STEVE WOZNIAK AND ALLEN BAUM
;                       AUG. 11, 1976
;
;            FROM SEPT. '76 ISSUE  (PGS.249-252)
;                    OF DR. DOBB'S JOURNAL
;
;     TIDIED FOR KIM-1, ETC., BY DAVE HASSLER, SEPT. 2022
;
; ... AND ALL I DID WAS REPLACE THE APPLE 1 OUTPUT ROUTINES
; WITH KIM-1 ANALOGUES, PLUS A LITTLE 'MASSAGING' OF THE ASCII.
; OTHERWISE, IT'S AS IT WAS 46 YEARS AGO, EVEN IN THE SAME
; LOCATION. IT'S COMPLETELY RELOCATEABLE TO ANY CONTIGUOUS
; MEMORY BLOCK. FOR THE PAL-1 AND microKIM, IF YOU ARE
; 'UNEXPANDED' IN THE RAM DEPT., $1200 MAKES SENSE.
; HOPEFULLY, IT'LL BE OF USE TO THOSE FOLKS.  --DHH
;
; * TO USE *
; PLACE THE ADDRESS TO START DISASSEMBLY IN $44 AND $45 ON ZERO PAGE.
; LITTLE ENDIAN FASHION: FOR $03DA, ENTER DA --> $44; 03 --> $45.  
; $47 AND $48 ARE USED AS TEMP STORAGE FOR A AND Y REGISTERS.
; IT'S BEST TO CLEAR THE DECIMAL FLAG BEFORE RUNNING: 00 --> $F1.
; TO CONTINUE DISASSEMBLING THE NEXT SET OF INSTRUCTIONS, SIMPLY
; RUN THE PROGRAM AGAIN WITHOUT CHANGING $44 AND $45.
;
; COMMENTS FOR THIS SOURCE CODE CAN BE FOUND IN THE ACCOMPANYING PDF
; "6502_DISASSEMBLER_FROM_APPLE.PDF".

         ; FORMAT = $40          
         ; LENGTH = $41          
         ; LMNEM  = $42         
         ; RMNEM  = $43         
         ; PCL    = $44       
         ; PCH    = $45       
         ; COUNT  = $46         
         ; TEMPA  = $47         
         ; TEMPY  = $48         
                      
                    * = $0800
  DSMBL     LDA #$13              
            STA $46         
DSMBL2     JSR INSTDS                
          JSR PCADJ           
            STA $44         
            STY $45         
            DEC $46         
            BNE DSMBL2         
INSTDS     JSR PRPC                
            LDA ($44,X)         
              TAY        
              LSR A       
            BCC IEVEN         
              LSR A       
            BCS ERR         
            CMP #$22         
            BEQ ERR         
            AND #$07         
            ORA #$80         
    IEVEN     LSR A            
              TAX        
          LDA $08FE,X           
            BCS RTMODE         
              LSR A       
              LSR A       
              LSR A       
              LSR A       
  RTMODE     AND #$0F              
            BNE GETFMT         
  ERR     LDY #$80              
            LDA #$00         
    GETFMT     TAX             
          LDA $0942,X           
            STA $40         
            AND #$03         
            STA $41         
              TYA        
            AND #$8F         
              TAX        
              TYA        
            LDY #$03         
            CPX #$8A         
            BEQ MNNDX3         
    MMNDX1     LSR A            
            BCC MNNDX3         
              LSR A       
    MNNDX2     LSR A            
            ORA #$20         
              DEY        
            BNE MNNDX2         
              INY        
    MNNDX3     DEY             
            BNE MMNDX1         
              PHA        
  PROP     LDA ($44),Y              
          JSR PRTHEX           
            LDX #$01         
PROPBL     JSR PRBL2                
            CPY $41         
              INY        
            BCC PROP         
            LDX #$03         
            CPY #$04         
            BCC PROPBL         
              PLA        
              TAY        
          LDA $095C,Y           
            STA $42         
          LDA $099C,Y           
            STA $43         
  PRMN1     LDA #$00              
            LDY #$05         
  PRMN2     ASL $43              
            ROL $42         
              ROL A       
              DEY        
            BNE PRMN2         
            ADC #$BF         
          JSR KIMOUT           
              DEX        
            BNE PRMN1         
          JSR PRBLNK           
            LDX #$06         
  PRADR1     CPX #$03              
            BNE PRADR3         
            LDY $41         
            BEQ PRADR3         
  PRADR2     LDA $40              
            CMP #$E8         
            LDA ($44),Y         
            BCS RELADR         
          JSR PRTHEX           
              DEY        
            BNE PRADR2         
  PRADR3     ASL $40              
            BCC PRADR4         
          LDA $094F,X           
          JSR KIMOUT           
          LDA $0955,X           
            BEQ PRADR4         
          JSR KIMOUT           
    PRADR4     DEX             
            BNE PRADR1         
              RTS        
RELADR     JSR PCADJ2                
              TAX        
              INX        
            BNE PRNTYX         
              INY        
    PRNTYX     TYA             
PRNTAX     JSR PRTHEX                
    PRNTX     TXA             
          JMP PRTHEX           
  PRPC    NOP
	  NOP  		; ORIG LDA #$8D           
          JSR CRLF    ; ORIG JSR KIMOUT    
            LDA $45         
            LDX $44         
          JSR PRNTAX           
            LDA #$2D         
          JSR KIMOUT           
  PRBLNK     LDX #$03              
  PRBL2     LDA #$20              
PRBL3     JSR KIMOUT                
    L08EB     DEX             
            BNE PRBL2         
              RTS        
  PCADJ     LDA $41              
    PCADJ2    SEC              
  PCADJ3     LDY $45              
              TAX        
            BPL PCADJ4         
              DEY        
  PCADJ4     ADC $44              
            BCC RTS1         
              INY        
    RTS1     RTS             
.BYTE $40   ;  START TABLES                 
.BYTE $02                     
.BYTE $45                     
.BYTE $03                     
.BYTE $D0                     
.BYTE $08                     
.BYTE $40                     
.BYTE $09                     
.BYTE $30                     
.BYTE $22                     
.BYTE $45                     
.BYTE $33                     
.BYTE $D0                     
.BYTE $08                     
.BYTE $40                     
.BYTE $09                     
.BYTE $40                     
.BYTE $02                     
.BYTE $45                     
.BYTE $33                     
.BYTE $D0                     
.BYTE $08                     
.BYTE $40                     
.BYTE $09                     
.BYTE $40                     
.BYTE $00                     
.BYTE $40                     
.BYTE $B0                     
.BYTE $D0                     
.BYTE $00                     
.BYTE $40                     
.BYTE $00                     
.BYTE $00                     
.BYTE $22                     
.BYTE $44                     
.BYTE $33                     
.BYTE $D0                     
.BYTE $8C                     
.BYTE $44                     
.BYTE $00                     
.BYTE $11                     
.BYTE $22                     
.BYTE $44                     
.BYTE $33                     
.BYTE $D0                     
.BYTE $8C                     
.BYTE $44                     
.BYTE $9A                     
.BYTE $10                     
.BYTE $22                     
.BYTE $44                     
.BYTE $33                     
.BYTE $D0                     
.BYTE $08                     
.BYTE $40                     
.BYTE $09                     
.BYTE $10                     
.BYTE $22                     
.BYTE $44                     
.BYTE $33                     
.BYTE $D0                     
.BYTE $08                     
.BYTE $40                     
.BYTE $09                     
.BYTE $62                     
.BYTE $13                     
.BYTE $78                     
.BYTE $A9                     
.BYTE $00                     
.BYTE $21                     
.BYTE $81                     
.BYTE $82                     
.BYTE $00                     
.BYTE $00                     
.BYTE $59                     
.BYTE $4D                     
.BYTE $91                     
.BYTE $92                     
.BYTE $86                     
.BYTE $4A                     
.BYTE $85                     
.BYTE $9D                     
.BYTE $2C                     
.BYTE $29                     
.BYTE $2C                     
.BYTE $23                     
.BYTE $28                     
.BYTE $24                     
.BYTE $79                     
.BYTE $00                     
.BYTE $78                     
.BYTE $24                     
.BYTE $24                     
.BYTE $00                     
.BYTE $1C                     
.BYTE $8A                     
.BYTE $1C                     
.BYTE $23                     
.BYTE $5D                     
.BYTE $8B                     
.BYTE $1B                     
.BYTE $A1                     
.BYTE $9D                     
.BYTE $8A                     
.BYTE $1D                     
.BYTE $23                     
.BYTE $9D                     
.BYTE $8B                     
.BYTE $1D                     
.BYTE $A1                     
.BYTE $00                     
.BYTE $29                     
.BYTE $19                     
.BYTE $AE                     
.BYTE $69                     
.BYTE $A8                     
.BYTE $19                     
.BYTE $23                     
.BYTE $24                     
.BYTE $53                     
.BYTE $1B                     
.BYTE $23                     
.BYTE $24                     
.BYTE $53                     
.BYTE $19                     
.BYTE $A1                     
.BYTE $00                     
.BYTE $1A                     
.BYTE $5B                     
.BYTE $5B                     
.BYTE $A5                     
.BYTE $69                     
.BYTE $24                     
.BYTE $24                     
.BYTE $AE                     
.BYTE $AE                     
.BYTE $A8                     
.BYTE $AD                     
.BYTE $29                     
.BYTE $00                     
.BYTE $7C                     
.BYTE $00                     
.BYTE $15                     
.BYTE $9C                     
.BYTE $6D                     
.BYTE $00                     
.BYTE $A5                     
.BYTE $69                     
.BYTE $29                     
.BYTE $53                     
.BYTE $84                     
.BYTE $13                     
.BYTE $34                     
.BYTE $11                     
.BYTE $A5                     
.BYTE $69                     
.BYTE $23                     
.BYTE $A0                     
.BYTE $D8                     
.BYTE $62                     
.BYTE $5A                     
.BYTE $48                     
.BYTE $26                     
.BYTE $62                     
.BYTE $94                     
.BYTE $88                     
.BYTE $54                     
.BYTE $44                     
.BYTE $C8                     
.BYTE $54                     
.BYTE $68                     
.BYTE $44                     
.BYTE $E8                     
.BYTE $94                     
.BYTE $00                     
.BYTE $B4                     
.BYTE $08                     
.BYTE $84                     
.BYTE $74                     
.BYTE $B4                     
.BYTE $28                     
.BYTE $6E                     
.BYTE $74                     
.BYTE $F4                     
.BYTE $CC                     
.BYTE $4A                     
.BYTE $72                     
.BYTE $F2                     
.BYTE $A4                     
.BYTE $8A                     
.BYTE $00                     
.BYTE $AA                     
.BYTE $A2                     
.BYTE $A2                     
.BYTE $74                     
.BYTE $74                     
.BYTE $74                     
.BYTE $72                     
.BYTE $44                     
.BYTE $68                     
.BYTE $B2                     
.BYTE $32                     
.BYTE $B2                     
.BYTE $00                     
.BYTE $22                     
.BYTE $00                     
.BYTE $1A                     
.BYTE $1A                     
.BYTE $26                     
.BYTE $00                     
.BYTE $72                     
.BYTE $72                     
.BYTE $88                     
.BYTE $C8                     
.BYTE $C4                     
.BYTE $CA                     
.BYTE $26                     
.BYTE $48                     
.BYTE $44                     
.BYTE $44                     
.BYTE $A2                     
.BYTE $C8                     
.BYTE $00                     
.BYTE $00                     
                      
CRLF STA $47  		; START OF PRINT 2 HEX CHARS SUBROUTINE           
    			; (HIDING A,Y IN ZERO PG.)             
STY $48  		;                  
JSR $1E2F 		;                   
JMP RESTOR  		; JMP TO RESTORE A,Y              
                      
                      
PRTHEX STA $47  	; START OF PRINT 2 HEX CHARS SUBROUTINE           
    			; (HIDING A,Y IN ZERO PG.)             
 	STY $48   	;                 
 JSR $1E3B 	;                   
 JMP RESTOR  ; JMP TO RESTORE A,Y              
                      
                      
KIMOUT	STA $47   ; START OF FIX ASCII FOR KIM SUBROUTINE           
 TYA 	  ; (HIDING A,Y IN ZERO PG.)             
 	STA $48   ;                 
 LDA $47   ;                 
 AND #$7F  ; STRIP HIGH BIT               
 JSR $1EA0 ; CALL OUTCH                 
RESTOR LDA $48  ; RESTORE REGISTERS                
 TAY   ;                   
 LDA $47  ;                  
 RTS   ;                   
