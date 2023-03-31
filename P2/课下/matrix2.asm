.data
tempMatrix: .word 0:300
resultMatrix: .word 0:300

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

.macro print_str(%ans)
	la $a0, %ans
	li $v0, 4
	syscall
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
read_int($s1) # n
read_int($s2) # m

li $t0, 0
readloopi:
	beq $t0, $s2, readloopi_end
	li $t1, 0
	readloopj:
		beq $t1, $s2, readloopj_end
		read_int($t2)
		get_index($t3, $t0, $t1, $s2, $s2)
		sw $t2, tempMatrix($t3)
		
		addi $t1, $t1, 1
		j readloopj
	readloopj_end:
	
	addi $t0, $t0, 1
	j readloopi
readloopi_end:

jal powerTempMatrix

print_part:
	li $t0, 0 # i
	printloopi:
		beq $t0, $s2, printloopi_end
		
		li $t1, 0 # j
		printloopj:
			beq $t1, $s2, printloopj_end
			get_index($t3, $t0, $t1, $s2, $s2)
			lw $t4, tempMatrix($t3)
			print_int($t4)
			print_str(str_space)
			
			addi $t1, $t1, 1
			j printloopj
		printloopj_end:
		print_str(str_enter)
		
		addi $t0, $t0, 1
		j printloopi
	printloopi_end:

li $v0, 10
syscall



powerTempMatrix:
	push($ra)
	
	# move $t0, $s1
	
	
	li $t0, 0
	forpTM:
		beq $t0, $s1, forpTM_end
		push($t0)
		jal sqrtTempMatrix
		jal replaceTempMatrix
		pop($t0)

		addi $t0, $t0, 1
		j forpTM
	forpTM_end:
	
	pop($ra)
	jr $ra

sqrtTempMatrix:
	push($ra)
	
	li $t0, 0 # i
	fori:
		beq $t0, $s2, fori_end
		
		li $t1, 0 # j
		forj:
			beq $t1, $s2, forj_end
			get_index($t3, $t0, $t1, $s2, $s2)
			sw $zero, resultMatrix($t3)
			
			li $t2, 0 # k
			fork:
				beq $t2, $s2, fork_end
				get_index($t4, $t0, $t2, $s2, $s2)
				get_index($t5, $t2, $t1, $s2, $s2)
				lw $t6, resultMatrix($t3)
				lw $t7, tempMatrix($t4)
				lw $t8, tempMatrix($t5)
				mult $t7, $t8
				mflo $t8
				add $t6, $t6, $t8
				sw $t6, resultMatrix($t3)
				
				addi $t2, $t2, 1
				j fork
			fork_end:
			
			addi $t1, $t1, 1
			j forj
		forj_end:
		
		addi $t0, $t0, 1
		j fori
	fori_end:
	
	pop($ra)
	jr $ra

replaceTempMatrix:
	push($ra)
	
	li $t0, 0 # i
	forrTMi:
		beq $t0, $s2, forrTMi_end
		
		li $t1, 0 # j
		forrTMj:
			beq $t1, $s2, forrTMj_end
			get_index($t3, $t0, $t1, $s2, $s2)
			lw $t4, resultMatrix($t3)
			sw $t4, tempMatrix($t3)

			addi $t1, $t1, 1
			j forrTMj
		forrTMj_end:
			
		addi $t0, $t0, 1
		j forrTMi
	forrTMi_end:
	
	pop($ra)
	jr $ra





