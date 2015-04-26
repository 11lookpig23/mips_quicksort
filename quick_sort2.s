	.data
data:	.word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
size:	.word 15
#use below sample if above example is too large to debug
#data:	.word 4,2,5,3,1
#size:	.word 5
	.text
## a0 = data(array) address, a1=0 (start) a2= size-1(end)
partition:
	# TODO: fill in your code here
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s0, 8($sp) ## s0=left
	sw $s1, 4($sp) ## s1=right
	sw $s2, 0($sp) ## s2=pivot
	

	sll $t0, $a1, 2 ## t0 세팅
	add $t0, $a0, $t0 ## 주소에 t0 더해줌 그걸 t0에 넣음 t0= address for data[start] 원주소에 t0더해줌
	lw $t1, 0($t0) ## t1=data[start]

	addi $s0, $a1, 0 ##int left=start;
	addi $s1, $a2, 0 ##int right=end;
	addi $s2, $t1, 0 ##int pivot=data[start];

	while1st:
	bge $s0, $s1, while1stend  ## use psudoinstructuon bge : branch if greater than equal

	while2nd:
	ble $t3, $s2, while2ndend  ## use psudoinstructuon ble : branch if less than equal      
	addi $s1, $s1, -1
	sll $t2, $s1, 2 ## right를 t2로 세팅중 4곱해서 어레이에 들어가게
	add $t2, $a0, $t2 ##t2= address for data[right] 원 주소에 t4를 더해줌
	lw $t3, 0($t2) ##t3=data[right]
	j while2nd
	while2ndend:

	while3rd:
	bge $s0, $s1, while3rdend
	sll $t4, $s0, 2 ##left를 t4로 세팅중 4곱해서 어레이에 들어가게
	add $t4, $a0, $t4 ##t4=address for data[left] 원 주소에 t4를 더해줌
	lw $t5, 0($t4) ##t5=data[left]
	bgt $t5, $s2, while3rdend ## use psudoinstructuon bgt : branch if greater than    
	addi $s0, $s0, 1
	j while3rd
	while3rdend:

	if1st:
	bge $s0, $s1, if1stend
	sll $t2, $s1, 2 ## right를 t2로 세팅중 4곱해서 어레이에 들어가게
	add $t2, $a0, $t2 ##t2= address for data[right] 원 주소에 t4를 더해줌
	lw $t3, 0($t2) ##t3=data[right]
	sll $t4, $s0, 2 ##left를 t4로 세팅중 4곱해서 어레이에 들어가게
	add $t4, $a0, $t4 ##t4=address for data[left] 원 주소에 t4를 더해줌
	lw $t5, 0($t4) ##t5=data[left]

	addi $t6, $t3, 0 ##t6=temp
	addi $t3, $t5, 0 
	addi $t5, $t6, 0
	
	sw $t3, 0($t2)
	sw $t5, 0($t4)
	if1stend:
	
	j while1st
	
	while1stend:

	sll $t2, $s1, 2 ## right를 t2로 세팅중 4곱해서 어레이에 들어가게
	add $t2, $a0, $t2 ##t2= address for data[right] 원 주소에 t4를 더해줌
	lw $t3, 0($t2) ##t3=data[right]
	
	addi $t1, $t3, 0
	addi $t3, $s2, 0
	
	sw $t1, 0($t0)
	sw $t3, 0($t2)
	
	addi $v0, $s1, 0
	
	lw $ra, 12($sp)
	lw $s0, 8($sp) ## s0=left
	lw $s1, 4($sp) ## s1=right
	lw $s2, 0($sp) ## s2=pivot
	addi $sp, $sp, 16
	
	jr 	$ra

quick_sort:
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s0, 8($sp) ##s0=start
	sw $s1, 4($sp) ##s1=end
	sw $s2, 0($sp) ##s2=pivotposition
	addi $s0, $a1, 0                
	addi $s1, $a2, 0
	if2nd:
	bge $s0, $s1, if2ndend
	jal partition
	addi $s2, $v0, 0
	
	addi $a2, $s2, -1	
	jal quick_sort
	
	addi $a2, $s1, 0
 	addi $a1, $s2, 1
	jal quick_sort 
	if2ndend:
	lw $ra, 12($sp)
	lw $s0, 8($sp)
	lw $s1, 4($sp) 
	lw $s2, 0($sp)
	addi $sp, $sp, 16
	jr 	$ra

main:
	la 	$a0, data				#load address of "data"."la" is pseudo instruction, see Appendix A-66 of text book.
	addi 	$a1, $zero, 0
	lw 	$a2, size				#loads data "size"
	addi	$a2, $a2, -1

	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)

	jal 	quick_sort				#quick_sort(data,0,size-1)

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4

	jr 	$ra


## a0 = data(array) address, a1=0 (start) a2= size-1(end)