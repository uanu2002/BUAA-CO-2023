.data

char_A: .byte 'A'
char_B: .byte 'B'
char_C: .byte 'C'
str_enter: .asciiz "\n"
str_space: .asciiz " "
str_move: .asciiz "move disk "
str_from: .asciiz " from "
str_to: .asciiz " to "
.macro get_index(%ans, %i, %j, %n, %m)
	mult %i, %m
	mflo %ans
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.macro read_int(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.macro print_int(%ans)
	move $a0, %ans
	li $v0, 1
	syscall
.end_macro

.macro push(%ans)
	sw %ans, 0($sp)
	subi $sp, $sp, 4
.end_macro

.macro pop(%ans)
	addi $sp, $sp, 4
	lw %ans, 0($sp)
.end_macro

.macro load_char(%ans, %var)
	la %ans, %var
	lb %ans, 0(%ans)
.end_macro

.macro movep(%id, %from, %to)
	la $a0, str_move
	li $v0, 4
	syscall
	print_int(%id)
	la $a0, str_from
	li $v0, 4
	syscall
	# load_char($a0, %from)
	move $a0, %from
	li $v0, 11
	syscall
	la $a0, str_to
	li $v0, 4
	syscall
	# load_char($a0, %from)
	move $a0, %to
	li $v0, 11
	syscall
	la $a0, str_enter
	li $v0, 4
	syscall
.end_macro

.text

read_int($s0) # n
move $s2, $s0 # base
load_char($a1, char_A) # from
load_char($a2, char_B) # via
load_char($a3, char_C) # to
jal hanoi

li $v0, 10
syscall

hanoi:
	push($ra)
	bne $s2, $zero, ifbase0_end
	movep($s2, $a1, $a2)
	movep($s2, $a2, $a3)
	pop($ra)
	jr $ra
	ifbase0_end:
	
	push($s2)
	subi $s2, $s2, 1
	jal hanoi
	pop($s2)
	movep($s2, $a1, $a2)
	
	push($s2)
	push($a1)
	push($a3)
	subi $s2, $s2, 1
	move $t5, $a1
	move $a1, $a3
	move $a3, $t5
	jal hanoi
	pop($a3)
	pop($a1)
	pop($s2)
	movep($s2, $a2, $a3)
	push($s2)
	subi $s2, $s2, 1
	jal hanoi
	pop($s2)
	pop($ra)
	jr $ra


