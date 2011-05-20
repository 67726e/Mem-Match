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

;----- Start Menu -----;
STARTMENU:
	.include "mem-match_startmenu.asm"

;----- Game Loop -----;
GAMELOOP:	
	.include "mem-match_gameloop.asm"
	
;----- Game Over -----;
GAMEOVER:	
	.include "mem-match_gameover.asm"
	
;----- Pause Menu -----;
PAUSEMENU:
	.include "mem-match_pausemenu.asm"
	

;----- NMI Interrupt -----;
NMI:
	LDA #$00
	STA $2003			; Store low byte $02(00) of RAM address
	LDA #$02
	STA $4014			; Store high byte $(02)00 of RAM address

	RTI					; NMI Over, Return

;----- Generic Data -----;
	.include "mem-test_data.asm"
	
;----- Setup Addresses -----;
	.org $FFFA
	.dw NMI				; NMI Address
	.dw RESET			; RESET Address
	.dw 0				; Disable external interrupt

;----- Graphics Data -----;
	.bank 2
	.org $0000
	.incbin "mem-match.chr"