.data
array: .word 0:200
str_enter: .asciiz "\n"
str_space: .asciiz " "

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
	

.text
main:
	read_int($s0) # n: length of array
	li $t0, 0
	readloop:
		beq $t0, $s0, readloop_end
		read_int($t1)
		get_index($t2, $zero, $t0, $zero, $s0)
		sw $t1, array($t2)
		addi $t0, $t0, 1
		j readloop
	readloop_end:
	li $s1, 0 # left
	subi $s2, $s0, 1 #right
	jal qsort
	
	li $t0, 0
	printloop:
		beq $t0, $s0, printloop_end
		get_index($t2, $zero, $t0, $zero, $s0)
		lw $t1, array($t2)
		print_int($t1)
		la $a0, str_space
		li $v0, 4
		syscall
		addi $t0, $t0, 1
		j printloop
	printloop_end:
	
	li $v0, 10
	syscall
qsort:
	push($s1)
	push($s2)
	push($ra)
	blt $s1, $s2, if0_end
	pop($ra)
	pop($s2)
	pop($s1)
	jr $ra
	if0_end:
	
	move $t1, $s1 # i
	move $t2, $s2 # j
	get_index($t3, $zero, $s1, $zero, $s0)
	lw $t3, array($t3) # pivot
	while:
		bgt $t1, $t2, while_end
		while1:
			get_index($t4, $zero, $t1, $zero, $s0)
			lw $t4, array($t4)
			bge $t4, $t3, while1_end
			addi $t1, $t1, 1
			j while1
		while1_end:
		while2:
			get_index($t4, $zero, $t2, $zero, $s0)
			lw $t5, array($t4)
			ble $t5, $t3, while2_end
			subi $t2, $t2, 1
			j while2
		while2_end:
		bgt $t1, $t2, if1_end
		swap:
			get_index($t4, $zero, $t1, $zero, $s0)
			lw $t7, array($t4)
			sw $t5, array($t4)
			get_index($t4, $zero, $t2, $zero, $s0)
			sw $t7, array($t4)
			addi $t1, $t1, 1
			subi $t2, $t2, 1
		if1_end:
		j while
	while_end:
	push($s2)
	move $s2, $t2
	push($t1)
	jal qsort
	pop($t1)
	pop($s2)
	move $s1, $t1
	jal qsort
	pop($ra)
	pop($s2)
	pop($s1)
	jr $ra

