;************************************************************************************
; 1k2b - 2ch 1-bit music routine for unexpanded ZX81 (best used with "loud" tape mod)
; by utz 03'2015 * www.irrlichtproject.de
;************************************************************************************

	org #4009
 
;************************************************************************************
;system variables
 
	db 0		;VERSN
	dw 0		;E_PPC
	dw dfile	;D_FILE
	dw dfile+1	;DF_CC
	dw var		;VARS
	dw 0		;DEST
	dw var+1	;E_LINE
	dw last-1	;CH_ADD
	dw 0		;X_PTR
	dw last		;STKBOT
	dw last		;STKEND
	db 0		;BERG
	dw membot	;MEM
	db 0		;not used
	db 2		;DF_SZ
	dw 1		;S_TOP
	db #ff,#ff,#ff	;LAST_K
	db 55		;MARGIN
	dw line10	;NXTLIN
	dw 0		;OLDPPC
	db 0		;FLAGX
	dw 0		;STRLEN
	dw #0c8d	;T_ADDR
	dw 0		;SEED
	dw #ffff	;FRAMES
	db 0,0		;COORDS
	db #bc		;PR_CC
	db 33,24	;S_POSN
	db #40		;CDFLAG (bit 7 reset = FAST mode)

membot equ $+33		;401F:5D40

;************************************************************************************
;65 bytes that can hopefully be used

	;ds 33		;Print buffer
	;ds 30		;Calculator´s memory area
	;ds 2		;not used
	
playnote					
switch1 equ $+1						;output switch ch1
	out (c),a			;12		;in (c),a = ED 78, out (c),a = ED 79
								
base1 equ $+1					
	ld hl,0				;10		;base counter value ch1
	add hl,de			;11		;calculate current counter
	ex de,hl			;4		;preserve current counter val in de
	jr nc,skip1			;12/7

	ld hl,switch1			;10	;3
	ld a,(hl)			;7	;1	;toggle IN/OUT
	xor b				;4	;1
	ld (hl),a			;7	;1
	ld a,c				;4	;1	;toggle between #ff and #fe
	xor b				;4	;1
	ld c,a				;4	;1
					;40t	;9b	
skip1
	exx						;switch to alt register set
	
switch2 equ $+1
	out (c),a					;in (c),a = ED 78, out (c),a = ED 79
	
base2 equ $+1
	ld hl,0						;base counter val ch2
	add hl,sp					;calculate current counter ch2
	ld sp,hl					;preserve current counter val in sp
	jr nc,skip2

	ex af,af'			;4		;toggle IN/OUT, af' holds a copy of (switch2)
	xor b				;4
	ld (switch2),a			;13
	ex af,af'			;4

	ld a,c				;4		;toggle between #ff and #fe
	xor b				;4
	ld c,a				;4
					;40t
skip2
	dec de
	ld a,d
	or e
	exx
	jr nz,playnote
	
oldSP equ $+1
	ld sp,0	
	jr rdnotes
	
reinit
	ld hl,musicdata			;3		;init pointer to song data
	push hl				;1
	
selectptn						;select pattern
	pop hl				;1
	ld e,(hl)			;1		;load lo byte of sequence pointer
	inc hl				;1
	ld d,(hl)			;1		;load hi byte of sequence pointer - ptn pointer now in de
	inc hl				;1
	ld a,d				;1		;check for end marker
	or e				;1
	jr z,reinit			;1		;loop if end marker found
	push hl				;1		;save sequence pointer
	push de				;1		;save ptn pointer
	jr rdnotes			;2 = 16b
 
;************************************************************************************
;BASIC upstart
 
line0			;#407d
	db 0,0		;line number
	dw line10-$-2	;line length
	db #ea		;REM

;************************************************************************************
;main routine

