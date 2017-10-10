
.include    "m2560def.inc"
.def    Temp = r16
.def    Data = r17
.def    RS = r18
.def    text_length = r19
.def    line_length = r20
.def    counter = r21
.def    delaytime = r24
.def    delaytime2 = r25
.equ    BITMODE4 = 0b00000010       ; 4-bit operation
.equ    CLEAR = 0b00000001      ; Clear display
.equ    DISPCTRL = 0b00001111       ; Display on, cursor on, blink on.

.cseg
.org 0x0000     ; Reset vector
rjmp reset
line1:
    .DB "First line"         ; Store String text as constant byte in program memory
line2:
    .DB "Second line"
line3:
    .DB "Third line"
line4:
    .DB "Fourth line"
.org    0x0072
reset:  
    ser Temp                ; r16 = 0b11111111
    out DDRE, Temp                 ; port B = outputs ( Display JHD202A)
    ldi Temp, HIGH(RAMEND)      ; Temp = high byte of ramend address
    out SPH, Temp               ; sph = Temp
    ldi Temp, LOW(RAMEND)       ; Temp = low byte of ramend address
    out SPL, Temp               ; spl = Temp
    rcall init_disp             ; init display
    ldi text_length, 10         ; set initial line length
    ldi line_length, 40
    ldi counter, 0            ; set counter to start at first line
main:
    rcall clr_disp            ; clear display first
    cpi counter, 0            ; compare counter to show correct lines
    breq first
    cpi counter, 1
    breq second
    cpi counter, 2
    breq third
    cpi counter, 3
    breq fourth
    
    rjmp main

first:            ; every line needs its own handling, since line lengths differ
    inc counter
    ldi text_length, 10        ; 'First line' counts 10 chars
    ldi line_length, 40        

    ; we define register pair pointer z and load the Line constant (.DB) to it 
    ; since the program memory is organized word wise (2 bytes ) and access is limited to 15 bits
    ;  we point the highest and least significant bits in z accordingly hence the (address*2) (read 5.2.2 in Beginners Guide)

    ldi ZH, HIGH(line1*2)    
    ldi ZL, LOW(line1*2)
    rcall write_line        
    ldi text_length, 11        ; 'Second line' counts 11 chars.
    ldi line_length, 40
    ldi ZH, HIGH(line2*2)
    ldi ZL, LOW(line2*2)
    rcall write_line
    rcall start_delay
    rjmp main
second:
    inc counter
    ldi text_length, 11
    ldi line_length, 40
    ldi ZH, HIGH(line2*2)
    ldi ZL, LOW(line2*2)
    rcall write_line
    
    ldi text_length, 10
    ldi line_length, 40
    ldi ZH, HIGH(line3*2)
    ldi ZL, LOW(line3*2)
    rcall write_line
    rcall start_delay
    rjmp main
third:
    inc counter
    ldi text_length, 10
    ldi line_length, 40
    ldi ZH, HIGH(line3*2)
    ldi ZL, LOW(line3*2)
    rcall write_line
    
    ldi text_length, 11
    ldi line_length, 40
    ldi ZH, HIGH(line4*2)
    ldi ZL, LOW(line4*2)
    rcall write_line
    rcall start_delay
    rjmp main
fourth:
    ldi counter, 0
    ldi text_length, 11
    ldi line_length, 40
    ldi ZH, HIGH(line4*2)
    ldi ZL, LOW(line4*2)
    rcall write_line
    
    ldi text_length, 10
    ldi line_length, 40
    ldi ZH, HIGH(line1*2)
    ldi ZL, LOW(line1*2)
    rcall write_line
    rcall start_delay
    rjmp main

write_line:
    lpm                    ; read access to the program storage space
                    ; The instruction copies the byte 
; at program flash address Z to the register R0.
    mov Data, r0
    rcall write_char        ; write char uses Data to display the line char by char
    push zh
    push zl
    rcall short_wait        ; push Z because Z is used in short_wait
    pop zl
    pop zh
    adiw ZL, 1        ; increment address to point to next byte in prog. mem.
    subi line_length, 1    ; subtract line length
    subi text_length, 1
    brne write_line        

write_space:
    ldi Data, 0x20        ; when text_length has reached zero, continue here
    rcall write_char        ; to go to new line.
    rcall short_wait
    subi line_length, 1
    brne write_space
    ret



; ** init_display
; **
init_disp:  
    rcall long_wait         ; wait for display to power up
    ldi Data, BITMODE4      ; 4-bit operation
    rcall write_nibble      ; (in 8-bit mode)
    rcall short_wait        ; wait min. 39 us
    ldi Data, DISPCTRL      ; disp. on, blink on, curs. On
    rcall write_cmd         ; send command
    rcall short_wait        ; wait min. 39 us
clr_disp:   
    ldi Data, CLEAR         ; clr display
    rcall write_cmd         ; send command
    rcall long_wait         ; wait min. 1.53 ms
    ret
; ** write char/command
; **
write_char:     
    ldi RS, 0b00100000      ; RS = high
    rjmp write
write_cmd:  
    clr RS                  ; RS = low
write:  
    mov Temp, Data          ; copy Data
    andi Data, 0b11110000   ; mask out high nibble
    swap Data               ; swap nibbles
    or Data, RS             ; add register select
    rcall write_nibble      ; send high nibble
    mov Data, Temp          ; restore Data
    andi Data, 0b00001111   ; mask out low nibble
    or Data, RS             ; add register select
write_nibble:
    rcall switch_output     ; Modify for display JHD202A, port E
    nop                     ; wait 542nS
    sbi PORTE, 5            ; enable high, JHD202A
    nop                     ; wait 542nS
    cbi PORTE, 5            ; enable low, JHD202A
    nop                     ; wait 542nS
    ret
; ** busy_wait loop
; **
short_wait: 
    clr zh                  ; approx 50 us
    ldi zl, 30
    rjmp wait_loop
long_wait:  
    ldi zh, HIGH(1000)      ; approx 2 ms
    ldi zl, LOW(1000)
    rjmp wait_loop
dbnc_wait:  
    ldi zh, HIGH(4600)      ; approx 10 ms
    ldi zl, LOW(4600)
wait_loop:  
    sbiw z, 1               ; 2 cycles
    brne wait_loop          ; 2 cycles
    ret
; ** modify output signal to fit LCD JHD202A, connected to port E
; **
switch_output:
    push Temp
    clr Temp
    sbrc Data, 0                ; D4 = 1?
    ori Temp, 0b00000100        ; Set pin 2 
    sbrc Data, 1                ; D5 = 1?
    ori Temp, 0b00001000        ; Set pin 3 
    sbrc Data, 2                ; D6 = 1?
    ori Temp, 0b00000001        ; Set pin 0 
    sbrc Data, 3                ; D7 = 1?
    ori Temp, 0b00000010        ; Set pin 1 
    sbrc Data, 4                ; E = 1?
    ori Temp, 0b00100000        ; Set pin 5 
    sbrc Data, 5                ; RS = 1?
    ori Temp, 0b10000000        ; Set pin 7 
    out PORTE, Temp
    pop Temp
    ret

start_delay:
    ldi delaytime, LOW(5000)
    ldi delaytime2, HIGH(5000)
    
delay1:     
    sbiw delaytime2:delaytime, 1
    brne delay2
    ret
    
delay2:
    ldi Temp, 0xFA
    rcall delay3
    rjmp delay1
    
delay3:
    dec Temp
    cpi Temp, 0x00
    brne delay3
    ret

