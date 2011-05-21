;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pause menu module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PAUSE_MENU:

PAUSE_MENU0:
	lda timer
	beq PAUSE_MENU0

	jmp PAUSE_MENU0