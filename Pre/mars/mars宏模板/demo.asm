.data

Array: .word 0:100
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.macro  get_index(%ans, %i, %j, %n, %m) # ans为结果，返回(n,m)数组中(i,j)位置元素
    mult %i, %m             
    mflo %ans
    add %ans, %ans, %j          
    sll %ans, %ans, 2           # byte -> word
.end_macro

.macro pop(%ans)
	addi $sp,$sp,4
	lw %ans,0($sp)
.end_macro

.macro push(%ans)
	sw %ans,0($sp)
	subi $sp,$sp,4
.end_macro

.macro read_int(%ans)
	li $v0,5
	syscall
	move %ans,$v0
.end_macro

.macro print_int(%ans)
	move $a0,%ans
	li $v0,1
	syscall
.end_macro

.text
read_int($t0)
print_int($t0)

li $v0,10
syscall