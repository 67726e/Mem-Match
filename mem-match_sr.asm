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
	sta DMA, x
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
	sta DMA, y
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
	
;----- Load Card -----;
LOAD_CARD:
	;ld_point name_table, $2021
	ldx #$00
	ldy #$04 		;tabel width for indexing
LOAD_CARD0:		;start writing to bg
	lda $2002
	lda name_table + 1
	sta $2006
	lda name_table
	sta $2006
	
	lda name_table
	clc
	adc #$01
	sta name_table
	lda name_table + 1
	adc #$00
	sta name_table + 1
	
	txa
	clc
	adc #$30	;card sprite offset
	sta $2007
	inx
	dey
	cpy #02
	bne LOAD_CARD1
	;move to next line
	lda name_table
	clc
	adc #$1e
	sta name_table
	lda name_table + 1
	adc #$00
	sta name_table + 1
LOAD_CARD1:
	cpy #0
	bne LOAD_CARD0
	rts
	
	
;----- Move Selector -----;
MOVE_SELECTOR:
	lda DMA
	sta DMA + 4
	sta DMA + 8
	clc
	adc #$08
	sta DMA + 12
	sta DMA + 16
	clc
	adc #$08
	sta DMA + 20
	sta DMA + 24
	sta DMA + 28
	
	lda DMA + 3
	sta DMA + 15
	sta DMA + 23
	clc
	adc #$08
	sta DMA + 7
	sta DMA + 27
	clc
	adc #$08
	sta DMA + 11
	sta DMA + 19
	sta DMA + 31
	rts 

;----- Random Number Generator -----;
RAND_ROL_INIT:
	lda #$20 ;#%00100000
	sta mask
	lda #$01
	sta rand_gen_l
	
RAND_ROL0:
	lda rand_gen_h
	asl rand_gen_l
	rol rand_gen_h
	eor rand_gen_l
	bit mask
	beq RAND_ROL1
	inc rand_gen_l ;asl clears last bit, inc sets to 1
RAND_ROL1:
	rts

;----- Wait for Vblank -----;
WAIT_VBLANK:
	lda timer
	beq WAIT_VBLANK
	dec timer	;only ever set to 1, so this resets
	rts
	