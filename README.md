# PAL-1 Stuff

Code (mainly BASIC, but eventually some ML) for the PAL-1, microKIM, and KIM-1 6502 computers.  NOTE: *Some* flavors of Tiny Basic will not allow you to play some of these games, as I make use of Tom Pitmann's original version for the KIM-1.  Jim McClelland's port for the PAL-1 that loeads to $0200 (https://github.com/w4jbm/PAL-1-6502-SBC) (should be fine on a microKIM, too) is "faithful" and will allow for "PEEK" and "POKE", ersatz 1-dimentional arrays, and calling ML routines.

### LIL' ZILCH for KIM/PAL-1 Tiny BASIC

   This is a dice game. You roll 5 dice and try to collect as many 1s and 5s as you can within a 3-roll turn. If at any time you cannot get a 1 or 5, you 'zilch' and lose any points gained in the turn. You have 10 turns to reach 2,000 points. This is based on the classic 6-dice game Zilch, aka Greedy, or even "Cosmic Wimpout".  The turn limit is your "opponent," as I ran out of room to have the computer play against you.

   I tore out everything but the 1s-and-5s (no 3- or 4-of-a-kind, no straights) and crunched it down to 2.4 KB, with about 30 bytes left over in an 'unexpanded' PAL-1 with 5K RAM onboard running Tiny Basic.  I'm sure it can be improved - even within its current space limitations.  But, it's quite playable and fun.  I find I win about half the time...just about right!  :^)

VARIABLES:
A - Game score.  
B - Generic input.  
C - Turns counter.  
D - Dice array.  
E - Dice flag (kept) array.  
F - All 5 played flag.  
I - Loop counter.  
L - Rolls w/i turn counter.  
M - # of dice 'kept'.  
O - Pointer to TB 'POKE' USR routine.  
P - Pointer to TB 'PEEK' USR routine.
Q - Generic holder for PEEK and POKE.  
W - Score holder w/i turn
Y - Final turn score (added to A).
Z - Generic holder for PEEK and POKE.  

REMARKS:  
10 - Instructions and Init.  
50 - Start of Turn loop.  
100 - Check for 'zilch'.  
500 - Scoring.  
800 - End.  
900 - Print scorecard.  
1000 - Select 'keeper' dice.  
1111 - Check for all 5 played.  
1125 - Score it, or re-roll the rest?

### LIL' YAWT: an original adaptation for Tiny BASIC

   I wanted to see if I could cram the popular 5-dice poker-like game into the 2.5K left over from loading Tiny BASIC into the unexpanded PAL-1 (will work with a 4K-expanded KIM-1, too).  I couldn't fit in the "poker hands," but this version has the 1 through 6 categories, "Yawt," and a final slot for the sum of one "garbage hand" that won't score anything else.
   
   This one took some serious cutting down.  All PRINT statements are abbreviated as PR, and I stripped out 'LET' from all the variable assignments (Pitmann says it's a tad slower without the LET, but I didn't notice).  It's quite playable, and I'm pleased with it, but I'm not completely satisfied with two things: A) the Yawt test is not iron-clad; it's possible (though highly unlikely) that a false positive could happen; B) the scorecard printout is ... uneven, at the start.  Maybe someone can improve on this, hopefully  Certainly, it can be expanded if one has RAM from $2000 and up (rmember that the 'PEEK' and 'POKE' routine addresses will change in that case).  Also, a few of the tests on user input had to come out, due to space limits; this game _can_ be broken or cheated.  More clever fixes?  :^)
   
   VARIABLES: B - No. of dice to reroll; category to score at end of turn.  C - Categories, start of 1-D array ($17D4).  D - Dice throws, start of array ($17CA).  F - Part of test for YAWT.  I - 'For/Next' loop generic counter.  L - No. of rolls within a turn.  O - Loc. of TB 'POKE' routine ($0218).  P - Loc. of TB 'PEEK' routine ($0214).  Q - Holds return val. of O and P.  T - Total scored/turn.  U - No. of dice to reroll.  V - 'Value' of a turn, to be put in a category.  W - Main loop counter; Counter for end game bonus/total.  Z - Holder for randomizing dice.
   
   REMARKS: 42 - Init variables, category array.  65 - Start of Main Loop (ends 560).  300 - Roll all 5 dice.  400 - Put score into a category.  700 - Check for YAWT.  900 - Add up for Chance.  1000 - Print out each dice roll.  1300 - Print out scorecard.  1500 - Total up and end.

### BOXCARS AND SNAKE EYES: an original game in Tiny BASIC 

   Well, mainly original.  I took the idea from a high school math/programming class project.  The kids created C++ code, while I decided to just follow the "outline" presented by the teacher and write this in Tiny BASIC for the KIM-1/PAL-1 (5K).  The game is a dice game - you against the computer to 100 points.  In seven-or-less rolls per turn, try to get as many points as possible without encountering "boxcars" (12) and losing your points for the turn, or "snake eyes" (2) and losing the game right then and there.  To make it fit in 2.4 KB, I first cobbled the program together 'freely,' then cut and cut and cut ... just like Hammurabi, below.  Here are some helps, in case someone wants to improve on it:

   VARIABLES: H=Human's score, total. I=delay loop var for computer turns. J=the roll counter per turn. O=player(1) or computer(2) currently playing. P=PAL-1's total score. S=Computer's playing 'style'. T=temp var. for total point w/i a turn. X,Y=dice. Z=misc. input var.
