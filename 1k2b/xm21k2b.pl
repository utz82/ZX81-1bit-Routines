#!/usr/bin/perl

use strict;
use warnings;
use Fcntl qw(:seek);

print "XM 2 1K2B CONVERTER\n";

my $infile = 'music.xm';
my $outfile = 'music.asm';
my $debuglvl;
my $debug = 0;
my $sdebug = 0;


#pass dummy command line parameter if none present
$debuglvl = $#ARGV + 1;
$ARGV[0] = '-0' if ($debuglvl == 0);

#check if music.xm is present, and open it if it is
if ( -e $infile ) {
	print "Converting...\n";
	open INFILE, $infile or die "Could not open $infile: $!";
	binmode INFILE;
} 
else {
	print "$infile not found\n";
	exit 1;
}

#delete music.asm if it exists
unlink $outfile if ( -e $outfile );

#create new music.asm
open OUTFILE, ">$outfile" or die $!;

#setup variables
my ($binpos, $fileoffset, $ptnoffset, $ix, $uniqueptns, $headlength, $packedlength, $plhibyte, $ptnlengthx, $ptnusage);
use vars qw/$songlength/;

#check if xm is version 1.04
sysseek(INFILE, 0x3a, 0) or die $!;
sysread(INFILE, $ix, 1) == 1 or die $!;
$ix = ord($ix);
if ($ix <= 3) {
	print "Error: XM version < 1.04. Please use a more recent editor.\n";
	close INFILE;
	close OUTFILE;
	exit 1;
}
print "Using XM version 1.0$ix\n" if ( $ARGV[0] eq '-v' );

#check if module has correct number of channels (4)
sysseek(INFILE, 68, 0) or die $!;
sysread(INFILE, $ix, 1) == 1 or die $!;
if ( ord($ix) != 4 ) {
	print "Error: Invalid number of channels in module\n";
	close INFILE;
	close OUTFILE;
	exit 1;
}

#determine song length
sysseek(INFILE, 64, 0) or die $!;
sysread(INFILE, $songlength, 1) == 1 or die $!;
$songlength = ord($songlength);
print "song length:\t\t $songlength \n" if ( $ARGV[0] eq '-v' );

#determine number of unique patterns
sysseek(INFILE, 70, 0) or die $!;
sysread(INFILE, $uniqueptns, 1) == 1 or die $!;
$uniqueptns = ord($uniqueptns);
print "unique patterns:\t $uniqueptns \n" if ( $ARGV[0] eq '-v' );


#locate the pattern headers within the .xm source file and check pattern lengths
my (@ptnoffsetlist, @ptnlengths);

$ptnoffsetlist[0] = 336;
$fileoffset = $ptnoffsetlist[0];

for ($ix = 0; $ix < $uniqueptns; $ix++) {
	sysseek(INFILE, $fileoffset, 0) or die $!;	#read ptn header length
	sysread(INFILE, $headlength, 1) == 1 or die $!;
	$headlength = ord($headlength);
		
	$fileoffset = ($fileoffset) + 5;		#read ptn lengths
	sysseek(INFILE, $fileoffset, 0) or die $!;
	sysread(INFILE, $ptnlengthx, 1) == 1 or die $!;
	$ptnlengths[$ix] = ord($ptnlengthx);
		
	$fileoffset = ($fileoffset) + 2;		#read packed data length
	sysseek(INFILE, $fileoffset, 0) or die $!;
	sysread(INFILE, $packedlength, 1) == 1 or die $!;
	$packedlength = ord($packedlength);
	$fileoffset++;
	sysseek(INFILE, $fileoffset, 0) or die $!;
	sysread(INFILE, $plhibyte, 1) == 1 or die $!;
	$packedlength = $packedlength + ord($plhibyte)*256;

	$ptnoffsetlist[($ix+1)] = ($ptnoffsetlist[($ix)]) + ($headlength) + ($packedlength);
		
	$fileoffset = $fileoffset + $packedlength + 1;	#calculate pos of next ptn header
}

my ($globalspeed, $jx);
$fileoffset = 78;				#initialize values
sysseek(INFILE, $fileoffset, 0) or die $!;
sysread(INFILE, $jx, 1) == 1 or die $!;
$globalspeed = 0x100 - (ord($jx));

print OUTFILE "\nspeed equ #";
printf(OUTFILE "%x", $globalspeed);
print OUTFILE "00\n\nseq\n";

#generate pattern sequence
my $ptnval;
for ($fileoffset = 80; $fileoffset < ($songlength+80); $fileoffset++) {
	sysseek(INFILE, $fileoffset, 0) or die $!;
	sysread(INFILE, $ptnval, 1) == 1 or die $!;
	$ptnval = ord($ptnval);
	print OUTFILE "\tdw ptn$ptnval\n";	
}
print OUTFILE "\tdw ",'0',"\n\n";		


