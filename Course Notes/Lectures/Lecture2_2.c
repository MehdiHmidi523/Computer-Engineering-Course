/*
 ============================================================================
 Name        : Example4.c
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

int main(void) {

int i = 4;

	// Fix that Eclipse bug!
	setvbuf(stdout, NULL, _IOLBF, 0);
	setvbuf(stdout, NULL, _IONBF, 0);

	switch( i)
	{
		/*
		 * If i==4 then it will through to
		 * case 5 as well since there is no
		 * break;
		 */
		case 4:
		case 5:
			printf("5\n");
			break;
	}

	/*
	 * Same as the switch statement above.
	 */
	if( i==4 && i == 5)
	{
		printf("5\n");
	}


	//for(;;);  // Infinite loop

	int j = 0;

	/*
	 * Infinite loop.
	 * The ';' character is put there by mistake.
	 */
	while(j < 5);

	/*
	 * Run through the loop as long as
	 * j < 5.
	 */
	while(j < 5)
	{
		printf("Value=%i\n", j);
		j++;
	}

	/*
	 * Infinite loop.
	 * Sometimes found in server applications.
	 */
	while(1)
	{
		/*
		 * This is usually found somewhere (or let some external
		 * event kill the process).
		 */
		break;
	}

	return 0;
}
