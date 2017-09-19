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
; Function: To run a Johnson Counter 
; 
; Input ports: None 
; 
; Output ports: Leds connected to port B. 
; 
; Subroutines: delay: accounts for 1 second delay between changing LED. 
; 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
.include "m2560def.inc" 
 
;Initialize stack pointer 
ldi r16, high(ramend)
 out sph, r16 
 ldi r20, low(ramend)
 out spl, r20 
 
ldi r19, 0x00 
ldi r20, 0x01 
 
_add: 
   out DDRB, r19 	 
   add r19, r20        ; adds current value r19 with logical left shifted r20   
   lsl r20             ; to keep lighting LEDs until bit 7. 
   rcall delay         ; have a delay of 1 second between lighting LEds. 
  
   cpi r19, 0xff 
   brne _add           ; run _add until all LEDs are lit. 
 
_sub: 
  
   out DDRB, r19 
   lsr r19 
   rcall delay 
   brcs _sub            ; branch if carry flag is set in status register 
   ldi r20, 0x01 
   rjmp _add 
 
delay:                 ; 16MHz -> 16000000 cycles = 1s,  
                       ; Cycles = 3a + 4ab + 3abc   ->  a(3 + b(4 + 3c))    
	ldi r16, 11         ; -> a 
 delay_1: 
   ldi r17, 237        ; -> b 
 delay_2: 
   ldi r18, 255        ; -> c  (a,b,c ~> 0.5s) 
 delay_3: 
   dec r18             ; decrements value of r18 until 0 because 
                       ; it will branch to delay_3 again if not zero.   
   brne delay_3        ; 3c - 1        -> d = 3c - 1 
   dec r17 
   nop                 ; delay_2 resets r18 to 255 for 237 times because 
                       ; r17 is decremented each time when delay_3 is zero. 
   brne delay_2        ; 5b - 1 + bd   -> e = 5b - 1 + 3cb - b 
  
   dec r16             ; the whole process above is repeated 11 times. 
   brne delay_1        ; 5a - 1 + ae   -> f = 3a + 5ab + 3abc - ab 
  
   ret                 ; f - 1 
