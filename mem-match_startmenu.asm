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

	lda #$04
	sta load_length
	ld_point START_SPRITE_TABLE, sprite_read
	jsr LOAD_SPRITES

	lda #$00
	STA $2005				; Set X coordinate to 0
	STA $2005				; Set Y coordinate to 0

	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	lda #%00011110			; Enable sprites
	sta $2001

	;----- Pause Menu Module -----;
START_MENU_WAIT:
	lda timer
	beq START_MENU_WAIT
	lda #$00
	sta timer

	;----- Read Controllers -----;
	lda #$01
	sta $4016
	lda #$00
	sta $4016

START_A:
	lda $4016
	and #$01
	beq START_B

START_B:
	lda $4016
	and #$01
	beq START_SELECT

START_SELECT:
	lda $4016
	and #$01
	beq START_SELECT_RELEASED	; Select is not pressed
	ldx select_pressed			; Load select pressed status
	bne START_START				; If pressed (not 0), we're done here
	inx
	stx select_pressed			; Otherwise set select_pressed to 1 (pressed)
	
	lda $0200					; Get the "selector" Y
	clc
	adc #$10					; Add 16 to it
	cmp #$d0					; Check if below final option
	beq START_SELECT0			; We gotta fix if yes
	sta $0200					; Otherwise we are good
	jmp START_START
START_SELECT0:
	sec
	sbc #$30					; Subtract 48 otherwise; top of menu
	sta $0200
	jmp START_START
START_SELECT_RELEASED:
	lda #$00					; Set select as released
	sta select_pressed

START_START:
	lda $4016
	and #$01
	beq START_UP

START_UP:
	lda $4016
	and #$01
	beq START_DOWN

START_DOWN:
	lda $4016
	and #$01
	beq START_LEFT

START_LEFT:
	lda $4016
	and #$01
	beq START_RIGHT

START_RIGHT:
	lda $4016
	and #$01
	beq START_CONTROL_END

START_CONTROL_END:
	;----- End Controller Control -----;
	jmp START_MENU_WAIT