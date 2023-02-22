; DATA SECTION

.data

i: 		.double 17, 44, 66, 21, 46, 75, 94, 28, 61, 76, 79, 72, 64, 84, 34, 40, 73, 14, 18, 55, 6, 100, 90, 19, 43, 78, 74, 56, 51, 58

w: 		.double 60, 92, 28, 16, 50, 11, 18, 31, 79, 68, 32, 25, 49, 57, 21, 96, 29, 53, 42, 65, 39, 41, 38, 54, 93, 24, 61, 10, 98, 30 

b:		.double 0xab
c:		.double 0x7ff
y:		.space 8



; CODE SECTION
.text
MAIN:



		daddi R1, R0, 240		# max contatore ciclo
		dadd R2, R0, R0			# registro contatore ciclo
		l.d F5, b(R0)			# 0xab
		l.d F8, c(R0)			# 0x7ff
		mtc1 R0, F2
		mtc1 R0, F4
FOR:	
		l.d F0, i(R2)	
		l.d F1, w(R2)
		mul.d F3, F0, F1		# i_j * w_j
		add.d F2, F2, F3		# sommatoria
		
		daddi R2, R2, 8
		
		bne R1, R2, FOR
		
		add.d F2, F2, F5		# + b
		
		
		# CHECK EXPONENT PART OF X
		
		mfc1 R3, F2				# metto contenuto di F2 in R3
		dsrl R6, R3, 28			# shift exponent di R3
		dsrl R9, R6, 24
		mtc1 R9, F6
		mfc1 R8, F8
		beq R9, R8, ZERO		# verifica exponent
		s.d F2, y(R0)			# y = x
		halt					# stop caso 2
		
		
ZERO:		
		mtc1 R0, F2				# y = 0
		s.d F2, y(R0)
		halt					# stop caso 1
		
		
		