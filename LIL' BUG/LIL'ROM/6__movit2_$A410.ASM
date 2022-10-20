; MOVIT by Lew Edwards. First Book of KIM, pg. 127
;
; tiny little niceties, Dave Hassler
;
;   I moved the origin - Lew said we could! :^) - so that this sits
; nicely inside my LIL' BUG set/wrapper.  
;   I also added a little press-a-key routine, because this is a 
; "destructive" program; if the right values are not set beforehand, one
; could unintentionally write over needed data that was not yet saved.
;   Last, I added a little "OK" message, to let the user know that things
; went through.  I also added Lew's suggestion (in FBOK) to have the program
; break back to the KIM monitor at the last address written.


        OSAL    = $D0
        OSAH    = $D1
        OEAL    = $D2
        OEAH    = $D3
        NSAL    = $D4
        NSAH    = $D5
        NEAL    = $D6
        NEAH    = $D7
        BCL     = $D8
        BCH     = $D9

        .ORG    $A410

	LDX #$00
PRNT1	LDA TITLE,X
	BEQ ISITG	; OUT TO TEST GOT 'GO'
	JSR $1EA0	; CALL OUTCH
	INX
	JMP PRNT1

ISITG	JSR $1E5A	; GET A KEYSTROKE
	CMP #$47	; IS IT G?
	BEQ START	; YES, START
	JMP $A000	; NO, TO MENU (SO USER CAN ENTER VALUES)



START:  CLD
        LDY     #$FF            ; STORE TEST VALUE
        SEC
        LDA     OEAL            ; HOW MANY BYTES?
        SBC     OSAL            ; TO MOVE?
        STA     BCL
        LDA     OEAH
        SBC     OSAH
        STA     BCH
        CLC
        LDA     BCL             ; ADD THE COUNT TO
        ADC     NSAL            ; THE NEW START TO
        STA     NEAL            ; GET A NEW END
	STA	$FA
        LDA     BCH
        ADC     NSAH
        STA     NEAH
	STA	$FB
        INC     BCL             ; ADJUST THE BYTE COUNT
        INC     BCH             ; TO PERMIT ZERO TESTING
        SEC
        LDA     NSAL            ; IF NEW LOCATION
        SBC     OSAL            ; HIGHER THAN OLD
        LDA     NSAH            ; CARRY FLAG IS SET
        SBC     OSAH
LOOP:   LDX     #$00            ; HIGH POINTER INDEX
        BCC     MOVE
        LDX     #$02            ; LOW POINTER INDEX
MOVE:   LDA     (OSAL,X)        ; MOVE OLD. NOTE ERROR IN PRINTED LISTING
        STA     (NSAL,X)        ; TO NEW. NOTE ERROR IN PRINTED LISTING
        BCC     DOWN
        DEC     OEAL            ; ADJUST UP POINTER, (OLD)
        TYA                     ; BELOW ZERO?
        EOR     OEAL
        BNE     NOT             ; NO, ENOUGH
        DEC     OEAH            ; YES, ADJUST THE HIGH BYTE
NOT:    DEC     NEAL            ; ADJUST THE OTHER ONE (NEW)
        TYA
        EOR     NEAL            ; NEED HIGH BYTE ADJUSTED?
        BNE     NEIN            ; NO
        DEC     NEAH            ; YES, DO IT
NEIN:   BCS     COUNT
DOWN:   INC     OSAL            ; ADJUST "OLD" DOWN POINTER
        BNE     NYET
        INC     OSAH            ; AND THE HIGH BYTE IF NEEDED
NYET:   INC     NSAL            ; AND THE "NEW" ONE
        BNE     COUNT
        INC     NSAH
COUNT:  DEC     BCL             ; TICK OFF THE BYTES,
        BNE     ONE             ; ENOUGH FINGERS?
        DEC     BCH             ; USE THE OTHER HAND
ONE:    BNE     LOOP            ; 'TIL THEY'RE ALL DONE
DONE:   JSR $1E2F
	LDA #$6F		; PRINT 'OK'
	JSR $1EA0
	LDA #$6B
	JSR $1EA0
	JMP $0B00               ; & BACK TO MENU





TITLE
.BYTE $0A $0D
.BYTE "MOVIT-Lew Edwards"
.BYTE $0A $0D
.BYTE "Orig start: low $D0, high $D1. Orig end: $D2, $D3"
.BYTE $0A $0D
.BYTE "New start: $D4, $D5. 'G' starts, other Menu"
.BYTE $0A $0D $00

