#include <unistd.h>
#include <sys/reboot.h>

int main(void)
{
	sync();
	reboot(RB_AUTOBOOT);
	return 0;
}

#include <stdio.h>
/* Both: use strong. Only weak: use weak * */
void hello() __attribute__ ((weak,alias("hey")));
void hey(void)
{
	printf("hey\n");
}

/*
 * 如果 if (lilely(a)), 说明 a 条件发生的可能性大,
 * 那么 a 为真的语句在编译时就应紧跟在前面程序的后
 * 面, 这样就会被cache预读取进去, 增加程序执行速度.
 * unlikely 正好相反.
 */
