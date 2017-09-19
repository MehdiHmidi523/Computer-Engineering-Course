;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; 1DT301, Computer  Technology  I ; Date: 2016-09-15 ; Authors: 
; Mehdi Hmidi 
; Jorian Wielink 
; 
; Lab number: 2 
; Title: Task 1 
; 
; Hardware: STK600, CPU ATmega2560 
; 
; Function: Switch Ring counter/  Johnson  Counter,
;           The  pushbutton  must  be  checked  frequently,  so  there  is  no 
;			delay between the button is pressed  and  the  change  between  Ring/Johnson. 
;			Uses  SW0  ( PA0)  for  the  button.
;			Each time  you press the button, the program should change counter 
; 
; Input ports: On board switches on portA 
; Output ports: on-board LEDs connected to PORTB. 
; 
; Subroutines:  delay,  johnson,  sub  and  ring  counter. 
; Included files: m2560def.inc 
; 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
 
 
.include "m2560def.inc" 
;set initial states: Set data direction registers--------------- 
ldi 	r21, 0x00 	; switch value ldi 	r20, 0x01 
ldi 	r19, 0xFF 	; r19 used for portB state 
 
;set port details:---------------------------------------------- 
ldi 	r16, 0xFF 	; set ddrb ports as output 
out 	DDRB,  r16 
out 	PORTB, r16 	;  0 XFF  on  the  board  translates to off state 
ldi 	r16,  0 x00 	;  set  ddrc  port  as  input 
out 	DDRC,  r16 	  
rjmp johnson 

switch: 	
	in 	r23, PINC 	; Switch in pressed condition. User did not release button yet. 
	cpi 	r23, 0xFE 	; Check if switch has been released 
	breq	switch 	; loop until release of switch. 
	com 	r21 	; we change the counters depending on previous state. 
	brne	ring_counter	; if not equal to zero, branch to ring counter. 
		; otherwise, continue with johnson counter below. 
	ldi 	r20, 0x01 	  
	ldi 	r19, 0xFF
	
johnson: 	
	r19, 0xFF 	;  Johnson counter parameters reinitialized. 
	out 	PORTB, r19 	  
	com 	r19 	; one´s complement is used to invert the bits (to successfully add 
	add 	r19, r20 	; r20 to r19). 
	lsl 	r20 	; logical shift left to light the LED to the consequent left 
	com 	r19 
	rcall   delay 	  ; for output purposes, one´s complement again. 
	cpi 	r19, 0x00 ; conditional statement, checks if end has been reached(LEds Lit). 	
	brne	johnson ; if end not reached continue "while" loop. 

j_return: 	
	out 	PORTB, r19 
	com 	r19 	; same principle as above, only now we only need to shift right 
	lsr r19
	com r19 
	
	rcall   delay  		; after doing a one's complement. 

	cpi r19, 0xFF 
	brne j_return 	; if all bits are set, skip looping this sub 

	ldi r20, 0x01 
	rjmp johnson 
	
ring_counter: 	; reset r20 to start adding to r19 (output to LED) from the right 
  
	ldi 	r20, 0xFE ; all leds except led 0 are off 
    loop:  			
		out	PORTB, r20 
		rcall delay  ; light the leds 
		com r20 	
		lsl r20 	  	
		brcs ring_counter 	
		com r20 	; complement back AFTER possible branch to 
	rjmp loop 		; reset, to account for carry flag in brcs! 

delay: 	  	
	ldi 	r16, 3 
delay_1: 
	ldi 	r17, 10 
delay_2: 
	ldi   	r18, 150 
 delay_3:
	in 	r23, PINC  
    cpi r23, 0xFE 
	breq	switch   ;check while in the delay for input(press of switch) 	  

	dec 	r18   ;continue delay sequence. 
	brne	delay_3 	  
	
	dec 	r17 
	brne	delay_2 	 
	
	dec 	r16 
	brne 	delay_1 
	ret  		  
 
 
