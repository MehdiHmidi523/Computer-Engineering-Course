/*
 ============================================================================
 Name        : Example2.c
 Author      : Lars Karlsson
 Version     :
 Copyright   : Your copyright notice
 Description : -
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

// This is a comment that starts with the '//' and ends where the row ends.

/*
 * A multiline comment.
 * They can be useful...
 */


/*
 * j is a global variable. Don't use them unless you absolutely have to!
 * Combine global variables and Spaghetti code and you are in for a
 * great ride of confusion and madness.
 */
int j = 2;


int main(void)
{ // Body of main starts here

	printf("%i\n", j); // 2 is printed. '\n' means 'newline'.
	/*
	 * The variable i exists within the current code block which in this case is
	 * the body of main().
	 */
	int i = 3;

	{ // Start a new code block.
		/*
		 * This is not the same variable i as the one declared at row 38.
		 * The one declare here exists only within the current code block
		 * (rows 40 through 48).
		 */
		int i = 4;
		printf("%i\n", i); // 4 is printed
	} // End of code block started at line 40

	printf("%i\n", i); // 3 is printed.

	int i1 = 9;
	printf("---%i %i---", ++i1, ++i1);

	/*
	 * You must return an integer. What value one should return is decided by the
	 * constructor of the program.
	 */
	return 3;
} // Body of main ends here.
