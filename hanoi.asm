#void hanoi(int n, char origen, char destino, char auxiliar) {
#    if (n == 1) {
#        printf("Mover disco 1 desde %c a %c\n", origen, destino);
#        return;
#    }
#    hanoi(n - 1, origen, auxiliar, destino);
#    printf("Mover disco %d desde %c a %c\n", n, origen, destino);

#    hanoi(1, origen, destino, auxiliar);
#    hanoi(n - 1, auxiliar, destino, origen);
#}	
#32 bits cada palabra = 4 bytes 

# 1.- Mover parte superior a Auxiliar 
# 2.- Mover pieza actual a Destino
# 3.- Mover parte superior al Destino
#Mover los N-1 discos superiores de la torre de A a B, siendo B la posición que no corresponde ni al origen ni al destino.
#Mover el disco restante (el más grande) de A a C.
#Mover los N-1 discos de B a C, colocándolos encima del disco de mayor diámetro.
.text 
main:   addi s0, zero, 3  # numero de discos 
	add s2, s0, zero #copia de mi n 
	addi t2, zero,  4 # espacio de cada disco 
	addi t0, zero, 1 # es mi limite del ciclo 
	lui s1, 0x10010 #apunta a la dirección más baja de la 1001 
	
ciclo:  sw s0, 0(s1)  #escribe el disco en la dirección 
	addi s0, s0, -1 #reducir n-1 el numero de discos 
	addi s1, s1, 4 # sumo 4 para pasar a la sig dirección
	bge s0, t0, ciclo # si no son iguales repites el ciclo if(s0 != 1)
	slli t1, s2,2 #n*2
	slli t1, s2,2 #n*2

#s1 -> queda con la dirección de aux 
#a2 -> n = Numero de discos
	add a2, zero, s2 #n = Numero de discos  
#a3 -> origen = A
	sub a3,s1,t1 #origen, resto s1 -(n*4) para apuntar a la base origen 
#a4 -> aux = B
	add a4, zero, s1 # aux s1 apunta a la siguiente direccion se multiplica por zero por que ahi empieza el aux
#a5 -> destino = C 
	add a5, s1, t1 #destino, sumo s1+(n*4) para apuntar a la base destino 
#          s1-4,a3, a5 
	jal hanoi
	jal end

###############################################
# 1. Mover parte superior a NO destino
    #1.1 Ajustar apuntadores (Reducir Origen y Aumentar Destino)
# 2. Mover pieza actual a destino
# 3. Mover parte superior a destino

hanoi:  beq a2, t0, if # if (n == 1)
#    hanoi(n - 1, origen, auxiliar, destino); 
#antes de llamar a la función guardo mis datos para no perderlos
llamada1: addi sp, sp, -20 #push 
	sw a5, 16(sp)#destino
	sw a4, 12(sp)#aux
	sw a3, 8(sp) #origen
	sw a2, 4(sp) # n
	sw ra, 0 (sp)#dirección de regreso
	#modificar argumentos e intercambiar los valores de destino y aux para la sig llamada
	sub a2, a2, t0 # n-1 aqui seria con el 2 disco
	addi a3,a3,4 #origen a3 apunta al sig disco
	lw a4, 16(sp)#destino en aux 
	lw a5, 12(sp)#aux en destino
	jal hanoi #ya modificados hago la 1ra llamada recursiva
	#pop 
	lw ra, 0(sp)#dirección de regreso
	lw a2, 4(sp)#n
	lw a3, 8(sp)#origen
	lw a4, 12(sp)#aux
	lw a5, 16(sp)#destino
	
	#antes de llamar la función recursiva 2 tengo que modificar los argumentos
	#llamda recursiva 2 
	# hanoi(1, origen, destino, auxiliar); 
	#push 
	addi sp, sp, -20 
	sw a5, 16(sp)#destino
	sw a4, 12(sp)#aux
	sw a3, 8(sp) #origen
	sw a2, 4(sp) # n
	sw ra, 0 (sp)#dirección de regreso
	#modificar argumento
	addi a2, zero, 1#n=1
llamada2:jal hanoi
	#pop 
	lw ra, 0(sp)#return address
	lw a2, 4(sp)#n
	lw a3, 8(sp)#origen
	lw a4, 12(sp)#aux
	lw a5, 16(sp)#destino
	addi sp, sp, +20
#	jalr ra

#3ra llamada
#    hanoi(n - 1, auxiliar, destino, origen);
	#push 
	addi sp, sp, -20 #push 
	addi a5, a5, 4 #arriba del disco anterior
	sw a5, 16(sp)#destino
	sw a4, 12(sp)#aux
	sw a3, 8(sp) #origen
	sw a2, 4(sp) # n
	sw ra, 0 (sp) 
	#modificar parametros
llamada3:sub a2, a2, t0 # n-1 
	lw a4, 8(sp)#origen = aux
	lw a3, 12(sp)#aux = origen
	#destino tiene el mismo valor y ya fue obtenido en la llamada anterior
	addi sp, sp, +20
	jal hanoi 
	#pop 
	lw ra, 0(sp)#return address
	lw a2, 4(sp)#n
	lw a3, 8(sp)#origen
	lw a4, 12(sp)#aux
	lw a5, 16(sp)#destino
	addi sp, sp, +20 #regresa a la dirección de la llama anterior
	jalr ra #regresa a la llamada
	
	#mover 1 disco de un lado a otro
if:     lw t2, 0(a3) # cargo el valor del origen a t2
	sw t2, 0(a5) # destino = origen
	sw zero, 0(a3)# se carga un 0 en origen
	jalr ra
end: nop
	
