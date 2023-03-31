.data
G: .space  1000 
book: .space 100 #储存已经遍历的点

str_enter: .asciiz "\n"
str_space: .asciiz " "

.macro get_index(%ans, %i, %j, %n, %m)
	mult %i, %m
	mflo %ans
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.macro pop(%ans)
	addi $sp, $sp, 4
	lw %ans, 0($sp)
.end_macro

.macro push(%ans)
	sw %ans, 0($sp)
	subi $sp, $sp, 4
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

.text
li $s5, 0 # 表示不存在哈密顿回路
read_int($s0) # 读入顶点数
read_int($s1) # 读入边数

li $t0, 0

in_m_i:
	beq $t0, $s1, in_m_i_end # x=$t1,y=$t2,i=$t0
	read_int($t1) # 读入左侧点
	subi $t1, $t1, 1
	read_int($t2) # 读入右侧点
	subi $t2, $t2, 1

	get_index($t3,$t1, $t2, $s0, $s0)
	li $t4, 1
	sw $t4, G($t3)
	get_index($t3,$t2, $t1, $s0, $s0)
	li $t4, 1
	sw $t4, G($t3)
	addi $t0, $t0, 1
	j in_m_i
in_m_i_end:

li $a1,0
jal dfs

print:
print_int($s5)
li $v0,10
syscall

dfs:
push($ra)
push($a1)

sll $t6, $a1, 2
move $t4, $t6
li $t5, 1
sw $t5, book($t4)

li $t7, 1 # flag=1
li $t0, 0 # i=$t0

all_begin:
	beq $t0, $s0, all_end # 检查是否通过所有点
	sll $t6, $t0, 2
	lw $t5, book($t6)
	and $t7, $t7, $t5
	addi $t0, $t0, 1
	j all_begin
all_end:


beq $t7, 0, search_begin # if
	get_index($t3, $a1, $zero, $s0,$s0)
	lw $t8, G($t3)
beq $t8, 0, search_begin # if
	li $s5, 1 # ans = 1
	pop($a1)
	pop($ra)
	jr $ra
search_begin:
	li $t0,0 #i = $t0
	loop_begin:
		beq $t0, $s0, loop_end
		sll $t1,$t0,2
		lw $t1,book($t1)
		get_index($t3, $a1, $t0, $s0,$s0)
		lw $t8, G($t3)
		bne $t1,0,label
		beq $t8,0,label
		sw $a1,0($sp)
		subi $sp,$sp,4
		move $a1,$t0
		jal dfs
		move $t0,$a1
		addi $sp,$sp,4
		lw $a1,0($sp)
		label:
		addi $t0,$t0,1
		j loop_begin
	loop_end:
	
li $t5, 0
sll $t6, $a1, 2
move $t4, $t6
sw $t5, book($t4)

pop($a1)
pop($ra)
jr $ra
