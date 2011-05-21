;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Start Menu loop/init code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START_MENU:
	lda #$00
	sta $2000				; Disable NMI & sprites pattern table
	sta $2001				; Disable background/sprite rendering
	jsr CLEAR_BACKGROUND	; Clear all background
	jsr CLEAR_SPRITES		; Remove all sprites from screen

	lda #$04								; Assign a length of 4 bytes to write
	sta load_length
	ld_point $228E, background_write		; Assign write-to address
	ld_point START_EASY, background_read	; Read from START_EASY
	jsr LOAD_BACKGROUND

	lda #$06								; Assign a length of 6 bytes to write
	sta load_length
	ld_point $22CE, background_write		; Write 2 lines below above line
	ld_point START_MEDIUM, background_read	; Read from START_MEDIUM
	jsr LOAD_BACKGROUND

	lda #$04								; Assign a length of 4 bytes to write
	sta load_length
	ld_point $230E, background_write		; Write 2 lines below above line
	ld_point START_HARD, background_read	; Read from START_HARD
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