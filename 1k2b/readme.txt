1k2b - beeper music routine for ZX81
by utz 03'2015 * www.irrlichtproject.de
===================================================


About 1k2b
==========

One Kilobyte, 2 Beeps, or short 1k2b, is a 2 channel beeper
music routine for the unexpanded Sinclair ZX81. A machine
with "loud cassette" mod as suggested in Funkschau 18/1983
(http://www.sinclairzxworld.com/viewtopic.php?f=7&t=514) is 
recommended for playback. The routine also runs on RAM-
expanded machines.

1k2b features 2 channels of square wave with 16-bit frequency
dividers as well as two interrupting click drum sounds.


Requirements
============

In order to use the 1k2b compiler package, you need the
following:

- pasmo or a compatible assembler of your choice
  (http://pasmo.speccy.org)
- Perl (http://www.perl.org/get.html)
- Milkytracker or another XM tracker that supports XM 
  version 1.04 (http://milkytracker.org)
- a ZX81 or an emulator that correctly emulates the ZX81's
  behaviour regarding ports (EightyOne for Windows, or the
  latest sz81 [v2.1.9] for *nix)


Usage
=====

Provided you have pasmo and perl installed and/or available
in your search path, you may

Step 1: Compose music using the provided XM template
Step 2: Execute compile.bat/compile.sh
Step 3: Profit!


Composing Music
===============

You can use the included XM template to compose music for
1k2b. It will however give only a rough approximation of
how the music will sound on actual ZX81.

The following restrictions apply:

Tones must be entered into tracks 1 and 2, using instrument
01. The available note range is C-0..B-3. Tones on track 2
will play slightly louder.

There are two click drums available, which interrupt tone
playback. They may be entered into any channel. Their pitch
is ignored, and you can only use one of them at a given time.
Note that the speed correction for the drums is not 100%
accurate, so you might experience a slight groove.

You can change the global BPM setting, up to a maximum of
253 BPM. Tempo conversion is not very accurate, though.

You may not change the global Speed setting. You can however
temporarily halve the speed by entering an F1E command on any
of the channels. In order to return to full speed, use F0F.
This feature will not work correctly if BPM is not set to an
even value.

All other effects, volume and panning settings are ignored.

Music data size on unexpanded (1K) machines is limited to
547 bytes. The assembler will warn you in case you exceed
the memory limit. On expanded machines, you can increase the
value in line 235 of main.asm to allow for larger music data.
It is safest to only increase the first two digits (43).


Note to Programmers
===================

1k2b is optimized for unexpanded 1K Zeddies. To use it on
expanded machines, you most likely want to change the org
statement in line 247 of main.asm to point to a higher
address. Make sure that the frequency table (@notetab) does
not cross page boundaries.

The routine never returns, so if you intend to use it in
a larger project, you need to add your own exit procedure
and jump to it from line 112 of main.asm.

In its current form, 1k2b cannot be relocated, however this
can be facilitated with a few minor changes.


Music Data Format Specification
===============================

1k2b music data consists of 3 sections.

The first section contains an equate statement which defines
the global BPM setting. It takes the form 
   speed equ #nm00
where nm is a byte-length hex digit which can take any value
from #02 - #ff.

The second section is the pattern sequence. It consists of a
list of word-length pointers to any of the following patterns.
It must be terminated with a dw 0 statement.

The third section contains the song's patterns. Patterns can
be of any length, and must be terminated with a 0-byte. A song
can contain a maximum of 255 patterns, though you will most
likely run out of RAM long before that.

Each row of pattern data is encoded in 2 bytes. The first byte
sets the note value for channel 1 and controls the auxiliary
tempo switch, which halves the global speed when activated. 
Valid note values are 0..#30. A value of #31 silences the 
channel. To activate the aux tempo switch, add #80 to the note
value.
The scond byte in a row of pattern data sets the note value
for channel 2 and also contains the drum triggers. To trigger
drum 1 (hihat sound), add #80 to the note value. To trigger
drum 2 (kick drum), add #c0 to the note value.


Thanks
======

... to kokkiklhs for reinstating my belief that polyphonic
    beeper music is possible on ZX81.
... to Andy Rea for revising the synthesis method so it
    actually works on real hardware.
... to no$cash for properly documenting the ZX81 ports.