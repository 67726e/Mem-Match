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
	lda $2002
	lda #high($228E)
	sta $2006
	lda #low($228E)
	sta $2006
	
	ld_point START_EASY, background_read	; Read from START_EASY
	jsr LOAD_BACKGROUND

	lda #$06								; Assign a length of 6 bytes to write
	sta load_length
	lda $2002
	lda #high($22CE)
	sta $2006
	lda #low($22CE)
	sta $2006
	ld_point START_MEDIUM, background_read	; Read from START_MEDIUM
	jsr LOAD_BACKGROUND

	lda #$04								; Assign a length of 4 bytes to write
	sta load_length
	lda $2002
	lda #high($230E)
	sta $2006
	lda #low($230E)
	sta $2006
	ld_point START_HARD, background_read	; Read from START_HARD
	jsr LOAD_BACKGROUND
	
	lda #$00
	STA $2005				; Set X coordinate to 0
	STA $2005				; Set Y coordinate to 0
	
	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	lda #%00011110			; Enable sprites
	sta $2001

START_MENU_WAIT:
	lda timer
	beq START_MENU_WAIT
	lda #$00
	sta timer
   
	jmp START_MENU_WAIT