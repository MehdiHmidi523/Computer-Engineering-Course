.include "m2560def.inc"

.def percent        = r19
.def output         = r16
.def temp           = r21
.def lighttime      = r22
.def valueh         = r25
.def valuel         = r24

.equ time           = 5000

.cseg
.org 0x0000
    rjmp    start

.org ovf1addr
    jmp     timer1_int

.org int1addr
    jmp     increase

.org int2addr
    jmp     decrease

.org 0x72
start:
    ldi     lighttime, 10
    ldi     valueh, high(time)  
    com     valueh
    ldi     valuel, low(time)   
    com     valuel

                                ; initialize sp, stack pointer
    ldi     temp, low(RAMEND)
    out     spl, temp
    ldi     temp, high(RAMEND)  
    out     sph, temp

                                ; prescaler
    ldi     output, 0x03            
    out     DDRB, output

                                ; time for timer 0x05 -> 1024
    ldi     temp, 0x03          
    sts     TCCR1B, temp
    ldi     temp, (1<<TOIE1)    
    sts     TIMSK1, temp

    ldi     temp, 0b00000110        
    out     EIMSK, temp         ; int0 and int1 and (perhaps also int2) enabled
    ldi     temp, 0b00101000        
    sts     EICRA, temp         ; int1 falling edge, int0 rising edge

    sts     TCNT1H, valueh
    sts     TCNT1L, valuel
    sei

loop:
    nop
    rjmp    loop

timer1_int:
    cpi     output, 0x01
    brne    darktime            ;the light was off and should be lit with light time
    mov     percent, lighttime
    ldi     output, 0x00
    rjmp    set_time
darktime:                       ;the light was on and should be off now with darktime
    ldi     percent, 20
    sub     percent, lighttime
    ldi     output, 0x01

set_time:                       ; set time to percent * maxTime
    ldi     valuel, low(0)
    ldi     valueh, high(0)     ;setting it to zero
    cpi     percent, 0
    brne    settime_loop        ;if zero then it should not continue to the loop
    rjmp    timeroutput

set_time_loop:
    sbiw    valuel, 60
    sbiw valuel, 60
    sbiw    valuel, 60
    sbiw    valuel, 60
    sbiw    valuel, 60
    sbiw    valuel, 60
    sbiw    valuel, 10          ;50 -> 5% off time (5000)

    dec     percent
    cpi     percent, 0
    brne    set_time_loop

timeroutput:
    out     DDRB, output

    sts     TCNT1H, valueh
    sts     TCNT1L, valuel

    reti


increase:                       ; 20 is max => 5% (percent / 20) p=0.05
    cpi     lighttime, 20   
    breq    afterinc            ; if 'higher' then 20

    inc     lighttime
afterinc:
    reti


decrease:
    cpi     lighttime, 0    
    breq    afterdec            ; if 'below' then 0

    dec     lighttime
afterdec:
    reti
