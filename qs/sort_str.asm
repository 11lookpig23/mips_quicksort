

.data           0x10010000

Aarray:          .space     100

# print string
.macro print_str(%str)
.data
myLabel: .asciiz %str
.text
	li   $v0, 4
	la   $a0, myLabel
	syscall
.end_macro

.text
main:

# 1. Read string
               print_str("* input string for sorting : ")    
               li         $v0, 8                             # syscall for read string
               la         $a0, Aarray
               li         $a1, 100                           # buffer length
               syscall                                       # read from fil

# 2. print input string
               la         $a0, Aarray
               li         $v0, 4
               syscall
              
# 3. count string size              
               la         $a0, Aarray
               jal        strlen
               nop
       
# 4. quicksort                             
               addi       $t0, $a0, 0                        # load length
               la         $a0, Aarray
               addi       $a2, $t0, -1                       # length - 1
               ori        $a1, $zero, 0                      # a1 = 0
               jal        Quicksort
               ori        $t0, $t0, 0                        # nop

# 5. print result
               la         $a0, Aarray
               li         $v0, 4
               syscall
               
# 6. exit
               li         $v0, 10                            # exit
               syscall

#################################
# Quicksort 
#################################
Quicksort:        
               slt        $t0, $a1, $a2                      # a1(=p):starting position a2(=r):ending position
               beq        $t0, $zero, Quicksort_end          # if a1>=a2 branch to Quicksort_end
               ori        $t0, $t0, 0                        # nop

               subu       $sp, $sp, 16
               sw         $ra, 16($sp)                       # save return address
               sw         $a0, 12($sp)                       # a0 is the base address of an array (=A[])
               sw         $a1, 8($sp)
               sw         $a2, 4($sp)                        # save a0, a1, a2 to call sub-procedure
               jal        Partition                          # call Partition(A[], p, r) : same argument as current procedure

               subu       $sp, $sp, 4
               sw         $v0, 4($sp)                        # save return value of Partition (=q)
               lw         $a0, 16($sp)
               lw         $a1, 12($sp)                       # load A[], p
               ori        $a2, $v0, 0                        # move q to a2
               jal        Quicksort                          # call Quicksort(A[], p, q)

               lw         $a0, 16($sp)                       # load A[]
               lw         $t0, 4($sp)                        # load q
               addi       $a1, $t0, 1                        # a1 = q + 1
               lw         $a2, 8($sp)                        # load r
               jal        Quicksort                          # Quicksort(A[], q+1, r)
               ori        $t0, $t0, 0                        # nop

               addu       $sp, $sp, 20                       # pop A[], p, r, q, ra
               lw         $ra, 0($sp)                        # restore reaturn address

Quicksort_end:        
               jr         $ra                                # return


#################################
# Partition 
#################################
Partition:
               add        $t0, $a1, $a0                      # t0 = A[] + t0
               lb         $t0, 0($t0)                        # t0 = A[p]        : x

               addi       $t1, $a1, -1                       # i = p-1
               addi       $t2, $a2, 1                        # j = r+1

               add        $t3, $t1, $a0                      # t3 = address of A[i] to minimize the loop 
               add        $t4, $t2, $a0                      # t4 = address of A[j]

Loop1:        
               addi       $t1, $t1, 1                        # i = i+1
               addi       $t3, $t3, 1                        # t3 = t3 + 1 : reset the address of A[i]
               lb         $t5, 0($t3)
               slt        $t6, $t5, $t0
               bne        $t6, $zero, Loop1                  # if A[i] < x, branch to Loop2
               ori        $t0, $t0, 0                        # nop

Loop2:         
               addi       $t2, $t2, -1                       # j = j-1
               addi       $t4, $t4, -1                       # t4 = t4 - 1 : reset the address of A[j]
               lb         $t5, 0($t4)
               
               slt        $t6, $t0, $t5
               bne        $t6, $zero, Loop2                  # if A[j] > x, branch to Loop1

               slt        $t5, $t1, $t2
               beq        $t5, $zero, Partition_end          # if i >= j, branch to Partition_end

               lb         $t5, 0($t3)
               lb         $t6, 0($t4)
               sb         $t6, 0($t3)
               sb         $t5, 0($t4)                        # swap A[i] and A[j]
               beq        $zero, $zero, Loop1

Partition_end: 
               addu       $v0, $zero, $t2                    # v0 = j
               jr         $ra                                # return


#################################
# strlen 
#################################
strlen: 
               addi       $s0, $a0, 0
               li         $s1, 0x0d
               li         $s2, 0x0a
slen_0: 
               lb         $t0, ($a0)   # load current byte, move to next
               addi       $a0, $a0, 1
               beq        $t0, $s1, strlen_end
               beq        $t0, $s2, strlen_end
               beq        $t0, $zero, strlen_end
               b          slen_0 
        
strlen_end:
               sub        $a0, $a0, $s0
               subi       $a0, $a0, 1
               jr         $ra          # return to caller
               nop