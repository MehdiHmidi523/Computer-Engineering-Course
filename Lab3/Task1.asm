;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-19
; Author: 
; Mehdi Hmidi
;
; Lab number: 3
; Task:1
; Title: Interrupts
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Turn on and off lamps using interrupts 
;
; Output ports: PORTB
; Input port: PORTA
;
; Included files: m2560def.inc
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
	
.org 0x00
rjmp start

.org INT0addr
jmp interrupt

.org 0x72

start:
;initialize SP, stack pointer
ldi r20, high(ramend)
out sph, r20
ldi r20, low(ramend)
out spl, r20		

ldi r16, 0x00		
out DDRA, r16		; port a - output

ldi r16, 0xff		; set pull-up resistors on d input pin
out DDRB, r16		; port b - output

ldi r16, 0x03		; int0 and int1 enabled
out EIMSK, r16

ldi r16, 0x08
sts EICRA, r16		; int1 falling edge, int0 rising edge

sei					; global interupt enable

; main pogram
ldi r16, 0x00
out DDRB, r16
main:
	nop     ;The reason for this is that it takes a
			;small amount of time for the out ddrb,r16 to take effect. Without the nop, the next
			;instruction (in r0,pinb) may not have the direction of the port set up in time
	rjmp main

interrupt:
	com r16
	out DDRB, r16
	reti
