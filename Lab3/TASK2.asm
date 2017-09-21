;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-19
; Author: 
; Mehdi Hmidi
;
; Lab number: 3
; Task:2
; Title: Johnsson and a Ring counter using Interrupts
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Switches from johnsson and ring counter when a button is clicked (using interrupt)
;
; Output ports: PORTB
; Input port: PORTA
;
; Included files: m2560def.inc
;
; Other information: the switch is the actual interrupt function
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00
rjmp start

.org INT1addr
jmp switch

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

ldi r16, 0x02		; int0 and int1 enabled
out EIMSK, r16

ldi r16, 0b00001100
sts EICRA, r16		; int1 falling edge, int0 rising edge
sei					; global interupt enable

ldi r21, 0x00 ; switch value
ldi r20, 0x01
ldi r19, 0x00
rjmp Johnson

switch:
	sei
	com r21				;change value to 1
	brne ring_counter	;branch because r21 has 0X01 not 0X00
	
	ldi r20, 0x01	;reinitialize
	ldi r19, 0x00
	
Johnson:
	out DDRB, r19
	add r19, r20
	lsl r20
	rcall delay
	
	cpi r19, 0xff
	brne Johnson

Jreturn:
	
	out DDRB, r19
	lsr r19
	rcall delay
	
	cpi r19, 0x00
	brne Jreturn		;end(original state) not reached
	ldi r20, 0x01
	rjmp Johnson


delay:				; 16MHz -> 16000000 cycles = 1s,  Cycles = 3a + 4ab + 10abc   ->  a(3 + b(4 + 10c)),  ((250 * 10 + 4) * 100 + 3) * 8 = 2 003 224 ~ 2 000 000
	ldi r16, 8		; -> a
delay_1:
	ldi r17, 100	; -> b
delay_2:
	ldi r18, 250	; -> c

delay_3:
	nop
	nop
	nop
	nop
	nop
	nop
	dec r18
	brne delay_3	; 10c - 1		-> d

	dec r17
	nop
	brne delay_2	; 5b - 1 + bd	-> e = 5b - 1 + 10cb - b

	dec r16
	brne delay_1	; 5a - 1 + ae	-> f = 3a + 5ab + 10abc - ab
	ret				; f - 1


ring_counter:
	ldi r20, 0x01
	loop:
		out DDRB, r20
		rcall delay
		lsl r20
		cpi r20, 0x00
		breq ring_counter
	rjmp loop
