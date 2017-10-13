/*
 ============================================================================
 Name        : Example3.c
 Author      : Lars Karlsson
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>

int main(void) {

	float f = 12.34;
	int i = (int)f;  // Force the value of f into an integer. Decimals are lost!

	printf("%i\n", i); // Prints 12.

	double d = 1243446555555.6464735585486;

	/*
	 * Casts from a larger to a smaller type size. d's
	 * value is too large.
	 */
	f = (float)d;
	printf("%f\n", f); // 1243446509568 is printed !!!

	int i1 = 9;
	int i2 = 2;

	/*
	 * If no cast to float (or double) is done then integer division is performed.
	 * It doesn't matter if i1 or i2 is casted.
	 */
	float f1 = i1/(float)i2;

	/*
	 * Prior to the printf() call i1 has a value of 9.
	 */
	printf("%i %i", ++i1, ++i1); // Prints 11 11


	/*
	 * The comparison contains an error. The purpose is the check whether
	 * i1 is equal to 33 or not. However a '=' character has been lost by
	 * mistake. The result is an assignment of 33 which is interpreted as
	 * 'true' and therefore 'Is 33' is always printed.
	 */
	if ( i1 = 33  )
		printf("Is 33");

	/*
	 * This is a bad way of checking if two floating variables are equal
	 * (due to the problem of storing floating point values using
	 * binary representation).
	 */
	if ( f1 == f2)
		printf("Are equal");

	/*
	 * Better way of checking if two floating variables are equal.
	 */
	if ( abs(f1 - f2) < FLT_EPSILON)
		printf("Are equal");


	printf("\n\n"); // Print two newlines

	/*
	 * This is an if-statement where the indentations fools one to
	 * visually get the wrong impression of what is actually executed.
	 * It also contains an syntactic error.
	 */
	if ( i1 > 2)
		printf("Hi1");
		printf("Hi2"); //This row will generate an error. Only one statement is allowed.
	else
		printf("Hi3");
		printf("Hi4"); // This row will always be executed. Probably not the intention.

	/*
	 * The 'correct' implementation of the if-statement above.
	 * The bad behaviour above is a reason for always using {}
	 */
	if ( i1 > 2)
	{
		printf("Hi1");
		printf("Hi2");
	}
	else
	{
		printf("Hi3");
		printf("Hi4");
	}

	return EXIT_SUCCESS;
}
