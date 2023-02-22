/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include <string.h>
#include "lpc17xx.h"
#include "timer.h"
#include "../GLCD/GLCD.h" 
#include "../TouchPanel/TouchPanel.h"
#include "../mine.h"
#include "../adc/adc.h"

/******************************************************************************
** Function name:		Timer0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

// static int first_touch = 0;

uint16_t SinTable[45] =                                       /*                      */
{
    410, 467, 523, 576, 627, 673, 714, 749, 778,
    799, 813, 819, 817, 807, 789, 764, 732, 694, 
    650, 602, 550, 495, 438, 381, 324, 270, 217,
    169, 125, 87 , 55 , 30 , 12 , 2  , 0  , 6  ,   
    20 , 41 , 70 , 105, 146, 193, 243, 297, 353
};


void TIMER0_IRQHandler (void)
{
	ADC_start_conversion();
	MOVE_Paddle();
	MOVE_sup_Paddle();
	MOVE();
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}


/******************************************************************************
** Function name:		Timer1_IRQHandler
**
** Descriptions:		Timer/Counter 1 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/



void TIMER1_IRQHandler (void)
{
	/*
	static int ticks=0;
	if(first_touch == 0){
			ticks = -45;
	}
	first_touch = 1;
	// DAC management //	
	LPC_DAC->DACR = SinTable[ticks%45]<<6;
	ticks++;
	if(ticks==45){
		disable_timer(1);
		ticks=0;
		LPC_DAC->DACR = 0;
	}
	*/
	MOVE_sup_Paddle();
  LPC_TIM1->IR = 1;			// clear interrupt flag 
  return;
}


void TIMER2_IRQHandler (void)
{
  LPC_TIM2->IR = 1;			/* clear interrupt flag */
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
