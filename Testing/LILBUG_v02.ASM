;
; LIL' BUG - a 6502 debugging set for the 5 KB 'unexpanded'
; PAL-1 (KIM-1) hobby microcomputer kit designed by Liu Ganning.
;
; Included in the set:
; eWOZ Monitor Lite by a) Steve Wozniak, 1976 (original); b) F. Safstrom 2007
;   (added Intel Hex load and backspace fix); c) Jim B. McClanahan, 2021
;   (added A,Y-save print routine, needed for PAL-1); d) David H. Hassler,
;   2022 ('eWoz-Lite', took out Intel load, moved input buffer for more
;   contiguous PAL-1 memory; can start ML programs at $0200 this way).
; 6502 Disassembler by Steve Wozniak and Allen Baum, 1976 (JBM's PAL-1
;   print routine added by DHH).
; SEARCH by Jeff Tranter. This version derived from his JMON source.
; MOVIT v2 by Lew Edwards, 1977 ("First Book of KIM" - a little press-a-key
;   routine added by DHH. Because this is a "destructive" program, it gives
;   the user a chance to quit before it writes to memory).
; LIL' FILL by DHH (adapted from source at 6502.org, and has the same
;   press-a-key routine as above).
; LIL' MEM DUMP by DHH (has ASCII, as Woz Mon doesn't).
; LIL' REGISTER by DHH (BRK interrupt vector at $17FE can point to this).
; 
; This menu/picker by Dave Hassler, 2022.
;

.ORG = $0B00

START	CLD
	STA $24
	STX $25		; STORE X, IN CASE 'R' IS CALLED
	STY $26		; STORE A & Y, TOO.
	LDX #$00
PRNT1	LDA TITLE,X
	BEQ GETCMD	; OUT TO TEST KEY
	
	JSR $1EA0	; CALL OUTCH
	INX
	JMP PRNT1

GETCMD	JSR $1E5A	; GET A KEYSTROKE
	CMP #$43	; IS IT C?
	BEQ JMPTBL	; YES, GO TO COPY PROGRAM
	CMP #$44	; IS IT D?
	BEQ JMPTBL+3	; YES, GO TO DISASM PROGRAM
	CMP #$45	; IS IT E?
	BEQ JMPTBL+6	; YES, GO TO eWOZ
	CMP #$46	; IS IT F?
	BEQ JMPTBL+9	; YES, GO TO FILL PROGRAM
	CMP #$4D	; IS IT M?
	BEQ JMPTBL+12	; YES, GO TO MEM DUMP PROGRAM
	CMP #$58	; IS IT X?
	BEQ JMPTBL+15	; YES, GO TO KIM MONITOR
	CMP #$53	; IS IT S?
	BEQ JMPTBL+18	; YES, GO TO SEARCH PROGRAM
	CMP #$52	; IS IT R?
	BEQ RESTOR	; YES, GO TO REGISTER PROGRAM
	JSR $1E2F	; AIN'T NONE O' THAT STUFF?
	LDA #$2D	; PRINT CRLF THEN '->' ...
	JSR $1EA0
	LDA #$3E
	JSR $1EA0
	JMP GETCMD	; ... AND TRY AGAIN


	

JMPTBL	
	JMP $0F10	; 0 START OF MOVIT v2
	JMP $1010	; 3 START OF DISASM
	JMP $1220	; 6 START OF eWOZ MON Lite
	JMP $0E50	; 9 START OF FILL
	JMP $0D60	; 12 START OF MEMORY DUMP
	JMP $1C4F	; 15 TO KIM MONITOR
	JMP $0BFC	; 18 START OF SEARCH

	

RESTOR	LDY $26		; RESTORE Y,X,A          
	LDX $25		; IN CASE 'R' IS CALLED
	LDA $24
	JMP $0CFD	; START OF REGISTER PRINT


TITLE
.BYTE	$0A $0D
.BYTE	" LIL BUG - 6502 Tools"
.BYTE	$0A $0D
.BYTE	"[C]opy Mem.  [D]isasmb  [E]WozLite  [F]ill Mem."
.BYTE	$0A $0D
.BYTE	"[M]em. Dump  [R]egister Print  [S]earch  e[X]it"
.BYTE	$0A $0D
.BYTE   "(Disasm start: $44/45)"
.BYTE	$0A $0D
.BYTE	"->"
.BYTE	$00