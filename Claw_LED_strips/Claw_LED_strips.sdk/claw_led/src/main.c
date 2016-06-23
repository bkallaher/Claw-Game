/*
 * main.c
 *
 *  Created on: Jun 15, 2016
 *      Author: Brandon Kallaher
 */

#include "DigiLED.h"
#include "xgpio.h"
#include "patterns.h"

char prev_btn_st = 0;
char init = 0;
short case_ID = 0;
int state = 0;
XGpio gpio; //For reading the Push buttons

int main(void)
{
	//Initialize the Buttons
	XGpio_Initialize(&gpio, 0);
	XGpio_SetDataDirection(&gpio, 1, 0xFFFF);

	//Prep the LEDs
	clearLEDs(num_led);
	enable_LEDs();

	//Main loop
	while (1)
	{
		//Read the button once per loop
		state = XGpio_DiscreteRead(&gpio, 1);
		if ((state == 1) && !prev_btn_st)
		{
			prev_btn_st = 1;
			init = 0;
			if (case_ID < num_patterns - 1) case_ID++;
			else case_ID = 0;
		}
		else if ((state == 1) && prev_btn_st)
			clearLEDs(num_led);
		else
		{
			prev_btn_st = 0;
			switch(case_ID)
			{
			case 0:
				rainbow_loop(15);
				break;
			case 1:
				pulse();
				break;
			case 2:
				rotate();
				break;
			case 3:
				randTwinkle(10);
				break;
			case 4:
				singleColor(510, 255, 60);
				break;
			case 5:
				rainbow_fade();
				break;
			case 6:
				mult_rotate(6);
				break;
			case 7:
				police_lightsONE();
				break;
			case 8:
				police_lightsALL();
				break;
			case 9:
				color_bounceFADE();
				break;
			default:
				clearLEDs(num_led);
				break;
			}
		}
	}


	return 0;
}
