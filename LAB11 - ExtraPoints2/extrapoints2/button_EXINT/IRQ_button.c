#include "button.h"
#include "lpc17xx.h"
#include "../mine.h"
#include "../led/led.h"
#include "../timer/timer.h"
#include "../GLCD/GLCD.h" 

int pause_game = 0;
extern int reset_game;
extern int start_game;
extern int speed[2];
extern int segno_x;
extern int segno_y;

extern int punteggio;
extern int max;

extern int key1;
extern int int0;
extern int key2;

void EINT0_IRQHandler (void)	  	// INT0 --> RESET
{
	NVIC_DisableIRQ(EINT0_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 20);     /* GPIO pin selection */
	int0=1;
	/*
	start_game = 0; // se faccio reset, ha senso premere KEY1 per ricominciare
	reset_game = 1;	// reset valido
	pause_game = 2; // pause non valido, essendo in RESET
	UPDATE_Score(punteggio,max);
	disable_timer(0);
	// ripristino settings di partenza: la pallina va in basso a sinistra
	speed[0] = -1;
	speed[1] = 1;
	segno_x = -1;
	segno_y = 1;
	LCD_Clear(Black);
	GUI_Text(100,120,(unsigned char*) "RESET!",White,Black);
	GUI_Text(70,140,(unsigned char*) "Press KEY1 to",White,Black);
	GUI_Text(65,160,(unsigned char*) "start the game",White,Black);
	*/
	LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
	
}


void EINT1_IRQHandler (void)	  	// KEY 1 --> START
{
	NVIC_DisableIRQ(EINT1_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 22);     /* GPIO pin selection */
	key1=1;
	/*
	pause_game = 0; // setto per partire con KEY1
	if(start_game == 0){
		LCD_Clear(Black);
		START_game();
		init_timer(0,0x186A0);									// 100000 
		enable_timer(0);	
		start_game = 1; // premuto KEY1, devo aspettare di fare RESET o GAME OVER per ripremere KEY1
	}
	*/
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
	
}

void EINT2_IRQHandler (void)	  	// KEY 2 --> PAUSE 
{
	
	NVIC_DisableIRQ(EINT2_IRQn);		/* disable Button interrupts			 */
	LPC_PINCON->PINSEL4    &= ~(1 << 24);     /* GPIO pin selection */
	key2=1;
	/*
	if(pause_game !=2)	// vale 2 solo dopo aver premuto RESET
		start_game = 1; // se faccio pause, NON ha senso premere KEY1
	if(pause_game == 0){
		disable_timer(0);
		GUI_Text(100,120,(unsigned char*) "PAUSE!",White,Black);
		GUI_Text(70,140,(unsigned char*) "Press KEY2 to",White,Black);
		GUI_Text(65,160,(unsigned char*) "resume the game",White,Black);
		pause_game=1;
	} else if (pause_game == 1){
		enable_timer(0);
		GUI_Text(100,120,(unsigned char*) "PAUSE!",Black,Black);
		GUI_Text(70,140,(unsigned char*) "Press KEY2 to",Black,Black);
		GUI_Text(65,160,(unsigned char*) "resume the game",Black,Black);
		pause_game = 0;
	}
	*/
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */  
}


