.include "m2560def.inc"

.def tmp = r17
.def char = r16
.equ ubrr_value = 12        ; use 4800 as speed

.org 0x00
   rjmp    start

.org 0x72
start:
   ldi     tmp, 0xff
   out     ddrb, tmp
   ldi     tmp, 0x55
   out     portb, tmp

   ldi     tmp, ubrr_value
   sts     UBRR1L, tmp     ; connect jumper cable to pin 2/3 on Port D

   ldi     tmp, (1<<TXEN1) | (1<<RXEN1)  ; enable USART transmitter
   sts     UCSR1B, tmp

get_char:
   lds     tmp, UCSR1A     ; read from USART to get character
   sbrs    tmp, RXC1       ; Receive Complete
   rjmp    get_char

   lds     char, UDR1

port_output:
   com     char            ; invert bits to show binary on leds
   out     portb, char
   com     char

put_char:
   lds     tmp, UCSR1A    
   sbrs    tmp, UDRE1
   rjmp    put_char
   sts     UDR1, char
   rjmp    get_char
