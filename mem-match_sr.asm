;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SubRoutine module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----- Load Palette Data -----;
LOAD_PALETTE:
	LDX $2002			; Read the PPU status to reset the latch
	LDA #$3F
	STA $2006			; Set the low byte $3F(00) of the address
	LDA #$00
	STA $2006			; Set the high byte of $(3F)00 of the address
	LDX #$00
LOAD_PALETTE1:
	LDA palette, x
	STA $2007
	INX
	CPX #$20
	BNE LOAD_PALETTE1
	RTS

;----- Load Attribute Data -----;
LOAD_ATTRIBUTE
	LDA $2002			; Read PPU status to reset the latch
	LDA #$23
	STA $2006			; Write high byte $(23)C0 of address
	LDA #$C0
	STA $2006			; Write low byte $23(C0) of address
	LDX #$00
LOAD_ATTRIBUTE0:
	LDA attribute, x
	STA $2007
	INX
	CPX #$40
	BNE LOAD_ATTRIBUTE0
	RTS
