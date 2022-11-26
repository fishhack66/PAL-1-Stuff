; LIL' FILL - DAVE HASSLER, '22
; Fills 256 contiguous memory locations with a specific value
; Adapted from http://www.6502.org/source/general/clearmem.htm
; ONLY X REGISTER IS ALTERED UPON EXIT

.ORG = $0E50

			; $D0/D1=START ADDR
			; $D2=FILL VALUE	$D3/D4=TEMP STORAGE
			
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



FILMEM	LDX #$00	; # TIMES TO LOOP (256)
	LDA $D2		;Set up fill value
        LDY #$00	;Initialize index pointer
WRMEM   STA ($D0),Y	;Clear memory location
        INY             ;Advance index pointer
        DEX             ;Decrement counter
        BNE WRMEM       ;Not zero, continue writing
	JSR $1E2F
	LDA #$4F	; PRINT 'Ok'
	JSR $1EA0
	LDA #$6B
	JSR $1EA0

	JSR RESTOR	; RESTORE ORIG A,Y
	
	JMP $0B00	; BACK TO MENU

                  	
STORAY	STA $D3		; STORE A, Y           
	STY $D4
	RTS

RESTOR	LDY $D4         ; RESTORE Y,A
	LDA $D3	
	RTS	

TITLE
.BYTE $0A $0D
.BYTE "LIL' FILL - 256 bytes. Start addr: low $D0, high $D1. Fill value $D2."
.BYTE $0A $0D
.BYTE "'G' to start, other key Menu"
.BYTE $0A $0D $00
.BYTE "LIL' BUG by K7CCC "



