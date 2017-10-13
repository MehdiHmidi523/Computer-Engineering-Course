/*
 ============================================================================
 Name        : Example5.c
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

int main(void) {

	// Fix that Eclipse bug!
	setvbuf(stdout, NULL, _IOLBF, 0);
	setvbuf(stdout, NULL, _IONBF, 0);

	int i = 6;
	int j = 7;

	// Declare an integer pointer p1 and let it point at i.
	int *p1 = &i;

	// Declare an integer pointer p2 and let it point at j.
	int *p2 = &j;

	/*
	 * It is a good idea to set a pointer to NULL (defined as 0) if it is not
	 * pointing anywhere. That prevents misuse of it, hopefully.
	 *
	 * Putting ** in a declaration means a double pointer ( a pointer that
	 * points to a pointer).
	 */
	int **pp = NULL;

	printf("%i %i\n", i, *p1);

	p2 = &i; // p2 points at i
	printf("%i %i\n", i, *p2); // Read *p2 as 'where p2 points at, get that value'

	pp = &p2; // pp points at p2 (and p2 points at i)

	/*
	 * Since pp points at p2 and p2 points at i then **p means
	 * that we're retrieving the value of i.
	 */
	printf("%i %i\n", i, **pp);

	pp = &p1;
	p1 = &j;
	printf("%i %i\n", i, **pp);

	**pp = 99;
	printf("%i %i\n", i, j);

	 // Allocate an integer dynamically.
	int *p3 = (int *)malloc(sizeof(int));

	/*
	 * When assigning it to NULL we're losing the address to where
	 * the memory chunk is since we haven't deallocated it using a
	 * call to free(p3).
	 *
	 * That memory chunk is now dangling since we don't know where it is.
	 */
	p3 = NULL;

	// Allocate 3456 bytes (being pointed to by an integer pointer)
	p3 = (int *)malloc(3456);

	// Allocate an array containing 3 items. Each item is a float.
	float *f = (float *)malloc(sizeof(float)*3);

	/*
	 * Make a byte pointer point to an integer pointer.
	 */
	unsigned char *b = &p3;
	b++; 	// Move one byte forward (pointing to the second byte of the integer)
	*b=2;

	return EXIT_SUCCESS;
}
