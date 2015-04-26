################################
# DATA 
################################
.data 0x0000

strs: .space 100

newline: .asciiz "\n"

################################
# MACRO  
################################
# exit
.macro exit
	li   $v0,10
	syscall
.end_macro	

# print int
.macro print_int(%x)
	li   $v0, 1
	add  $a0, $zero, %x
	syscall
	
	li   $v0, 4
	la   $a0, newline
	syscall
.end_macro
	
# print string
.macro print_str(%str)
.data
myLabel: .asciiz %str
.text
	li   $v0, 4
	la   $a0, myLabel
	syscall
.end_macro


################################
# TEXT
################################
.text 0x3000

main:

# 1. Read string
	print_str("* input string for sorting : ")    
    li   $v0, 8          # syscall for read string
    la   $a0, strs
    li   $a1, 100        # buffer length
    syscall              # read from fil

# 2. Do Quick Sort


# 3. Print result
	print_str("* sorted result            : ")    
	li   $v0, 4          # print string
	la   $a0, strs       # address of string to be printed
	syscall


	exit	

