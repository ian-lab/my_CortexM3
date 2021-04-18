#include "CortexM3.h"
#include "CortexM3_driver.h"
// 1 led亮 0 led灭
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

