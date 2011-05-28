;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pause menu module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PAUSE_MENU:
	lda #$00
	sta $2000				; Disable NMI & sprites pattern table
	sta $2001				; Disable background/sprite rendering
	jsr CLEAR_BACKGROUND	; Clear all background
	jsr CLEAR_SPRITES		; Remove all sprites from screen

	; TODO: Initial background/sprite writing

	lda #$00
	STA $2005				; Set X coordinate to 0
	STA $2005				; Set Y coordinate to 0

	lda #%10010000			; Enable NMI, sprites from Pattern Table 0
	sta $2000
	lda #%00011110			; Enable sprites
	sta $2001

PAUSE_MENU0:
	lda timer
	beq PAUSE_MENU0
	dec timer	;only ever set to 1, so this resets

	jmp PAUSE_MENU0