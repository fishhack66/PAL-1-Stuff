- Fully Commented Commodore 64 KERNAL ROM Disassembly (English, "CBM")
-
- The comments have been taken from
-    The original C64 KERNAL source by Commodore (901227-03)
-    https://github.com/mist64/cbmsrc
-    https://www.pagetable.com/?p=894
-
- The comments here are basically a complete copy of the original
- source code, lined up with the version in the C64 ROM.
- This way, even all variable names are intact.
-
- Converted and formatted by Michael Steil <mist64@mac.com>
-
- Corrections (formatting, lining up) welcome at:
- https://github.com/mist64/c64disasm
-
------------------------------------------------------------
-
# This plain text file is formatted so that it can be automatically
# parsed in order to create cross-references etc.
# * Lines starting with "-" is top-level information. The first line
#   is the title. Lines starting with "--" are separators.
# * Lines starting with "#" are internal comments.
# * Lines starting with ".," indicate code to be disassembled.
# * Lines starting with ".:" indicate bytes to be dumped.
# * Comments start at the 33rd column.
# * 32 leading spaces and ".LIB" indicate a heading.
# * Otherwise, 32 leading spaces indicate an overflow comment.
# The encoding is UTF-8.
;
; This code is a subset of the original c64 kernal code.
; It has been modified to implement the load and save IEC routines
; to be run on a KIM-1 single board computer.
; The code assumes a ROM expansion on the KIM-1 at $2000.
;
; Modified June, 2022 by Dave McMurtrie <dave@commodore.international>

                                .LIB   DISCLAIMER
                                ;****************************************
                                ;*                                      *
                                ;* KK  K EEEEE RRRR  NN  N  AAA  LL     *
                                ;* KK KK EE    RR  R NNN N AA  A LL     *
                                ;* KKK   EE    RR  R NNN N AA  A LL     *
                                ;* KKK   EEEE  RRRR  NNNNN AAAAA LL     *
                                ;* KK K  EE    RR  R NN NN AA  A LL     *
                                ;* KK KK EE    RR  R NN NN AA  A LL     *
                                ;* KK KK EEEEE RR  R NN NN AA  A LLLLL  *
                                ;*                                      *
                                ;***************************************
                                ;
                                ;***************************************
                                ;* PET KERNAL                          *
                                ;*   MEMORY AND I/O DEPENDENT ROUTINES *
                                ;* DRIVING THE HARDWARE OF THE         *
                                ;* FOLLOWING CBM MODELS:               *
                                ;*   COMMODORE 64 OR MODIFED VIC-40    *
                                ;* COPYRIGHT (C) 1982 BY               *
                                ;* COMMODORE BUSINESS MACHINES (CBM)   *
                                ;***************************************
                                ;****LISTING DATE --1200 14 MAY 1982****
                                ;***************************************
                                ;* THIS SOFTWARE IS FURNISHED FOR USE  *
                                ;* USE IN THE VIC OR COMMODORE COMPUTER*
                                ;* SERIES ONLY.                        *
                                ;*                                     *
                                ;* COPIES THEREOF MAY NOT BE PROVIDED  *
                                ;* OR MADE AVAILABLE FOR USE ON ANY    *
                                ;* OTHER SYSTEM.                       *
                                ;*                                     *
                                ;* THE INFORMATION IN THIS DOCUMENT IS *
                                ;* SUBJECT TO CHANGE WITHOUT NOTICE.   *
                                ;*                                     *
                                ;* NO RESPONSIBILITY IS ASSUMED FOR    *
                                ;* RELIABILITY OF THIS SOFTWARE. RSR   *
                                ;*                                     *
                                ;***************************************
                                .END
