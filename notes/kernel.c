/* XXX ------ udelay
 * loops = n * HZ * loops_per_jiffy / 1000000
 * refer to arch/arm/lib/delay.S(2199023U>>11 = 2^30/1000000)
 * loops_per_jiffy is cacluted in start_kernel, easy but skillful
 */


/* XXX: ------ Assert in kernel */
/* BUG_ON and panic causes an oops and halt your system */
BUG_ON(bad_thing);

if (terrible_thing)
	panic("....");

/* to see value of regs and the callback route, use dump_stack() */
if (debug)
	dump_stack();


/* XXX ------ list_head */
/* init: */ LIST_HEAD(hello); /* or */
struct list_head head;
LIST_HEAD_INIT(head);

list_add(c, a); /* insert */
/*
 * a ---n---> b ---n---> a    a ---n---> c ---n---> b ---n---> a
 * a ---p---> b ---p---> a    a ---p---> b ---p---> c ---p---> a
 */

list_del(a); /* delete*/

list_entry(ptr, type, member); /* container_of(ptr, type, member) */

list_for_each_entry(pos, head, member);
/* for loop: pos used to be return parent struct of every node */
/* example */
static struct s *s;
static LIST_HEAD(list);
list_add_tail(&s->list, &list);
list_for_each_entry(s, head, member) {
	s->a = 2;
}

list_for_each_entry_safe(pos, n, head, member) /* support delete */
list_for_each(list, head)

/* XXX ------ hash table */
hlist_del(struct hlist_node *n); /* delete */
hlist_add_head(struct hlist_node *n, struct hlist_head *h); /* n after head */
hlist_add_before(struct hlist node *n,struct hlist_node *next); /* next -> n */
hlist_add_after(struct hlist node *n,struct hlist_node *next); /* n -> next */
hlist_for_each_entry(tpos, pos, head, member); /* tpos -> parent struct */


/* XXX ------ critical section
 * only allow one thread entering at any time.
 * globa varibal: as hardware, visit it only when
 * it is free(need atomic op)
 */
if (atomic_dec_and_test(&a)) {
	atomic_inc(&a);
	return -EBUSY;
} else {
	... critical section ...
}


/* XXX ------ gcc */
switch-case: case 2 ... 7: statement;

int widths[] = {[1 ... 9] = 1, [10 ... 19] = 2, [20] = 3};

struct store {
     int a;
     int data[0];
};


/* XXX ------ likely
 * if (likely(a)), case a would be compile after fore
 * code, so it could be cached with the fore code
 */



/*
 * XXX: ------ Error process
 * ERR_PTR and PTR_ERR is simple, it's all about a type convertion.
 *
 * In kernel, some func return a pointer. If error, we all
 * hope the returned pointer could reflect it. A right returned
 * pointer points to the start of a page(4k). It means: ptr & 0xfff == 0
 * So if ptr is between (0xfffff000, 0xffffffff), it's a invalid ptr.
 * And cast int(-1000-0) to unsigned long, it would be between
 * 0xfffff000-0xffffffff.
 */
static inline long IS_ERR(const void *ptr)
{
	return (unsigned long)ptr > (unsigned long)-1000L;
}

if (a) return ERR_PTR(-EBUSY);

/*
 * XXX: ------ Basic
 * 在编写驱动时, 程序员应当特别注意这个基础的概念:
 * 编写内核代码来存取硬件, 但是不能强加特别的策略给
 * 用户, 因为不同的用户有不同的需求. 驱动应当做到使
 * 硬件可用, 将所有关于如何使用硬件的事情留给应用程序.
 * 一个驱动, 这样, 就是灵活的, 如果它提供了对硬件能
 * 力的存取, 没有增加约束. 然而, 有时必须作出一些策
 * 略的决定. 例如, 一个数字 I/O 驱动也许只提供对硬件
 * 的字符存取, 以便避免额外的代码处理单个位.
 *
 *   对策略透明的驱动有一些典型的特征. 包括支持同步
 * 和异步操作, 可以多次打开的能力, 利用硬件全部能力,
 * 没有软件层来"简化事情"或者提供策略相关的操作. 这
 * 样的驱动不但对他们的最终用户好用, 而且证明也是易
 * 写易维护的.
 *
 *   __devinit 和 __devinitdata 只在内核没有配置支持
 * hotplug 设备时转换成 __init 和 _initdata
 *
 *   在注册内核设施时, 注册可能失败. 即便最简单的动作
 * 常常需要内存分配, 分配的内存可能不可用. 因此模块代
 * 码必须一直检查返回值, 并确认要求的操作实际上已成功.
 *
 *   内核完全可能会在注册完成之后马上使用任何你注册的
 * 设施. 换句话说, 在你的初始化函数仍然在运行时, 内核
 * 将调用进你的模块. 不要注册任何设施, 直到所有的需要
 * 支持那个设施的你的内部初始化已经完成.
 *
 *   内核调试, printk 和 ioctl/proc 仍是 linus 推荐的
 * 方式. printk 在串口上带来的延迟可用 ioctl 方案代替.
 * strace/kgdb 不是 linus 推荐的.
 *
 */

/*
 * XXX: ------ bit_ops
 * use local variable to guarantee "if" and "test_and_set_bit"
 * to be atomic.
 */
static inline int
____atomic_test_and_set_bit(unsigned int bit, volatile unsigned long *p)
{
	unsigned long flags;
	unsigned int res;
	unsigned long mask = 1UL << (bit & 31);

	p += bit >> 5;

	raw_local_irq_save(flags);
	res = *p;
	*p = res | mask;
	raw_local_irq_restore(flags);

	return (res & mask) != 0;
}
