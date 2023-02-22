;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF
				
				
				AREA 	my_data1, DATA, READWRITE
total_tickets	space 4
	
				AREA	my_data2, DATA, READWRITE
				space 48
Sector_quantity_update 
				DCD 0x02, 250, 0x05, 250, 0x03, 550, 0x01, 150, 0x04
				DCD 100, 0x06, 200	

                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK] 


				; loop iniziale per ricopiare valori default di sector_quantity in sector_quantity_update
				LDR		R0, = Sector_quantity_update 
				LDR		R1, = Sector_quantity
				MOV 	R2, #12
				
loop_in			LDR		R3, [R1]
				STR		R3, [R0]
				ADD		R1, R1, #4
				ADD		R0, R0, #4
				SUBS	R2, R2, #1
				BNE		loop_in
				
				
				LDR		R0, = Sector_prices			; puntatore all'indirizzo inizio vettore 'sector_prices'
				LDR		R1, = Sector_quantity_update ; puntatore all'indirizzo inizio vettore 'sector_quantity'
				LDR		R2, = Num_sectors			
				LDR 	R2, [R2]					; numero di settori disponibili
				MOV		R11, R2
				LDR		R3, = Tickets				; puntatore all'indirizzo inizio vettore di request 'tickets'
				LDR		R4, = Ticket_requests		
				LDR		R4, [R4]					; tickets request
				
loop1			; riaggiorno i dati memorizzati in memoria per i cicli successivi
				
				LDR		R0, = Sector_prices			; puntatore all'indirizzo inizio vettore 'sector_prices'
				LDR		R1, = Sector_quantity_update ; puntatore all'indirizzo inizio vettore 'sector_quantity'
				LDR		R2, = Num_sectors			
				LDR 	R2, [R2]					; numero di settori disponibili
				MOV		R11, R2
				
				; inizio 'vero' del loop
				
				LDR		R5, [R3]					; leggo richiesta SETTORE i-esimo				
				LDR 	R6, [R3, #4]				; leggo richiesta QUANTITA' dell'i-esimo SETTORE
				
				

loop2			LDR		R7, [R1]					; leggo SETTORE j-esimo
				LDR     R8, [R1, #4]				; leggo QUANTITA' disponibile del j-esimo SETTORE
				CMP 	R5, R7						; verifico se il settore è quello richiesto
				BEQ 	loop3
				ADD		R1, R1, #8					; aggiorno ciclo interno (j)
				SUBS	R2, R2, #1					; decremento counter di ciclo interno (j)
				BNE		loop2

				ADD		R3, R3, #8					; aggiorno ciclo esterno (i)
				
				
loop3			SUBS	R10, R8, R6					; la quantità richiesta è disponibile?	disponibile (R8) - richiesta (R6)
				
				LDRMI	R9, = total_tickets			; se il SETTORE è SOLD-OUT 
				MOVMI	R10, #0						
				STRMI	R10, [R9]					; 0 in total_tickets
				MOVMI	R11, #0x01 					; 0x01 in R11
				ADDMI	R3, R3, #8					; aggiorno ciclo esterno (i)

				LDRNE	R9, [R0]					; leggo SETTORE k-esimo
				LDRNE	R10, [R0, #4]				; leggo PREZZO del SETTORE k-esimo
				CMPNE 	R5, R9
				
				BEQ		uguale						; non potendo usare doppi conditional flag, splitto con due salti
				BNE		non_uguale
				
uguale			
				MUL		R10, R10, R6				; moltiplico prezzo per quantità richiesta
				PUSH	{R0}						; finiti i registri, salvo momentaneamente r0 per usarlo
				CMP		R6, #10						; se i biglietti richiesti sono > 10 --> 
				MOVGT	R0, #2						; BLACK FRIDAY ---> 
				SDIVGT	R10, R10, R0 				; 50% di SCONTO
				POP 	{R0}						
				ADD 	R12, R12, R10				; aggiorno prezzo totale
				SUB		R8, R8, R6					; aggiorno registro quantità disponibile
				ADD		R1, R1, #4					
				STR		R8, [R1]					; aggiorno vettore quantità disponibile
				SUB		R1, R1, #4
				CMP		R5, R9						; rifaccio la compare per attivare i flag per le operazioni sotto
				
non_uguale		ADDEQ	R3, R3, #8					; aggiorno ciclo esterno (i)
				MOVEQ	R11, #1						; aggiorno counter per terminare il loop3, visto che ho trovato il match per questo 'giro'
				
				ADD		R0, R0, #8					; aggiorno ciclo (k)
				SUBS	R11, R11, #1				; decremento counter di ciclo (k)
				BNE		loop3
								
				SUBS	R4, R4, #1					; decremento counter di ciclo esterno (i)
                BNE		loop1
				
				LDR		R0, = total_tickets			; rileggo indirizzo della variabile result in RAM
				STR		R12, [R0]					; e la aggiorno con il prezzo totale richiesto
				
				B		.
                ENDP


Sector_prices 	DCD 0x01, 25, 0x02, 40, 0x03, 55, 0x04, 65, 0x05, 80
				DCD 0x06, 110
					
Sector_quantity DCD 0x02, 250, 0x05, 250, 0x03, 550, 0x01, 150, 0x04
				DCD 100, 0x06, 200						
										
Num_sectors 	DCB 6

Tickets 		DCD 0x05, 2, 0x03, 10, 0x01, 120
	
Ticket_requests DCD 3



; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END
