.data

uno:	.asciiz "holas"
dos:	.asciiz "hola"

.text

##### PROBANDO EL PROGRAMA #####

# holas vs hola
la $a0 str1
la $a1 str2
jal strcmp

add $a0 $v0 $zero
addi $v0 $zero 1
syscall

# hola vs holas
la $a0 str1
la $a1 str2
jal strcmp

add $a0 $v0 $zero
addi $v0 $zero 1
syscall

# salir
addi $v0 $zero 10
syscall

##### FIN DE LA PRUEBA #####

strcmp:
   li $t2 ' '			# caracter espacio
   li $t3 10			# cual es el caracter 10?
strcmp_loop:
   lb $t0 0($a0)
   lb $t1 0($a1)
   beq $t0 $t2 strcmp_true	# que pasa si hay un espacio o un caracter 10...
   beq $t0 $t3 strcmp_true	# ...en $a0? y si estan en $a1?
   beq $t0 $0  strcmp_true	# fin de cadena
   bne $t0 $t1 strcmp_false	# es diferente
   addi $a0 $a0 1
   addi $a1 $a1 1
   j strcmp_loop
strcmp_true:
   li $v0 1
   jr $ra
strcmp_false:
   li $v0 0
   jr $ra