; LIL' FILL - DAVE HASSLER, '22
; Adapted from http://www.6502.org/source/general/clearmem.htm
; This program writes a page-worth or less of a single hex value into memory.
;
;   ONLY X REGISTER IS ALTERED UPON EXIT
;
;   To the original, I added a little press-a-key routine, because this is a 
; "destructive" program; if the right values are not set beforehand, one
; could unintentionally write over needed data that was not yet saved.
;   I also changed the zero page locations to match my own memory dump program,
; and the user can select a 'custom' hex value (not just $00) for the fill.
; The save-A-and-Y bits are needed bacause of the KIM's kernal routines. Well,
; not absolutely necessary, but nice.
;   Last, I added a little "OK" message, to let the user know that things
; went through. 
;


.ORG = $1100

			; $20/21=START ADDR     $22=BYTES TO WRITE (<=$FF) 
			; $23=FILL VALUE	$24/25=TEMP STORAGE
			
	CLD		; INIT
	JSR STORAY	; SAVE ORIG A,Y

	LDX #$00
PRNT1	LDA TITLE,X
	BEQ ISITG	; OUT TO TEST GOT GO
	JSR $1EA0	; CALL OUTCH
	INX
	JMP PRNT1

ISITG	JSR $1E5A	; GET A KEYSTROKE
	CMP #$47	; IS IT G?
	BEQ FILMEM	; YES, START
	BRK		; NO, TO MONITOR (SO USER CAN ENTER VALUES)



FILMEM	LDX $22		; # TIMES TO LOOP
	LDA $23		;Set up fill value
        LDY #$00	;Initialize index pointer
WRMEM   STA ($20),Y	;Clear memory location
        INY             ;Advance index pointer
        DEX             ;Decrement counter
        BNE WRMEM       ;Not zero, continue checking
	JSR $1E2F
	LDA #$4F	; PRINT 'OK'
	JSR $1EA0
	LDA #$6B
	JSR $1EA0

	JSR RESTOR	; RESTORE ORIG A,Y A,Y
	
	BRK		; BACK TO MONITOR (OR WHERE EVER)

                  	
STORAY	STA $24		; STORE A, Y
	TYA             
	STA $25
	LDA $24
	RTS

RESTOR	LDA $25         ; RESTORE Y,A
	TAY
	LDA $24	
	RTS	

TITLE
.BYTE $0A $0D
.BYTE "LIL' FILL - Start addr: low $20, high $21"
.BYTE $0A $0D
.BYTE "# to write (<256) $22, fill value $23."
.BYTE $0A $0D
.BYTE "'G' to start, other to BRK"
.BYTE $0A $0D $00



