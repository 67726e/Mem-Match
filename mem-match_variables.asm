;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Declare & Initiate all variables in this file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.rsset $0000
timer			.rs 1			; Holds the flag used to determine if a loop can continue iterate
palette			.rs 2			; Holds address of the palette table to be loaded
attribute		.rs 2			; Holds address of the attribute table to be loaded
name_table		.rs 2			; Holds address of the name table to be loaded
load_length 	.rs 1			; Number of bytes to load in a load subroutine
background_read	.rs 2			; Holds address of the background bytes to be loaded
background_write .rs 2			; Holds address of the name table location to write to
sprite_read		.rs 2			; Holds Address of the sprite bytes to be loaded

select_pressed	.rs 1			; Button status
start_pressed	.rs 1
a_pressed		.rs 1
b_pressed		.rs 1
left_pressed	.rs 1
right_pressed	.rs 1
up_pressed		.rs 1
down_pressed	.rs 1