#include <stdio.h>

/*
 * sum(1) = 1;
 * sum(n) = n + sum(n - 1)
 */
int sum(int a)
{
	if (a == 1)
		return 1;
	return a + sum(a - 1);
}

/*
 * hanoi(1, a, b, c): a -> c
 * hanoi(n, a, b, c):
 * 	hanoi(n - 1, a, c, b)
 * 	hanoi(1, a, b, c)
 * 	hanoi(n - 1, b, a, c)
 */
void hanoi(int n, char a, char b, char c)
{
	if (n == 1) {
		printf("from %c to %c\n", a, c);
		return;
	}
  	hanoi(n - 1, a, c, b);
  	hanoi(1, a, b, c);
  	hanoi(n - 1, b, a, c);
}

/*
 *  rev(1, s): putchar(s);
 *  rev(n, s):
 *  	rev(n - 1, s + 1)
 *  	putchar(s)
 *
 */
void rev(int n, char *s)
{
	if (n == 1) {
		putchar(*s);
		return;
	}

	putchar(*(s + n - 1));
	rev(n - 1, s);
}

int main(void)
{
	char str[10] = "abcdefghi";

	hanoi(3, 'A', 'B', 'C');
	rev(9, str);
	printf("%d\n", sum(100));
	return 0;
}
