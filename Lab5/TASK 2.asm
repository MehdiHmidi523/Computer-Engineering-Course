.include     "m2560def.inc"
.def    Temp    = r16
.def    Data    = r17
.def    RS    = r18
.def    sfl     = r19
.def    sfh    = r20


.equ    BITMODE4    = 0b00000010        ; 4-bit operation
.equ    CLEAR        = 0b00000001        ; Clear display
.equ    DISPCTRL    = 0b00001111        ; Display on, cursor on, blink on.

.cseg
.org    0x0000                ; Reset vector
    jmp reset

.org     INT1addr
    rjmp interrupt_show_num

.org    0x0072

reset:    

    ldi Temp, HIGH(RAMEND)    ; Temp = high byte of ramend address
    out SPH, Temp            ; sph = Temp
    ldi Temp, LOW(RAMEND)    ; Temp = low byte of ramend address
    out SPL, Temp            ; spl = Temp

    ser Temp                ; r16 = 0b11111111
    out DDRE, Temp            ; port E = outputs ( Display JHD202A)
    clr Temp                ; r16 = 0
    out PORTE, Temp    

    ldi Data, 0x25

    ldi Temp, 0b00000010
    out EIMSK, Temp

    ldi Temp, 0b00001000
    sts EICRA, Temp

    sei

; **
; ** init_display
; **
init_disp:    
    rcall power_up_wait        ; wait for display to power up

    ldi Data, BITMODE4        ; 4-bit operation
    rcall write_nibble        ; (in 8-bit mode)
    rcall short_wait        ; wait min. 39 us
    ldi Data, DISPCTRL        ; disp. on, blink on, curs. On
    rcall write_cmd            ; send command
    rcall short_wait        ; wait min. 39 us

rcall clr_disp

loop:    
nop
    rjmp loop            ; loop forever

clr_disp:    
    ldi Data, CLEAR            ; clr display
    rcall write_cmd            ; send command
    rcall long_wait            ; wait min. 1.53 ms
    ret



; **
; ** write char/command
; **

write_char:        
    ldi RS, 0b00100000        ; RS = high
    rjmp write
write_cmd:     
    clr RS                ; RS = low
write:    
    mov Temp, Data        ; copy Data
    andi Data, 0b11110000    ; mask out high nibble
    swap Data            ; swap nibbles
    or Data, RS            ; add register select
    rcall write_nibble        ; send high nibble
    mov Data, Temp        ; restore Data
    andi Data, 0b00001111    ; mask out low nibble
    or Data, RS            ; add register select

write_nibble:
    rcall switch_output        ; Modify for display JHD202A, port E
    nop                ; wait 542nS
    sbi PORTE, 5            ; enable high, JHD202A
    nop
    nop                ; wait 542nS
    cbi PORTE, 5            ; enable low, JHD202A
    nop
    nop                ; wait 542nS
    ret

; **
; ** busy_wait loop
; **
short_wait:    
    clr zh                    ; approx 50 us
    ldi zl, 30
    rjmp wait_loop
long_wait:    
    ldi zh, HIGH(1000)        ; approx 2 ms
    ldi zl, LOW(1000)
    rjmp wait_loop
dbnc_wait:    
    ldi zh, HIGH(4600)        ; approx 10 ms
    ldi zl, LOW(4600)
    rjmp wait_loop
power_up_wait:
    ldi zh, HIGH(9000)        ; approx 20 ms
    ldi zl, LOW(9000)

wait_loop:    
    sbiw z, 1                ; 2 cycles
    brne wait_loop            ; 2 cycles
    ret

; **
; ** modify output signal to fit LCD JHD202A, connected to port E
; **

switch_output:
    push Temp
    clr Temp
    sbrc Data, 0                ; D4 = 1?
    ori Temp, 0b00000100            ; Set pin 2 
    sbrc Data, 1                ; D5 = 1?
    ori Temp, 0b00001000            ; Set pin 3 
    sbrc Data, 2                ; D6 = 1?
    ori Temp, 0b00000001            ; Set pin 0 
    sbrc Data, 3                ; D7 = 1?
    ori Temp, 0b00000010            ; Set pin 1 
    sbrc Data, 4                ; E = 1?
    ori Temp, 0b00100000            ; Set pin 5 
    sbrc Data, 5                ; RS = 1?
    ori Temp, 0b10000000            ; Set pin 7 (wrong in previous version)
    out porte, Temp
    pop Temp
    ret

interrupt_show_num:
    push Temp

Reset_seventyfive:            ; 2 registers are used for counting to 75.
    ldi sfh, 0            ; sfh for the tens of the number;
    ldi sfl, 1            ; sfl for the ones of the number.

increase:
    in Temp, PIND
    cpi Temp, 0xff
    breq switch_lifted        ; keep counting until switch is lifted (0xff)

    inc sfl
    cpi sfl, 10
    brne max_not_reached

    inc sfh
    clr sfl

max_not_reached:
    cpi sfh, 7            
    brne increase            ; if not 7, so not in the 7x range, increase
    cpi sfl, 6             ; 76
    breq reset_seventyfive    ; if equal to 6 (and thus to 7 too), reset nr.

    rjmp increase            ; and jump to increase

switch_lifted:
    
    rcall clr_disp        ; when switch is lifted, counter has a value
    rcall short_wait        ; which we can output to the display.

    mov Data, sfh
    ldi Temp, 0b00110000
    add Data, Temp
    rcall write_char

    pop Temp

    reti
