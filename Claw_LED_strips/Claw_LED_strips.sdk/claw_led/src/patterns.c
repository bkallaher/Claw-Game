/*
 * patterns.c
 *
 *  Created on: Jun 15, 2016
 *      Author: Brandon Kallaher
 */


#include "patterns.h"
#include "DigiLED.h"
#include "xil_types.h"

int dir = 1;
int fader = 0;
int fade_dir = 0;
int pos_index = 0;
int ihue = 0;
int loop_index = 0;
int bouncedirection = 0;
short values[16];
short next_values[16];

HSV_DATA colors[4] =
{
		{510, 255, 60}, //Green
		{200, 255, 60}, //Yellow
		{1, 255, 60},  //Red
};

//-FIND INDEX OF ANTIPODAL OPPOSITE LED
int antipodal_index(int i) {
  //int N2 = int(NUM_LEDS/2);
  int iN = i + num_led/2;
  if (i >= num_led/2) {iN = ( i + num_led/2 ) % num_led; }
  return iN;
}

//-FIND ADJACENT INDEX CLOCKWISE
int adjacent_cw(int i) {
  int r;
  if (i < num_led - 1) {r = i + 1;}
  else {r = 0;}
  return r;
}


//-FIND ADJACENT INDEX COUNTER-CLOCKWISE
int adjacent_ccw(int i) {
  int r;
  if (i > 0) {r = i - 1;}
  else {r = num_led - 1;}
  return r;
}

//Same as rotate but with a trail of LEDs
void mult_rotate(int trail_len)
{
	int i = 0;
	clearLEDs(num_led);
	if (pos_index == num_led) pos_index = 0;

	for (i = 0; i < trail_len - 1; i++)
	{
		if (pos_index + i > num_led) SetLEDColor(pos_index + i - num_led - 1, colors[0].hue, colors[0].sat, colors[0].val);
		else SetLEDColor(pos_index + i, colors[0].hue, colors[0].sat, colors[0].val);
	}
	pos_index++;
	for (i = 0; i < 500000; i++);
}

void pulse()
{
	int i = 0;
	if (fade_dir)
	{
		fader--;
		if (fader == 0)
		{
			fade_dir = 0;
		}
		for (i = 0; i < num_led; i++) SetLEDColor(i, colors[0].hue, colors[0].sat, fader);
	}
	else
	{
		fader++;
		if (fader == max_fade)
		{
			fade_dir = 1;
		}
		for (i = 0; i < num_led; i++) SetLEDColor(i, colors[0].hue, colors[0].sat, fader);
	}
	for (i = 0; i < 100000; i++);
}

void rotate()
{
	int i = 0;
	clearLEDs(num_led);
	SetLEDColor(pos_index, colors[0].hue, colors[0].sat, colors[0].val);
	pos_index++;
	if (pos_index == num_led) pos_index = 0;
	for (i = 0; i < 250000; i++);
}

void randTwinkle(int num_on)
{
	int i = 0;
	clearLEDs(num_led);
	for (i = 0; i < num_on; i++)
	{
		SetLEDColor(rand()%num_led, rand()%hue_max, rand()%255, 50);
	}
	for (i = 0; i < 1000000; i++);
}

void singleColor(int h, int s, int v)
{
	int i = 0;

	for(i = 0; i < num_led; i++)
	{
		SetLEDColor(i, h, s, v);
	}
}

void rainbow_fade()
{ //-FADE ALL LEDS THROUGH HSV RAINBOW
    int idex = 0;
	ihue++;
    if (ihue >= hue_max) {ihue = 0;}
    for(idex = 0 ; idex < num_led; idex++ ) {
      SetLEDColor(idex,ihue,255,60);
    }
    for (idex = 0; idex < 100000; idex++);
}

void rainbow_loop(int istep)
{ //-LOOP HSV RAINBOW
	int i = 0;
	ihue = ihue + istep;

	if (loop_index >= num_led) {loop_index = 0;}
	if (ihue >= hue_max) {ihue = 0;}

	SetLEDColor(loop_index, ihue, 255, 60);
	for (i = 0; i < 200000; i++);
	loop_index++;
}

void police_lightsONE()
{ //-POLICE LIGHTS (TWO COLOR SINGLE LED)
  loop_index++;
  int i = 0;
  if (loop_index >= num_led) {loop_index = 0;}
  int idexR = loop_index;
  int idexB = antipodal_index(idexR);
  for(i = 0; i < num_led; i++ ) {
    if (i == idexR) {SetLEDColor(i, 0, 255, 255);}
    else if (i == idexB) {SetLEDColor(i, 900, 255, 255);}
    else {SetLEDColor(i, 0, 0, 0);}
  }
  for (i = 0; i < 100000; i++);
}

void police_lightsALL()
{ //-POLICE LIGHTS (TWO COLOR SOLID)
	int i = 0;
	loop_index++;
	if (loop_index >= num_led) {loop_index = 0;}
	int idexR = loop_index;
	int idexB = antipodal_index(idexR);
	SetLEDColor(idexR, 0, 255, 150);
	SetLEDColor(idexB, 900, 255, 150);
	for (i = 0 ; i < 80000; i++);
}

void color_bounceFADE() { //-BOUNCE COLOR (SIMPLE MULTI-LED FADE)
	int i = 0;
	if (bouncedirection == 0) {
		loop_index = loop_index + 1;
		if (loop_index == num_led) {
		  bouncedirection = 1;
		  loop_index = loop_index - 1;
		}
    }
  if (bouncedirection == 1) {
	  loop_index = loop_index - 1;
    if (loop_index == 0) {
      bouncedirection = 0;
    }
  }
  int iL1 = adjacent_cw(loop_index);
  int iL2 = adjacent_cw(iL1);
  int iL3 = adjacent_cw(iL2);
  int iR1 = adjacent_ccw(loop_index);
  int iR2 = adjacent_ccw(iR1);
  int iR3 = adjacent_ccw(iR2);

  for(i = 0; i < num_led; i++ ) {
    if (i == loop_index) {SetLEDColor(i, 510, 255, 255);}
    else if (i == iL1) {SetLEDColor(i, 510, 255, 99);}
    else if (i == iL2) {SetLEDColor(i, 510, 255, 48);}
    else if (i == iL3) {SetLEDColor(i, 510, 255, 10);}
    else if (i == iR1) {SetLEDColor(i, 510, 255, 99);}
    else if (i == iR2) {SetLEDColor(i, 510, 255, 48);}
    else if (i == iR3) {SetLEDColor(i, 510, 255, 10);}
    else {SetLEDColor(i, 0, 0, 0);}
  }

  for (i = 0; i < 1000000; i++);
}
