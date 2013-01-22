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
