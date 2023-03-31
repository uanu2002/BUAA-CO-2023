.data
matrix: .word 0:200
conv: .word 0:200
g: .word 0:200
str_enter:  .asciiz "\n"
str_space:  .asciiz " "
.macro  getindex(%ans, %i, %j, %n, %m)
    mult %i, %m             # %ans = %i * 8
    mflo %ans
    add %ans, %ans, %j          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro
.text
li $v0,5
syscall
move $s0,$v0
li $v0,5
syscall
move $s1,$v0
li $v0,5
syscall
move $s2,$v0
li $v0,5
syscall
move $s3,$v0
sub $s6,$s0,$s2
add $s6,$s6,1
sub $s7,$s1,$s3
add $s7,$s7,1
li $t0,0
li $t1,0
loop:
li $v0,5
syscall
move $t2,$v0
getindex($t3,$t0,$t1,$s0,$s1)
sw $t2, matrix($t3)
addi $t1,$t1,1
bne $t1,$s1,loop
li $t1,0
addi $t0,$t0,1
bne $t0,$s0,loop

li $t0,0
li $t1,0
loop2:
li $v0,5
syscall
move $t2,$v0
getindex($t3,$t0,$t1,$s2,$s3)
sw $t2, conv($t3)
addi $t1,$t1,1
bne $t1,$s3,loop2
li $t1,0
addi $t0,$t0,1
bne $t0,$s2,loop2

li $t0,0
li $t1,0
loop_out:
li $t2,0
li $t3,0
li $s4,0
loop_in:
add $t4,$t0,$t2
add $t5,$t1,$t3
getindex($t6,$t4,$t5,$s0,$s1)
lw $t7,matrix($t6)
getindex($t6,$t2,$t3,$s2,$s3)
lw $t8,conv($t6)
mult $t7,$t8
mflo $s5
add $s4,$s4,$s5
add $t3,$t3,1
bne $t3,$s3,loop_in
li $t3,0
add $t2,$t2,1
bne $t2,$s2,loop_in
getindex($t6,$t0,$t1,$s6,$s7)
sw $s4,g($t6)
move $a0,$s4
li $v0,1
syscall
la  $a0, str_space
li  $v0, 4
syscall
add $t6,$t1,1
bne $t6,$s7,ll
la  $a0, str_enter
li  $v0, 4
syscall
ll:
add $t1,$t1,1
add $t5,$t1,$s3
sub $t5,$t5,1
bne $t5,$s1,loop_out
li $t1,0
add $t0,$t0,1
add $t4,$t0,$s2
sub $t4,$t4,1
bne $t4,$s0,loop_out

li $v0,10
syscall



