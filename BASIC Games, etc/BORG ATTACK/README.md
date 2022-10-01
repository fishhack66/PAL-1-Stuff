"STAR TREK' on a 5K PAL-1?  In Tiny BASIC??!?" you ask. "How can you do that in just 2.2K?"
Well, you can't, really, but I wanted to try anyway, and this one should prove 'interesting,' at least. Possibly 'fascinating.'  ;^)

 * * *

### BORG ATTACK 
imagines a defense of the planet Chandra V. The Borg are bearing down on the Chandrans, hell-bent on assimilating this odd and peaceful species. 
Due to other urgent matters, Capt. Picard has left YOU with Shuttlepod No. 4 to defend the planet ... but it's not just *any* shuttlepod. 

No. 4 is equipped with secret technology from Section 31, initially developed by USS Discovery (NC-1031). You have 'multiphasic' shields
and torpedoes to (hopefully) confound the Borg. The shuttle also possesses a limited 'jump' drive, which utilizes the 'mycelial network.'

While docked at the orbiting Chandra Station, monitors detect the presence of a Borg Cube at the edge of the quadrant -- where, exactly, is unknown.
Your mission is to scout out the Cube and stop it before it can reach Chandra V.

The Borg are clever. While the cloaked Cube will move relentlessly toward the planet, it will sometimes feint - zig and zag - on its way 
to Chandra V -- it may even 'play possum' -- all to deceive any possible pursuer ... such as you.

Your best bet to save the Chandrans from assimilation is to find the cube early in your mission, so you have some margin for error. 
But if you find it close to the planet ...

 * * *

GAME PLAY:

The quaudrant is laid out on a 8x8 grid: 0-7, X-Y co-ordinates. The planet and its space station are at 0,0; the "outer edges" of the quadrant
are 0,7 over to 7,7 then down to 7,0. The Borg Cube will first show up there somewhere, and then work its way down-and-to-the-left toward the planet.

The 'jump drive' lets the player pop into and out of any co-ordinate on the grid. Sensors will tell you if an "anomaly" is nearby.
One problem is that when you jump, the Borg Cube moves also, so you have to try to anticipate where it will go next. Another problem is that
unless the pilot is extremely lucky with a perfect shot, it will two successful hits to disable the Cube. Unfortunately, the Cube possesses
superior weapons...

Chandra V Space Station (at 0,0) can reload the pod's torpedoes and recharge sheilds; but, in the meantime, the Borg will have moved twice 
by the next time you jump: once when you jumped to Chandra and again when you go back out.

In play testing, I found I will win about half the time, and fail most often when I take risks (shades of Tom Paris!). Factors such as
the shuttle's accuracy/aim and torpedo potency, plus the Cube's lethality, can be changed within the "battle stations' section of the program.
I also had a version where the Borg moved 0, 1, or 2 spaces at a time on a larger 10x10 grid, but that proved quite difficult to win.

Live long and prosper, DHH

 * * *

LOADING INSTRUCTIONS:

A) Load the file "BORG_ATTACK_ML.PTP" 

B) Load Tiny BASIC at $0200 

C) Inside TB, load "BORG_ATTACK.BAS" 

D) Type RUN

I used almost every bit of RAM I could think of when making this game. The game code takes up all-but 90 bytes of the available contiguous RAM
in an 'unexpanded' PAL-1 or microKIM after Tiny BASIC is loaded. I used the 6532 RIOT chip RAM to hide the 'print data' code, and when the remaining 
space proved inadequate for the data of my title routine, I put the data at the bottom of the stack (Page $01); if it gets overwritten after the
initial run, that's OK: at least my "splash screen" displayed when first run.  :^)

Here is a list of variables used, and some REM references, so interested persons can have some guideposts.  
I'm *sure* this code can be improved upon, even expanded (graphic displays, more weapons/controls, different navigation?) if you have TB running 
in an 8 KB+ environment, so have at it!

VARIABLES

A - Generic input variable

B - X position of Borg Cube

C - Y position of Borg Cube

D - Damage level of Cube (2-0)

E - Energy level of pod's shields

G - X position of Fed. shuttlepod

H - Y position of Fed. shuttlepod

I - 'For/Next' loop generic counter

J - 'For/Next' loop generic counter

Q - Holds return val. of USR/RND call

R - Holds return val. of RND call

T - Torpedoes onboard pod

U - X position HOLDER of diff betw cube/pod

V - Y position HOLDER of diff betw cube/pod

X - X position ENTERED of Fed. shuttlepod

Y - Y position ENTERED of Fed. shuttlepod


REMARKS

by Dave Hassler

Built Sept. 2022 for the PAL-1 computer

Runs under Tiny BASIC loaded at $0200

2 REM Call PrintMsg hiding in RIOT RAM

3 REM Seed RND generator

19 REM Place Borg Cube at edge of quadrant

99 REM Move Borg Cube 0 or -1 (X and Y) on grid

199 REM Pod jump routine

399 REM Complete jump and perform scan

499 REM Resupply at Chandra Base

799 REM Battle Stations!

999 REM 'Thinking' loop

1099 REM Det. Cube's positional relationship to Pod (1 sector resolution)

