; EWoz Monitor Lite v1.0p
;
; Modified to work on the PAL-1 6502 kit
;
; This version by Jim B. McClanahan, April 2021
;
;   'Amputation' of Intel HEX Load portion, relocation of input buffer, other cuts
; to optimize for an 'unexpanded' PAL-1 or microKIM by Dave Hassler, Sept 2022.
;   Not that what Safstrom and McClanahan did is not needed - their work is amazing, and
; I've learned a lot; it's just that *I* don't need to load Intel HEX files - I use the
; online 6502 assember by Masswerk at:  https://www.masswerk.at/6502/assembler.html
; and it outputs perfect Apple I-format hex files.
;   In addition, I put the input buffer just above the end of the WozMon, butted up
; against the limit of the RAM of the 'unexpanded' PAL-1 and microKIM at $13FF.
;   By moving the buffer and stripping the Intel load code, we gain 704 bytes of
; contiguous RAM, which is significant - all of the First Book of KIM programs
; are smaller than just the savings! We have just over 4K to examine/load without issue.
;
; JBM vers based on EWoz 1.0 by "fsafstrom," March 2007. Relevant notes from original:
;
; "The EWoz 1.0 is just the good old Woz mon with a few improvements
; and extensions so to say.
; It prints a small welcome message when started.
; All key strokes are converted to uppercase.
; The backspace works so the _ is no longer needed.
; When you run a program, it's called with an JSR so if the program ends
;   with an RTS, you will be taken back to the monitor.
; You can load Intel HEX format files* and it keeps track of the checksum.
; [To load an Intel Hex file, just type L and hit return.
;   Now just send a Text file that is in the Intel HEX Format just as you
;   would send a text file for the Woz mon. You can abort the transfer by
;   hitting ESC.]
;
; I have also incorporated some changes from the Glitch Works and TangentDelta
; version created for the R65x1Q SBC."
;
; Notes for this version (1.0P as in 'PAL-1') by JBM:
;
; "Currently designed to load into RAM.
; Makes use of I/O routines in the PAL-1's ROM.
; May clobber Page Zero locations used by other applications, so you should
;   probably cold start anything else like the original monitor.
; By default, the original KIM-1 echoes all input. This uses a hardware 'trick'
;   to add some flexibility, but it is still limited to 'blocking' input. In
;   other words, there is no way to check if a key has been pressed--instead you
;   go to read a key and wait until one is pressed before returning."
;

; Input buffer is located at $1380.
xBuffr	= $1380	

; Keys and Characters
BS	= $08	; Backspace
;LF	= $0A	; Line Feed
;CR	= $0D	; Carriage Return
ESC	= $1B	; Escape
SPC	= $20	; Space
DOT	= $2E	; Period
CLN	= $3A	; Colon

IN	= xBuffr	;Input Buffer
;
; eWoz Page Zero Usage
; 
XAML	= $30
XAMH	= $31
STL	= $32
STH	= $33
L	= $34
H	= $35
YSAV	= $36
MODE	= $37
SADDR   = $38            ; Pointer to messages

; Define the KIM ROM routines we will use...
;
; A routine to send a byte to the console...
xOutch     = $1EA0
;
; A routine to get a byte from the console...
xGetch     = $1E5A


;
; Define any constants we want to use...
;
CR         = $0D
LF         = $0A

;
; PAL-1/KIM Hardware addresses used
;
SBD        = $1742           ; PAL-1 RIOT B Data Register


; Define Starting Address
;
*	= $1220


RESET:	CLD		; Clear decimal mode (just in case)
	LDX #$FF	; Set up stack
	TXS
; SFTRST loads the Escape key. We drop through and this prints
; the initial prompt.
SFTRST:	LDA #ESC	; Load Escape key
NOTCR:	CMP #BS		; Was it a backspace?
	BEQ BCKSPC
	CMP #ESC	; Was it an Escape?
	BEQ ESCAPE
	INY		; Increment Buffer Index (Y)
	BPL NXTCHR	; 'Auto-Escape' if buffer >127
ESCAPE:	LDA #$5C	; Load the prompt character ("\")
	JSR ECHO	; ...and display it