init
	di
	out (#fd),a			;disable NMI aka switch to FAST mode
	jr reinit

rdnotes
	pop de				;retrieve ptn pointer
	ld a,(de)			;get note val ch1
	or a				;check for end marker
	jr z,selectptn			;if end marker is found, select next entry in pnt sequence
	
	ld hl,notetab-2			;init pointer to frequency LUT
	rla				;A=A*2, carry is reset from previous or op
	exx
	ld de,speed			;prep speed counter
	jr nc,rdskip1			;check if half speed should be used
	sla d				;adjust speed counter if necessary
rdskip1	
	exx
	add a,l				;calculate offset
	ld l,a
	ld a,(hl)			;get frequency val
	ld (base1),a			;and store it in (base1) and (base1+1)
	inc l
	ld a,(hl)
	ld (base1+1),a
	
	inc de				;point to note val ch2
	ld a,(de)			;get note val ch2
	rla
	call c,drum			;if bit 7 was set, play drum	
	ld l,LOW(notetab-2)		;reset pointer to frequency LUT (low byte #2e -2 (offset))
	add a,l
	ld l,a
	ld a,(hl)
	ld (base2),a
	inc l
	ld a,(hl)
	ld (base2+1),a

	inc de				;point to next row
	push de				;and preserve ptn pointer
	
	ld (oldSP),sp

	ld a,#79			;set both channel outputs to low
	ld (switch1),a
	ld (switch2),a
	ld bc,#01ff			;b = XOR mask, c = IN/OUT toggle
	push bc
	exx
	pop bc
	exx
	ld a,#79			;backup of (switch2)
	ex af,af'
	jp playnote

;************************************************************************************
;drum code

drum
	exx				;using alt register set
	bit 7,a				;if bit 7 is still set
	jr nz,drum2
	ex af,af'
	ld hl,0
	ld bc,#380
drlp1
	ld a,(hl)
	inc hl
	rra
	out (#ff),a
	jr nc,drskip1
	in a,(#fe)
drskip1
	dec bc
	ld a,b
	or c
	jr nz,drlp1
	
drumret
	dec d				;adjust speed counter
	dec d
	ld e,#80
	exx
	ex af,af'
	and %01111111			;clear bit 7 for later
	ret

drum2
	ex af,af'
	ld b,1
drlp2
	ld a,b
drwlp2
	out (#ff),a
	push hl
	pop hl
	dec a
	jr nz,drwlp2
	ld c,b
drwlp3
	in a,(#fe)
	push hl
	pop hl
	dec c
	jr nz,drwlp3
	sll b
	jr nc,drlp2

	jr drumret

;************************************************************************************
;song data
	
musicdata
	include "music.asm"
musicend
	
 	org #4331			;432E

notetab
 	dw #100, #10F, #11F, #130, #143, #156, #16A, #180, #196, #1AF, #1C8, #1E3	;#01-#0c
 	dw #200, #21E, #23F, #261, #285, #2AB, #2D4, #2FF, #32D, #35D, #390, #3C6	;-#18
 	dw #400, #43D, #47D, #4C2, #50A, #557, #5A8, #5FE, #659, #6BA, #720, #78D	;-#24
 	dw #800, #879, #8FA, #983, #A14, #AAD, #B50, #BFC, #CB2, #D74, #E41, #F19	;-#30
	db 0		;silence (actually dw 0, using low byte of line# as 2nd byte)	;#31

;************************************************************************************
	;db #76		;newline			;not needed since no LISTing is ever produced
line10
	db 0,10		;line number
	dw dfile-$-2	;line length
	db #f9		;RAND
	db #d4		;USR
	db #1d		;1
	db #22		;6
	db #21		;5
	db #1d		;1
	db #20		;4
	db #7e		;FP mark
	db #8f		;5 bytes FP number
	db #01
	db #04
	db #00
	db #00
;	db #76		;newline			;not needed, can use first byte of dfile
 
;- Display file --------------------------------------------
 
dfile
	db #76
	db #76,#76,#76,#76,#76,#76,#76,#76
	db #76,#76,#76,#76,#76,#76,#76,#76
	db #76,#76,#76,#76,#76,#76,#76,#76
 
;- BASIC-Variables ----------------------------------------
 
var
	db #80		;2 bytes, actually!
 
;- End of program area ----------------------------
			;STACK GOES HERE!
last

IF (musicend > notetab)
.warning music data too large
ENDIF