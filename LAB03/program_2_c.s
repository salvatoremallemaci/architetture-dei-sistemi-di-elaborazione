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
		daddui  R3, R2, 8
		daddui  R4, R2, 16
		daddui  R5, R2, 24
FOR:
		
		l.d	F2, v2(R2)			
		l.d	F3, v3(R2)
		l.d	F8, v2(R3)			
		l.d	F9, v3(R3)
		l.d	F14, v2(R4)			
		l.d	F15, v3(R4)
		l.d	F22, v2(R5)			
		l.d	F23, v3(R5)
				
		mul.d 	F5, F2, F3		# v2[i] * v3[i] = temp[i]
		mul.d 	F10, F8, F9		# v2[i+1] * v3[i+1] = temp[i+1]
		mul.d 	F16, F14, F15	# v2[i+2] * v3[i+2] = temp[i+2]
		mul.d 	F24, F22, F23	# v2[i+3] * v3[i+3] = temp[i+3]
		
		l.d	F1, v1(R2)
		l.d	F4, v4(R2)
		l.d F11, v1(R3)
		l.d F12, v4(R3)
		l.d F17, v1(R4)
		l.d F18, v4(R4)
		l.d F26, v1(R5)
		l.d F27, v4(R5)
		
		add.d 	F5, F5, F1		# v1[i] + temp[i] = v5[i]
		add.d 	F10, F10, F11	# v1[i+1] + temp[i+1] = v5[i+1]
		add.d 	F16, F16, F17	# v1[i+2] + temp[i+2] = v5[i+2]
		add.d 	F24, F24, F26	# v1[i+3] + temp[i+3] = v5[i+3]
		
		s.d 	F5, v5(R2)
		s.d 	F10, v5(R3)
		s.d 	F16, v5(R4)
		s.d 	F24, v5(R5)
		
		mul.d 	F6, F5, F4		# v5[i] * v4[i] = v6[i]
		mul.d 	F13, F10, F12	# v5[i+1] * v4[i+1] = v6[i+1]
		mul.d 	F19, F16, F18	# v5[i+2] * v4[i+2] = v6[i+2]
		mul.d 	F28, F24, F27	# v5[i+3] * v4[i+3] = v6[i+3]
		
		s.d		F6, v6(R2)
		s.d 	F13, v6(R3)
		s.d 	F19, v6(R4)
		s.d 	F28, v6(R5)
		
		div.d 	F7, F6, F2		# v6[i] / v2[i] = v7[i]
		div.d 	F25, F13, F8	# v6[i+1] / v2[i+1] = v7[i+1]
		div.d 	F21, F19, F14	# v6[i+2] / v2[i+2] = v7[i+2]
		div.d 	F29, F28, F22	# v6[i+3] / v2[i+3] = v7[i+3]
		
		s.d 	F7, v7(R2)			
		s.d 	F25, v7(R3)
		s.d 	F21, v7(R4)
		s.d 	F29, v7(R5)
		
		daddui	R2, R2, 32
		daddui 	R3, R3, 32
		daddui  R4, R4, 32
		daddui  R5, R5, 32
		
		daddui	R1, R1, -4
		
		bnez	R1, FOR				
		
		nop
		halt					
		