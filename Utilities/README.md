# Five Tools for the Unexpanded PAL-1

### 6502 Disassembler by Wozniak and Baum
Yes, it their 1976 hit, ported and tweaked by me for the KIM-1/PAL-1.  Details are in the source code file (and full comments in the PDF here), but to use it, put your disassembly starting address in $44 and $45 (little endian).  It loads and runs at $0800.  To see the next batch of disassembly from where you left off, just run the program again without entering a new starting address for disassembly. My third project! 

### Lil' Mem Dump
This program is my second attempt at 6502 assembly language programming, and I'm pretty pleased with it.  Enter a starting address at $20 and $21 (little endian), then load and run LMD at $1000.  To see the next 256 bytes, simply run the program program again without entering a new starting address, ala Woz and Baum -- we stand on the shoulders of giants....

### Lil' Fill
This is just the ubiquitous "fill a page of memory with zeroes" routine from 6502.org's source code library, gussied up a little, mainly to allow the user to specify what value the hex fill should have.  I also added a little safequard before execution, in case the user forgot to set up the zero page variables, and some info about those locations.

### MOVIT-2
Lew Edwards' classic from First Book of KIM, again with just a few additions. The opportunity to break out in case zero page locations did not get set, and some info, we also added.

### Register Print
My first go at making something useful.  Not pretty, but it quite small and works.  Loads at $1000  :^)  

***
Thoughts:

These programs could (should?) be relocated for maximum utility by the unexpanded PAL-1 user.  The register printer could sit at $1380, the memory dump could go at $12A0, and the disassembler at $1150.  That leaves a full 2K for machine code on the PAL or microKIM ($0300-$1100).  To quote numerous people, "We sent men to the moon with a lot less than that!"

That would even leave a little room to make a "menu" program and tie it all together to make a package out of it - a fair debugger/monitor, when combined with the KIM/PAL's native monitor for poking in values and executing programs.  Maybe that's my Project #4 ... unless you beat me to it!
