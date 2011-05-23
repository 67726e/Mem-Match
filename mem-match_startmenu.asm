;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Start Menu loop/init code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START_MENU:
	lda #$00
	sta $2000				; Disable NMI & sprites pattern table
	sta $2001				; Disable background/sprite rendering
	jsr CLEAR_BACKGROUND	; Clear all background
	jsr CLEAR_SPRITES		; Remove all sprites from screen

	mov load_length, #$04					; Assign a length of 4 bytes to write
	ld_2006 $228E
	ld_point background_read, START_EASY 	; Read from START_EASY
	jsr LOAD_BACKGROUND

	mov load_length, #$06					; Assign a length of 6 bytes to write
	ld_2006 $22CE
	ld_point background_read, START_MEDIUM 	; Read from START_MEDIUM
	jsr LOAD_BACKGROUND

	mov load_length, #$04					; Assign a length of 4 bytes to write
	ld_2006 $230E
	ld_point background_read, START_HARD 	; Read from START_HARD
	jsr LOAD_BACKGROUND

	mov load_length, #$04
	ld_point sprite_read, START_SPRITE_TABLE 
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
	jsr WAIT_VBLANK

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
	
	lda DMA					; Get the "selector" Y
	clc
	adc #$10					; Add 16 to it
	cmp #$d0					; Check if below final option
	bne START_SELECT0			; We gotta fix if yes
	sec
	sbc #$30					; Subtract 48 otherwise; top of menu
START_SELECT0:
	sta DMA					; Otherwise we are good
	jmp START_START

START_SELECT_RELEASED:
	lda #$00					; Set select as released
	sta select_pressed

START_START:
	lda $4016
	and #$01
	beq START_UP
	lda DMA 				; Get menu position
	sec
	sbc START_SPRITE_TABLE 	; Subtract starting offset
	sta game_diff			; Store for game loop to read
	jmp GAME_LOOP			; Change module

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