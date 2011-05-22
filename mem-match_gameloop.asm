;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Game loop module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GAME_LOOP:
	lda #$00
	sta $2000				; Disable NMI & sprites pattern table
	sta $2001				; Disable background/sprite rendering
	jsr CLEAR_BACKGROUND	; Clear all background
	jsr CLEAR_SPRITES		; Remove all sprites from screen

	; TODO: Initial background/sprite writing
		
	mov load_length, #$05					; Assign a length of 5 bytes to write
	ld_2006 $228E
	ld_point background_read, GAME_START 	; Read from GAME_START
	jsr LOAD_BACKGROUND
	
	mov load_length, #$20
	ld_point sprite_read, GAME_SPRITE_TABLE
	jsr LOAD_SPRITES
	
	;set up cards
	lda #$00
	ldx #$10
STORE_CARDS:
	sta card_table, x
	dex
	txa
	bne STORE_CARDS
	
	jsr LOAD_CARDS
	
	lda #$00
	STA $2005				; Set X coordinate to 0
	STA $2005				; Set Y coordinate to 0
	
	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	lda #%00011110			; Enable sprites
	sta $2001
	

	
GAME_LOOP0:
	lda timer
	beq GAME_LOOP0
	dec timer	;only ever set to 1, so this resets

	jmp GAME_LOOP0