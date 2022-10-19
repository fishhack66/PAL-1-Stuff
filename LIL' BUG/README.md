A collection of small programs appropriate for debugging code on an 'unexpanded' 5 KB PAL-1 or microKIM computer.

Includes: eWozLite, 6502 Disassembler, Search, Copy, Fill, Memory Dump (with ASCII), and Register Printer, plus a menu/picker
(see documentation for full details on use).  The .WAV file is a Hypertape 3x recording of the same package as the .PTP file.

NOTE: these modules/programs can be broken *easily* -- there are no checks for mistakes or errors.  Everything works and works well, but just in a certain way.  I took my user input method cue directly from Woz and Baum's disassembler: enter addresses, etc., *before* running the programs.  This helped keep the size down, which after functionality was my main concern. 

If loading individual modules, load the eWozLite PTP file (in Object folder) first, at $1220, then use that to bring in the other files (in Apple I hex format).  You should set the ASCII transfer for A1 Hex files to no less than 10 msec character delay and 200 msec line delay, just to give eWozLite time to process the stream.

ROM version: see the folder LIL' ROM for versions for burning to an (E)EPROM, relocated to $A000 and tuned up by Netzherpes.  WTG!
