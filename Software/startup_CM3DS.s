;/**************************************************************************//**
; * @file     startup_CM3DS_MPS2.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           Device CM3DS_MPS2
; * @version  V3.01
; * @date     06. March 2012
; *
; * @note
; * Copyright (C) 2012,2017 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/
;/*
;//-------- <<< Use Configuration Wizard in Context Menu >>> ------------------
;*/


; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00008000

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00008000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     UARTRX_Handler            ; UART RX Handler
                DCD     UARTTX_Handler            ; UART TX Handler
                DCD     UARTOVR_Handler           ; UART RX and TX OVERRIDE Handler
                
__Vectors_End

__Vectors_Size  EQU     __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                IMPORT  SystemInit
                IMPORT  __main
                ;IMPORT  main
                LDR     R0, =SystemInit
                BLX     R0
                LDR     R0, =__main
                ;LDR     R0, =main
                BX      R0
                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                IMPORT  NMIHandler
                PUSH    {LR}
                BL      NMIHandler
                POP     {PC}
                ENDP

HardFault_Handler PROC
                EXPORT  HardFault_Handler         [WEAK]
                IMPORT  HardFaultHandler
                PUSH    {LR}
                BL      HardFaultHandler
                POP     {PC}
                ENDP

MemManage_Handler PROC
                EXPORT  MemManage_Handler         [WEAK]
                IMPORT  MemManageHandler
                PUSH    {LR}
                BL      MemManageHandler
                POP     {PC}
                ENDP

BusFault_Handler PROC
                EXPORT  BusFault_Handler          [WEAK]
                IMPORT  BusFaultHandler
                PUSH    {LR}
                BL      BusFaultHandler
                POP     {PC}
                ENDP

UsageFault_Handler PROC
                EXPORT  UsageFault_Handler        [WEAK]
                IMPORT  UsageFaultHandler
                PUSH    {LR}
                BL      UsageFaultHandler
                POP     {PC}                
                ENDP

SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                IMPORT  SVCHandler
                PUSH    {LR}
                BL      SVCHandler
                POP     {PC}   
                ENDP

DebugMon_Handler PROC
                EXPORT  DebugMon_Handler          [WEAK]
                IMPORT  DebugMonHandler
                PUSH    {LR}
                BL      DebugMonHandler
                POP     {PC}
                ENDP

PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                IMPORT  PendSVHandler
                PUSH    {LR}
                BL      PendSVHandler
                POP     {PC}
                ENDP

SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                IMPORT  SysTickHandler
                PUSH    {LR}
                BL      SysTickHandler
                POP     {PC}
                ENDP

UARTRX_Handler  PROC
                EXPORT UARTRX_Handler             [WEAK]
                IMPORT  UARTRXHandler 
                PUSH    {LR}
                BL      UARTRXHandler 
                POP     {PC}
                ENDP

UARTTX_Handler  PROC
                EXPORT UARTTX_Handler             [WEAK]
                IMPORT  UARTTXHandler 
                PUSH    {LR}
                BL      UARTTXHandler 
                POP     {PC}
                ENDP

UARTOVR_Handler PROC
                EXPORT UARTOVR_Handler             [WEAK]
                IMPORT  UARTOVRHandler 
                PUSH    {LR}
                BL      UARTOVRHandler 
                POP     {PC}
                ENDP

                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap

__user_initial_stackheap PROC
                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR
                ENDP

                ALIGN

                ENDIF


                END
