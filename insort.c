/*
 * SORT(A)  --- hoho
 * for i = 2 to n
 * 	a = A[i];
 * 	j = i - 1;
 * 	while a < A[j] and j > 0
 * 		a[j + 1] = a[j];
 * 		j = j - 1;
 * 	A[j + 1] = a;
 */

#include <stdio.h>

int main(void)
{
	int a[5] = {6, 10, 3, 98, 1};
	int i, j, k;

	for (i = 1; i < 5; i++) {
		k = a[i];
		for (j = i - 1; k < a[j] && j >= 0; j--)
			a[j + 1] = a[j];
		a[j + 1] = k;
	}

	for (i = 0; i < 5; i++)
		printf("%d ", a[i]);
	printf("\n");
	return 0;
}


