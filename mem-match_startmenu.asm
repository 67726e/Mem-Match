;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Start Menu loop/init code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START_MENU:
	lda #$00
	sta $2000				; Disable NMI & sprites pattern table
	sta $2001				; Disable background/sprite rendering
	jsr CLEAR_BACKGROUND	

	lda $2002
	lda #$2A
	sta $2006
	lda #$AE
	sta $2006
	lda #$0E
	sta $2007
	lda #$0A
	sta $2007
	lda #$1C
	sta $2007
	lda #$22
	sta $2007
	
	lda #$00
	STA $2005
	STA $2005
	
	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	lda #%00011110			; Enable sprites
	sta $2001
START_MENU0:
	lda timer
	beq START_MENU0

	jmp START_MENU0