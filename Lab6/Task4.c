
#include <avr/io.h>
#include <stdio.h>
#include <util/delay.h>

//Values for USART
#define FOSC 1843200// Clock Speed
#define SPEED_BAUD 2400
#define UBRR_value ((FOSC/16)/SPEED_BAUD)-1
#define START 0x0D
#define END 0x0A
#define MessageLen(x)  (sizeof(x) / sizeof((x)[0]))

void USART_Init( unsigned int ubrr){
    // Set baud rate
    UBRR0H = (unsigned char)(ubrr>>8);
    UBRR0L = (unsigned char)ubrr;
    // Enable receiver and transmitter
    UCSR0B = (1<<RXEN0)|(1<<TXEN0);
    // Set frame format: 8data, 2stop bit
    UCSR0C = (1<<USBS0)|(3<<UCSZ00);
} // USART_Init

void USART_Transmit( unsigned char data )
{
    // Wait for empty transmit buffer
    while ( !( UCSR0A & (1<<UDRE0)) );
    // Put data into buffer, sends the data
    UDR0 = data;
}

unsigned char USART_Receive( void )
{
    // Wait for data to be received
    while ( !(UCSR0A & (1<<RXC0)) ) //RXC0 for receive instructions.
    ;
    // Get and return received data from buffer
    return UDR0;
}

int getCheckSum(char define[], int define_size, char *message) {
    int sum = 0;
    for(int i = 0; i < define_size; i++){
        sum += (int)define[i];
    }
    for(int i = 0; i < strlen(message); i++){
        sum += (int)message[i];
    }
    return (sum+13)%256;        // +13 adds the START 0D in Decimal format.
}

void PrintLine(char memory, char *message) {
    char commando[] = {'A','O','0','0','0','1'};
    commando[0] = memory;
    char checksum[2]; // think it's better to leave 1 space just in case.
    //MessageLen is to determine the storage size of this particular datatype.
    int sum = getCheckSum(commando, MessageLen(commando), message);
    // get the first sum of the message instructions in the CyberTech Display.
    sprintf(checksum,"%02X",sum); //Convert Value to base 16.
    //%02 means print at least 2 digits,or in our case just 2.
    
    DisplayInstruction(commando, MessageLen(commando), message, checksum);
}

void EndLine(){
    char exec[7] = {'Z','D','0','0','1','3','C'};
    USART_Transmit( START );
    for(int i = 0; i < MessageLen(exec); i++) {
        USART_Transmit( exec[i] );
    }
    USART_Transmit( END );
}

void DisplayInstruction(char commando[], int command_size, char *message, char checksum[]){

    USART_Transmit( START );
    for(int i = 0; i < command_size; i++){
        USART_Transmit(commando[i]);
    }
    for (int i = 0; i < strlen(message); i++ ){
        USART_Transmit( message[i]);
    }
    USART_Transmit( checksum[0]);
    USART_Transmit( checksum[1]);
    USART_Transmit( END );
    
}

void receive(char line, char *message, int index) {
    char input = USART_Receive();
    
    if (input == '%')
    {
        PrintLine(line, message);
        EndLine();
        return;
    }
    else
    {
        message[index] = input;
        index++;
        
        receive(line, message, index);
    }
}

unsigned char getAddress() {
        // get A or B!
        char input = USART_Receive();
}

int main(void)
{
    USART_Init ( UBRR_value );
    
    char *message;
    message = malloc(48 * sizeof(int));
    int index = 0;
    char line;
    
    
    
    while (1) {
        line = getAddress();
        receive(line ,message, index);
    }
    
}
