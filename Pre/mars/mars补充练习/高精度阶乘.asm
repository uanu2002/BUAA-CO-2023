.data
a: .word 0:200


str_space: .asciiz " "
str_enter: .asciiz "\n"

.macro get_index(%ans, %i, %j, %n, %m)
	mult %i, %m
	mflo %ans
	add %ans, %ans, %j
	sll %ans, 2
.end_macro

.macro read_int(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.macro read_char(%ans)
	li $v0, 12
	syscall
	move %ans, $v0
.end_macro

.macro print_int(%ans)
	move $a0, %ans
	li $v0, 1
	syscall
.end_macro

.macro print_str(%ans)
	la $a0, %ans
	li $v0, 4
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



.text
read_int($s0) # n
li $s1, 0 # l
li $t0, 1
sw $t0, a($zero)

li $t0, 1
for1i:
	bgt $t0, $s0, for1i_end
	
	li $a1, 0 # s
	li $t1, 0 # j
	for1j:
		bgt $t1, $s1, for1j_end
		sll $t3, $t1, 2
		lw $t2, a($t3)
		mul $t2, $t2, $t0
		add $a1, $a1, $t2
		li $a2, 10
		div $a1, $a2
		mfhi $a2
		sw $a2, a($t3)
		mflo $a2
		move $a1, $a2

		addi $t1, $t1, 1
		j for1j
	for1j_end:
	while:
		beq $a1, 0, while_end
		addi $s1, $s1, 1
		sll $t3, $s1, 2
		li $a2, 10
		div $a1, $a2
		mfhi $a2
		sw $a2, a($t3)
		mflo $a2
		move $a1, $a2
		j while
	while_end:
	addi $t0, $t0, 1
	j for1i
for1i_end:

move $t0, $s1
printloop:
	blt $t0, 0, printloop_end
	sll $t1, $t0, 2
	lw $t1, a($t1)
	print_int($t1)
	subi $t0, $t0, 1
	j printloop
printloop_end:














