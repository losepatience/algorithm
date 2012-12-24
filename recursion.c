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

/*
 * n 个有区别的球放到 m 个相同的盒子中，要求无一空盒，
 * 其不同的方案数用S(n,m)表示，称为第二类Stirling数
 * ① bn 独自占一个盒子, 方案数为 S(n-1, m-1)
 * ② bn 与别的球共占一个盒子, 那么可以事先将 b1, b2, ... bn-1
 *   这 n-1 个球放入 m 个盒子中，然后再将球 bn 可以放入其
 *   中一个盒子中，方案数为 mS(n-1, m)
 * [定理] S(n, m) = mS(n-1, m) + S(n-1,m-1) (n > 1, m > 1)
 */

/*
 * 设有 n 条封闭曲线画在平面上, 而任何两条封闭曲线恰好相
 * 交于两点, 且任何三条封闭曲线不相交于同一点, 问这些封
 * 闭曲线把平面分割成的区域个数
 *
 * 当平面上已有 n-1 条曲线将平面分割成 an-1­个区域后, 第
 * n-1 条曲线每与曲线相交一次，就会增加一个区域:
 *     an = an-1 + 2(n-1)
 */

/*
 * 设N个人为a,b,c,d...,N张卡为A,B,C,D...
 * 若 a 拿 b 的卡 B, b 也拿 a 的卡 A, 则显然只剩下 N-2
 * 个人拿卡, 自然是 f(N - 2) 种了.
 * 若 a 拿 b 的卡 B, b 没拿 a 的卡 A, 则显然与 N-1 个人
 * 拿卡一样,自然是 f(N-1) 种了. 而a不一定拿 B, 只要是
 * B,C,D...(N-1个) 中的一个就可以了, 所以在 f(N-1) + f(N-2)
 * 再乘上 N-1 就行了.
 *
 * 思考的角度不同得到的答案也不同，奇怪了！
 * 1.是 n 个信和信封的装错装法，将第 n+1 封信与前
 *   n 封中的某一封对调, 有n*A(n)种情况.
 * 2.是n个信和信封中，某一个装对了，其余 n - 1 个
 *   信和信封的装错装法, 再将将第 n+1 封信与前n封
 *   中的装对的那一封对调, 有 n * A(n - 1) 种情况.
 */

/*
 * 由 "E" "O" "F" 三种字符组成的字符串, 禁止在串中出现 O 相
 * 邻的情况. 共有多少种满足要求的不同的字符串吗?
 * F(n) = E(n) + O(n)
 * O(n) = E(n - 1)
 * E(n) = 2F(n - 1)
 * ---> F(n) = 2(F(n - 1) + F(n - 2))
 */

int main(void)
{
	char str[10] = "abcdefghi";

	hanoi(3, 'A', 'B', 'C');
	rev(9, str);
	printf("%d\n", sum(100));
	return 0;
}
