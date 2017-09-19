;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-15
; Authors:
; Mehdi Hmidi
; Jorian Wielink
;
; Lab number: 2
; Title: Task 4
;
; Hardware: STK600, CPU ATmega2560
;
; Function: a general delay routine that can be called from other programs. It should be named ;wait_milliseconds. The number of milliseconds should be transferred to register pair R24, R25.
;
;; Output ports: on-board LEDs connected to PORTB.
;
; Subroutines:; Included files: m2560def.inc
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"
    ldi     r20, HIGH(RAMEND)                   ; R20 = high part of RAMEND address
    out     SPH, R20                             ; SPH = high part of RAMEND address
    ldi     R20, low(RAMEND)                    ; R20 = low part of RAMEND address
    out     SPL, R20                             ; SPL = low part of RAMEND address
   
   ldi     r16, 0xff
    out     ddrb, r16           ; ddrb as output
    out     portb, r16          ; switch off leds
    ldi     r17, 0xff           ; r17 drives leds
loop:
    out     PORTB, r17                 ; Write state to LEDs
    ldi     r25, HIGH(500)             
    ldi     r24, LOW(500)
    rcall   wait_milliseconds          ; Delay to make changes visible
    rol     r17                        ; Rotate LED state to the left
    rjmp    loop
    
wait_milliseconds:
 waitfor_lowzero:
  cpi r24, 0                  ; wait for lower nibble to clear to 0 (contains least significant bits)
  breq waitfor_highzero       ; if it´s decreased to zero, start wait for high zero. repeat this until high zero
                                    ; has reached zero too.
  rjmp decrement_delay
       
 waitfor_highzero:               ; contains most significant bits (bit 9 - 15)
        cpi r25, 0                  ; if this also zero, the time is up and we branch to subroutine zero.
        breq zero
        rjmp decrement_delay
    zero:                           ; returns to the loop driving the LEDS. 
	ret      
	
decrement_delay:                ; this decreases the 16-bit value by using subtract immediate (SBIW)
    sbiw r25:r24, 1             ; this delay is called as many times defined in the register pair in ms.
    ldi  r18, 2                 ; accounts for the delay. Equals 1 ms (including all overhead calls)
    ldi  r19, 74
L1:
    dec  r19
    brne L1
    dec  r18
    brne L1
    
    rjmp waitfor_lowzero
