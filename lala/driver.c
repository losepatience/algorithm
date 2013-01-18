/* XXX: assert in kernel */

/* if bad_thing is true, BUG_ON can cause an oops. */
BUG_ON(bad_thing); /* it can halt your system */

/* panic causes an oops and then halt your system */
if (terrible_thing)
	panic("....");

/*
 * if you want to see value of regs and the callback route
 * use dump_stack()
 */
if (debug)
	dump_stack();


/* XXX: list in kernel */

/* list node */
struct list_head
{
       struct list_head*next, *prev;
};

/* initialize a list_head, both its prev and next point itself */
static inline void INIT_LIST_HEAD(struct list_head *list);

/* add a list_head between head and head->next */
static inline void list_add(struct list_head *new, struct  list_head *head);

/* add a list_head between head->prev and head */
static inline void list_add_tail(struct list_head *new, struct list_head *head);

/* get the container of a list_head */
#define list_entry(ptr, type, member) \
       container_of(ptr,type, member)

/*
 * look through the linked list, each list_head returned by pos
 * in fact, it's a for loop
 */
#define list_for_each(pos, head) \
    for (pos = (head)->next, prefetch(pos->next); pos != (head); \
    pos = pos->next, prefetch(pos->next))

list_for_each(list,&current->chilidren) {
              task = list_entry(list, struct task_struct, sibling);
}

/*
 * look through the linked list, each container of list_head
 * returned by pos.
 */
list_for_each_entry(pos, head, member);

/* XXX: ERR_PTR */

/*
 * ERR_PTR and PTR_ERR is simple, it's all about a type convertion.
 *
 * in kernel, some func return a pointer. if error, we all
 * hope the returned pointer could reflect it. a right returned
 * pointer points to the start of a page(4k). it means: ptr & 0xfff == 0
 * so if ptr is between (0xfffff000，0xffffffff), it's a invalid ptr.
 */
static inline long IS_ERR(const void *ptr)
{
	return (unsigned long)ptr > (unsigned long)-1000L;
}

if (a) return ERR_PTR(-EBUSY);




