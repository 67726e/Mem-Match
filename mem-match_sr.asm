;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SubRoutine module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----- Load Palette Data -----;
LOAD_PALETTE:
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
	LDX #$00
LOAD_ATTRIBUTE0:
	LDA attribute, x
	STA $2007
	INX
	CPX #$40
	BNE LOAD_ATTRIBUTE0
	RTS
