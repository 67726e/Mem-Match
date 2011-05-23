;----- Macros -----;
	.macro ld_point	;loads a destination, pointer source
		lda #low(\2)
		sta \1
		lda #high(\2)
		sta \1 + 1
	.endm
	
	.macro ld_2006	;puts an address into $2006
		lda $2002
		lda #high(\1)
		sta $2006
		lda #low(\1)
		sta $2006
	.endm
	
	.macro mov	;destination, source
		lda \2
		sta \1
	.endm

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
	
	txa ;X is still 0

CLRMEM:
	sta $0000, x
	sta $0100, x
	sta $0200, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	inx
	bne CLRMEM

VWAIT2:
	bit $2002
	bpl VWAIT2
	
	jsr CLEAR_BACKGROUND
	
;	ld_point name_table, name_table_file
;	jsr LOAD_NAME_TABLE_0

	ld_point palette, PALETTE 
	jsr LOAD_PALETTE_BG

	ld_point palette, (PALETTE + 10)
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
	lda #low(DMA)
	sta $2003			; Store low byte $02(00) of RAM address
	lda #high(DMA)
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