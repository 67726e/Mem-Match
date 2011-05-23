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
	

	
GAME_LOOP_WAIT:
	lda timer
	beq GAME_LOOP_WAIT
	dec timer	;only ever set to 1, so this resets
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
	dec DMA
	jsr MOVE_SELECTOR
GAME_DOWN:
	lda $4016
	and #$01
	beq GAME_LEFT
	inc DMA
	jsr MOVE_SELECTOR
GAME_LEFT:
	lda $4016
	and #$01
	beq GAME_RIGHT
	dec DMA + 3
	jsr MOVE_SELECTOR
GAME_RIGHT:
	lda $4016
	and #$01
	beq GAME_CONTROL_END
	inc DMA + 3
	jsr MOVE_SELECTOR
GAME_CONTROL_END:

	jmp GAME_LOOP_WAIT