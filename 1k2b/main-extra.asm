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
switch1 equ $					;output switch ch1
	in a,(#fc)			;11		;in a,(n) = #db xx; out (n),a = #d3 xx -> XOR val is #8
								;using #fc because a write to #fe would enable NMI generator
	
base1 equ $+1					
	ld hl,0				;10		;base counter value ch1
	add hl,bc			;11		;calculate current counter
	ld b,h				;4		;preserve current counter val in bc
	ld c,l				;4
	jr nc,skip1			;12/7
	ld a,(switch1)		;13
	xor #8				;7
	ld (switch1),a		;13
	
skip1					;40 vs 40 ok
switch2 equ $					;output switch ch2
	in a,(#fc)
	
base2 equ $+1
	ld hl,0						;base counter val ch2
	add hl,de					;calculate current counter ch2
	ex de,hl					;preserve current counter val in de
	jr nc,skip2
	
	ld a,(switch2)
	xor #8
	ld (switch2),a

skip2
	exx
	dec bc
	ld a,c
	or b
	exx
	jr nz,playnote
	
	jr rdnotes

wait1
	ld a,(ix+0)			;19
	ld a,0				;7
	jr skip1			;12
	
wait2
	ld a,(ix+0)			;19
	ld a,0				;7
	jr skip2			;12
	
;	ds 7
 
;************************************************************************************
;BASIC upstart			;not needed since we jump into code via D-FILE
 
;line0			;#407d
;	db 0,0		;line number
;	dw line10-$-2	;line length
;	db #ea		;REM

;************************************************************************************
;main routine

init
	di
	out (#fd),a			;disable NMI aka switch to FAST mode
reinit
	ld hl,musicdata			;init pointer to song data
	push hl
	
selectptn				;select pattern
	pop hl
	ld e,(hl)			;load lo byte of sequence pointer
	inc hl
	ld d,(hl)			;load hi byte of sequence pointer - ptn pointer now in de
	inc hl
	ld a,d				;check for end marker
	or e
	jr z,reinit			;loop if end marker found
	push hl				;save sequence pointer
	push de				;save ptn pointer

rdnotes
	exx
	ld bc,speed			;prep speed counter
	exx

	pop de				;retrieve ptn pointer
	ld a,(de)			;get note val ch1
	or a				;check for end marker
	jr z,selectptn		;if end marker is found, select next entry in pnt sequence
	
	ld hl,notetab-2		;init pointer to frequency LUT
	rla					;A=A*2, carry is reset from previous or op
	jr nc,rdskip1		;check if half speed should be used
	exx
	sla b				;adjust speed counter if necessary
	exx
rdskip1	
	add a,l				;calculate offset
	ld l,a
	ld a,(hl)			;get frequency val
	ld (base1),a		;and store it in (base1) and (base1+1)
	inc l
	ld a,(hl)
	ld (base1+1),a
	
	inc de				;point to note val ch2
	ld a,(de)			;get note val ch2
	rla
	call c,drum			;if bit 7 was set, play drum
	;ld l,#2c			;reset pointer to frequency LUT (low byte #2e -2 (offset))
	ld l,#86
	add a,l
	ld l,a
	ld a,(hl)
	ld (base2),a
	inc l
	ld a,(hl)
	ld (base2+1),a

	inc de				;point to next row
	push de				;and preserve ptn pointer

	ld a,#d3			;set both channel outputs to low
	ld (switch1),a
	ld (switch2),a
	ld b,0				;reset temp counter
	ld c,b
	ld d,b
	ld e,b
	jp playnote

drum
	exx					;using alt register set
	bit 7,a				;if bit 7 is still set
	jr nz,drum2
	ex af,af'
	ld hl,0
	ld de,#380
drlp1
	ld a,(hl)
	inc hl
	rra
	out (#fc),a
	jr nc,drskip1
	in a,(#fc)
drskip1
	dec de
	ld a,d
	or e
	jr nz,drlp1
	
drumret
	dec b				;adjust speed counter
	exx
	ex af,af'
	and %01111111		;clear bit 7 for later
	ret

drum2
	ex af,af'
	ld d,1
drlp2
	ld a,d
drwlp2
	out (#fc),a
	push hl
	pop hl
	dec a
	jr nz,drwlp2
	ld e,d
drwlp3
	in a,(#fc)
	push hl
	pop hl
	dec e
	jr nz,drwlp3
	sll d
	jr nc,drlp2

	jr drumret
	
musicdata
	include "music.asm"
musicend
	
 	org #4388			;432E geht noch

notetab
 	dw #100, #10F, #11F, #130, #143, #156, #16A, #180, #196, #1AF, #1C8, #1E3	;#01-#0c
 	dw #200, #21E, #23F, #261, #285, #2AB, #2D4, #2FF, #32D, #35D, #390, #3C6	;-#18
 	dw #400, #43D, #47D, #4C2, #50A, #557, #5A8, #5FE, #659, #6BA, #720, #78D	;-#24
 	dw #800, #879, #8FA, #983, #A14, #AAD, #B50, #BFC, #CB2, #D74, #E41, #F19	;-#30
 	dw 0		;silence							;#31

;***************************************************************** 
 
line10
 
;- Display file --------------------------------------------
 
dfile				;harharhar
	jp init
 
var
	db #80		;2 bytes, actually!
 
;- End of program area ----------------------------
			;STACK GOES HERE!
last

IF (musicend > notetab)
.warning music data too large
ENDIF