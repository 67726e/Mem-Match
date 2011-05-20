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
	SEI				; Disable IRQ
	CLD				; Disable decimal
	LDX #$40
	STX $4017		; Disable APU IRQ
	LDX #$FF
	TXS				; Setup stack
	INX				; X = 0
	STX $2000		; Disable NMI
	STX $2001		; Disable rendering
	STX $4010		; Disable DMC IRQ

VWAIT:
	BIT $2002
	BPL VWAIT

CLRMEM:
	LDA #$00
	STA $0000, x
	STA $0100, x
	STA $0200, x
	STA $0300, x
	STA $0400, x
	STA $0500, x
	STA $0600, x
	STA $0700, x
	LDA #$FE
	STA $0200, x
	INX
	BNE CLRMEM

VWAIT2:
	BIT $2002
	BPL VWAIT2

;----- Load Palette Data -----;
	LDX $2002			; Read the PPU status to reset the latch
	LDA #$3F
	STA $2006			; Set the low byte $3F(00) of the address
	LDA #$00
	STA $2006			; Set the high byte of $(3F)00 of the address
	LDX #$00
LOAD_PALETTE:
	LDA PALETTE, x
	STA $2007
	INX
	CPX #$20
	BNE LOAD_PALETTE
	
;----- Load Attribute Data -----;
	LDA $2002			; Read PPU status to reset the latch
	LDA #$23
	STA $2006			; Write high byte $(23)C0 of address
	LDA #$C0
	STA $2006			; Write low byte $23(C0) of address
	LDX #$00
LOAD_ATTRIBUTE:
	LDA Attribute
	STA $2007
	INX
	CPX #$40
	BNE LOAD_ATTRIBUTE
	
;----- Start Menu -----;
START_MENU:
	.include "mem-match_startmenu.asm"

;----- Game Loop -----;
GAME_LOOP:	
	.include "mem-match_gameloop.asm"
	
;----- Game Over -----;
GAME_OVER:	
	.include "mem-match_gameover.asm"
	
;----- Pause Menu -----;
PAUSE_MENU:
	.include "mem-match_pausemenu.asm"
	

;----- NMI Interrupt -----;
NMI:
	LDA #$00
	STA $2003			; Store low byte $02(00) of RAM address
	LDA #$02
	STA $4014			; Store high byte $(02)00 of RAM address

	INC timer			; Set the flag to allow another module iteration
	
	RTI					; NMI Over, Return

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