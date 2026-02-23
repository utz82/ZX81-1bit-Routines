;************************************************************************************
;
; 1k2b - 2ch 1-bit music routine for unexpanded ZX81 (best used with "loud" tape mod)
;   by utz 03'2015 * www.irrlichtproject.de
;
; Super Maxi Load adaptation and new music
;   by stevexyz 02'2026 * https://github.com/stevexyz/ZX81-1bit-Routines
;
;************************************************************************************

  org $4000

; main routine
init
    di ; needed? (NMI is already off via hw mask, are standard interrupt a problem?)

reinit
    ld hl,musicdata     ;3      ;init pointer to song data
    push hl             ;1
selectptn                       ;select pattern
    pop hl              ;1
    ld e,(hl)           ;1      ;load lo byte of sequence pointer
    inc hl              ;1
    ld d,(hl)           ;1      ;load hi byte of sequence pointer - ptn pointer now in de
    inc hl              ;1
    ld a,d              ;1      ;check for end marker
    or e                ;1
    jr z,reinit         ;1      ;loop if end marker found
    push hl             ;1      ;save sequence pointer
    push de             ;1      ;save ptn pointer
    jr rdnotes          ;2 = 16b

playnote                    
switch1 equ $+1                     ;output switch ch1
    out (c),a           ;12     ;in (c),a = ED 78, out (c),a = ED 79
                               
base1 equ $+1                   
    ld hl,0             ;10     ;base counter value ch1
    add hl,de           ;11     ;calculate current counter
    ex de,hl            ;4      ;preserve current counter val in de
    jr nc,skip1         ;12/7

    ld hl,switch1       ;10 ;3
    ld a,(hl)           ;7  ;1  ;toggle IN/OUT
    xor b               ;4  ;1
    ld (hl),a           ;7  ;1
    ld a,c              ;4  ;1  ;toggle between #ff and #fe
    xor b               ;4  ;1
    ld c,a              ;4  ;1
                        ;40t    ;9b 
skip1
    exx                 ;switch to alt register set
    
switch2 equ $+1
    out (c),a           ;in (c),a = ED 78, out (c),a = ED 79
    
base2 equ $+1
    ld hl,0             ;base counter val ch2
    add hl,sp           ;calculate current counter ch2
    ld sp,hl            ;preserve current counter val in sp
    jr nc,skip2

    ex af,af'           ;4      ;toggle IN/OUT, af' holds a copy of (switch2)
    xor b               ;4
    ld (switch2),a      ;13
    ex af,af'           ;4

    ld a,c              ;4      ;toggle between #ff and #fe
    xor b               ;4
    ld c,a              ;4
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

rdnotes
    pop de              ;retrieve ptn pointer
    ld a,(de)           ;get note val ch1
    or a                ;check for end marker
    jr z,selectptn      ;if end marker is found, select next entry in pnt sequence
    
    ld hl,notetab-2     ;init pointer to frequency LUT
    rla                 ;A=A*2, carry is reset from previous or op
    exx
    ld de,speed         ;prep speed counter
    jr nc,rdskip1       ;check if half speed should be used
    sla d               ;adjust speed counter if necessary
rdskip1 
    exx
    add a,l             ;calculate offset
    ld l,a
    ld a,(hl)           ;get frequency val
    ld (base1),a        ;and store it in (base1) and (base1+1)
    inc l
    ld a,(hl)
    ld (base1+1),a
    
    inc de              ;point to note val ch2
    ld a,(de)           ;get note val ch2
    rla
    call c,drum         ;if bit 7 was set, play drum    
    ld l,LOW(notetab-2) ;reset pointer to frequency LUT (low byte #2e -2 (offset))
    add a,l
    ld l,a
    ld a,(hl)
    ld (base2),a
    inc l
    ld a,(hl)
    ld (base2+1),a

    inc de              ;point to next row
    push de             ;and preserve ptn pointer
    
    ld (oldSP),sp

    ld a,#79            ;set both channel outputs to low
    ld (switch1),a
    ld (switch2),a
    ld bc,#01ff         ;b = XOR mask, c = IN/OUT toggle
    push bc
    exx
    pop bc
    exx
    ld a,#79            ;backup of (switch2)
    ex af,af'
    jp playnote

; drum code
drum
    exx                 ;using alt register set
    bit 7,a             ;if bit 7 is still set
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
    dec d               ;adjust speed counter
    dec d
    ld e,#80
    exx
    ex af,af'
    and %01111111       ;clear bit 7 for later
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

; song data
musicdata
    include "music.asm"
musicend

    org $4392
; note frequencies parameters (should be kept all in $43xx)
notetab
    dw $100,$111,$120,$133,$140,$155,$166,$180,$199,$1AA,$1C7,$1E0 ; octave 1
    dw $200,$222,$240,$266,$280,$2AA,$2CC,$300,$333,$355,$38E,$3C0 ; octave 2
    dw $400,$444,$480,$4CC,$500,$555,$599,$600,$666,$6AA,$71C,$780 ; octave 3
    dw $800,$888,$900,$999,$A00,$AAA,$B33,$C00,$CCC,$D55,$E38,$F00 ; octave 4
    dw 0 ; silence
	; sml closure

    ;org $43F4
    ret
    nop