STATUS = $90            ;I/O OPERATION STATUS BYTE
C3P0   = $94            ;IEEE BUFFERED CHAR FLAG
BSOUR  = $95            ;CHAR BUFFER FOR IEEE
R2D2   = $A3            ;SERIAL BUS USAGE
BSOUR1 = $A4            ;TEMP USED BY SERIAL ROUTINE
COUNT  = $A5            ;TEMP USED BY SERIAL ROUTINE
FNLEN  = $B7            ;FILENAME LENGTH
FNADR  = $BB            ;FILENAME ADDRESS
FA     = $BA            ;FILE PRIMARY ADDRESS
SA     = $B9            ;FILE SECONDARY ADDRESS
STAL   = $AA                ;SAVE END ADDR LOW BYTE FOR SAVE ROUTINE
STAH   = $AB            ;SAVE END ADDR HIGH BYTE FOR SAVE ROUTINE
SAL    = $AC            ;START ADDR LOW BYTE FOR SAVE ROUTINE
SAH    = $AD            ;START ADDR HIGH BYTE FOR SAVE ROUTINE
EAL    = $AE            ;END ADDRESS LOW BYTE
EAH    = $AF            ;END ADDRESS HIGH BYTE
MEMUSS = $C3            ;USER SPECIFIED FILE LOAD ADDRESS
VERCK  = $0A            ;LOAD OR VERIFY FLAG
SPERR  = 16
FNAME  = $27            ;FILENAME
MYSTATUS = $30
        ;LOCATIONS USED BY THE NATIVE KIM-1 TAPE LOAD AND SAVE ROUTINES.
        ;I'LL USE THESE FOR DISK LOAD AND SAVE FOR CONSISTENCY OF USER
        ;EXPERIENCE.
ID     = $17F9          ;KIM-1 TAPE ID. USE AS FILENAME
TSAL   = $17F5          ;KIM-1 START ADDRESS LOW BYTE FOR TAPE ROUTINES
TSAH   = $17F6          ;KIM-1 START ADDRESS HIGH BYTE FOR TAPE ROUTINES
TEAL   = $17F7          ;KIM-1 END ADDRESS LOW FOR TAPE SAVE
TEAH   = $17F8          ;KIM-1 END ADDRESS HIGH FOR TAPE SAVE

        ; THE C64 KERNAL USED DC00 AND DD00 6526 ADDRESSES FOR THESE.
        ; CONVERTED TO USE 6530 LOCATIONS FOR TIMER AND IO TO RUN ON
        ; A KIM-1.
PAD    = $1700          ;PERIPHERAL DATA REGISTER A ON KIM-1
PADD   = $1701          ;PERIPHERAL DATA DIR REGISTER A ON KIM-1
D2PRA  = $1700          ;PERIPHERAL DATA REGISTER A ON C64
D2DDRA = $1701          ;PERIPHERAL DATA DIR REGISTER A ON C64
D1T2H  = $1704          ;1T INTERVAL TIMER ON THE 6530
D64TH  = $1706          ;64T INTERVAL TIMER ON THE 6530
D1ICR  = $1707          ;6530 INTERVAL TIMER STATUS REGISTER

* = $2000   ; TO BE LOADED INTO AN EPROM AND MAPPED IN AT $2000
LDINIT  CLD        
        SEI 
        LDA #%00000111
        STA PAD
        LDA #%00111111 
        STA PADD
        ;
        LDA #02        ;LENGTH OF OUR FILENAME IS 2 BYTES
        STA FNLEN
        LDA #01        ;SETTING THE SECONDARY ADDR TO 1 CAUSES IT TO USE THE
        STA SA         ;FIRST TWO BYTES OF THE FILE AS THE SAVE ADDRESS. 
        LDA #08        ;THIS IS THE DEVICE NUMBER. HARD CODING 8 FOR NOW.
        STA FA
        LDA #$27
        STA FNADR
        LDA #$00
        STA FNADR+1 
        STA EAL
        STA EAH
        STA STATUS
        STA MYSTATUS
        STA VERCK
        ;COPY KIM-1 NATIVE TAPE ROUTINE VALUES TO THE C64 KERNAL LOCATIONS
        LDA TSAL
        STA SAL
        LDA TSAH
        STA SAH

        ;********************************
        ;* C64 KERNAL IEEE LOAD ROUTINE *
        ;********************************
        ;LOAD FROM CBM IEEE DEVICE
        ;
        JSR CONVID
        LDY FNLEN       ;MUST HAVE FILE NAME
        BNE LD25        ;YES...OK
        ;
        JMP ERROR8      ;MISSING FILE NAME
        ;