#convert pattern data
my (@ch2, @ch3, @drums, @speed);
my ($rows, $cpval, $temp, $temp2, $mx, $nx);
for ($ix = 0; $ix <= ($uniqueptns)-1; $ix++) {

	$ptnusage = IsPatternUsed($ix);

	if ($ptnusage == 1) {

		print OUTFILE "ptn$ix\n";
	
		$speed[0] = 0;

		$drums[0] = 0;
		$ch2[0] = 0x31;	#tone
		$ch3[0] = 0x31;	#tone
	
		$fileoffset = $ptnoffsetlist[$ix] + 9;
	
		for ($rows = 1; $rows <= $ptnlengths[($ix)]; $rows++) {	#Achtung! Row values offset by -1 so we can preload dummy values
			$speed[$rows] = $speed[$rows-1];		#set default speed
			$drums[$rows] = 0;
			$ch2[$rows] = $ch2[$rows-1];
			$ch3[$rows] = $ch3[$rows-1];
		
			for ($mx = 0; $mx <=3; $mx++) {				#reading 4 tracks per row
				sysseek(INFILE, $fileoffset, 0) or die $!;	#read control byte of row
				sysread(INFILE, $cpval, 1) == 1 or die $!;
				$cpval = ord($cpval);
		
				if ($cpval >= 128) {				#if we have compressed data
			
					$fileoffset++;
			
					if ($cpval != 128) {

						sysseek(INFILE, $fileoffset, 0) or die $!;	#read first data byte of row
						sysread(INFILE, $temp, 1) == 1 or die $!;
						$temp = ord($temp);
				
						if (($cpval&1) == 1) {				#if bit 0 is set, it's note -> counter val.		
							if ($temp >= 0x31 || $temp ==0) {
								$debug++ if ($temp != 97 && $temp != 0);	#correction for stop note signal
								$temp = 0x31;
							}
							$ch2[$rows] = $temp if ($mx == 0);
							$ch3[$rows] = $temp if ($mx == 1);
							$fileoffset++;
							sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
							sysread(INFILE, $temp, 1) == 1 or die $!;
							$temp = ord($temp);
						}
			
						if (($cpval&2) == 2) {				#if bit 1 is set, it's instrument -> if val = 3..5, set drum val.
							$drums[$rows] = $temp-1 if ($temp >= 2 && $temp <= 3 && $drums[$rows] == 0);
							$fileoffset++;
							sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
							sysread(INFILE, $temp, 1) == 1 or die $!;
							$temp = ord($temp);
						}
			
						if (($cpval&4) == 4) {				#if bit 2 is set, it's volume -> ignore
							$fileoffset++;
							sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
							sysread(INFILE, $temp, 1) == 1 or die $!;
							$temp = ord($temp);
						}
					
					
						if (($cpval&8) == 8 && $temp == 15) {		#if bit 3 is set and value is $f, it's Fxx command
							$fileoffset++;
							sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
							sysread(INFILE, $temp2, 1) == 1 or die $!;
							$temp2 = ord($temp2);
							if (($cpval&16) == 16 && $temp2 == 0x1e) {
								$speed[$rows] = 0x80;	#setting speed if bit 4 is set
							}
							if (($cpval&16) == 16 && $temp2 == 0x0f) {
								$speed[$rows] = 0;		#setting speed if bit 4 is set
							}
							$fileoffset++;
						}
					}
				}
				else {			#if we have uncompressed data
					$temp = $cpval;
					if ($temp >= 0x31 || $temp ==0) {
						$debug++ if ($temp != 97 && $temp != 0);	#correction for stop note signal
						$temp = 0x31;
					}
					$ch2[$rows] = $temp if ($mx == 0);
					$ch3[$rows] = $temp if ($mx == 1);
					$fileoffset++;
					sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
					sysread(INFILE, $temp, 1) == 1 or die $!;
					$temp = ord($temp);
				
					$drums[$rows] = $temp-1 if ($temp >= 2 && $temp <= 3 && $drums[$rows] == 0);
					$fileoffset++;
					sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
					sysread(INFILE, $temp, 1) == 1 or die $!;
					$temp = ord($temp);
				
					$fileoffset++;
					sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
					sysread(INFILE, $temp, 1) == 1 or die $!;
					$temp = ord($temp);
					$cpval = $temp;
				
					$fileoffset++;
					sysseek(INFILE, $fileoffset, 0) or die $!;	#read next byte of row
					sysread(INFILE, $temp, 1) == 1 or die $!;
					$temp = ord($temp);
					if ($cpval == 0x0f && $temp == 0x1e) {
						$speed[$rows] = 0x80;		#setting speed
					}
					if ($cpval == 0x0f && $temp == 0x0f) {
						$speed[$rows] = 0;			#setting speed
					}
					$fileoffset++;
				}
			}

			$ch2[$rows] = $ch2[$rows] + 0x80 if ($speed[$rows] == 0x80);
			$ch3[$rows] = $ch3[$rows] + 0x80 if ($drums[$rows] == 1);
			$ch3[$rows] = $ch3[$rows] + 0xc0 if ($drums[$rows] == 2);
		
			print OUTFILE "\tdb ",'#';
			printf(OUTFILE "%x", $ch2[$rows]);
			print OUTFILE ',#';
			printf(OUTFILE "%x", $ch3[$rows]);
			print OUTFILE "\n";
			
			$ch3[$rows] = $ch3[$rows] - 0x80 if ($drums[$rows] == 1);
			$ch3[$rows] = $ch3[$rows] - 0xc0 if ($drums[$rows] == 2);
		}
	
		print OUTFILE "\tdb ",'0',"\n\n";
	}
}


print "WARNING: $debug out of range note(s) replaced with rests.\n" if ( $debug >= 1);

print "SUCCESS!\n";

#close files and exit
close INFILE;
close OUTFILE;
exit 0;

#check if a pattern is actually used
sub IsPatternUsed {
my ($fileoffset, $ptnval);
my $usage = 0;
my $patnum = $_[0];
	for ($fileoffset = 80; $fileoffset < ($songlength+80); $fileoffset++) {
	sysseek(INFILE, $fileoffset, 0) or die $!;
	sysread(INFILE, $ptnval, 1) == 1 or die $!;
	$usage = 1 if ($patnum == ord($ptnval));
	}
	return($usage);
}

