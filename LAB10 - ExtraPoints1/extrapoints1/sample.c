/****************************************Copyright (c)****************************************************
**                                      
**                                 http://www.powermcu.com
**
**--------------File Info---------------------------------------------------------------------------------
** File name:               main.c
** Descriptions:            The GLCD application function
**
**--------------------------------------------------------------------------------------------------------
** Created by:              AVRman
** Created date:            2010-11-7
** Version:                 v1.0
** Descriptions:            The original version
**
**--------------------------------------------------------------------------------------------------------
** Modified by:             Paolo Bernardi
** Modified date:           03/01/2020
** Version:                 v2.0
** Descriptions:            basic program for LCD and Touch Panel teaching
**
*********************************************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "LPC17xx.h"
#include "GLCD/GLCD.h" 
#include "TouchPanel/TouchPanel.h"
#include "timer/timer.h"
#include "mine.h"
#include "button_EXINT/button.h"
#include "adc/adc.h"
#include "led/led.h"
#include "RIT/RIT.h"
#include <stdio.h>
#include <math.h>

int ball[2];
int speed[2] = {-1,1}; 		// partenza : la pallina va in basso a sinistra
int movement[2];
int clear[2];
int ball_old[2];

int speed_paddle;
int speed_paddle_prev;

int paddle_mid[2];
int paddle_sx[2];
int paddle_dx[2];

// versione int dei record da stampare, inizializzati
int punteggio = 0	;
int max = 100;

// versione stringa dei record da stampare
char score[10];
char record[10];

// flag stato del gioco
int start_game = 0;
int reset_game = 0;

#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif

int main(void)
{
	SystemInit();  												/* System Initialization (i.e., PLL)  */
	BUTTON_init();												/* BUTTON Initialization              */
  LCD_Initialization();
	init_RIT(0x004C4B40);									/* RIT Initialization 50 msec       	*/
	enable_RIT();													/* 50ms * 100MHz = 0x4C4B40						*/
	ADC_init();														/* ADC Initialization									*/
	LCD_Clear(Black);
	
	
	
	if(start_game == 0){
		// prima volta che parti
		sprintf(score,"%d",punteggio);
		sprintf(record,"%d",max);
		GUI_Text(70,140,(unsigned char*) "Press KEY1 to",White,Black);
		GUI_Text(65,160,(unsigned char*) "start the game",White,Black);
	}
	
	
	
	LPC_SC->PCON |= 0x1;									// power-down	mode										
	LPC_SC->PCON &= ~(0x2);						
	
	LPC_PINCON->PINSEL1 |= (1<<21);
	LPC_PINCON->PINSEL1 &= ~(1<<20);
	LPC_GPIO0->FIODIR |= (1<<26);

  while (1)	
  {
		__ASM("wfi");
  }
	
}

/*********************************************************************************************************
      END FILE
*********************************************************************************************************/
