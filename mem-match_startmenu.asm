;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Start Menu loop/init code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START_MENU:
	lda #$00
	sta $2000				; Disable NMI & sprites pattern table
	sta $2001				; Disable background/sprite rendering
	jsr CLEAR_BACKGROUND

	lda #$04
	sta load_length
	ld_point $228E, background_write
	ld_point BACKGROUND_START, background_read
	jsr LOAD_BACKGROUND

	lda #$00
	STA $2005				; Set X coordinate to 0
	STA $2005				; Set Y coordinate to 0

	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	lda #%00011110			; Enable sprites
	sta $2001
START_MENU0:
	lda timer
	beq START_MENU0

	jmp START_MENU0