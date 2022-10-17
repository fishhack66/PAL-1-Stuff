A collection of small programs appropriate for debugging code on an 'unexpanded' 5 KB PAL-1 or microKIM computer.

Includes: eWozLite, 6502 Disassembler, Search, Copy, Fill, Memory Dump (with ASCII), and Register Printer, plus a menu/picker
(see documentation for full details on use).

If loading individual modules, load the eWozLite PTP file (in Object folder) first, at $1220, then use that to bring in the other files (in Apple I hex format).  You should set the ASCII transfer for A1 Hex files to no less than 10 msec character delay and 200 msec line delay, just to give eWozLite time to process the stream.
