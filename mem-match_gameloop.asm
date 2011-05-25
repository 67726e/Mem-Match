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
	ld_point background_read, GAME_TEST
	jsr LOAD_BACKGROUND
	
	mov load_length, #$20
	ld_point sprite_read, GAME_SPRITE_TABLE
	jsr LOAD_SPRITES
	
	lda #$83
	sta DMA
	lda #$84
	sta DMA + 3
	jsr MOVE_SELECTOR

	
;SET_CARD_VALUES:	

	ldx CARD_NUMBER
CARD_LOADER:
	lda #low($2021)
	sta name_table
	lda #high($2021)
	sta name_table + 1
	
	lda CARD_POS1 - 1, x
	lsr	A				;div 8 for row#
	lsr A
	lsr A
	tay
	iny
CARD_LOADER0:
	dey
	beq CARD_LOADER1
	clc
	lda name_table
	adc #$60			;row
	sta name_table
	lda name_table + 1
	adc #$00
	sta name_table + 1

	jmp CARD_LOADER0
CARD_LOADER1:
	
	lda CARD_POS1 - 1, x
	asl A 				;multiply by 4
	asl A
	;clc ;vals are smaller than 64, so asl clears carry
	adc name_table
	sta name_table
	lda #$00
	adc name_table + 1	;store carry
	sta name_table + 1
	
	txa ;push x
	pha
	jsr LOAD_CARD
	pla
	tax
	dex
	bne CARD_LOADER
	
	lda #$00
	sta $2005				; Set X coordinate to 0
	sta $2005				; Set Y coordinate to 0

	; fceuxd wants $2001 written first, don't know why
	lda #%00011110			; Enable sprites
	sta $2001
	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	
GAME_LOOP_WAIT:
	jsr WAIT_VBLANK
	;----- Read Controllers -----;
	lda #$01
	sta $4016
	lda #$00
	sta $4016

GAME_A:
	lda $4016
	and #$01
	beq GAME_B

GAME_B:
	lda $4016
	and #$01
	beq GAME_SELECT

GAME_SELECT:
	lda $4016
	and #$01
	beq GAME_START

GAME_START:
	lda $4016
	and #$01
	beq GAME_UP
	;store some data?
	;push return address?
	;TODO:once pause return rewrite name tables
	;jmp PAUSE_MENU

GAME_UP:
	lda $4016
	and #$01
	beq GAME_DOWN
	lda #$00
	sta selector_move_x
	lda #-2
	sta selector_move_y
	lda #$10
	sta selector_count
	jmp ANIMATION_LOOP
GAME_DOWN:
	lda $4016
	and #$01
	beq GAME_LEFT
	lda #$00
	sta selector_move_x
	lda #$02
	sta selector_move_y
	lda #$10
	sta selector_count
	jmp ANIMATION_LOOP
GAME_LEFT:
	lda $4016
	and #$01
	beq GAME_RIGHT
	lda #-2
	sta selector_move_x
	lda #$00
	sta selector_move_y
	lda #$10
	sta selector_count
	jmp ANIMATION_LOOP
GAME_RIGHT:
	lda $4016
	and #$01
	beq GAME_CONTROL_END
	lda #$02
	sta selector_move_x
	lda #$00
	sta selector_move_y
	lda #$10
	sta selector_count
	jmp ANIMATION_LOOP
GAME_CONTROL_END:

	jmp GAME_LOOP_WAIT
	
ANIMATION_LOOP:			;this locks out the controls and animates
	jsr WAIT_VBLANK
	
	lda DMA				;move the top left sprite
	clc
	adc selector_move_y
	sta DMA
	lda DMA + 3
	clc
	adc selector_move_x
	sta DMA + 3
	jsr MOVE_SELECTOR	;update the entite selector
	dec selector_count
	bne ANIMATION_LOOP
	jmp GAME_LOOP_WAIT