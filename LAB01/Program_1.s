; DATA SECTION

.data

a: 		 .byte -6, 0x21, 0x8f, 0xbb, -8, 0x00, 0x01, -11
		 .byte -6, 0x21, 0x8f, 0xbb, -8, 0x00, 0x01, -11
         .byte -6, 0x21, 0x8f, 0xbb, -8, 0x00, 0x01, -11
         .byte -6, 0x21, 0x8f, 0xbb, -8, 0x00
		 
b: 		 .byte 0x01, 0x00, -4, -2, 0xab, 0x4c, 0x11, 0x00
         .byte 0x01, 0x00, -4, -2, 0xab, 0x4c, 0x11, 0x00
         .byte 0x01, 0x00, -4, -2, 0xab, 0x4c, 0x11, 0x00
         .byte 0x01, 0x00, -4, -2, 0xab, 0x4c

c:		.space 240

threshold_high:	.space 8
threshold_low:	.space 8
max:			.space 8
min:			.space 8
threshold:		.byte 0x0
			
; CODE SECTION
.text
MAIN:

		daddi R1, R0, 30		# contatore ciclo
		dadd R2, R0, R0			# offset vettori, contatore
		dadd R5, R0, R0			# registro di appoggio
		dadd R6, R0, R0			# counter th 
		dadd R9, R0, R0			# counter tl
		dadd R10, R0, R0		# registro max
		dadd R11, R0, R0		# registro min
		lb 	R8, threshold(R0)	# memorizzo in un reg la soglia
		
		lb R3, a(R0)
		lb R4, b(R0)
		dadd R12, R3, R4
		dadd R10, R12, R0		# inizializzo max a primo val di c
		dadd R11, R12, R0		# inizializzo min a primo val di c
FOR:	
		lb 	R3, a(R2)		
		lb 	R4, b(R2)
		dadd R5, R3, R4
		
		slt R7, R5, R8			# se c[i] è minore di 0x0 --> R7 = 1 
		dadd R9, R9, R7			
		sb 	R5, c(R2)
		
		slt R13, R10, R5		# if max < c[i] -> R13 = 1, else 0
		movn R10, R5, R13		# if R13 != 0 (ossia =1) -> max = c[i]
		
		slt R13, R11, R5		# if min < c[i] -> R13 = 1, else 0
		movz R11, R5, R13		# if R13 = 0  (ossia min > c[i]) -> min = c[i]
		
		
		daddi R2, R2, 1			# incremento contatore di 1 byte
		bne R1, R2, FOR		
	
		dsub R6, R1, R9			# finita la scansione, th = 30 - tl	
		
		sb R6, threshold_high(R0)
		sb R9, threshold_low(R0)
		sb R10, max(R0)
		sb R11, min(R0)
		
		HALT
			
		