/*
 ============================================================================
 Name        : Lecture2.c
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

int main(void) {

int i = 12;

	/* IF statement */

/*
	if( i > 3)
		printf("statement1");
		printf("statement2");  // <-- Rowe causes compiler error
	else
		printf("statement3");
		printf("statement4");	// Always printed!
*/


	if( i > 3)
	{
		printf("statement1");
		printf("statement2");
	}
	else
		printf("statement3");
		printf("statement4");	// Always printed! Is that what You wanted ?

	// Statements correctly surrounded by code blocks!
	if( i > 3)
	{
		printf("statement1");
		printf("statement2");
	}
	else
	{
		printf("statement3");
		printf("statement4");
	}

	/* Pointers ------------------------------------------------------------*/
int ii = 15;
int *p1 = &i;	// p1 points at i
int *p2 = &i;	// p2 points at i

	printf("%i %i %i\n", i, *p1, *p2);	// Prints 12 12 12

	p1 = &ii;				// p1 points at ii
	printf("%i %i %i\n", i, *p1, *p2);	// Prints 12 15 12

int **pp1 = &p2;			// pp1 points at p2 (that points at i)
	printf("%i\n",**pp1);	// prints 12

	pp1 = &p1;				// pp1 points at p1 (that points at ii)
	printf("%i\n",**pp1);	// Prints 15

	pp1 = 123;				// pp1 points at memory location 123.
							// Probably not a good idea on a Windows OS!
							// Absolute address assignment is ok on an ATMEL
							// processor.
	printf("%i\n",**pp1);	// Undefined.

	return EXIT_SUCCESS;
}
