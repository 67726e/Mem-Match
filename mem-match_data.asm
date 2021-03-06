;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Holds general data e.g. palette, background
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.bank 1
	.org $E000

PALETTE:
	.db $0F,$30,$21,$01, $0F,$30,$21,$01, $0F,$30,$21,$01, $0F,$30,$21,$01
	.db $0F,$30,$21,$01, $0F,$30,$21,$01, $0F,$30,$21,$01, $0F,$30,$21,$01

START_EASY:
	.db $0E,$0A,$1C,$22
START_MEDIUM:
	.db $16,$0E,$0D,$12,$1E,$16
START_HARD:
	.db $11,$0A,$1B,$0D
START_SPRITE_TABLE:
	;  Vert Tile# Attr Horiz
	.db $A0, $00, $00, $60
	
	;Should constants have their own file?
	h_flip: .equ 6 ;sprite attribute bit positions
	v_flip: .equ 7
	
	DMA:	.equ $0200	; Sprite DMA page

GAME_SPRITE_TABLE:
	;  Vert Tile# Attr Horiz
	.db $08, $01, $00, $04
	.db $08, $02, $00, $0c
	.db $08, $01, (1<<h_flip), $14
	.db $10, $03, $00, $04
	.db $10, $03, (1<<h_flip), $14
	.db $18, $01, (1<<v_flip), $04
	.db $18, $02, (1<<v_flip), $0c
	.db $18, $01, (1<<h_flip)|(1<<v_flip), $14
	
CARD_POS1:
	.db  0,  1,  2,  3,  4,  5,  6,  7
	.db  8,  9, 10, 11, 12, 13, 14, 15
	.db  17,  19, 21, 23, 24, 26, 28, 30
	;.db 32, 33, 34, 35, 36, 37, 38, 39

CARD_NUMBER:
	.db 24 ;number of bytes in card position table