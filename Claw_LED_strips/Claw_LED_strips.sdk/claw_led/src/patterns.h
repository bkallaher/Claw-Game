/*
 * patterns.h
 *
 *  Created on: Jun 15, 2016
 *      Author: Brandon Kallaher
 */

#ifndef SRC_PATTERNS_H_
#define SRC_PATTERNS_H_

#include "DigiLED.h"
#include <stdlib.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xil_types.h"
#include "xil_io.h"

#define num_led 90
#define leds_per_strip 30
#define num_patterns 11
#define hue_max 1525
#define max_fade 100

typedef struct hsv_data{
	uint16_t hue;
	uint8_t sat;
	uint8_t val;
}HSV_DATA;

int antipodal_index(int i);
void mult_rotate(int trail_len);
void pulse();
void rotate();
void randTwinkle(int num_on);
void singleColor(int h, int s, int v);
void rainbow_fade();
void rainbow_loop(int istep);
void HSVtoRGB(int hue, int sat, int val, int colors[3]);
void police_lightsONE();
void police_lightsALL();
int adjacent_ccw(int i);
int adjacent_cw(int i);
void color_bounceFADE();

#endif /* SRC_PATTERNS_H_ */