LD25    LDX SA          ;SAVE SA IN .X
        JSR LUKING      ;TELL USER LOOKING
        LDA #$60        ;SPECIAL LOAD COMMAND
        STA SA
        JSR OPENI       ;OPEN THE FILE
        ;
        LDA FA
        JSR TALK        ;ESTABLISH THE CHANNEL
        LDA SA
        JSR TKSA        ;TELL IT TO LOAD
        ;
        JSR ACPTR       ;GET FIRST BYTE
        STA EAL
        ;
        LDA STATUS      ;TEST STATUS FOR ERROR
        LSR A
        LSR A
        BCS LD90        ;FILE NOT FOUND...
        JSR ACPTR
        STA EAH
        ;
        TXA             ;FIND OUT OLD SA
        BNE LD30        ;SA<>0 USE DISK ADDRESS
        LDA MEMUSS      ;ELSE LOAD WHERE USER WANTS
        STA EAL
        LDA MEMUSS+1
        STA EAH
LD30    JSR LODING      ;TELL USER LOADING
        ;
LD40    LDA #$FD        ;MASK OFF TIMEOUT
        AND STATUS
        STA STATUS
        ;
        ;JSR STOP        ;STOP KEY?
        ;BNE LD45        ;NO...
        ;
        ;JMP BREAK       ;STOP KEY PRESSED
        ;
LD45    JSR ACPTR       ;GET BYTE OFF IEEE
        TAX
        LDA STATUS      ;WAS THERE A TIMEOUT?
        LSR A
        LSR A
        BCS LD40        ;YES...TRY AGAIN
        TXA
        LDY VERCK       ;PERFORMING VERIFY?
        BEQ LD50        ;NO...LOAD
        LDY #0
        CMP (EAL),Y     ;VERIFY IT
        BEQ LD60        ;O.K....
        LDA #SPERR      ;NO GOOD...VERIFY ERROR
        JSR UDST        ;UPDATE STATUS
        .BYTE $2C       ;SKIP NEXT STORE
        ;
LD50    STA (EAL),Y
LD60    INC EAL         ;INCREMENT STORE ADDR
        BNE LD64
        INC EAH
LD64    BIT STATUS      ;EOI?
        BVC LD40        ;NO...CONTINUE LOAD
        ;
        JSR UNTLK       ;CLOSE CHANNEL
        JSR CLSEI       ;CLOSE THE FILE
        BCC LD180       ;BRANCH ALWAYS
        ;
LD90    JMP ERROR4      ;FILE NOT FOUND
        ;
OPENI   LDA SA
        BMI OP175       ;NO SA...DONE
       
        LDY FNLEN
        BEQ OP175       ;NO FILE NAME...DONE
        ;
        LDA #0          ;CLEAR THE SERIAL STATUS
        STA STATUS
        ;
        LDA FA
        JSR LISTN       ;DEVICE LA TO LISTEN
        ;
        LDA SA
        ORA #$F0
        JSR SECND
        ;
        LDA STATUS      ;ANYBODY HOME?
        BPL OP35        ;YES...CONTINUE
        ;
        ;THIS ROUTINE IS CALLED BY OTHER
        ;KERNAL ROUTINES WHICH ARE CALLED
        ;DIRECTLY BY OS.  KILL RETURN
        ;ADDRESS TO RETURN TO OS.
        ;
        PLA
        PLA
        JMP ERROR5      ;DEVICE NOT PRESENT
        ;
OP35    LDA FNLEN
        BEQ OP45        ;NO NAME...DONE SEQUENCE
        ;
        ;SEND FILE NAME OVER SERIAL
        ;
        LDY #0
OP40    LDA (FNADR),Y
        JSR CIOUT
        INY
        CPY FNLEN
        BNE OP40
        ;
