#include "mine.h"
#include "GLCD/GLCD.h" 
#include "stdlib.h"
#include "timer/timer.h"
#include <stdio.h>
#include "math.h"

#define LOW_NOTE 2050
#define HIGH_NOTE 1050

static int i;
static int j;

extern int ball[2];
extern int speed[2];
extern int movement[2];
extern int clear[2];
extern int ball_old[2];
int segno_x = -1;
int segno_y = 1;

// in paddle_ mi salvo la coordinata in alto centrale, sinistra e destra

extern int paddle_mid[2];
extern int paddle_sx[2];
extern int paddle_dx[2];

extern int speed_paddle;
extern int speed_paddle_prev;
extern unsigned short AD_current;
extern unsigned short AD_last;
extern unsigned short value;
extern unsigned short prev_value;

extern int start_game;
extern int reset_game;

extern int punteggio;
extern int max;

extern char score[10];
extern char record[10];

void DRAW_Walls(){
	for(i=0;i<5;i++){
		LCD_DrawLine(0,i,240,i,Red);
	}
	for(i=0;i<5;i++){
		LCD_DrawLine(i,320-32,i,0,Red);
	}
	for(i=240;i>235;i--){
		LCD_DrawLine(i,320-32,i,0,Red);
	}
}

void DRAW_Paddle(){
	for(i=0;i<10;i++){	
		LCD_DrawLine(100,320-32-i,140,320-32-i,Green);
		paddle_mid[1] = 320-32-i;
	}
	paddle_sx[0] = 100;
	paddle_mid[0] = 120;
	paddle_dx[0] = 140;
	
	paddle_sx[1] = paddle_dx[1] = paddle_mid[1];
	
	/*LCD_SetPoint(paddle_mid[0],paddle_mid[1],Green);
	LCD_SetPoint(paddle_sx[0],paddle_sx[1],Green);
	LCD_SetPoint(paddle_dx[0],paddle_dx[1],Green);*/
}
/*
void DRAW_Ball(){
	for(i=0;i<5;i++){
		for(j=0;j<5;j++){
			ball[0] = 240 - 6 - i;
			ball[1] = 160 - 6 - j;
			LCD_SetPoint(ball[0],ball[1],Green);
			movement[0] = ball[0] + speed[0];
			movement[1] = ball[1] + speed[1];
		}
	}
	//ball[0] = 230;
	//ball[1] = 150;
}
*/


void DRAW_Ball(){
	ball[0] = 240-6;
	ball[1] = 160-6;
	movement[0] = ball[0];
	movement[1] = ball[1];
	for(i=0;i<5;i++){
		for(j=0;j<5;j++){
			ball[0] = movement[0] + segno_x *i ;
			ball[1] = movement[1] + segno_y *j ;
			LCD_SetPoint(ball[0],ball[1],Green);
			//LCD_SetPoint(ball[0] -segno_x*5, ball[1] -segno_y*5, Black);
		}
	}
	
}


void DRAW_Score(){
	GUI_Text(10,160, (uint8_t *) score, White, Black);
	// PutChar(10,160,score,White,Black);
	GUI_Text(205,10, (uint8_t *) record, White, Black);
	// PutChar(220,10,100,White,Black);
}

