#include "CortexM3.h"
#include "CortexM3_driver.h"
// 1 led亮 0 led灭

char disp_flag = 0;

int main(void) 
{	
	printf("***********************\n");
	printf("*****             *****\n");
	printf("*****  Cortex M3  *****\n");
	printf("*****             *****\n");
	printf("***********************\n");
	
	send2LED(0x00);
	
	change_threshold(40);
	disp_choice(disp_flag);
	
	while(1) 
	{
		disp_choice(disp_flag);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();
		send2LED(0x01);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();	
		send2LED(0x02);		
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();
		send2LED(0x04);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();	
		send2LED(0x08);	
	}
}

