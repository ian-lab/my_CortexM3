#include "CortexM3.h"
#include "CortexM3_driver.h"
void NMIHandler(void) {
    ;
}

void HardFaultHandler(void) {
    ;
}

void MemManageHandler(void) {
    ;
}

void BusFaultHandler(void) {
    ;
}

void UsageFaultHandler(void) {
    ;
}

void SVCHandler(void) {
    ;
}

void DebugMonHandler(void) {
    ;
}

void PendSVHandler(void) {
    ;
}

void SysTickHandler(void) {
    Set_SysTick_CTRL(0);
    SCB->ICSR = SCB->ICSR | (1 << 25);
}


void UARTRXHandler(void) {
    ;
}

void UARTTXHandler(void) {
    ;
}

void UARTOVRHandler(void) {
    ;
}

void KEYHandler(void) {
    printf("***** KEY IRQ *****\n");
		if (disp_flag >= 2)
			disp_flag = 0;
		else 
			disp_flag += 1;
}