OP45    JMP CUNLSN      ;JSR UNLSN: CLC: RTS
        ;MODIFIED CUNLSN TO BRK INSTEAD OF RTS
        ;
        ;***************************
        ;*HOMEBREW SUPPORT NONSENSE*
        ;***************************
LUKING  PHA        
        LDA #$01
        STA MYSTATUS
        PLA
        RTS
        ;
ERROR4  LDA #$04
        STA MYSTATUS
        BRK
        ;
ERROR5  LDA #$05
        STA MYSTATUS
        BRK
        ;
ERROR8  LDA #$08
        STA MYSTATUS
        BRK
        ;
LODING  PHA
        LDA #$02
        STA MYSTATUS
        PLA
        RTS
        ;
SAVING  PHA
        LDA #$03 
        STA MYSTATUS
        PLA
        RTS
        ;
UDST    ORA STATUS
        STA STATUS
        RTS
        ;
CLSEI   BIT SA
        BMI CLSEI2
        LDA FA
        JSR LISTN
        LDA SA
        AND #$EF
        ORA #$E0
        JSR SECND
        ;
CUNLSN  JSR UNLSN       ;ENTRY FOR OPENI
        ;
CLSEI2  CLC
        RTS
        ;
LD180   CLC             ;GOOD EXIT
        ;
        ; SET UP END LOAD ADDRESS
        ;
        LDX EAL
        LDY EAH
        ;
OP175   CLC             ;FLAG GOOD OPEN
        ;OP180   RTS             ;EXIT IN PEACE
OP180   BRK
        ;
        ;CONVERT TAPE ID TO ASCII AND STORE IN FNAME
        ;
CONVID  PHA
        LDA ID
        LSR A
        LSR A
        LSR A
        LSR A 
        JSR ASCONV
        STA FNAME
        LDA ID
        JSR ASCONV
        STA FNAME+1
        PLA
        RTS
        ;
        ;CONVERT LSD OF A TO ASCII
        ;
ASCONV  AND #$0F
        CMP #$0A      
        CLC   
        BMI HEX1
        ADC #$07
HEX1    ADC #$30
        RTS
        ;
        ;****************
        ;* SAVE ROUTINE *
        ;****************
SVINIT  CLD  
        SEI
        LDA #%00000111
        STA PAD
        LDA #%00111111
        STA PADD

        LDA #02   ;LENGTH OF OUR FILENAME IS 2 BYTES
        STA FNLEN 
        LDA #01   ;SETTING THE SECONDARY ADDR (SA) TO 1 CAUSES IT TO USE THE
        STA SA    ;FIRST TWO BYTES OF THE FILE AS THE SAVE ADDRESS.
        LDA #08   ;THIS IS THE DEVICE NUMBER. HARD CODING 8 FOR NOW.
        STA FA
        LDA #$27
        STA FNADR
        LDA #$00
        STA FNADR+1
        STA EAL
        STA EAH
        STA STATUS
        STA MYSTATUS
        STA VERCK
        JSR CONVID

SAVESP  LDX TEAL 
        LDY TEAH
        STX EAL
        STY EAH
        LDA TSAL
        STA STAL
        STA SAL
        LDA TSAH
        STA STAH
        STA SAH
        ;
SAVE 
        LDA #$61
        STA SA
        LDY FNLEN
        BNE SV25
        ;
        JMP ERROR8          ;MISSING FILE NAME
        ;
SV25    JSR OPENI
        JSR SAVING
        LDA FA
        JSR LISTN
        LDA SA
        JSR SECND
        LDY #0
        JSR RD300
        LDA SAL
        JSR CIOUT
        LDA SAH
        JSR CIOUT
SV30    JSR CMPSTE      ;COMPARE START TO END
        BCS SV50        ;HAVE REACHED END
        LDA (SAL),Y
        JSR CIOUT
        ;JSR STOP
        ;BNE SV40
        ;
        ;BREAK   JSR CLSEI
        ;        LDA    #0
        ;        SEC
        ;        RTS
        ;
SV40    JSR INCSAL      ;INCREMENT CURRENT ADDR.
        BNE SV30
