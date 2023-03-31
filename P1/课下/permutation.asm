.data
symbol: .word 0:10
array: .word 0:10
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.text
li $v0,5
syscall
move $s0,$v0
li $t0,0

loop:
sll $t1,$t0,2
sw $zero symbol($t1)
add $t0,$t0,1
bne $t0,$s0,loop

li $s2,-1
li $s3,0
jal loop2

li $v0,10
syscall

loop2:
sw $ra,0($sp)
subi $sp,$sp,4
sw $s2,0($sp)
subi $sp,$sp,4
sw $s3,0($sp)
subi $sp,$sp,4

addi $s2,$s2,1
sub $t1,$s2,$s0
bltz $t1,for2
li $t0,0
for1:
sll $t1,$t0,2
lw $t2,array($t1)
move $a0,$t2
li $v0,1
syscall
la  $a0, str_space
li  $v0, 4
syscall
add $t0,$t0,1
bne $t0,$s0,for1
la  $a0, str_enter
li  $v0, 4
syscall
addi $sp,$sp,4
lw $s3, 0($sp)
addi $sp,$sp,4
lw $s2, 0($sp)
addi $sp,$sp,4
lw $ra, 0($sp)
jr $ra
for2:
li $t0,0
loop3:
sll $t1,$t0,2
lw $t2, symbol($t1)
bne $t2,$zero,not_equal
addi $t4,$t0,1
sll $t5,$s2,2
sw $t4, array($t5)
li $t2,1
sw $t2, symbol($t1)
move $s3,$t0
#addi $s2,$s2,1
jal loop2
li $t2,0
move $t0,$s3
sll $t1,$t0,2
sw $t2, symbol($t1)
not_equal:
addi $t0,$t0,1
bne $t0,$s0,loop3
addi $sp,$sp,4
lw $s3, 0($sp)
addi $sp,$sp,4
lw $s2, 0($sp)
addi $sp,$sp,4
lw $ra, 0($sp)
jr $ra




