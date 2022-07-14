# PAL-1-Stuff

Code (mainly BASIC, but eventually some ML) for the PAL-1, microKIM, and KIM-1 6502 computers

GAMES

Hammurabi for Tiny BASIC (TB ported and tweaked by W4JBM for PAL-1)

Greetings!

This is the "explanation" (I can't call it "documentation") of my effort to squeeze the classic BASIC game "Hamurabi" into the bit of RAM left after Tiny BASIC loads on the PAL-1 (or microKIM, or 4K-expanded actual KIM-1).  I managed to shrink it down from the 4.1KB text file found in the classic David Ahl-edited book "BASIC Computer Games" to 2.4KB.  It works - just barely - with a few bytes to spare.  I stripped this thing down to the bare bones, but it's playable.

I'm *sure* someone in the 6502 retro community has either A) done this before, or B) can improve on this work (just renumbering the BASIC lines would surely buy a few more bytes).  In the latter case, I certainly hope so!  I played about 20 games during testing, and I never reached a "Masterful" rating; only "Fair" twice and "Despot" the rest of the time.  Plus, I never encountered the plague....(FIXED! Now 20% chance)  In any case, playing it took me right back to Dale J. Ickes Junior High in 1978, playing this on a PDP-11 via the school library's teletype and acoustic modem.  What a way to time travel!

In the event that someone may want to augment/fix/streamline this code, I offer the following: a variable list for this Tiny BASIC version, and all the REM statements I stripped out of the original.

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