SV50    JSR UNLSN
        JSR CLSEI
        ;
        JMP CUNLSN
        ;
RD300   LDA STAH        ; RESTORE STARTING ADDRESS...
        STA SAH         ;...POINTERS (SAH & SAL)
        LDA STAL
        STA SAL
        RTS
        ;COMPARE START AND END LOAD/SAVE
        ;ADDRESSES.  SUBROUTINE CALLED BY
        ;TAPE READ, SAVE, TAPE WRITE
        ;
CMPSTE  SEC
        LDA SAL
        SBC EAL
        LDA SAH
        SBC EAH
        RTS
        ;
INCSAL  INC SAL
        BNE INCR
        INC SAH
INCR    RTS
        ;
        ;******************
        ;* SERIAL LIBRARY *
        ;******************
        ;
        ;COMMAND SERIAL BUS DEVICE TO TALK
        ;
TALK    ORA #$40        ;MAKE A TALK ADR
        .BYTE $2C       ;SKIP TWO BYTES
        ;
        ;COMMAND SERIAL BUS DEVICE TO LISTEN
        ;
LISTN   ORA #$20         ;MAKE A LISTEN ADR
        ; XXX THE CALL TO RSP232 IS NOT NECESSARY ON THE KIM-1
        ;JSR RSP232     ;PROTECT SELF FROM RS232 NMI'S
LIST1   PHA
        ;
        BIT C3P0        ;CHARACTER LEFT IN BUF?
        BPL LIST2       ;NO...
        ;
        ;SEND BUFFERED CHARACTER
        ;
        SEC             ;SET EOI FLAG
        ROR R2D2
        ;
        JSR ISOUR       ;SEND LAST CHARACTER
        ;
        LSR C3P0        ;BUFFER CLEAR FLAG
        LSR R2D2        ;CLEAR EOI FLAG
        ;
LIST2   PLA             ;TALK/LISTEN ADDRESS
        STA BSOUR
        ;SEI
        JSR DATAHI
        CMP #$3F        ;CLKHI ONLY ON UNLISTEN
        BNE LIST5
        JSR CLKHI
        ;
LIST5   LDA D2PRA       ;ASSERT ATTENTION
        ORA #$08
        STA D2PRA
        ;
        ;ISOURA SEI
ISOURA  NOP
        JSR CLKLO       ;SET CLOCK LINE LOW
        JSR DATAHI
        JSR W1MS        ;DELAY 1 MS
        ;ISOUR SEI      ;NO IRQ'S ALLOWED
ISOUR   NOP
        JSR DATAHI      ;MAKE SURE DATA IS RELEASED
        JSR DEBPIA      ;DATA SHOULD BE LOW
        BCS NODEV
        JSR CLKHI       ;CLOCK LINE HIGH
        BIT R2D2        ;EOI FLAG TEST
        BPL NOEOI
        ;DO THE EOI
ISR02   JSR DEBPIA      ;WAIT FOR DATA TO GO HIGH
        BCC ISR02
        ;
ISR03   JSR DEBPIA      ;WAIT FOR DATA TO GO LOW
        BCS ISR03
        ;
NOEOI   JSR DEBPIA      ;WAIT FOR DATA HIGH
        BCC NOEOI
        JSR CLKLO       ;SET CLOCK LOW
        ;
        ;SET TO SEND DATA
        ;
        LDA #$08        ;COUNT 8 BITS
        STA COUNT
        ;
ISR01
        LDA D2PRA       ;DEBOUNCE THE BUS
        CMP D2PRA
        BNE ISR01
        ASL A           ;SET THE FLAGS
        BCC FRMERR      ;DATA MUST BE HI
        ;
        ROR BSOUR       ;NEXT BIT INTO CARRY
        BCS ISRHI
        JSR DATALO
        BNE ISRCLK
