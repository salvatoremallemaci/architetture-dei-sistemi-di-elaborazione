; DATA SECTION

.data

v1:		.double 1, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2

v2:		.double 1, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2

v3:		.double 1, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2

v4:		.double 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2, 32.5, 33, 0.2, 4, 2, 1.2, 7, 8, -9, 10.2

v5:		.space 320
v6:		.space 320
v7:		.space 320


; CODE SECTION
.text
MAIN:
		dadd 	R2, R0, R0		
		daddui 	R1, R0, 40		
FOR:
		l.d	F2, v2(R2)			
		l.d	F3, v3(R2)	
		mul.d 	F5, F2, F3		# v2[i] * v3[i] = temp[i]
		l.d	F1, v1(R2)
		l.d	F4, v4(R2)
		daddui	R1, R1, -1
		add.d 	F5, F5, F1		# v1[i] + temp[i] = v5[i]
		s.d 	F5, v5(R2)
		mul.d 	F6, F5, F4		# v5[i] * v4[i] = v6[i]
		s.d		F6, v6(R2)
		div.d 	F7, F6, F2		# v6[i] / v2[i] = v7[i]
		s.d 	F7, v7(R2)		
		bnez	R1, FOR	
		daddi	R2, R2, 8
		halt					

			