GETLIN:	JSR OUTCRLF	; Print CR/LF
	LDY #$01	; Initialize Buffer Index (Y)
BCKSPC:	DEY		; If backspacing, decrement Buffer Index (Y)
	BMI GETLIN	; If we backspace to far, start again
	LDA #SPC	; Overwrite the backspaced char with Space
	JSR ECHO
	LDA #BS		; And backspace again
	JSR ECHO
NXTCHR:	JSR GetKey	; Get next incoming char
	CMP #$60	; Is it lower case?
	BMI CNVRT	; If not, skip ahead
	AND #$5F	; Otherwise, convert to UPPER CASE
; CNVRT origially did an ORA #$80 which set the high bit. This is
; needed on the Apple to reset the high bit after conversion to
; upper case. We are just using ASCII so we can skip this.
CNVRT:	STA IN,Y	; Add the character to the text buffer
	JSR ECHO	; Display it to the screen
	CMP #$0D	; Was it a carriage return?
	BNE NOTCR	; If not, loop back for next character
	LDY #$FF	; Reset text index.
	LDA #$00	; For XAM mode.
	TAX		; 0->X.
SETSTR:	ASL		; Leaves $7B if setting STOR mode.
SETMOD:	STA MODE	; $00 = XAM, $7B = STOR, $AE = BLOK XAM.
BLSKIP:	INY		; Advance text index.
NXTITM:	LDA IN,Y	; Get character.
	CMP #CR		; CR?
	BEQ GETLIN	; Yes, done this line.
	CMP #DOT	; "."?
	BCC BLSKIP	; Skip delimiter.
	BEQ SETMOD	; vSet BLOCK XAM mode.
	CMP #$3A	; ":"?
	BEQ SETSTR	; Yes, set STOR mode.
	CMP #$44	; "D"?
	BEQ ASCII	; YES, GO SET UP FOR JSR OUT TO ASCII DUMP PRG.
	CMP #$52	; "R"?
	BEQ RUN		; Yes, run user program.
			; CMP #'L'	 * "L"?
			; BEQ LDINT	 * Yes, Load Intel Code.
	STX L		; $00->L.
	STX H		; and H.
	STY YSAV	; Save Y for comparison.
NXTHEX:	LDA IN,Y	; Get character for hex test.
	EOR #$30	; Map digits to $0-9.
	CMP #$0A	; Digit?
	BCC DIG		; Yes.
	ADC #$88	; Map letter "A"-"F" to $FA-FF.
	CMP #$FA	; Hex letter?
	BCC NOTHEX	; No, character not hex.
DIG:	ASL
	ASL		; Hex digit to MSD of A.
	ASL
	ASL
	LDX #$04	; Shift count.
HEXSFT:	ASL		; Hex digit left MSB to carry.
	ROL L		; Rotate into LSD.
	ROL H		; Rotate into MSD's.
	DEX		; Done 4 shifts?
	BNE HEXSFT	; No, loop.
	INY		; Advance text index.
	BNE NXTHEX	; Always taken. Check next character for hex.
NOTHEX:	CPY YSAV	; Check if L, H empty (no hex digits).
	BNE NOESC	; * Branch out of range, had to improvise...
	JMP SFTRST	; Yes, do a soft reset

ASCII	LDA XAML	; SET XAM ADDR TO ZERO PG LOC THAT ASCII DUMP USES
	STA $20
	LDA XAMH
	STA $21
	JSR $1170
	JMP SFTRST
RUN:	JSR ACTRUN	; * JSR to the Address we want to run.
	JMP SFTRST	; * When returned for the program, reset EWOZ.
ACTRUN:	JMP (XAML)	; Run at current XAM index.

			; LDINT:	JSR LDINT * Load the Intel code.
			; JMP SFTRST * When returned from the program, reset EWOZ.
			; LDINT 'amputated' BY D. HASSLER
			; 

NOESC:	BIT MODE	; Test MODE byte.
	BVC NOTSTR	; B6=0 for STOR, 1 for XAM and BLOCK XAM
	LDA L		; LSD's of hex data.
	STA (STL,X)	; Store at current "store index".
	INC STL		; Increment store index.
	BNE NXTITM	; Get next item. (no carry).
	INC STH		; Add carry to 'store index' high order.
