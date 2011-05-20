;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SubRoutine module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----- Load Palette Data -----;
LOAD_PALETTE_BG:
	ldx $2002			; Read the PPU status to reset the latch
	lda #$3F
	sta $2006			; Set the low byte $3F(00) of the address
	lda #$00
	sta $2006			; Set the high byte of $(3F)00 of the address
	jmp LOAD_PALETTE

LOAD_PALETTE_SP:
	ldx $2002
	lda #$3F
	sta $2006
	lda #$10
	sta $2006

LOAD_PALETTE:
	ldx #$00
LOAD_PALETTE0:
	lda palette, x
	sta $2007
	inx
	cpx #$10			;Writes only BG or Sprite (16 each)
	bne LOAD_PALETTE0
	rts

;----- Load Attribute Data -----;
LOAD_ATTRIBUTE_0:
	lda $2002			; Read PPU status to reset the latch
	lda #$23
	sta $2006			; Write high byte $(23)C0 of address
	lda #$C0
	sta $2006			; Write low byte $23(C0) of address
	jmp LOAD_ATTRIBUTE

LOAD_ATTRIBUTE_1:
	lda $2002
	lda #$27
	sta $2006
	lda #$C0
	sta $2006
	jmp LOAD_ATTRIBUTE

LOAD_ATTRIBUTE_2:
	lda $2002
	lda #$2B
	sta $2006
	lda #$C0
	sta $2006
	jmp LOAD_ATTRIBUTE
	
LOAD_ATTRIBUTE_3:
	lda $2002
	lda #$2F
	sta $2006
	lda #$C0
	sta $2006
	
LOAD_ATTRIBUTE:
	ldx #$00
LOAD_ATTRIBUTE0:
	lda attribute, x
	sta $2007
	inx
	cpx #$40
	bne LOAD_ATTRIBUTE0
	rts

;----- Load Name Table Data -----;
	
LOAD_NAME_TABLE_0:
	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	jmp LOAD_NAME_TABLE

LOAD_NAME_TABLE_1:
	lda $2002
	lda #$24
	sta $2006
	lda #$00
	sta $2006
	jmp LOAD_NAME_TABLE
	
LOAD_NAME_TABLE_2:
	lda $2002
	lda #$28
	sta $2006
	lda #$00
	sta $2006
	jmp LOAD_NAME_TABLE
	
LOAD_NAME_TABLE_3:
	lda $2002
	lda #$30
	sta $2006
	lda #$00
	sta $2006
	jmp LOAD_NAME_TABLE
	
LOAD_NAME_TABLE:
    ldy #$00
    ldx #$04
LOAD_NAME_TABLE0:
    lda name_table,y
    sta $2007
    iny
    bne LOAD_NAME_TABLE0
	inc name_table + 1
	dex
	bne LOAD_NAME_TABLE0
	rts
	