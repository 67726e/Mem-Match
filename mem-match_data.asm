;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Holds general data e.g. palette, background
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.bank 1
	.org $E000

PALETTE:
	.db $0F,$30,$0F,$01, $0F,$30,$0F,$01, $0F,$30,$0F,$01, $0F,$30,$0F,$01
	.db $0F,$30,$0F,$01, $0F,$30,$0F,$01, $0F,$30,$0F,$01, $0F,$30,$0F,$01

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
	
GAME_START:
	.db $1c, $1d, $0a, $1b, $1d
GAME_SPRITE_TABLE:
	;  Vert Tile# Attr Horiz
	.db $80, $01, $00, $80
	.db $80, $02, $00, $88
	.db $80, $01, (1<<h_flip), $90
	.db $88, $03, $00, $80
	.db $88, $03, (1<<h_flip), $90
	.db $90, $01, (1<<v_flip), $80
	.db $90, $02, (1<<v_flip), $88
	.db $90, $01, (1<<h_flip)|(1<<v_flip), $90
	
