; LIL' FILL - DAVE HASSLER, '22
; Adapted from http://www.6502.org/source/general/clearmem.htm
; ONLY X REGISTER IS ALTERED UPON EXIT

.ORG = $0E50

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
	JMP $0B00	; NO, TO MENU (SO USER CAN ENTER VALUES)
			; SINCE THIS PROGRAM WRITES TO MEMORY



FILMEM	LDX $22		; # TIMES TO LOOP
	LDA $23		;Set up fill value
        LDY #$00	;Initialize index pointer
WRMEM   STA ($20),Y	;Clear memory location
        INY             ;Advance index pointer
        DEX             ;Decrement counter
        BNE WRMEM       ;Not zero, continue checking
	JSR $1E2F
	LDA #$4F	; PRINT 'Ok'
	JSR $1EA0
	LDA #$6B
	JSR $1EA0

	JSR RESTOR	; RESTORE ORIG A,Y A,Y
	
	JMP $0B00	; BACK TO MENU

                  	
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
.BYTE "# to write (<=$FF) $22, fill value $23."
.BYTE $0A $0D
.BYTE "'G' to start, other key Menu"
.BYTE $0A $0D $00



