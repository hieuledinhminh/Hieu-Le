/*
 * GccApplication1.c
 *
 * Created: 5/30/2024 9:46:10 PM
 * Author : DELL
 */ 

#define F_CPU      8000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>


#define MODE_PIN	PINC0
#define UP_PIN		PINC1
#define DOWN_PIN	PINC2

#define SWITCH_DDR	DDRC

#define MUX_WAIT_FOR_STABLE 5
#define TIME_DISPLAY_MAIN	50
#define LCD_E_PIN	PINB0
#define LCD_E_PORT	PORTB
#define LCD_E_DDR	DDRB

#define LCD_RS_PIN	PIND7
#define LCD_RS_PORT	PORTD
#define LCD_RS_DDR	DDRD

#define OUT_PUT	PIND3

uint8_t ADC_time = 0;
uint16_t ADC_Data;
uint8_t time_display = 0;

uint8_t Mode = 0;
uint8_t threshold = 0;
uint8_t buffer[10];
float temp_table[] = {13, 21, 28.4, 37, 43, 48, 52, 57, 62, 68, 78, 91};
uint16_t adc_table[] = {33, 62, 95, 133, 156, 178, 193, 216, 237, 263, 303, 358}; 
	
	

void LCD_Command(unsigned char cmd){
	cli();
	LCD_RS_PORT &= ~(1<<LCD_RS_PIN);
	PORTB &= 0xE0;
	PORTB |= 0x01 | ((0xF0 & cmd)>>3);
	PORTB &= 0xE0;
	PORTB |= 0x01 | ((0x0F & cmd)<<1);
	PORTB &= 0xE0;
	_delay_ms(1);
	sei();
}
void LCD_Data(unsigned char data){
	cli();
	LCD_RS_PORT |= (1<<LCD_RS_PIN);
	PORTB &= 0xE0;
	PORTB |= 0x01 | ((0xF0 & data)>>3);
	PORTB &= 0xE0;
	PORTB |= 0x01 | ((0x0F & data)<<1);
	PORTB &= 0xE0;
	_delay_ms(1);
	sei();
}
void LCD_Init(){
	_delay_ms(15);
	LCD_Command(0x02);	//Home
	LCD_Command(0x28);	//Funtion Set
	LCD_Command(0x0C);	//Display ON/OFF
	LCD_Command(0x06);	//Entry Mode Set
	LCD_Command(0x01);	//Clear
	_delay_ms(5);

}
void LCD_Clear(){
	LCD_Command(0x01);
	_delay_ms(2);
}
/*
void LCD_String(const char *msg){
	while((*msg)!=0){
		LCD_Data(*msg);
		msg++;
	}
}*/
void LCD_String(const char *msg,uint8_t len){
	while(len > 0){
		len--;
		if((*msg)!=0)
		LCD_Data(*msg);
		else
		LCD_Data(' ');
		msg++;
	}
}
void LCD_SetCursor(uint8_t x , uint8_t line){
	switch(line){
		case 0:
		LCD_Command(0x80 | x);
		break;
		
		case 1:
		LCD_Command(0x80 | (x + 0x40));
		break;
		
		case 2:
		LCD_Command(0x80 | (x + 0x14));
		break;
		
		case 3:
		LCD_Command(0x80 | (x + 0x54));
		break;
	}
}


void ADC_Init()
{
	ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	ADMUX = (1<<REFS0)|(1<<MUX2);
	ADCSRA |= 1<<ADIE;
	//	ADCSRA |= 1<<ADSC;
	sei();
}


void TIMER0_Init(){			//1ms
	cli();
	TIMSK |= (1<<TOIE0);
	TCNT0 = -125;
	sei();
	TCCR0 = (1<<CS01)|(1<<CS00);				//DIV = 64
}

bool is_btn_press(uint8_t pin)
{
	uint8_t temp = (1<<pin)&PINC;
	if(temp != 1<<pin)
	{
		while(((1<<pin)&PINC)!=(1<<pin))
		{
			_delay_ms(5);
		}
		return true;	
	}
	return false;
}

void set_ouput_pin(uint8_t pin)
{
	PORTD |= (1<<pin);
}

void reset_ouput_pin(uint8_t pin)
{
	PORTD &= ~(1<<pin);
}


float calculate(uint16_t adc_val, uint16_t adc_calib1, float temp1, uint16_t adc_calib2, float temp2)
{
	float temp = (adc_val - adc_calib1) * 1.0f * (temp2 - temp1);
	temp *= 1.0f/(adc_calib2 - adc_calib1);
	temp += temp1;  
	return temp;
}


int itoa_s(int value, char *buf) {
	int index = 0;
	int i = value % 10;
	if (value >= 10) {
		index += itoa_s(value / 10, buf);
	}
	buf[index] = i+0x30;
	index++;
	return index;
}

