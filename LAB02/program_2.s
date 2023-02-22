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


		dadd 	R2, R0, R0		#  FDEMW       offset                      6+1 + 55*40 + 1
		daddui 	R1, R0, 40		#   FDEMW	   indice

FOR:
		l.d	F1, v1(R2)			#	  FDEMW
		l.d	F2, v2(R2)			#	   FDEMW
		l.d	F3, v3(R2)			#	    FDEMW
		l.d	F4, v4(R2)			#	     FDEMW	
		mul.d 	F5, F2, F3		#		      FDmmmmmmmmMW	
		add.d 	F5, F5, F1		#		       FDsssssssaaaaaaMW
		mul.d 	F6, F5, F4		#			FsssssssDsssssmmmmmmmmMW
		div.d 	F7, F6, F2		#			        FsssssDsssssssddddddddddddddddddddddddMW
		s.d 	F5, v5(R2)		#				      FsssssssDEMW
		s.d	F6, v6(R2)			#				      FDEMW
		s.d 	F7, v7(R2)		#					       FDsssssssssssssssssssssEMW	
		daddui	R1, R1, -1		#					        FsssssssssssssssssssssDEMW
		daddi	R2, R2, 8		#					        		      FDEMW
		bnez	r1, FOR			#							       FDEMW
		nop						#						        F----
	
		halt					#							         FDEMW