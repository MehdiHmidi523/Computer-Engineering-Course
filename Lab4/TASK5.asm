.include "m2560def.inc"

.def tmp = r17
.def char = r16
.equ ubrr_value = 12

.org 0x00
   rjmp    start
.org URXC1addr             ; interrupt address
   rjmp    get_char   

.org 0x72
start:                      ; setup program until loop
    ldi     tmp, low(ramend)
    out     pl, tmp
    ldi     tmp, high(ramend)
    out     sph, tmp

    ldi     tmp, 0xff
    out     ddrb, tmp
    ldi     tmp, 0x55
    out     portb, tmp

    ldi     tmp, ubrr_value
    sts     UBRR1L, tmp
    ldi     tmp, 0b10011000 ; enable interrupt in USART
   ;ldi     tmp, (1<<RXCIE1) | (1<<TXEN1) | (1<<RXEN1)
    sts     UCSR1B, tmp
    sei                     ; set global interrupt flag

loop:                       ; loops until interrupt
    nop
    rjmp    loop

get_char:
    lds     r20, UCSR1A
    lds     char, UDR1

port_output:
    com     char
    out     portb, char
    com     char

put_char:
    lds     r20, UCSR1A
    sts     UDR1, char
    reti

