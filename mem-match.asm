;----- Create iNES Header -----;
	.inesprg 1	; 1x 16KB PRG
	.ineschr 1	; 1x 8KB CHR
	.inesmap 0	; NROM
	.inesmir 1	; Background mirroring

;----- Variable Declarations -----;
	.include "mem-match_variables.asm"

;----- Startup Code -----;
	.bank 0
	.org $C000
RESET:
	sei				; Disable IRQ
	cld				; Disable decimal
	ldx #$40
	stx $4017		; Disable APU IRQ
	ldx #$FF
	txs				; Setup stack
	inx				; X = 0
	stx $2000		; Disable NMI
	stx $2001		; Disable rendering
	stx $4010		; Disable DMC IRQ

VWAIT:
	BIT $2002
	BPL VWAIT

CLRMEM:
	;lda #$00
	txa ;X is still 0
	sta $0000, x
	sta $0100, x
	sta $0200, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	lda #$FE
	sta $0200, x
	inx
	bne CLRMEM

VWAIT2:
	bit $2002
	bpl VWAIT2

	.macro ld_point	;loads a pointer source, destination
		lda low(\1)
		sta \2
		lda high(\1)
		sta \2 + 1
	.endm

	JSR CLEAR_BACKGROUND
	
;	ld_point name_table_file, name_table
;	jsr LOAD_NAME_TABLE_0

	ld_point PALETTE, palette
	jsr LOAD_PALETTE_BG

	ld_point (PALETTE + 10), palette
	jsr LOAD_PALETTE_SP

;----- Start Menu -----;
	.include "mem-match_startmenu.asm"

;----- Game Loop -----;
	.include "mem-match_gameloop.asm"

;----- Game Over -----;
	.include "mem-match_gameover.asm"

;----- Pause Menu -----;
	.include "mem-match_pausemenu.asm"


;----- NMI Interrupt -----;
NMI:
	lda #$00
	sta $2003			; Store low byte $02(00) of RAM address
	lda #$02
	sta $4014			; Store high byte $(02)00 of RAM address

	lda #$01
	sta timer			; Set timer flag to allow module iteration

	rti					; NMI Over, Return

;----- Load Sub-Routines -----;
	.include "mem-match_sr.asm"

;----- Generic Data -----;
	.include "mem-match_data.asm"

;----- Setup Addresses -----;
	.org $FFFA
	.dw NMI				; NMI Address
	.dw RESET			; RESET Address
	.dw 0				; Disable external interrupt

;----- Graphics Data -----;
	.bank 2
	.org $0000
	.incbin "mem-match.chr"