REMs:  100 - Main Loop  170 - Scoring.  270 - Player done, back to PAL.  300 - PAL done, back to player.  400 - a winner!  500 - Boxcars  600 - Snake Eyes  700 - Instructions (mega-chopped!)  900 - delay loop for PAL rolls.

### EXAMPLES OF ML INTEGRATION

   DICE.BAS is an example program that illustrates the use of RIOT chip RAM to create TinyBASIC 'limited' one-dimensional arrays using TB's USR function.  TinyBASIC has (sort of) built in 'PEEK' and 'POKE' ML routines that are not BASIC keywords -- although, to use them, you just have to call them.  For translating small dice and card games from M$ BASIC, this is just what you need!  :^)  LIST the program for an amazingly simple method of making simple 1-D arrays that can hold numbers 0-255.  Enjoy!
   
   CHAR-SET.BAS takes advantage of the KIM-1 kernal ROM routines for printing characters to the TTY device to print out a table of the ASCII decimal codes for all of the "printing" chacters, 32-127.  The program "calls" the OUTCH, OUTSP, and CRLF routines.  Use of OUTCH is made to sort-of mimic MS Basic's ability to 'PRINT CHR$(x)'.  And yes, this would be *much* faster in ML, but sometimes you just want to print a character from a variable value in BASIC, even if it's 'tiny.'  :^)

### OTHER GAMES
   Acey-Ducey, Chuck-a-Luck, Craps, Hi-Lo, Lunar Lander, and Hurkle have been around forever, and are all-but obvious to play. The source code for each was snagged from Creative Computing's seminal '70s texts "BASIC Computer Games," and "More BASIC Computer Games," both edited by David Ahl.  For Craps, it was a challenge (like Hammurabi) to squeeze the translation to TinyBASIC into 2.4 KB, but still fun. There were other games I wanted to translate, but four-deep nested loops were just too much for me!  Still, if you don't have an add-on RAM board for your PAL-1 or microKIM, this will provide a little fun and food for thought, if nothing else, while you reacquaint yourself with 6502 machine code and assembly language.  :^)  Enjoy!

   *** HAMMURABI for TinyBASIC [(TINYbasic for PAL-1 ported and tweaked by W4JBM here on Github)](https://github.com/w4jbm/PAL-1-6502-SBC).


   This is the "explanation" (I can't call it "documentation") of my effort to squeeze the classic BASIC game "Hamurabi" into the bit of RAM left after Tiny BASIC loads on the "stock" PAL-1 (or microKIM, or 4K-expanded actual KIM-1).  I managed to shrink it down from the 4.1KB text file found in the classic David Ahl-edited book "BASIC Computer Games" to 2.4KB.  It works - just barely - with a few bytes to spare.  I stripped this thing down to the bare bones, but it's playable.

   I'm *sure* someone in the 6502 retro community has either A) done this before, or B) can improve on this work (just renumbering the BASIC lines would surely buy a few more bytes).  In the latter case, I certainly hope so!  I played about 20 games during testing, and I never reached a "Masterful" rating; only "Fair" twice and "Despot" the rest of the time.  Plus, I never encountered the plague....(7/13/22: FIXED! Now 20% chance of losing 1/3 of your population in any given year)  In any case, playing it took me right back to Dale J. Ickes Junior High in 1978, playing this on a PDP-11 via the school library's teletype and acoustic modem.  What a way to time travel!

   In the event that someone may want to augment/fix/streamline this code, I offer the following: a variable list for this TinyBASIC version, and all the REM statements I stripped out of the original.

VARIABLES:

A - acres  
B - RND holder for end of game  
C - land cost factor  
D - dead ppl counter  
E - bushels of grain rats eat  
H - starting harvest  
I - immigrants  
L - acres/person, end of game  
P - population  
Q - used as INPUT variable, plague chance, other misc stuff  
S - bushels stored  
U - holder for population calculations  
V - holder for dead ppl calculations  
Y - bushels of wheat harvested in a year  
Z - the year in the cycle  


REMARKS (from the Ahl '78 published version, typically lines I deleted):  
418 REM *** TRYING TO USE MORE GRAIN THAN IS IN SILOS?  
444 REM *** TRYING TO PLANT MORE ACRES THAN YOU OWN?  
449 REM *** ENOUGH GRAIN FOR SEED?  
454 REM *** ENOUGH PEOPLE TO TEND THE CROPS?  
512 REM *** A BOUNTIFUL HARVEST!  
523 REM *** RATS ARE RUNNING WILD!!  
532 REM *** LET'S HAVE SOME BABIES  
539 REM *** HOW MANY PEOPLE HAD FULL TUMMIES?  
541 REM *** HORRORS, A 15% CHANCE OF PLAGUE  
551 REM *** STARVE ENOUGH FOR IMPEACHMENT?


Best regards, 
Dave Hassler

July 12, 2002
