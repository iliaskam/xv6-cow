// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

//  Reference count array 

int ref_array[PHYSTOP/PGSIZE];

// Get active page array number

int pgnum(uint64 pa){
  return (pa - KERNBASE) / PGSIZE;
}

// Get reference count value

int get_ref_count(uint64 pa){
  return ref_array[pgnum(pa)];
}

// Increase reference count function

void inc_ref(void *pa) {
  acquire(&kmem.lock);
  ref_array[pgnum((uint64)pa)]++;
  release(&kmem.lock);
}

// Decrease reference count function

void dec_ref(void *pa) {
  acquire(&kmem.lock);
  ref_array[pgnum((uint64)pa)]--;
  release(&kmem.lock);
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
  // Set reference count to zero 
  for (int i = 0; i < (PHYSTOP/PGSIZE); i++) {
    acquire(&kmem.lock);
    ref_array[i] = 0;
    release(&kmem.lock);
  }
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  dec_ref(pa);
  // Page with reference couunt > 0 don't get freed
  if (get_ref_count((uint64)pa) > 0)
    return;
  ref_array[pgnum((uint64)pa)] = 0;

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk

  // Set reference count to 1
  if(r)
    ref_array[pgnum((uint64)r)] = 1;
  return (void*)r;
}
