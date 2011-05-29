;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Declare & Initiate all variables in this file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.rsset $0000
temp			.rs 1			; Holds data used short term
timer			.rs 1			; Holds the flag used to determine if a loop can continue iterate
palette			.rs 2			; Holds address of the palette table to be loaded
attribute		.rs 2			; Holds address of the attribute table to be loaded
name_table		.rs 2			; Holds address of the name table to be loaded
load_length 	.rs 1			; Number of bytes to load in a load subroutine
background_read	.rs 2			; Holds address of the background bytes to be loaded
background_write .rs 2			; Holds address of the name table location to write to
sprite_read		.rs 2			; Holds Address of the sprite bytes to be loaded
game_diff		.rs 1			; Game difficulty
gen_pointer		.rs 2			; General pointer holder

select_pressed	.rs 1			; Button status
start_pressed	.rs 1
a_pressed		.rs 1
b_pressed		.rs 1
left_pressed	.rs 1
right_pressed	.rs 1
up_pressed		.rs 1
down_pressed	.rs 1

selector_move_x	.rs 1			; How fast to move in a give direction
selector_move_y	.rs 1			; Two's complement for left and up
selector_count	.rs 1			; Number of times to move

card_table		.rs 8 * 7		; Max table size = 8*7

mask			.rs 1			; bit mask for LFSR
rand_gen_l		.rs 1
rand_gen_h		.rs 1

;should functions have a file?
SPRITE .func DMA +((\1) *4)		; Take a sprite number, returns address