void MOVE(){
	
	if(ball[0] < 10){	// muro sinistro
		lowNOTE();
		movement[1] = ball[1] + speed[1];
		speed[0] = -speed[0];
		movement[0] = ball[0] + speed[0];
		// la pallina viene da sopra:
		if(ball[1] - ball_old[1] > 0){
			movement[0] += 4;
			segno_x = 1;
			segno_y = 1;
		}else{ // la pallina viene da sotto
			movement[0] += 4;
			segno_x = 1;
			segno_y = -1;
		}
		// muro sinistro ripristinato
			for(i=0;i<5;i++){
				LCD_DrawLine(i,320-32,i,0,Red);
			}
		// refresh grafico punteggi
		DRAW_Score();
	} else if (ball[0] > 230) {	// muro destro
		lowNOTE();
		movement[1] = ball[1] + speed[1];
		speed[0] = -speed[0];
		movement[0] = ball[0] + speed[0];
		// la pallina viene da sopra:
		if(ball[1] - ball_old[1] > 0){
			movement[0] -= 4;
			segno_x = -1;
			segno_y = 1;
		}else{ // la pallina viene da sotto
			movement[0] -= 4;
			segno_x = -1;
			segno_y = -1;
		}
		// muro destro ripristinato
			for(i=240;i>235;i--){
				LCD_DrawLine(i,320-32,i,0,Red);
			}
		// refresh grafico punteggi
			DRAW_Score();
	} else if (ball[1] < 10){		// muro superiore
		lowNOTE();
		movement[0] = ball[0] + speed[0];
		speed[1] = -speed[1];
		movement[1] = ball[1] + speed[1] ;
		// la pallina viene da destra:
		if(ball[0] - ball_old[0] < 0){
			movement[1] += 4;
			segno_x = -1;
			segno_y = 1;
		}else{ 										// la pallina viene da sinistra.
			movement[1] += 4;
			segno_x = 1;
			segno_y = 1;
		}
		// muro superiore ripristinato
			for(i=0;i<5;i++){
				LCD_DrawLine(0,i,240,i,Red);
			}
		// refresh grafico punteggi
		DRAW_Score();
	} else if ( ball[1] >=  278) {   // regione paddle
		
		if ( ball[0] >= paddle_sx[0] && ball[0] <= paddle_dx[0] ) { // paddle colpito
			
			UPDATE_Score(punteggio,max);
			
			speed[0] = CHANGE_Speed(speed[0]);
			highNOTE();
			movement[0] = ball[0] + speed[0];
			speed[1] = -speed[1];
			movement[1] = ball[1] + speed[1] ;
			// la pallina viene da destra:
			if(ball[0] - ball_old[0] < 0){
				movement[1] -= 4;
				segno_x = -1;
				segno_y = -1;
			}else{ 										// la pallina viene da sinistra.
				movement[1] -= 4;
				segno_x = 1;
				segno_y = -1;
			}
			
			
		} else {
			// hai perso
			LOSE();
		}
		
		
	} else {										// no touching
		movement[0] = ball[0] + speed[0];
		movement[1] = ball[1] + speed[1];
	}
	
	
	ball_old[0] = movement[0] + segno_x;
	ball_old[1] = movement[1] + segno_y;
	
	// coloro di nero la posizione in cui si trovava la pallina al tempo i-1
	
	for(i=0;i<5;i++){
		for(j=0;j<5;j++){
			clear[0] = movement[0] + segno_x *i ;
			clear[1] = movement[1] + segno_y *j ;
			// 5 se 45 gradi, 6 se 30 gradi
			LCD_SetPoint(clear[0] - segno_x*(5+(abs(speed[0])-1)), clear[1] - segno_y*(5+(abs(speed[1])-1)), Black);
			//LCD_SetPoint(ball[0] -segno_x*5, ball[1] -segno_y*5, Black);
		}
	}
	
	// coloro di verde la posizione in cui si trova la pallina al tempo i
	
	for(i=0;i<5;i++){
		for(j=0;j<5;j++){
			ball[0] = movement[0] + segno_x *i ;
			ball[1] = movement[1] + segno_y *j ;
			LCD_SetPoint(ball[0],ball[1],Green);
			//LCD_SetPoint(ball[0] -segno_x*5, ball[1] -segno_y*5, Black);
		}
	}

}

void START_game(){
	DRAW_Walls();
	DRAW_Paddle();
	DRAW_Ball();
	DRAW_Score();
	enable_timer(0);
}

