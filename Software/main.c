#include "CortexM3.h"
#include "CortexM3_driver.h"



int main(void) {

	APB_BTN_TypeDef *apb_btn_1 = BUTTON;

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
		if (getPushBtn(apb_btn_1) == 0)
		{
				if(led!=0x08)
				{
					led = led<<1;
					led_flag = led_flag + 1;
				}
				else
				{
					led = 0x01;
					led_flag = 1;
				}
				while(getPushBtn(apb_btn_1) == 0);
				printf("***** %d LED *****\n",led_flag);
		}
		send2LED(led);						
	}
}

