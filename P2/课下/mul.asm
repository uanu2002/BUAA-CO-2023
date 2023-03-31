.data
num1: .word 0:300
num2: .word 0:300
res: .word 0:600

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
read_int($s1) # n1


move $t0, $s1
subi $t0, $t0, 1
readloop1:
	blt $t0, $zero, readloop1_end
	read_int($t1)
	sll $t2, $t0, 2
	sw $t1, num1($t2)
	subi $t0, $t0, 1
	j readloop1
readloop1_end:

read_int($s2) # n2

move $t0, $s2
subi $t0, $t0, 1
readloop2:
	blt $t0, $zero, readloop2_end
	read_int($t1)
	sll $t2, $t0, 2
	sw $t1, num2($t2)
	subi $t0, $t0, 1
	j readloop2
readloop2_end:

li $t0, 0 # i
fori:
	beq $t0, $s1, fori_end
	li $t1, 0 # j
	forj:
		beq $t1, $s2, forj_end
		add $t2, $t0, $t1 # i + j
		sll $t3, $t0, 2
		sll $t4, $t1, 2
		lw $t3, num1($t3)
		lw $t4, num2($t4)
		mult $t3, $t4
		mflo $t3
		sll $t2, $t2, 2
		lw $t5, res($t2)
		add $t5, $t5, $t3
		sw $t5, res($t2)
		
		addi $t1, $t1, 1
		j forj
	forj_end:
	addi $t0, $t0, 1
	j fori
fori_end:

li $t0, 0 # i
add $s4, $s1, $s2
forone:
	beq $t0, $s4, forone_end
	add $t1, $t0, 1
	sll $t1, $t1, 2 # i + 1
	sll $t2, $t0, 2
	lw $t3, res($t2)
	lw $t4, res($t1)
	li $t7, 10
	div $t3, $t7
	mfhi $t7 # remainer
	mflo $t6
	add $t4, $t4, $t6
	sw $t7, res($t2)
	sw $t4, res($t1)
	
	addi $t0, $t0, 1
	j forone
forone_end:

move $t0, $s4
li $s0, 0 # flag
printloop:
	blt $t0, $zero, printloop_end
	sll $t1, $t0, 2
	lw $t1, res($t1)
	beq $t1, $zero, if1_end
		li $s0, 1
	if1_end:
	seq $t3, $t0, $zero
	sgt $t4, $s0, $zero
	or $t3, $t3, $t4
	beq $t3, $zero, if2_end
		print_int($t1)
	if2_end:
	
	subi $t0, $t0, 1
	j printloop
printloop_end:

li $v0, 10
syscall