ISRHI   JSR DATAHI
ISRCLK  JSR CLKHI       ;CLOCK HI
        NOP
        NOP
        NOP
        NOP
        LDA D2PRA
        AND #$FF-$20    ;DATA HIGH
        ORA #$10        ;CLOCK LOW
        STA D2PRA
        DEC COUNT
        BNE ISR01
        LDA #$04        ;SET TIMER FOR 1MS
        STA D1T2H
        ;LDA #TIMRB     ;TRIGGER TIMER ; XXX NOT NEEDED ON KIM-1
        ;STA D1CRB
        ;LDA D1ICR      ;CLEAR THE TIMER FLAGS<<<<<<<<<<<<<
ISR04   LDA D1ICR
        AND #$02
        BNE FRMERR
        JSR DEBPIA
        BCS ISR04
        ;CLI            ;LET IRQ'S CONTINUE
        RTS
        ;
NODEV                   ;DEVICE NOT PRESENT ERROR
        LDA #$80
        .BYTE $2C
FRMERR                  ;FRAMING ERROR
        LDA #$03
CSBERR  JSR UDST        ;COMMODORE SERIAL BUSS ERROR ENTRY
        ;CLI            ;IRQ'S WERE OFF...TURN ON
        CLC             ;MAKE SURE NO KERNAL ERR

        BCC DLABYE      ;TURN ATN OFF ,RELEASE ALL LINES
        ;
        ;SEND SECONDARY ADDRESS AFTER LISTEN
        ;
SECND   STA BSOUR        ;BUFFER CHARACTER
        JSR ISOURA       ;SEND IT
        ;RELEASE ATTENTION AFTER LISTEN
        ;
SCATN   LDA D2PRA
        AND #$FF-$08
        STA D2PRA       ;RELEASE ATTENTION
        RTS
        ;TALK SECOND ADDRESS
        ;
TKSA    STA BSOUR       ;BUFFER CHARACTER
        JSR ISOURA      ;SEND SECOND ADDR
TKATN                   ;SHIFT OVER TO LISTENER
        ;SEI            ;NO IRQ'S HERE
        JSR DATALO      ;DATA LINE LOW
        JSR SCATN
        JSR CLKHI       ;CLOCK LINE HIGH JSR/RTS
TKATN1  JSR DEBPIA      ;WAIT FOR CLOCK TO GO LOW
        BMI TKATN1
        ;CLI            ;IRQ'S OKAY NOW
        RTS
        ;BUFFERED OUTPUT TO SERIAL BUS
        ;
CIOUT  BIT C3P0         ;BUFFERED CHAR?
        BMI CI2         ;YES...SEND LAST
        ;
        SEC             ;NO...
        ROR C3P0        ;SET BUFFERED CHAR FLAG
        BNE CI4         ;BRANCH ALWAYS
        ;
CI2    PHA              ;SAVE CURRENT CHAR
        JSR ISOUR       ;SEND LAST CHAR
        PLA             ;RESTORE CURRENT CHAR
CI4    STA BSOUR        ;BUFFER CURRENT CHAR
        CLC             ;CARRY-GOOD EXIT
        RTS
        ;SEND UNTALK COMMAND ON SERIAL BUS
        ;
        ;UNTLK  SEI 
UNTLK   NOP
        JSR CLKLO
        LDA D2PRA       ;PULL ATN
        ORA #$08
        STA D2PRA
        LDA #$5F        ;UNTALK COMMAND
        .BYTE $2C       ;SKIP TWO BYTES
        ;SEND UNLISTEN COMMAND ON SERIAL BUS
        ;
UNLSN  LDA #$3F         ;UNLISTEN COMMAND
        JSR LIST1       ;SEND IT
        ;
        ; RELEASE ALL LINES
DLABYE JSR SCATN        ;ALWAYS RELEASE ATN
        ; DELAY THEN RELEASE CLOCK AND DATA
        ;
DLADLH  TXA             ;DELAY APPROX 60 US
        LDX #10
DLAD00  DEX
        BNE DLAD00
        TAX
        JSR CLKHI
        JMP DATAHI
        ;INPUT A BYTE FROM SERIAL BUS
        ;
ACPTR
        SEI             ;NO IRQ ALLOWED
        LDA #$00        ;SET EOI/ERROR FLAG
        STA COUNT
        JSR CLKHI       ;MAKE SURE CLOCK LINE IS RELEASED
