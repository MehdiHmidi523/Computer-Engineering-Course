.include "m2560def.inc"

.org 0x00
    rjmp     init
.org INT0addr
    rjmp     int0_service

.org 0x72
init:
    ldi     r19, HIGH(RAMEND) ; MSB part av address to RAMEND
    out     SPH, r19 ; store in SPH
    ldi     r19, LOW(RAMEND) ; LSB part av address to RAMEND
    out     SPL, r19 ; store in SPL

    ldi     r16, 0xff            
    out     DDRB, r16            ; set port B as output
    out        PORTB, r16            ; switch leds off

    ldi     r16, 0x00
    out     DDRD, r16            ; set port D as input, bit 0 functions as an interrupt bit (see p. 84)

    ldi     r20, 0b10111111      
    out     PORTB, r20

    ldi     r16, 0b00000001    
    out     EIMSK, r16            ; 0x1D == EIMSK (p. 115)

    ldi     r16, 0b00000010
    sts     EICRA, r16            ; 0x69 == EICRA (p. 114)

    sei                            ; set global interrupt enable

main:                            ; after init, start waiting for the interrupt
    sleep
    out     PORTB, r20
    rjmp main

int0_service:
    rol        r20                    ;

    reti