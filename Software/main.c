#include "CortexM3.h"
#include "CortexM3_driver.h"


int main(void) 
{	
	printf("***********************\n");
	printf("*****             *****\n");
	printf("*****  Cortex M3  *****\n");
	printf("*****             *****\n");
	printf("***********************\n");
		
	while(1) 
	{
		send2LED(0x0f);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();
		
		send2LED(0x00);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();			
	}
}

