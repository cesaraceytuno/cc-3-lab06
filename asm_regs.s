.data

a0:	.asciiz "$a0"
sp:	.asciiz "$sp"
zero:	.asciiz "$0"


.text

la $s0 a0
jal asm_regs
move $a0 $v0
li $v0 1
syscall

la $s0 zero
jal asm_regs
move $a0 $v0
li $v0 1
syscall

la $s0 sp
jal asm_regs
move $a0 $v0
li $v0 1
syscall

li $v0 10
syscall

##### CONVERTIDOR DE REGISTROS #####

asm_regs:		# pasa de $xN -> N ej. $s0 -> 16
   addi $sp $sp -4	# por supuesto que esta incompleto...
   sw $ra 0($sp)
   li $t7 '$'		# voy a utilizarlo para verificar que viene un registro
   li $t6 'a'		# aX -> argumentos
   li $t5 'v'		# vX -> valores de retorno
   li $t4 '0'		# cero
   			# quienes faltan?
   
   lb $t0 0($s0)
   addi $s0 $s0 1
   bne $t0 $t7 asm_regs_error	# si no empieza con $ no es valido
   lb $t0 0($s0)
   addi $s0 $s0 1
   beq $t0 $t6 asm_regs_ax	# verifico a que grupo pertence para sumarle un offset
   beq $t0 $t5 asm_regs_vx
   beq $t0 $t4 asm_regs_zero
   				# quienes faltan?
   				
   j asm_regs_error		# no es ninguno, entonces es error

asm_regs_zero:		# caso trivial, $0 -> 0
   li $v0 0
   j asm_regs_exit

asm_regs_ax:		# sumamos 4 porque... $a0 -> 4, $a1 -> 5, etc.
   jal ascii_to_int
   addi $v0 $v0 4
   j asm_regs_exit

asm_regs_vx:
   jal ascii_to_int
   addi $v0 $v0 2
   j asm_regs_exit

asm_regs_exit:
   lw $ra 0($sp)
   addi $sp $sp 4
   jr $ra

asm_regs_error:
   # despliegue un mensaje de error
   # termine la ejecucion del programa
   li $v0 -1
   jr $ra
   
##### FIN DE CONVERTIDOR DE REGISTROS #####

##### ATOI: ASCII TO INTEGER #####

ascii_to_int:   # the infamous atoi, with no validations!
li $t1 0	# init with zero
li $t2 '0'	
li $t3 '9'	
li $t4 10
li $v0 0

ascii_to_int_loop:
   lb $t0 0($s0)
   beq $t0 $0  ascii_to_int_exit
   blt $t0 $t2 ascii_to_int_exit	# only accept numbers
   bgt $t0 $t3 ascii_to_int_exit	# only accept numbers
   addi $s0 $s0 1			# advance the char pointer
   addi $t0 $t0 -48			# get real number (without the '0' offset)
   mul  $v0 $v0 $t4			# multiply by 10
   add  $v0 $v0 $t0			# add real number
   j ascii_to_int_loop
   
ascii_to_int_exit:
   jr $ra
   
##### FIN DE ATOI #####