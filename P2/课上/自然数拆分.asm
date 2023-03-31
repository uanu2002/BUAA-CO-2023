.data
a: .word 0:200


str_space: .asciiz " "
str_enter: .asciiz "\n"
str_add: .asciiz "+"
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
move $a1, $s0
li $a2, 1
jal js

li $v0, 10
syscall

js:
	push($a1)
	push($a2)
	push($ra)
	bne $a1, 0, ifs0_end
		jal print
	ifs0_end:
	li $t0, 1
	jsfor:
		bgt $t0, $a1, jsfor_end
		subi $t2, $a2, 1
		sll $t2, $t2, 2
		lw $t2, a($t2)
		bgt $t2, $t0, if1_end
		bge $t0, $s0, if1_end
		sll $t2, $a2, 2
		sw $t0, a($t2)
		sub $a1, $a1, $t0
		push($t0)
		addi $a2, $a2, 1
		jal js
		subi $a2, $a2, 1
		pop($t0)
		add $a1, $a1, $t0 
		if1_end:
		
		addi $t0, $t0, 1
		j jsfor
	jsfor_end:
	
	pop($ra)
	pop($a2)
	pop($a1)
	jr $ra
	
	
print:
	push($ra)
	li $t0, 1
	subi $t1, $a2, 1
	printloop:
		beq $t0, $t1, printloop_end
		sll $t3, $t0, 2
		lw $t2, a($t3)
		print_int($t2)
		print_str(str_add)
		addi $t0, $t0, 1
		j printloop
	printloop_end:
	sll $t3, $t1, 2
	lw $t2, a($t3)
	print_int($t2)
	print_str(str_enter)
	pop($ra)
	jr $ra
	




