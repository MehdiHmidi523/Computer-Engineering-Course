;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; 1DT301,Computer Technology I 
; Date:2016-09-05  
;Authors: 
; Mehdi Hmidi 
; Jorian Wielink 
; 
; Lab number: 1 
; Title: Task 2 
; 
; Hardware: STK600, CPU ATmega2560 
; 
; Function: To read the switches and light the corresponding LED 
; 
; Input ports: Switches connected to port A 
; 
; Output ports: Leds connected to port B. 
; 
; Included files: m2560def.inc 
; 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
 
.include "m2560def.inc" 
 
ldi r16, 0xFF 	 
out DDRB, r16 	; set DDRB as output for lighting LEDs 
  ldi r16, 0x00 	; set DDRA as input for reading switches out DDRA, r16 
loop:	; Keep a loop running indefinitely 
  in r15, PINA 	; Read switch info from PIN A 
  out PORTB, r15 	; Send this info to light LED on Port B. 
rjmp loop 
