; increase and decrease the duty cycle using timer0

.include "m2560def.inc" ;our device include file

.ORG 0
	rjmp start
	
.ORG OVF0addr
	jmp timer0_int
	
;------------- inturrupts
.ORG INT0addr
	jmp interrupt_1
.ORG INT1addr
	jmp interrupt_2
;---------------


.org 0x50
.def temp= r16
.equ time =100
.def pwm= r19
.def value= r22
.equ fivepercent=0xc
.equ delay_lab =180/4

start:
	ldi r16, HIGH(RAMEND) ; R16 = high part of RAMEND address
	out sph,r16 		; SPH = high part of RAMEND address
	ldi r16, low(RAMEND) ; R16 = low part of RAMEND address
	out spl,r16 		; SPL = low part of RAMEND address

	ldi temp,(1<<COM0A1)|(1<<COM0B1)|(1<<WGM00)|(1<<WGM01)
	out TCCR0A,temp

	ldi temp, (5<<CS00)|(0<<WGM02) ; prescaler value to TCCR0
	out TCCR0B, temp ; CS2 - CS2 = 101, osc.clock / 1024

	ldi temp, (1<<TOIE0) ; Timer 0 enable flag, TOIE0
	sts TIMSK0, temp 	; to register TIMSK

	ldi temp, time 		; starting value for counter
	out TCNT0, temp 	; counter register

	ldi temp,0
	out OCR0A,temp

	ldi value,fivepercent

;--------------
;sitting r16 as an input and activating switch 1
	ldi r16,0b11111100
	out ddrd,r16
	
	ser r16
	out ddrb,r16

;initiate the instructions

;global
	ldi r16,0b11111111
	out portb,r16

;activating the interrupt

	ldi r16,0b00000011
	out EIMSK,r16

	ldi r16,0b00001111
	sts EICRA,r16

	sei 				; enable global interrupt
	ldi r17,0xff
	out ddrb,r17
	ldi r17,0b10111111

;------ Main Loop -----------	
ms_10:
	out portb,r17

	rjmp ms_10 			; main loop

;;;-------------- timer loop
timer0_int:
	push temp 			; timer interrupt routine
	in temp, SREG 		; save SREG on stack
	push temp
; additional code to create the square output
	ldi temp, time 		; starting value for counter
;out OCR0A,r16
	out TCNT0, temp 	; counter register

;-----------------
;on and off after 50 sec
	inc r20

	cpi r20,0x03
	brne exit

checkifonoroff:
	cpi r21,0x00
	breq off

	cpi r21,0xff
	breq on
	
off:
	ldi r21,0xff
	ldi r17,0b11111111
	out portb,r17

	ldi r20,0x00
	jmp exit
	
on:
	ldi r21,0x00
	ldi r17,0b10111111
	out portb,r17

	ldi r20,0x00
	jmp exit
	
exit:

	pop temp 			; restore SREG
	out SREG, temp
	pop temp 			; restore register
	reti 				; return from interrupt



;---------------
interrupt_1: 			;increase
	push r16
	in r16,SREG
	push r16

	in r16, OCR0A
	add r16,value
	out OCR0A,r16

	cpi r16,0xFF
	breq reset
	
cleared:
	pop r16

	out SREG,r16
	pop r16
	reti
	
;---------------
interrupt_2: 			;decrease
	push r16
	in r16,SREG
	push r16

	in r16, OCR0A
	sub r16,value
	out OCR0A,r16

	cpi r16,0x00
	breq reset2
	
cleared2:
	pop r16

	out SREG,r16
	pop r16
	reti

reset:
	ldi pwm,0x00
	rjmp cleared

reset2:
	ldi pwm,0xff
	rjmp cleared2
;-----------------------------
