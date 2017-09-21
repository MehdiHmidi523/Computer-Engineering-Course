;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-19
; Author: 
; Mehdi Hmidi
;
; Lab number: 3
; Task: 3
; Title: Rear lights on a car
;
; Hardware: STK600, CPU ATmega2560
;
; Function: mimics car lights when turning. When interrupt is clicked a turn will be displayed and when released it will go back to normal.
;
; Output ports: PORTB
; Input port: PORTA
;
; Included files: m2560def.inc
;
; Other information: interrupt address: 1 and 3 (1: right, 3: left) 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.org 0x00
rjmp start

.org INT1addr
jmp interrupt0

.org INT3addr
jmp interrupt2

.org 0x72
start:
;initialize SP, stack pointer
ldi r20, high(ramend)
out sph, r20
ldi r20, low(ramend)
out spl, r20		

ldi r16, 0x00		
out DDRA, r16		; port a input pin

ldi r16, 0xff		; set pull-up resistors on A input pin
out DDRB, r16		; port b - output

ldi r16, 0b00001110		; int0 and int1 and (perhaps also int2) enabled
out EIMSK, r16

ldi r16, 0b01010100
sts EICRA, r16		; int1 falling edge, int0 rising edge
sei					; global interupt enable

ldi r23, 0x00	; left register
ldi r19, 0x00	; right register
ldi r20, 0x00
ldi r22, 0x00

init:
	pop r17	; this value will be changed
	sei

normal:
	ldi r17, 0b11000011
	cpi r20, 0xff
	breq right
	ar:
		cpi r22, 0xff
		breq left
	al:
		out DDRB, r17
		rcall delay
		rjmp normal

left:	
	andi r17, 0b00001111 ; 'flush' led 5-8
	cpi r23, 0x00
	brne leftshift
	
	ldi r23, 0b00010000
	rjmp leftadd

	leftshift:
		lsl r23
	leftadd:
		add r17, r23
	rjmp al

right:	
	andi r17, 0b11110000 ; 'flush' led 0-4
	cpi r19, 0x00
	brne rightshift
	ldi r19, 0b00001000
	rjmp rightadd
	
	rightshift:
		lsr r19
	rightadd:
		add r17, r19
	rjmp ar
	
delay:				; 16MHz -> 16000000 cycles = 1s,  Cycles = 3a + 4ab + 10abc   ->  a(3 + b(4 + 10c)),  ((250 * 10 + 4) * 100 + 3) * 8 = 2 003 224 ~ 2 000 000
	ldi r16, 8		; -> a
delay_1:
	ldi r17, 100	; -> b
delay_2:
	ldi r18, 250	; -> c
delay_3:
	dec r18
	brne delay_3	; 10c - 1		-> d ( not 10 anymore... 3)
	dec r17
	nop
	brne delay_2	; 5b - 1 + bd	-> e = 5b - 1 + 10cb - b
	dec r16
	brne delay_1	; 5a - 1 + ae	-> f = 3a + 5ab + 10abc - ab
	ret				; f - 1

interrupt0:		; right
	com r20
	rjmp init

interrupt2:		; left
	com r22
	rjmp init
