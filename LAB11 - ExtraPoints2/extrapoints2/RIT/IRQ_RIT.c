/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "RIT.h"
#include "../led/led.h"
#include "../GLCD/GLCD.h" 
#include "../mine.h"
#include "../button_EXINT/button.h"
#include "../timer/timer.h"

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

int key1=0;
int int0=0;
int key2=0;

extern int pause_game;
extern int reset_game;
extern int start_game;
extern int speed[2];
extern int segno_x;
extern int segno_y;

extern int punteggio;
extern int punteggio_sup;
extern int max;

void RIT_IRQHandler (void)
{					
	
	/* button INT0 management */
	if(int0 > 1){ 
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){	/* INT0 pressed */				
			switch(int0){
				case 2:
					/* ASM */
					start_game = 0; // se faccio reset, ha senso premere KEY1 per ricominciare
					reset_game = 1;	// reset valido
					pause_game = 2; // pause non valido, essendo in RESET
					UPDATE_Score_2(punteggio,punteggio_sup);
					disable_timer(0);
					//disable_timer(1);
					// ripristino settings di partenza: la pallina va in basso a sinistra
					speed[0] = -1;
					speed[1] = 1;
					segno_x = -1;
					segno_y = 1;
					LCD_Clear(Black);
					GUI_Text(100,120,(unsigned char*) "RESET!",White,Black);
					GUI_Text(70,140,(unsigned char*) "Press KEY1 to",White,Black);
					GUI_Text(67,160,(unsigned char*) "start the game",White,Black);
					break;
				default:
					break;
			}
			int0++;
		}
		else {	/* button INT0 released */
			int0=0;			
			NVIC_EnableIRQ(EINT0_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 20);     /* External interrupt 0 pin selection */
		}
	}
	else {
		if (int0 == 1)
			int0++;
	}
			
	
	/* button KEY1 management */
	if(key1 > 1){ 
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* KEY1 pressed */				
			switch(key1){
				case 2:
					pause_game = 0; // setto per partire con KEY1
					if(start_game == 0){
						LCD_Clear(Black);
						START_game();
						init_timer(0,0x186A0);									// 100000 
						enable_timer(0);
						//init_timer(1,0x7A120);									// 500000
						//enable_timer(1);
						start_game = 1; // premuto KEY1, devo aspettare di fare RESET o GAME OVER per ripremere KEY1
					}
						
					break;
				default:
					break;
			}
			key1++;
		}
		else {	/* button KEY1 released */
			key1=0;			
			NVIC_EnableIRQ(EINT1_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	}
	else {
		if(key1 == 1)
			key1++;
	}
	
	/* button KEY2 management */
	if(key2 > 1){ 
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){	/* KEY2 pressed */				
			switch(key2){
				case 2:
					if(pause_game !=2)	// vale 2 solo dopo aver premuto RESET
						start_game = 1; // se faccio pause, NON ha senso premere KEY1
					if(pause_game == 0){
						disable_timer(0);
						//disable_timer(1);
						GUI_Text(100,120,(unsigned char*) "PAUSE!",White,Black);
						GUI_Text(70,140,(unsigned char*) "Press KEY2 to",White,Black);
						GUI_Text(65,160,(unsigned char*) "resume the game",White,Black);
						pause_game=1;
					} else if (pause_game == 1){
						enable_timer(0);
						//enable_timer(1);
						GUI_Text(100,120,(unsigned char*) "PAUSE!",Black,Black);
						GUI_Text(70,140,(unsigned char*) "Press KEY2 to",Black,Black);
						GUI_Text(65,160,(unsigned char*) "resume the game",Black,Black);
						pause_game = 0;
					}
						
					break;
				default:
					break;
			}
			key2++;
		}
		else {	/* button KEY2 released */
			key2=0;			
			NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
		}
	}
	else {
		if(key2 == 1)
			key2++;
	}
	
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
}

/******************************************************************************
**                            End Of File
******************************************************************************/
