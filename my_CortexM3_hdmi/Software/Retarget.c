/******************************************************************************/
/* RETARGET.C: 'Retarget' layer for target-dependent low level functions      */
/******************************************************************************/
/* This file is part of the uVision/ARM development tools.                    */
/* Copyright (c) 2005 Keil Software. All rights reserved.                     */
/* This software may only be used under the terms of a valid, current,        */
/* end user licence from KEIL for a compatible version of KEIL software       */
/* development tools. Nothing else gives you the right to use this software.  */
/******************************************************************************/

#include <stdio.h>
#include "CortexM3.h"

//#pragma import(__use_no_semihosting_swi)


extern int  sendchar(int ch);  /* in Serial.c */
extern int  getkey(void);      /* in Serial.c */
extern long timeval;           /* in Time.c   */


struct __FILE { int handle; /* Add whatever you need here */ };
FILE __stdout;
FILE __stdin;


int fputc(int ch, FILE *f) {
  if(ch == '\n') uart_SendChar(UART,'\r');
  uart_SendChar(UART,ch);
  return (ch);
}

int fgetc(FILE *f) {
  char buf;
  buf = uart_ReceiveChar(UART);
  uart_SendChar(UART,buf);
  if(buf == '\r') buf = '\n';
  return (buf);
}


int ferror(FILE *f) {
  /* Your implementation of ferror */
  return EOF;
}


void _ttywrch(int ch) {
  uart_SendChar(UART,ch);
}


void _sys_exit(int return_code) {
  while (1);    /* endless loop */
}
