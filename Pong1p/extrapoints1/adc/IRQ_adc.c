/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_adc.c
** Last modified Date:  20184-12-30
** Last Version:        V1.00
** Descriptions:        functions to manage A/D interrupts
** Correlated files:    adc.h
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "lpc17xx.h"
#include "adc.h"
#include "../led/led.h"
#include "stdlib.h"
#include "../mine.h"

/*----------------------------------------------------------------------------
  A/D IRQ: Executed when A/D Conversion is ready (signal from ADC peripheral)
 *----------------------------------------------------------------------------*/

int first = -1;

unsigned short AD_current;   
unsigned short AD_last = 0xFF;     /* Last converted value               */

unsigned short AD_current_prev = 0;
unsigned short AD_last_prev = 0xFF;

unsigned short AD_max = 0xFFF;

unsigned short value = 3;						// ipotizzo posizione centrale del potenziometro
unsigned short prev_value;

extern int speed_paddle_prev;
extern int speed_paddle;

void ADC_IRQHandler(void) {
	
	// AD_current_prev = AD_current;
	// AD_last_prev = AD_last;
	prev_value = value;
	speed_paddle_prev = speed_paddle;
  	
  AD_current = ((LPC_ADC->ADGDR>>4) & 0xFFF);/* Read Conversion Result             */
  if(AD_current != AD_last){
		
		first++;
		
		// ad_current : AD_max = value : 7
		value = (AD_current*7)/AD_max;
		
		if(value == 0 && first>0){	// estrema rotazione verso sinistra
			speed_paddle = -15;
		} else if(value == 1){	
			speed_paddle = -10;
		} else if(value == 2){
			speed_paddle = -5;
		} else if(value == 3){	// centro della rotazione
			speed_paddle = 0;
		} else if(value == 4){
			speed_paddle = 5;
		} else if(value == 5){
			speed_paddle = 10;
		} else if(value == 6 || value == 7){	// estrema rotazione verso destra
			speed_paddle = 15;
		}
		
		AD_last = AD_current;
  }	
}
