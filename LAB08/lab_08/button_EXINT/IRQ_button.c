#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"

extern int val_leds;
extern uint8_t n_value;			
extern uint8_t n_1_value; 	
extern uint8_t n_2_value;	


void EINT0_IRQHandler (void)	  
{
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
	
	val_leds = 1;
	LED_Out(val_leds);
	n_value = 1;
	n_1_value = 0;
	n_2_value = 0;	
	
}


void EINT1_IRQHandler (void)	  
{
	
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
	
	if ( n_value >= 233){
		val_leds = n_value;
		LED_Out(val_leds);
	}
	else{
	n_2_value = n_1_value; 
	n_1_value = n_value;   
	n_value = n_1_value + n_2_value; 
	
	val_leds = n_value;
	LED_Out(val_leds);
	
	}
}

void EINT2_IRQHandler (void)	  
{
	static int tmp;
	
	LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */   

	if ( n_value == 1){
		val_leds = n_value;
		LED_Out(val_leds);
	}else{
	tmp = n_1_value - n_2_value;
	n_value = n_1_value; 
	n_1_value = n_2_value; 
	n_2_value = tmp; 
	
	val_leds = n_value;
	LED_Out(val_leds);
	
	}		
}


