;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; 1DT301,Computer Technology I 
; Date:2016-09-05  
;Authors: 
; Mehdi Hmidi 
; Jorian Wielink 
; 
; Lab number: 1 
; Title: Task 3
; 
; Hardware: STK600, CPU ATmega2560 
;
; Function: To make a program to light LED0 when Switch 5 is pressed. 
; 
; Input ports: Switches connected to port A 
; 
; Output ports: LED s connected to port B. 
; 
; Included files: m2560def.inc 
; 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

 
.include "m2560def.inc" 
 
ldi r16, 0xFF 
out DDRB, r16 
ldi r16, 0x00 ; set DDRB as output for lighting LEDs 
out DDRA, r16 
 
ldi r16, 0xFF
out PORTB, r16  	; set DDRA as input for reading switches switches 

ldi r17, 0b11011111 
ldi r18, 0b11111110 

loop: 				; values set in register to compare to in loop 
	in r16, PINA 	; Read switch info from PIN A 
	cp r16, r17 	; Compare with r17, to check if SW5 is pressed 
	breq equal		; if so, branch to ‘equal’ 
rjmp loop 

equal: out portB, r18	; when run, this lights led 0  
