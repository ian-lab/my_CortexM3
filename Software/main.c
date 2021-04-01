#include "CortexM3.h"
#include "CortexM3_driver.h"


int main(void) {
	uint32_t led = 0x01;
	uint32_t led_flag = 1;
	
	printf("***********************\n");
	printf("*****             *****\n");
	printf("*****  Cortex M3  *****\n");
	printf("*****             *****\n");
	printf("***********************\n");
	
	send2LED(0x00);
	printf("***** %d LED *****\n",led_flag);
	
	while(1) 
	{
		send2LED(0x0f);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();
		send2LED(0x00);
		for(int i = 0; i<1000;i++)//计时1s
			delay_1ms();
//		if ( getKEY() == KEY_DOWN )
//		{
//				if(led!=0x08)
//				{
//					led = led<<1;
//					led_flag = led_flag + 1;
//				}
//				else
//				{
//					led = 0x01;
//					led_flag = 1;
//				}
//				while( getKEY() == KEY_DOWN );
//				printf("***** %d LED *****\n", led_flag);
//		}
//		send2LED(led);						
	}
}

