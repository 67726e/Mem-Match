;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Holds all macros for Mem-Match
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.macro ld_point	;loads a pointer source, destination
	lda low(\1)
	sta \2
	lda high(\1)
	sta \2 + 1
.endm