ACP00A  JSR DEBPIA      ;WAIT FOR CLOCK HIGH
        BPL ACP00A
        ;
EOIACP
        LDA #$04        ;SET TIMER 2 FOR 256US
        STA D64TH
        ;LDA #TIMRB     ; XXX NOT NEEDED ON KIM-1
        ;STA D1CRB
        JSR DATAHI      ;DATA LINE HIGH (MAKES TIMMING MORE LIKE VIC-20
        ;LDA D1ICR      ;CLEAR THE TIMER FLAGS<<<<<<<<<<<<
ACP00   BIT D1ICR
        BMI ACP00B      ;RAN OUT.....
        JSR DEBPIA      ;CHECK THE CLOCK LINE
        BMI ACP00       ;NO NOT YET
        BPL ACP01       ;YES.....
        ;
ACP00B  LDA COUNT       ;CHECK FOR ERROR (TWICE THRU TIMEOUTS)
        BEQ ACP00C
        LDA #2
        JMP CSBERR      ;ST = 2 READ TIMEOUT
        ;
        ; TIMER RAN OUT DO AN EOI THING
        ;
ACP00C  JSR DATALO      ;DATA LINE LOW
        JSR CLKHI       ;DELAY AND THEN SET DATAHI (FIX FOR 40US C64)
        LDA #$40
        JSR UDST        ;OR AN EOI BIT INTO STATUS
        INC COUNT       ;GO AROUND AGAIN FOR ERROR CHECK ON EOI
        BNE EOIACP
        ;
        ; DO THE BYTE TRANSFER
        ;
ACP01   LDA #08         ;SET UP COUNTER
        STA COUNT
        ;
ACP03   LDA D2PRA       ;WAIT FOR CLOCK HIGH
        CMP D2PRA       ;DEBOUNCE
        BNE ACP03
        ASL A           ;SHIFT DATA INTO CARRY
        BPL ACP03       ;CLOCK STILL LOW...
        ROR BSOUR1      ;ROTATE DATA IN
        ;
ACP03A  LDA D2PRA       ;WAIT FOR CLOCK LOW
        CMP D2PRA       ;DEBOUNCE
        BNE ACP03A
        ASL A
        BMI ACP03A
        DEC COUNT
        BNE ACP03       ;MORE BITS.....
        ;...EXIT...
        JSR DATALO      ;DATA LOW
        BIT STATUS      ;CHECK FOR EOI
        BVC ACP04       ;NONE...
        ;
        JSR DLADLH      ;DELAY THEN SET DATA HIGH
        ;
ACP04   LDA BSOUR1
        ;CLI            ;IRQ IS OK
        CLC             ;GOOD EXIT
        RTS
        ;
CLKHI                   ;SET CLOCK LINE HIGH (INVERTED)
        LDA D2PRA
        AND #$FF-$10
        STA D2PRA
        RTS
        ;
CLKLO                   ;SET CLOCK LINE LOW  (INVERTED)
        LDA D2PRA
        ORA #$10
        STA D2PRA
        RTS
        ;
DATAHI                  ;SET DATA LINE HIGH (INVERTED)
        LDA D2PRA
        AND #$FF-$20
        STA D2PRA
        RTS
        ;
DATALO                  ;SET DATA LINE LOW  (INVERTED)
        LDA D2PRA
        ORA #$20
        STA D2PRA
        RTS
        ;
DEBPIA  LDA D2PRA       ;DEBOUNCE THE PIA
        CMP D2PRA
        BNE DEBPIA
        ASL A           ;SHIFT THE DATA BIT INTO THE CARRY...
        RTS             ;...AND THE CLOCK INTO NEG FLAG
        ;
W1MS                    ;DELAY 1MS USING LOOP
        TXA             ;SAVE .X
        LDX #200-16     ;1000US-(1000/500*8=#40US HOLDS)
W1MS1   DEX             ;5US LOOP
        BNE W1MS1
        TAX             ;RESTORE .X
        RTS
