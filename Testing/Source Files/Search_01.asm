; SEARCH
; from JMON 1.3.7
; by Jeff Tranter (c) 2012-21,
; which is licensed under the Apache License, Version 2.0.
;
; This derivative work for LIL' BUG by Dave Hassler, 2022 (MIT License)
;
; I stripped this module down to the barest bones, preserving Jeff's excellent
; matching code and label/variable nomenclature while changing the addresses and
; length of the search 'string', which is now hex bytes only (no ASCII).  As is,
; it stands alone without any of the supporting routines in JMON, and takes up
; just under 256 bytes of memory.  My comments and labels are in UPPER CASE.
;
; It also must be "set up" prior to a run, much like everything else in LIL' BUG.
; This kept the size of the module waaay down. No niceties = tiny size -- the 
; responsibility is all on you, bub! :^)
;
; Search 'strings' of up to 11 bytes may be used, and that gives about four
; contiguous instructions to look for, which should be useful.  If one needs
; longer search strings, maybe commandeeer the bottom of the stack for the IN buffer,
; say from $0100-$0140?
;
; Like most of LIL' BUG's modules, it's *very* easy to break this, and it won't
; take much imagination to suss that out.  :^)  Mainly, I hope it's useful,
; especially for other 'unexpanded' 5K PAL-1 and microKIM users.  Hack away!



*=$0BFC

; Search Memory

  T1      = $CE                 ; Temp variable 1 (2 bytes)
  SL      = $D0                 ; Start address low byte
  SH      = $D1                 ; Start address high byte
  EL      = $D2                 ; End address low byte
  EH      = $D3                 ; End address high byte
  IN	  = $D4			; Start of buffer -> $DF

; Set parameters beforehand: 	start addr $D0/D1, end $D2/D3
; 				# of bytes $D4, search bytes $D5 -> $DF
;

	CLD			; BECAUSE, WHY NOT?
	LDX #$00		; PRINT HEADER
PRNT1	LDA TITLE,X
	BEQ STARTS		; OUT TO startS
	JSR $1EA0		; CALL OUTCH
	INX
	JMP PRNT1


StartS:
        LDX #0                  ; Index into fill pattern
search:
        LDY #0
        LDA IN+1,X              ; Get byte of pattern data
        CMP (SL),Y              ; compare with memory data
        BNE NoMtch
        INX
        CPX IN                  ; End of pattern reached?
        BEQ Match               ; If so, found match
        BNE PartMa
NoMTCH:
        STX T1                  ; Subtract X from SL,SH
        SEC
        LDA SL
        SBC T1
        STA SL
        LDA SH
        SBC #0
        STA SH
Cont:
        LDX #0                  ; Reset search to end of pattern
PartMa:
        LDA SH                  ; reached end yet?
        CMP EH
        BNE NoDone
        LDA SL
        CMP EL
        BNE NoDone
        JMP NOTFND

NoDone:
        LDA SL                  ; increment address
        CLC
        ADC #1
        STA SL
        BCC NoCary
        INC SH
NoCary:
        JMP search

Match:
        DEC IN                  ; Calculate start address as SL,SH minus (IN - 1)
        LDA SL
        SEC
        SBC IN
        STA SL
        LDA SH
        SBC #0                  ; Includes possible carry
        STA SH
        INC IN
        JSR FOUND

;        LDX SL
;        LDY SH
;        JSR PrintAddress
;        JSR PrintCR
;        JSR PromptToContinue
         JMP Cont
;        RTS             	; done

FOUND	JSR $1E2F		; PRINT CRLF
	LDA SH			; LOAD HIGH ADDR
	JSR $1E3B		; CALL PRTBYT
	LDA SL			; LOAD LOW ADDR
	JSR $1E3B
	RTS

NOTFND	JSR $1E2F		; PRINT CRLF
	LDA #$44		; PRINT A 'D"
	JSR $1EA0
	JMP $0B00		; BACK TO MENU


TITLE
.BYTE	$0A $0D
.BYTE	"LIL' SEARCH - Prints 'found at' addresses (D=done)"
.BYTE	$0A $0D
.BYTE	"Start/End addr: $D0/D1, $D2/D3"
.BYTE	$0A $0D
.BYTE	"# bytes (<0C): $D4. Search bytes: $D5-DF"
.BYTE	$0A $0D $00