void MOVE_Paddle(){
	
			
			// aggiornamento posizione paddle
	
			paddle_sx[0] = paddle_sx[0] + speed_paddle;
			// paddle_mid[0] = paddle_mid[0] + speed_paddle;
			paddle_dx[0] = paddle_dx[0] + speed_paddle;
			
	
			// controllo limite sinistro
	
			if ( paddle_sx[0] <= 6){
				paddle_sx[0] = 5;
				paddle_dx[0] = 45;
			}
			// controllo limite destro
			
			if ( paddle_dx[0] >= 234){
				paddle_sx[0] = 194;
				paddle_dx[0] = 234;
			}
			
			
			if ( speed_paddle > 0 ){
				// mi sposto verso destra di 'speed_paddle'
				// --> devo cancellare alla sinistra del paddle di 'speed_paddle'		
					for(i=0;i<10;i++){	
						LCD_DrawLine(paddle_sx[0]-speed_paddle,320-32-i,paddle_sx[0],320-32-i,Black);
					}
					// muro destro ripristinato
					if( paddle_dx[0] >= 220 && paddle_dx[0] <= 235){
						for(i=240;i>234;i--){
							LCD_DrawLine(i,320-32,i,0,Red);
						}
					}
			} else if ( speed_paddle < 0 ){
				// mi sposto verso sinistra di 'speed_paddle'
				// --> devo cancellare alla destra del paddle di 'speed_paddle'	
					for(i=0;i<10;i++){
						LCD_DrawLine(paddle_dx[0]-speed_paddle,320-32-i,paddle_dx[0],320-32-i,Black);
					}
					// muro sinistro ripristinato
					if( paddle_sx[0] >= 5 && paddle_sx[0] <= 20){
						for(i=0;i<5;i++){
							LCD_DrawLine(i,320-32,i,0,Red);
						}
					}
			}
			// disegno paddle in posizione aggiornata
				for(i=0;i<10;i++){	
					LCD_DrawLine(paddle_sx[0],320-32-i,paddle_dx[0],320-32-i,Green);
				}
	
}

int CHANGE_Speed(int speed){
	
	if(abs(speed) == 1){
		if(speed < 0){
				speed = -2;
		} else if(speed > 0){
				speed = 2;
		}	
	}
	else if(abs(speed) == 2){
			if(speed < 0){
				speed = -3;
			} else if(speed > 0){
				speed = 3;
			}
	} else {
			if (speed < 0){
				speed = -1;
			} else if (speed > 0){
				speed = 1;
			}
	}
	return speed;
}


void LOSE(){
	
	static int k=0;
	
	for(k=0;k<5;k++){
		
		movement[0] = ball[0] + speed[0];
		movement[1] = ball[1] + speed[1];
		
		// coloro di nero la posizione in cui si trovava la pallina al tempo i-1
		
		for(i=0;i<5;i++){
			for(j=0;j<5;j++){
				clear[0] = movement[0] + segno_x *i ;
				clear[1] = movement[1] + segno_y *j ;
				// 5 se 45 gradi, 6 se 30 gradi
				LCD_SetPoint(clear[0] - segno_x*(5+(abs(speed[0])-1)), clear[1] - segno_y*(5+(abs(speed[1])-1)), Black);
				//LCD_SetPoint(ball[0] -segno_x*5, ball[1] -segno_y*5, Black);
			}
		}
		
		// coloro di verde la posizione in cui si trova la pallina al tempo i
		
		for(i=0;i<5;i++){
			for(j=0;j<5;j++){
				ball[0] = movement[0] + segno_x *i ;
				ball[1] = movement[1] + segno_y *j ;
				LCD_SetPoint(ball[0],ball[1],Green);
				//LCD_SetPoint(ball[0] -segno_x*5, ball[1] -segno_y*5, Black);
			}
		}
		
	}
	
		GUI_Text(90,140,(unsigned char*) "You Lose",White,Black);
		disable_timer(0);
		// ripristino settings di partenza: la pallina va in basso a sinistra
		speed[0] = -1;
		speed[1] = 1;
		segno_x = -1;
		segno_y = 1;
		GUI_Text(70,180,(unsigned char*) "Press KEY1 to",White,Black);
		GUI_Text(65,200,(unsigned char*) "restart the game",White,Black);
		start_game = 0; // ha senso premere KEY1
}



void UPDATE_Score(int score_par, int record_par){
	
	if (score_par < 100 ){
		punteggio+=5;
	} else {
		punteggio+=10;
	}
	
	if (score_par >= record_par){
		max = punteggio;
	}
	
	sprintf(score,"%d",punteggio);
	sprintf(record,"%d",max);
	
	if(reset_game == 1){
		punteggio = 0;
		max = 100;
		sprintf(score,"%d",punteggio);
		sprintf(record,"%d",max);
		reset_game = 0;
	}
	
	DRAW_Score();
	
}

void lowNOTE(){
	reset_timer(1);
	//disable_timer(1);
  init_timer(1,LOW_NOTE);
  enable_timer(1);
}

void highNOTE(){
	reset_timer(1);
	//disable_timer(1);
  init_timer(1,HIGH_NOTE);  
  enable_timer(1);
}