char *itoa(int value, char *buf) {
	int len = itoa_s(value, buf);
	buf[len] = '\0';
	return buf;
}

char *ftoa(float value, int decimals, char *buf) {
	int index = 0;
	// Handle negative values
	if (value < 0) {
		buf[index] = '-';
		index++;
		value = -value;
	}
	
	// Rounding
	float rounding = 0.5;
	for (int d = 0; d < decimals; rounding /= 10.0, d++);
	value += rounding;

	// Integer part
	index += itoa_s((int)(value), buf+index);
	buf[index++] = '.';

	// Remove everything except the decimals
	value = value - (int)(value);

	// Convert decmial part to integer
	int ival = 1;
	for (int d = 0; d < decimals; ival *= 10, d++);
	ival *= value;

	// Add decimal part to string
	index += itoa_s(ival, buf+index);
	buf[index] = '\0';
	return buf;
}


float look_up(uint16_t adcval)
{
	float data;
	for(uint8_t i = 0; i < 12; i++)
	{
		if((adcval >= adc_table[i])&&(adcval < adc_table[i+1])) 
		{
			data = calculate(adcval, adc_table[i], temp_table[i], adc_table[i+1], temp_table[i+1]);
			return data;
		}
	}
	return 0;
	
}

ISR(TIMER0_OVF_vect) {
	if(ADC_time == 0)	ADCSRA |= 1<<ADSC;
	else	ADC_time--;
	if(time_display != 0) time_display--;
	TCNT0 = -125;
	//TCCR0 = (1<<CS01)|(1<<CS00);				//DIV = 64
}

ISR(ADC_vect)
{
	ADC_Data = ADCW;
	ADC_time = MUX_WAIT_FOR_STABLE;
}

int main(void)
{
    LCD_E_DDR |= 0x1F;
	LCD_RS_DDR |= (1<<OUT_PUT)|(1<<LCD_RS_PIN);
	DDRC &= ~((1<<MODE_PIN)|(1<<UP_PIN)|(1<<DOWN_PIN)|(1<<4));
	PORTC |= (1<<MODE_PIN)|(1<<UP_PIN)|(1<<DOWN_PIN);
	PORTC &= ~(1<<4);
	
	ADC_Init();
	TIMER0_Init();
	LCD_Init();
	LCD_Init();
	LCD_SetCursor(1,0);
	LCD_String("BTL DTUD HK232", 14);
	_delay_ms(3000);
	LCD_Clear();
    while (1) 
    {
		if(Mode)		//setup
		{
			LCD_String("Set threshold:", 14);
			//sprintf(buffer, "%d", threshold);
			LCD_SetCursor(0,1);
			LCD_String(itoa(threshold, buffer), 3);
			LCD_SetCursor(3,1);
			LCD_String("C", 1);
			while(1)
			{
				if(is_btn_press(UP_PIN))
				{
					threshold++;
					if(threshold > 99)	threshold = 0;
					sprintf(buffer, "%d", threshold);
					LCD_SetCursor(0,1);
					LCD_String(buffer, 3);
				}
				if(is_btn_press(DOWN_PIN))
				{
					threshold--;
					if(threshold < 1)	threshold = 99;
					sprintf(buffer, "%d", threshold);
					LCD_SetCursor(0,1);
					LCD_String(buffer, 3);
				}
				
				if(is_btn_press(MODE_PIN))
				{
					Mode = 1 - Mode;
					LCD_Clear();
					break;
				}
			}

		}
		
		else			//Normal
		{
			LCD_String("Temperature: ", 13);
			LCD_SetCursor(6,1);
			LCD_Data('C');
			while(1)
			{
				float temp_val = look_up(ADC_Data);
				
				if(time_display == 0)
				{
					
					LCD_SetCursor(0, 1);
					LCD_String(ftoa(temp_val, 1, buffer), 5);
					time_display = TIME_DISPLAY_MAIN;
				}
				
				if(temp_val > threshold)	set_ouput_pin(OUT_PUT);
				else if(temp_val <= threshold) reset_ouput_pin(OUT_PUT);
				
				if(is_btn_press(MODE_PIN))
				{
					Mode = 1 - Mode;
					LCD_Clear();
					break;
				}
								
			}

		}
		
		
		
		/*
		float haha = calculate(ADC_Data, 95, 28.4, 133, 37);
		//sprintf(buffer, "%d", haha);
		//float2ascii(buffer, haha, 1);
		LCD_SetCursor(0,0);
		LCD_String(ftoa(haha, 1, buffer), 4);
		_delay_ms(50);
		LCD_Clear();
		*/
		
		
    }
}

