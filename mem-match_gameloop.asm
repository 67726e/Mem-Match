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
	
	lda #$05								; Assign a length of 5 bytes to write
	sta load_length
	lda $2002
	lda #high($228E)
	sta $2006
	lda #low($228E)
	sta $2006

	ld_point GAME_START, background_read	; Read from GAME_START
	jsr LOAD_BACKGROUND
	
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
	lda #$00
	sta timer

	jmp GAME_LOOP0