;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Declare & Initiate all variables in this file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.rsset $0000
timer		.rs 1			; Holds the flag used to determine if a loop can continue iterate
palette		.rs 2			; Holds address of the palette table to be loaded
attribute	.rs 2			; Holds address of the attribute table to be loaded