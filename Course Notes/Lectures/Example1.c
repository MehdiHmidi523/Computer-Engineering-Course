/*
 ============================================================================
 Name        : Example1.c
 Author      : Lars Karlsson
 Version     :
 Copyright   : Your copyright notice
 Description :
	A program that allows a user to enter two integers. The integers are
	added and printed on the screen (console).
 ============================================================================
 */
#include <stdio.h>
#include <stdlib.h>

/*
 * main() is the starting point for the program.
 * There can be only one!
 */
int main(void)
{
	/*
	 * Make these two calls at the beginning of the program and you'll
	 * get rid of that annoying bug which displays all printf() calls
	 * after the program has terminated.
	 */
	setvbuf(stdout, NULL, _IOLBF, 0);
	setvbuf(stdout, NULL, _IONBF, 0);

	/*
	 * i1 and i2 are integer variables being initialized to 4 and 13 respectively.
	 * Many, but not all, compilers 'zeroes' their variables automatically, that is
	 * why the variable sum is initialized to 0.
	 */
	int i1 = 4;
	int i2 = 13;
	int sum;

	/*
	 * Print a descriptive text notifying the user what is expected of her or him.
	 * Read the first integer value from the keyboard. Do not forget to use the
	 * &-operator (address operator) as scanf() needs to know the memory location
	 * where it should store the value.
	 * The %i is a format specifier instructing scanf() that an integer should
	 * be read. There are several other format specifiers.
	 */
	printf("Enter first number:");
	scanf("%i", &i1);

	/*
	 * Read second integer value (see above).
	 */
	printf("Enter second number:");
	scanf("%i", &i2);

	/*
	 * Add and assign to the variable sum.
	 */
	sum = i1 + i2;

	/*
	 * Print a nice looking text to the screen.
	 * %i is a format specifier instructing the printf() function that wherever it
	 * is detected in the format string an integer is to be printed.
	 * There are several different format specifiers.
	 */
	printf("The sum of %i and %i is %i.", i1, i2, sum);

	/*
	 * Since we declared the function to return an integer (int main()) we do
	 * so by using the return construct. EXIT_SUCCESS is a defined value that
	 * can be found in stdlib.h. If you open any of the "inbuilt" header files,
	 * do not change any of them unless you know what you're doing.
	 * YOU HAVE BEEN WARNED.
	 */
	return EXIT_SUCCESS;
}

