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

	lda #$01
	sta grid_y				; Set off the grid y position at 1
	
	lda #$05
	sta grid_height			; Store the # of rows used for the match
	
	mov load_length, #$20
	ld_point sprite_read, GAME_SPRITE_TABLE
	jsr LOAD_SPRITES
	

	ldx grid_height
grid_mul_loop:			;calculate grid size
	beq grid_mul_done
	clc
	lda grid_h_temp
	adc #8
	sta grid_h_temp
	dex
	jmp grid_mul_loop
grid_mul_done:

	lda #$03		;set selector position
	sta DMA
	lda #$04
	sta DMA + 3
	jsr MOVE_SELECTOR

	ldx grid_h_temp ;number of cards to load
	
CARD_LOADER:
	lda #$01
	sta $4016
	lda #$00
	sta $4016
	lda $4016
	lda $4016
	lda $4016
	lda $4016
	and #$01
	beq CARD_LOADER0	;for a little more variance-
	jsr RAND_ROL0		;shift when start is held
CARD_LOADER0:	
	lda #low($2021)		;load pointer
	sta name_table
	lda #high($2021)
	sta name_table + 1
	
	jsr RAND_ROL0
	lda rand_gen_h		;combine low and high values
	asl A
	eor rand_gen_l
	lsr A
CARD_LOADER1:
	cmp grid_h_temp		;make sure our number is a valid-
	bcc CARD_LOADER2	;card position
	sec
	sbc grid_h_temp		;if too large subtract max
	jmp CARD_LOADER1
CARD_LOADER2:
	tay					;make sure the position is free
	lda card_table,y
	cmp #0
	bne CARD_LOADER0
	tya
	
	pha					;push our card#
	
	sta temp			;swap x and a
	txa
	ldx temp
	sta card_table, x
	tax
	lda temp

	lsr	A				;div 8 for row#
	lsr A
	lsr A
	tay
CARD_LOADER3:
	beq CARD_LOADER4	;setup screen position
	clc
	lda name_table
	adc #$60			;row
	sta name_table
	lda name_table + 1
	adc #$00
	sta name_table + 1
	dey
	jmp CARD_LOADER3
CARD_LOADER4:
	
	pla					;pop our card#
	
	asl A 				;multiply by 4
	asl A
	;vals are smaller than 64, so asl clears carry
	adc name_table
	sta name_table
	lda #$00
	adc name_table + 1	;store carry
	sta name_table + 1
	
	txa 				;push x so load card doesn't overwrite
	pha
	jsr LOAD_CARD
	pla
	tax
	dex
	beq CARD_LOADER_DONE
	jmp CARD_LOADER
CARD_LOADER_DONE:
;-------------------------------------------------------
	
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
	;lda DMA+3			;get x coord
	lda SPRITE(1)+3		;get x coord
	lsr A				;turn them into table values
	lsr A
	lsr A
	lsr A
	lsr A
	sta temp
	lda SPRITE(1)		;get y coord

	lsr A
	lsr A
	clc
	adc temp
	tax
	lda card_table, x	;grab the number from the table
	beq GAME_B
	clc
	adc #$10
	;sta DMA+1			;show a sprite
	sta SPRITE(8)+1			;show a sprite
	lda SPRITE(1)+3
	sta SPRITE(8)+3
	lda SPRITE(3)
	sta SPRITE(8)
	lda #$00
	sta SPRITE(8)+2
	
	
	

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
	
	lda grid_y				; Get the current Y coordinate
	cmp #$01				; If 1, at the top, can't go further
	beq GAME_DOWN
	dec grid_y				; Otherwise we can go up, decrement the counter

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
	
	lda grid_y				; Get current Y cooridnate
	cmp grid_height			; Compare to the grid height limit
	beq GAME_LEFT
	inc grid_y				; Otherwise we can still go down, do so
	
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