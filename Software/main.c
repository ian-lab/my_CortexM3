#include "CortexM3.h"
#include "CortexM3_driver.h"


uint32_t* hdmi_0 = 0x40003000;
uint32_t* hdmi_1 = 0x40003004;
uint32_t* hdmi_2 = 0x40003008;
uint32_t* hdmi_3 = 0x4000300c;
uint32_t* addr_hdmi = 0x40003000;
uint32_t a;
uint32_t b,c,d;
//uint16_t a,b,c,d;
int main(void) 
{	
	printf("***********************\n");
	printf("*****             *****\n");
	printf("*****  Cortex M3  *****\n");
	printf("*****             *****\n");
	printf("***********************\n");
		send2LED(0x0f);
	while(1) 
	{
		printf("***********************\n");
//		*hdmi_0 = 0x00;
//		*hdmi_1 = 0x01010101;
//		*hdmi_2 = 0x02020202;
//		*hdmi_3 = 0x03030303;
		
		for(uint8_t i = 0; i< 196; i++)
		{
			addr_hdmi = hdmi_0 + i;
			a = i<< 8;
			b = i<< 16;
			c = i<< 24;
			d = a+ b +c + i;
			*(addr_hdmi) = d;
		}
//		a = *hdmi_0;
//		b = *hdmi_1;
//		c = *hdmi_2;
//		d = *hdmi_3;
		printf("%d\n", *hdmi_0);
		printf("%d\n", *hdmi_1);
		printf("%d\n", *hdmi_2);
		printf("%d\n", *hdmi_3);
//		send2LED(0x0f);

		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();
		send2LED(0x00);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();	
		send2LED(0x0f);		

	}
}

