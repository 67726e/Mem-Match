;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SubRoutine module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----- Clear Background -----;
CLEAR_BACKGROUND:
	ld_2006 $2000
	lda #$24				; Assign A with the blank tile value
	ldx #$00				; Clear X
	ldy #$00				; Clear Y
CLEAR_BACKGROUND0:
	sta $2007				; Write blank tile to $2007 (background)
	inx
	cpx #$F8				; Compare X with 248
	bne CLEAR_BACKGROUND0	; If not 240, keep going
	ldx #$00				; Clear X
	iny
	cpy #$08				; Compare Y with 8
	bne CLEAR_BACKGROUND0	; If not 4, keep going
	lda #$00
	sta $2005				; Write 0 to $2005 twice to reset the X/Y
	sta $2005				; Coordinates to 0, 0
	rts

;----- Load Background x Times -----;
LOAD_BACKGROUND:
	ldy #$00
	ldx load_length			; Load # of bytes to load
LOAD_BACKGROUND0:
	lda [background_read],y
	sta $2007
	iny
	dex
	bne LOAD_BACKGROUND0
	rts

;----- Clear Sprite RAM -----;
CLEAR_SPRITES:
	lda #$FF
	ldx #$FF
CLEAR_SPRITES0:
	sta $0200, x
	dex
	bne CLEAR_SPRITES0
	rts

;----- Load Sprites Into RAM -----;
LOAD_SPRITES:
	lda sprite_read
	ldx load_length
	ldy #$00
LOAD_SPRITES0:
	lda [sprite_read], y
	sta $0200, y
	iny
	dex
	bne LOAD_SPRITES0
	rts
	
;----- Load Palette Data -----;
LOAD_PALETTE_BG:
	ld_2006 $3f00
	jmp LOAD_PALETTE

LOAD_PALETTE_SP:
	ld_2006 $3f10

LOAD_PALETTE:
	ldy #$00
LOAD_PALETTE0:
	lda [palette], y
	sta $2007
	iny
	cpy #$10			;Writes only BG or Sprite (16 each)
	bne LOAD_PALETTE0
	rts

;----- Load Attribute Data -----;
LOAD_ATTRIBUTE_0:
	ld_2006 $23c0
	jmp LOAD_ATTRIBUTE

LOAD_ATTRIBUTE_1:
	ld_2006 $27c0
	jmp LOAD_ATTRIBUTE

LOAD_ATTRIBUTE_2:
	ld_2006 $2bc0
	jmp LOAD_ATTRIBUTE

LOAD_ATTRIBUTE_3:
	ld_2006 $2fc0

LOAD_ATTRIBUTE:
	ldy #$40
LOAD_ATTRIBUTE0:
	lda [attribute], y
	sta $2007
	dey
	bne LOAD_ATTRIBUTE0
	rts

;----- Load Name Table Data -----;

LOAD_NAME_TABLE_0:
	ld_2006 $2000
	jmp LOAD_NAME_TABLE

LOAD_NAME_TABLE_1:
	ld_2006 $2400
	jmp LOAD_NAME_TABLE

LOAD_NAME_TABLE_2:
	ld_2006 $2800
	jmp LOAD_NAME_TABLE

LOAD_NAME_TABLE_3:
	ld_2006 $3000
	jmp LOAD_NAME_TABLE

LOAD_NAME_TABLE:
    ldy #$00
    ldx load_length
LOAD_NAME_TABLE0:
    lda [name_table],y
    sta $2007
    iny
    bne LOAD_NAME_TABLE0
	inc name_table + 1
	dex
	bne LOAD_NAME_TABLE0
	rts

;----- Load Cards -----;

LOAD_CARDS:
	lda game_diff 	;load table size
	;work out number of times to loop
	tax				;dec x for count
	ldy #$00 		;inc y for indexing
	ld_point name_table, card_table
	ld_2006 $2000
LOAD_CARDS0:		;start writing to bg
	lda card_table, y
	sta $2007
	lda name_table
	clc
	adc #$10		;spacing between cards?
	sta name_table
	bcc LOAD_CARDS1
	inc name_table + 1
LOAD_CARDS1:
	lda $2002
	lda name_table
	sta $2006
	lda name_table + 1
	sta $2006
	iny
	dex
	bne LOAD_CARDS0
	rts
	