TONXIT:	JMP NXTITM	; Get next command item.

NOTSTR:	LDA MODE
	CMP #DOT
	BEQ XAMNXT
	LDX #$02	; Byte count.
SETADR:	LDA L-1,X	; Copy hex data to
	STA STL-1,X	; "store index".
	STA XAML-1,X	; And to "XAM index'.
	DEX		; Next of 2 bytes.
	BNE SETADR	; Loop unless X = 0.
NXTPRN:	BNE PRDATA	; NE means no address to print.
	JSR OUTCRLF	; Output CR/LF
	LDA XAMH	; 'Examine index' high-order byte.
	JSR PRBYTE	; Output it in hex format.
	LDA XAML	; Low-order "examine index" byte.
	JSR PRBYTE	; Output it in hex format.
	LDA #$3A	; ":".
	JSR ECHO	; Output it.
PRDATA:	LDA #$20	; Blank.
	JSR ECHO	; Output it.
	LDA (XAML,X)	; Get data byte at 'examine index".
	JSR PRBYTE	; Output it in hex format.
XAMNXT:	STX MODE	; 0-> MODE (XAM mode).
	LDA XAML
	CMP L		; Compare 'examine index" to hex data.
	LDA XAMH
	SBC H
	BCS TONXIT	; Not less, so no more data to output.
	INC XAML
	BNE MD8CHK	; Increment 'examine index".
	INC XAMH
MD8CHK:	LDA XAML	; Check low-order 'exainine index' byte
	AND #$0F	; For MOD 8=0 ** changed to $0F to get 16 values per row **
	BPL NXTPRN	; Always taken.
PRBYTE:	PHA		; Save A for LSD.
	LSR
	LSR
	LSR		; MSD to LSD position.
	LSR
	JSR PRHEX	; Output hex digit.
	PLA		; Restore A.
PRHEX:	AND #$0F	; Mask LSD for hex print.
	ORA #$00	; Add "0".
	CMP #$3A	; Digit?
	BCC ECHO	; Yes, output it.
	ADC #$06	; Add offset for letter.
;
; Reworked to use PAL-1's OutCh which returns with
; Y set to $FF.
ECHO:	STA SADDR+0	; Save A
	TYA             ; Save Y
	STA SADDR+1
	LDA SADDR+0
	AND #$7F        ; Strip upper bit (for normal ASCII)
	JSR xOutch	; Send it using the ROM routine
	LDA SADDR+1     ; Restore Y
	TAY
	LDA SADDR+0	; Restore A
	RTS		; Done, over and out...

GETHEX:	LDA IN,Y	; Get first char.
	EOR #$30
	CMP #$0A
	BCC DONE1
	ADC #$08
DONE1:	ASL
	ASL
	ASL
	ASL
	STA L
	INY
	LDA IN,Y	; Get next char.
	EOR #$30
	CMP #$0A
	BCC DONE2
	ADC #$08
DONE2:	AND #$0F
	ORA L
	INY
	RTS




;
; GetKey - Fetches character from keyboard and returns
;          character in Accumulator
;
; This uses trickery to avoid the echo that usually
; is done in hardware by the PAL-1 and KIM.
;
; Y register is preserved because it is used as the buffer
; pointer by eWoz.
;
GetKey:    TYA               ; Save Y
           STA SADDR+1
           LDA SBD           ; Get the RIOT register
           AND #$FE          ; Mask out low bit
           STA SBD
           JSR $1E5A         ; Call KIM GETCH routine. Returns char in A. Changes Y.
           STA SADDR+0       ; Save A
           LDA SBD           ; Get the RIOT register
           ORA #$01          ; Mask in low bit
           STA SBD           ; And store it
           LDA SADDR+1       ; Restore Y
           TAY
           LDA SADDR+0       ; Restore A
           RTS

;
; OUTCRLF will display a carriage return and line feed
;
OUTCRLF:   TYA               ; Save Y
           STA SADDR+1
           LDA #CR           ; Load Carriage Return and print
           JSR XOutch
           LDA #LF           ; Load Line Feed and print
           JSR XOutch
           LDA SADDR+1       ; Restore Y
           TAY
           RTS
