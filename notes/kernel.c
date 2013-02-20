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
