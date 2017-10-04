
.include "m2560def.inc"

.org 0x00
   jmp     restart

.org OVF0addr
   jmp     timer_interrupt

.org 0x30
restart:
   ldi     r16, LOW(RAMEND)    ;initialize SP, Stackpointer
   out     SPL, r16
   ldi     r16, HIGH(RAMEND)
   out     SPH, r16
   ldi     r16, 0x01           ;initialize DDRB
   out     DDRB, r16

   ldi     r17, 0x05           ;prescaler value to TCCR0
   out     TCCR0B, r17         ;CS2 - CS2 = 101, osc.clock / 1024
   ldi     r17, (1<<TOIE0)     ;Timer 0 enable flag
   sts     TIMSK0, r17         ;to register TIMSK
   out     TCNT0, r17          ;counter register
   sei                         ;enable global interrupt

start:                          ;main loop
   rjmp    start

timer_interrupt:                ;interreupt routine
   inc     r18
   cpi     r18, 2
   breq    toggle
   reti                        ;return from interrupt

toggle:
   com     r16                 ;One's complement
   out     PORTB, r16
   ldi     r18,0
   reti
