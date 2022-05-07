
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	86013103          	ld	sp,-1952(sp) # 80008860 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	093050ef          	jal	ra,800058a8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <pgnum>:

int ref_array[PHYSTOP/PGSIZE];

// Get active page array number

int pgnum(uint64 pa){
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
  return (pa - KERNBASE) / PGSIZE;
    80000022:	800007b7          	lui	a5,0x80000
    80000026:	953e                	add	a0,a0,a5
    80000028:	8131                	srli	a0,a0,0xc
}
    8000002a:	2501                	sext.w	a0,a0
    8000002c:	6422                	ld	s0,8(sp)
    8000002e:	0141                	addi	sp,sp,16
    80000030:	8082                	ret

0000000080000032 <get_ref_count>:

// Get reference count value

int get_ref_count(uint64 pa){
    80000032:	1141                	addi	sp,sp,-16
    80000034:	e422                	sd	s0,8(sp)
    80000036:	0800                	addi	s0,sp,16
  return (pa - KERNBASE) / PGSIZE;
    80000038:	800007b7          	lui	a5,0x80000
    8000003c:	97aa                	add	a5,a5,a0
    8000003e:	83b1                	srli	a5,a5,0xc
  return ref_array[pgnum(pa)];
    80000040:	2781                	sext.w	a5,a5
    80000042:	078a                	slli	a5,a5,0x2
    80000044:	00009717          	auipc	a4,0x9
    80000048:	00c70713          	addi	a4,a4,12 # 80009050 <ref_array>
    8000004c:	97ba                	add	a5,a5,a4
}
    8000004e:	4388                	lw	a0,0(a5)
    80000050:	6422                	ld	s0,8(sp)
    80000052:	0141                	addi	sp,sp,16
    80000054:	8082                	ret

0000000080000056 <inc_ref>:

// Increase reference count function

void inc_ref(void *pa) {
    80000056:	1101                	addi	sp,sp,-32
    80000058:	ec06                	sd	ra,24(sp)
    8000005a:	e822                	sd	s0,16(sp)
    8000005c:	e426                	sd	s1,8(sp)
    8000005e:	e04a                	sd	s2,0(sp)
    80000060:	1000                	addi	s0,sp,32
    80000062:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000064:	00009917          	auipc	s2,0x9
    80000068:	fcc90913          	addi	s2,s2,-52 # 80009030 <kmem>
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	234080e7          	jalr	564(ra) # 800062a2 <acquire>
  return (pa - KERNBASE) / PGSIZE;
    80000076:	80000537          	lui	a0,0x80000
    8000007a:	94aa                	add	s1,s1,a0
    8000007c:	80b1                	srli	s1,s1,0xc
    8000007e:	2481                	sext.w	s1,s1
  ref_array[pgnum((uint64)pa)]++;
    80000080:	048a                	slli	s1,s1,0x2
    80000082:	00009797          	auipc	a5,0x9
    80000086:	fce78793          	addi	a5,a5,-50 # 80009050 <ref_array>
    8000008a:	94be                	add	s1,s1,a5
    8000008c:	409c                	lw	a5,0(s1)
    8000008e:	2785                	addiw	a5,a5,1
    80000090:	c09c                	sw	a5,0(s1)
  release(&kmem.lock);
    80000092:	854a                	mv	a0,s2
    80000094:	00006097          	auipc	ra,0x6
    80000098:	2c2080e7          	jalr	706(ra) # 80006356 <release>
}
    8000009c:	60e2                	ld	ra,24(sp)
    8000009e:	6442                	ld	s0,16(sp)
    800000a0:	64a2                	ld	s1,8(sp)
    800000a2:	6902                	ld	s2,0(sp)
    800000a4:	6105                	addi	sp,sp,32
    800000a6:	8082                	ret

00000000800000a8 <dec_ref>:

// Decrease reference count function

void dec_ref(void *pa) {
    800000a8:	1101                	addi	sp,sp,-32
    800000aa:	ec06                	sd	ra,24(sp)
    800000ac:	e822                	sd	s0,16(sp)
    800000ae:	e426                	sd	s1,8(sp)
    800000b0:	e04a                	sd	s2,0(sp)
    800000b2:	1000                	addi	s0,sp,32
    800000b4:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    800000b6:	00009917          	auipc	s2,0x9
    800000ba:	f7a90913          	addi	s2,s2,-134 # 80009030 <kmem>
    800000be:	854a                	mv	a0,s2
    800000c0:	00006097          	auipc	ra,0x6
    800000c4:	1e2080e7          	jalr	482(ra) # 800062a2 <acquire>
  return (pa - KERNBASE) / PGSIZE;
    800000c8:	80000537          	lui	a0,0x80000
    800000cc:	94aa                	add	s1,s1,a0
    800000ce:	80b1                	srli	s1,s1,0xc
    800000d0:	2481                	sext.w	s1,s1
  ref_array[pgnum((uint64)pa)]--;
    800000d2:	048a                	slli	s1,s1,0x2
    800000d4:	00009797          	auipc	a5,0x9
    800000d8:	f7c78793          	addi	a5,a5,-132 # 80009050 <ref_array>
    800000dc:	94be                	add	s1,s1,a5
    800000de:	409c                	lw	a5,0(s1)
    800000e0:	37fd                	addiw	a5,a5,-1
    800000e2:	c09c                	sw	a5,0(s1)
  release(&kmem.lock);
    800000e4:	854a                	mv	a0,s2
    800000e6:	00006097          	auipc	ra,0x6
    800000ea:	270080e7          	jalr	624(ra) # 80006356 <release>
}
    800000ee:	60e2                	ld	ra,24(sp)
    800000f0:	6442                	ld	s0,16(sp)
    800000f2:	64a2                	ld	s1,8(sp)
    800000f4:	6902                	ld	s2,0(sp)
    800000f6:	6105                	addi	sp,sp,32
    800000f8:	8082                	ret

00000000800000fa <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800000fa:	1101                	addi	sp,sp,-32
    800000fc:	ec06                	sd	ra,24(sp)
    800000fe:	e822                	sd	s0,16(sp)
    80000100:	e426                	sd	s1,8(sp)
    80000102:	e04a                	sd	s2,0(sp)
    80000104:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000106:	03451793          	slli	a5,a0,0x34
    8000010a:	e7a9                	bnez	a5,80000154 <kfree+0x5a>
    8000010c:	84aa                	mv	s1,a0
    8000010e:	00246797          	auipc	a5,0x246
    80000112:	13278793          	addi	a5,a5,306 # 80246240 <end>
    80000116:	02f56f63          	bltu	a0,a5,80000154 <kfree+0x5a>
    8000011a:	47c5                	li	a5,17
    8000011c:	07ee                	slli	a5,a5,0x1b
    8000011e:	02f57b63          	bgeu	a0,a5,80000154 <kfree+0x5a>
    panic("kfree");

  dec_ref(pa);
    80000122:	00000097          	auipc	ra,0x0
    80000126:	f86080e7          	jalr	-122(ra) # 800000a8 <dec_ref>
  return (pa - KERNBASE) / PGSIZE;
    8000012a:	800007b7          	lui	a5,0x80000
    8000012e:	97a6                	add	a5,a5,s1
    80000130:	83b1                	srli	a5,a5,0xc
    80000132:	2781                	sext.w	a5,a5
  return ref_array[pgnum(pa)];
    80000134:	00279693          	slli	a3,a5,0x2
    80000138:	00009717          	auipc	a4,0x9
    8000013c:	f1870713          	addi	a4,a4,-232 # 80009050 <ref_array>
    80000140:	9736                	add	a4,a4,a3
  // Page with reference couunt > 0 don't get freed
  if (get_ref_count((uint64)pa) > 0)
    80000142:	4318                	lw	a4,0(a4)
    80000144:	02e05063          	blez	a4,80000164 <kfree+0x6a>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000148:	60e2                	ld	ra,24(sp)
    8000014a:	6442                	ld	s0,16(sp)
    8000014c:	64a2                	ld	s1,8(sp)
    8000014e:	6902                	ld	s2,0(sp)
    80000150:	6105                	addi	sp,sp,32
    80000152:	8082                	ret
    panic("kfree");
    80000154:	00008517          	auipc	a0,0x8
    80000158:	ebc50513          	addi	a0,a0,-324 # 80008010 <etext+0x10>
    8000015c:	00006097          	auipc	ra,0x6
    80000160:	bfc080e7          	jalr	-1028(ra) # 80005d58 <panic>
  ref_array[pgnum((uint64)pa)] = 0;
    80000164:	00009717          	auipc	a4,0x9
    80000168:	eec70713          	addi	a4,a4,-276 # 80009050 <ref_array>
    8000016c:	00d707b3          	add	a5,a4,a3
    80000170:	0007a023          	sw	zero,0(a5) # ffffffff80000000 <end+0xfffffffeffdb9dc0>
  memset(pa, 1, PGSIZE);
    80000174:	6605                	lui	a2,0x1
    80000176:	4585                	li	a1,1
    80000178:	8526                	mv	a0,s1
    8000017a:	00000097          	auipc	ra,0x0
    8000017e:	172080e7          	jalr	370(ra) # 800002ec <memset>
  acquire(&kmem.lock);
    80000182:	00009917          	auipc	s2,0x9
    80000186:	eae90913          	addi	s2,s2,-338 # 80009030 <kmem>
    8000018a:	854a                	mv	a0,s2
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	116080e7          	jalr	278(ra) # 800062a2 <acquire>
  r->next = kmem.freelist;
    80000194:	01893783          	ld	a5,24(s2)
    80000198:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000019a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000019e:	854a                	mv	a0,s2
    800001a0:	00006097          	auipc	ra,0x6
    800001a4:	1b6080e7          	jalr	438(ra) # 80006356 <release>
    800001a8:	b745                	j	80000148 <kfree+0x4e>

00000000800001aa <freerange>:
{
    800001aa:	7179                	addi	sp,sp,-48
    800001ac:	f406                	sd	ra,40(sp)
    800001ae:	f022                	sd	s0,32(sp)
    800001b0:	ec26                	sd	s1,24(sp)
    800001b2:	e84a                	sd	s2,16(sp)
    800001b4:	e44e                	sd	s3,8(sp)
    800001b6:	e052                	sd	s4,0(sp)
    800001b8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800001ba:	6785                	lui	a5,0x1
    800001bc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800001c0:	94aa                	add	s1,s1,a0
    800001c2:	757d                	lui	a0,0xfffff
    800001c4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800001c6:	94be                	add	s1,s1,a5
    800001c8:	0095ee63          	bltu	a1,s1,800001e4 <freerange+0x3a>
    800001cc:	892e                	mv	s2,a1
    kfree(p);
    800001ce:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800001d0:	6985                	lui	s3,0x1
    kfree(p);
    800001d2:	01448533          	add	a0,s1,s4
    800001d6:	00000097          	auipc	ra,0x0
    800001da:	f24080e7          	jalr	-220(ra) # 800000fa <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800001de:	94ce                	add	s1,s1,s3
    800001e0:	fe9979e3          	bgeu	s2,s1,800001d2 <freerange+0x28>
}
    800001e4:	70a2                	ld	ra,40(sp)
    800001e6:	7402                	ld	s0,32(sp)
    800001e8:	64e2                	ld	s1,24(sp)
    800001ea:	6942                	ld	s2,16(sp)
    800001ec:	69a2                	ld	s3,8(sp)
    800001ee:	6a02                	ld	s4,0(sp)
    800001f0:	6145                	addi	sp,sp,48
    800001f2:	8082                	ret

00000000800001f4 <kinit>:
{
    800001f4:	7179                	addi	sp,sp,-48
    800001f6:	f406                	sd	ra,40(sp)
    800001f8:	f022                	sd	s0,32(sp)
    800001fa:	ec26                	sd	s1,24(sp)
    800001fc:	e84a                	sd	s2,16(sp)
    800001fe:	e44e                	sd	s3,8(sp)
    80000200:	1800                	addi	s0,sp,48
  initlock(&kmem.lock, "kmem");
    80000202:	00008597          	auipc	a1,0x8
    80000206:	e1658593          	addi	a1,a1,-490 # 80008018 <etext+0x18>
    8000020a:	00009517          	auipc	a0,0x9
    8000020e:	e2650513          	addi	a0,a0,-474 # 80009030 <kmem>
    80000212:	00006097          	auipc	ra,0x6
    80000216:	000080e7          	jalr	ra # 80006212 <initlock>
  freerange(end, (void*)PHYSTOP);
    8000021a:	45c5                	li	a1,17
    8000021c:	05ee                	slli	a1,a1,0x1b
    8000021e:	00246517          	auipc	a0,0x246
    80000222:	02250513          	addi	a0,a0,34 # 80246240 <end>
    80000226:	00000097          	auipc	ra,0x0
    8000022a:	f84080e7          	jalr	-124(ra) # 800001aa <freerange>
  for (int i = 0; i < (PHYSTOP/PGSIZE); i++) {
    8000022e:	00009497          	auipc	s1,0x9
    80000232:	e2248493          	addi	s1,s1,-478 # 80009050 <ref_array>
    80000236:	00229997          	auipc	s3,0x229
    8000023a:	e1a98993          	addi	s3,s3,-486 # 80229050 <pid_lock>
    acquire(&kmem.lock);
    8000023e:	00009917          	auipc	s2,0x9
    80000242:	df290913          	addi	s2,s2,-526 # 80009030 <kmem>
    80000246:	854a                	mv	a0,s2
    80000248:	00006097          	auipc	ra,0x6
    8000024c:	05a080e7          	jalr	90(ra) # 800062a2 <acquire>
    ref_array[i] = 0;
    80000250:	0004a023          	sw	zero,0(s1)
    release(&kmem.lock);
    80000254:	854a                	mv	a0,s2
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	100080e7          	jalr	256(ra) # 80006356 <release>
  for (int i = 0; i < (PHYSTOP/PGSIZE); i++) {
    8000025e:	0491                	addi	s1,s1,4
    80000260:	ff3493e3          	bne	s1,s3,80000246 <kinit+0x52>
}
    80000264:	70a2                	ld	ra,40(sp)
    80000266:	7402                	ld	s0,32(sp)
    80000268:	64e2                	ld	s1,24(sp)
    8000026a:	6942                	ld	s2,16(sp)
    8000026c:	69a2                	ld	s3,8(sp)
    8000026e:	6145                	addi	sp,sp,48
    80000270:	8082                	ret

0000000080000272 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000027c:	00009497          	auipc	s1,0x9
    80000280:	db448493          	addi	s1,s1,-588 # 80009030 <kmem>
    80000284:	8526                	mv	a0,s1
    80000286:	00006097          	auipc	ra,0x6
    8000028a:	01c080e7          	jalr	28(ra) # 800062a2 <acquire>
  r = kmem.freelist;
    8000028e:	6c84                	ld	s1,24(s1)
  if(r)
    80000290:	c4a9                	beqz	s1,800002da <kalloc+0x68>
    kmem.freelist = r->next;
    80000292:	609c                	ld	a5,0(s1)
    80000294:	00009517          	auipc	a0,0x9
    80000298:	d9c50513          	addi	a0,a0,-612 # 80009030 <kmem>
    8000029c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000029e:	00006097          	auipc	ra,0x6
    800002a2:	0b8080e7          	jalr	184(ra) # 80006356 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800002a6:	6605                	lui	a2,0x1
    800002a8:	4595                	li	a1,5
    800002aa:	8526                	mv	a0,s1
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	040080e7          	jalr	64(ra) # 800002ec <memset>
  return (pa - KERNBASE) / PGSIZE;
    800002b4:	800007b7          	lui	a5,0x80000
    800002b8:	97a6                	add	a5,a5,s1
    800002ba:	83b1                	srli	a5,a5,0xc

  // Set reference count to 1
  if(r)
    ref_array[pgnum((uint64)r)] = 1;
    800002bc:	2781                	sext.w	a5,a5
    800002be:	078a                	slli	a5,a5,0x2
    800002c0:	00009717          	auipc	a4,0x9
    800002c4:	d9070713          	addi	a4,a4,-624 # 80009050 <ref_array>
    800002c8:	97ba                	add	a5,a5,a4
    800002ca:	4705                	li	a4,1
    800002cc:	c398                	sw	a4,0(a5)
  return (void*)r;
}
    800002ce:	8526                	mv	a0,s1
    800002d0:	60e2                	ld	ra,24(sp)
    800002d2:	6442                	ld	s0,16(sp)
    800002d4:	64a2                	ld	s1,8(sp)
    800002d6:	6105                	addi	sp,sp,32
    800002d8:	8082                	ret
  release(&kmem.lock);
    800002da:	00009517          	auipc	a0,0x9
    800002de:	d5650513          	addi	a0,a0,-682 # 80009030 <kmem>
    800002e2:	00006097          	auipc	ra,0x6
    800002e6:	074080e7          	jalr	116(ra) # 80006356 <release>
  if(r)
    800002ea:	b7d5                	j	800002ce <kalloc+0x5c>

00000000800002ec <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002ec:	1141                	addi	sp,sp,-16
    800002ee:	e422                	sd	s0,8(sp)
    800002f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002f2:	ce09                	beqz	a2,8000030c <memset+0x20>
    800002f4:	87aa                	mv	a5,a0
    800002f6:	fff6071b          	addiw	a4,a2,-1
    800002fa:	1702                	slli	a4,a4,0x20
    800002fc:	9301                	srli	a4,a4,0x20
    800002fe:	0705                	addi	a4,a4,1
    80000300:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000302:	00b78023          	sb	a1,0(a5) # ffffffff80000000 <end+0xfffffffeffdb9dc0>
  for(i = 0; i < n; i++){
    80000306:	0785                	addi	a5,a5,1
    80000308:	fee79de3          	bne	a5,a4,80000302 <memset+0x16>
  }
  return dst;
}
    8000030c:	6422                	ld	s0,8(sp)
    8000030e:	0141                	addi	sp,sp,16
    80000310:	8082                	ret

0000000080000312 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000312:	1141                	addi	sp,sp,-16
    80000314:	e422                	sd	s0,8(sp)
    80000316:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000318:	ca05                	beqz	a2,80000348 <memcmp+0x36>
    8000031a:	fff6069b          	addiw	a3,a2,-1
    8000031e:	1682                	slli	a3,a3,0x20
    80000320:	9281                	srli	a3,a3,0x20
    80000322:	0685                	addi	a3,a3,1
    80000324:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000326:	00054783          	lbu	a5,0(a0)
    8000032a:	0005c703          	lbu	a4,0(a1)
    8000032e:	00e79863          	bne	a5,a4,8000033e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000332:	0505                	addi	a0,a0,1
    80000334:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000336:	fed518e3          	bne	a0,a3,80000326 <memcmp+0x14>
  }

  return 0;
    8000033a:	4501                	li	a0,0
    8000033c:	a019                	j	80000342 <memcmp+0x30>
      return *s1 - *s2;
    8000033e:	40e7853b          	subw	a0,a5,a4
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret
  return 0;
    80000348:	4501                	li	a0,0
    8000034a:	bfe5                	j	80000342 <memcmp+0x30>

000000008000034c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e422                	sd	s0,8(sp)
    80000350:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000352:	ca0d                	beqz	a2,80000384 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000354:	00a5f963          	bgeu	a1,a0,80000366 <memmove+0x1a>
    80000358:	02061693          	slli	a3,a2,0x20
    8000035c:	9281                	srli	a3,a3,0x20
    8000035e:	00d58733          	add	a4,a1,a3
    80000362:	02e56463          	bltu	a0,a4,8000038a <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000366:	fff6079b          	addiw	a5,a2,-1
    8000036a:	1782                	slli	a5,a5,0x20
    8000036c:	9381                	srli	a5,a5,0x20
    8000036e:	0785                	addi	a5,a5,1
    80000370:	97ae                	add	a5,a5,a1
    80000372:	872a                	mv	a4,a0
      *d++ = *s++;
    80000374:	0585                	addi	a1,a1,1
    80000376:	0705                	addi	a4,a4,1
    80000378:	fff5c683          	lbu	a3,-1(a1)
    8000037c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000380:	fef59ae3          	bne	a1,a5,80000374 <memmove+0x28>

  return dst;
}
    80000384:	6422                	ld	s0,8(sp)
    80000386:	0141                	addi	sp,sp,16
    80000388:	8082                	ret
    d += n;
    8000038a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000038c:	fff6079b          	addiw	a5,a2,-1
    80000390:	1782                	slli	a5,a5,0x20
    80000392:	9381                	srli	a5,a5,0x20
    80000394:	fff7c793          	not	a5,a5
    80000398:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000039a:	177d                	addi	a4,a4,-1
    8000039c:	16fd                	addi	a3,a3,-1
    8000039e:	00074603          	lbu	a2,0(a4)
    800003a2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003a6:	fef71ae3          	bne	a4,a5,8000039a <memmove+0x4e>
    800003aa:	bfe9                	j	80000384 <memmove+0x38>

00000000800003ac <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800003ac:	1141                	addi	sp,sp,-16
    800003ae:	e406                	sd	ra,8(sp)
    800003b0:	e022                	sd	s0,0(sp)
    800003b2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003b4:	00000097          	auipc	ra,0x0
    800003b8:	f98080e7          	jalr	-104(ra) # 8000034c <memmove>
}
    800003bc:	60a2                	ld	ra,8(sp)
    800003be:	6402                	ld	s0,0(sp)
    800003c0:	0141                	addi	sp,sp,16
    800003c2:	8082                	ret

00000000800003c4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003c4:	1141                	addi	sp,sp,-16
    800003c6:	e422                	sd	s0,8(sp)
    800003c8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003ca:	ce11                	beqz	a2,800003e6 <strncmp+0x22>
    800003cc:	00054783          	lbu	a5,0(a0)
    800003d0:	cf89                	beqz	a5,800003ea <strncmp+0x26>
    800003d2:	0005c703          	lbu	a4,0(a1)
    800003d6:	00f71a63          	bne	a4,a5,800003ea <strncmp+0x26>
    n--, p++, q++;
    800003da:	367d                	addiw	a2,a2,-1
    800003dc:	0505                	addi	a0,a0,1
    800003de:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003e0:	f675                	bnez	a2,800003cc <strncmp+0x8>
  if(n == 0)
    return 0;
    800003e2:	4501                	li	a0,0
    800003e4:	a809                	j	800003f6 <strncmp+0x32>
    800003e6:	4501                	li	a0,0
    800003e8:	a039                	j	800003f6 <strncmp+0x32>
  if(n == 0)
    800003ea:	ca09                	beqz	a2,800003fc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003ec:	00054503          	lbu	a0,0(a0)
    800003f0:	0005c783          	lbu	a5,0(a1)
    800003f4:	9d1d                	subw	a0,a0,a5
}
    800003f6:	6422                	ld	s0,8(sp)
    800003f8:	0141                	addi	sp,sp,16
    800003fa:	8082                	ret
    return 0;
    800003fc:	4501                	li	a0,0
    800003fe:	bfe5                	j	800003f6 <strncmp+0x32>

0000000080000400 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e422                	sd	s0,8(sp)
    80000404:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000406:	872a                	mv	a4,a0
    80000408:	8832                	mv	a6,a2
    8000040a:	367d                	addiw	a2,a2,-1
    8000040c:	01005963          	blez	a6,8000041e <strncpy+0x1e>
    80000410:	0705                	addi	a4,a4,1
    80000412:	0005c783          	lbu	a5,0(a1)
    80000416:	fef70fa3          	sb	a5,-1(a4)
    8000041a:	0585                	addi	a1,a1,1
    8000041c:	f7f5                	bnez	a5,80000408 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000041e:	00c05d63          	blez	a2,80000438 <strncpy+0x38>
    80000422:	86ba                	mv	a3,a4
    *s++ = 0;
    80000424:	0685                	addi	a3,a3,1
    80000426:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000042a:	fff6c793          	not	a5,a3
    8000042e:	9fb9                	addw	a5,a5,a4
    80000430:	010787bb          	addw	a5,a5,a6
    80000434:	fef048e3          	bgtz	a5,80000424 <strncpy+0x24>
  return os;
}
    80000438:	6422                	ld	s0,8(sp)
    8000043a:	0141                	addi	sp,sp,16
    8000043c:	8082                	ret

000000008000043e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000043e:	1141                	addi	sp,sp,-16
    80000440:	e422                	sd	s0,8(sp)
    80000442:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000444:	02c05363          	blez	a2,8000046a <safestrcpy+0x2c>
    80000448:	fff6069b          	addiw	a3,a2,-1
    8000044c:	1682                	slli	a3,a3,0x20
    8000044e:	9281                	srli	a3,a3,0x20
    80000450:	96ae                	add	a3,a3,a1
    80000452:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000454:	00d58963          	beq	a1,a3,80000466 <safestrcpy+0x28>
    80000458:	0585                	addi	a1,a1,1
    8000045a:	0785                	addi	a5,a5,1
    8000045c:	fff5c703          	lbu	a4,-1(a1)
    80000460:	fee78fa3          	sb	a4,-1(a5)
    80000464:	fb65                	bnez	a4,80000454 <safestrcpy+0x16>
    ;
  *s = 0;
    80000466:	00078023          	sb	zero,0(a5)
  return os;
}
    8000046a:	6422                	ld	s0,8(sp)
    8000046c:	0141                	addi	sp,sp,16
    8000046e:	8082                	ret

0000000080000470 <strlen>:

int
strlen(const char *s)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e422                	sd	s0,8(sp)
    80000474:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000476:	00054783          	lbu	a5,0(a0)
    8000047a:	cf91                	beqz	a5,80000496 <strlen+0x26>
    8000047c:	0505                	addi	a0,a0,1
    8000047e:	87aa                	mv	a5,a0
    80000480:	4685                	li	a3,1
    80000482:	9e89                	subw	a3,a3,a0
    80000484:	00f6853b          	addw	a0,a3,a5
    80000488:	0785                	addi	a5,a5,1
    8000048a:	fff7c703          	lbu	a4,-1(a5)
    8000048e:	fb7d                	bnez	a4,80000484 <strlen+0x14>
    ;
  return n;
}
    80000490:	6422                	ld	s0,8(sp)
    80000492:	0141                	addi	sp,sp,16
    80000494:	8082                	ret
  for(n = 0; s[n]; n++)
    80000496:	4501                	li	a0,0
    80000498:	bfe5                	j	80000490 <strlen+0x20>

000000008000049a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000049a:	1141                	addi	sp,sp,-16
    8000049c:	e406                	sd	ra,8(sp)
    8000049e:	e022                	sd	s0,0(sp)
    800004a0:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800004a2:	00001097          	auipc	ra,0x1
    800004a6:	af4080e7          	jalr	-1292(ra) # 80000f96 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800004aa:	00009717          	auipc	a4,0x9
    800004ae:	b5670713          	addi	a4,a4,-1194 # 80009000 <started>
  if(cpuid() == 0){
    800004b2:	c139                	beqz	a0,800004f8 <main+0x5e>
    while(started == 0)
    800004b4:	431c                	lw	a5,0(a4)
    800004b6:	2781                	sext.w	a5,a5
    800004b8:	dff5                	beqz	a5,800004b4 <main+0x1a>
      ;
    __sync_synchronize();
    800004ba:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004be:	00001097          	auipc	ra,0x1
    800004c2:	ad8080e7          	jalr	-1320(ra) # 80000f96 <cpuid>
    800004c6:	85aa                	mv	a1,a0
    800004c8:	00008517          	auipc	a0,0x8
    800004cc:	b7050513          	addi	a0,a0,-1168 # 80008038 <etext+0x38>
    800004d0:	00006097          	auipc	ra,0x6
    800004d4:	8d2080e7          	jalr	-1838(ra) # 80005da2 <printf>
    kvminithart();    // turn on paging
    800004d8:	00000097          	auipc	ra,0x0
    800004dc:	0d8080e7          	jalr	216(ra) # 800005b0 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004e0:	00001097          	auipc	ra,0x1
    800004e4:	72e080e7          	jalr	1838(ra) # 80001c0e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004e8:	00005097          	auipc	ra,0x5
    800004ec:	d48080e7          	jalr	-696(ra) # 80005230 <plicinithart>
  }

  scheduler();        
    800004f0:	00001097          	auipc	ra,0x1
    800004f4:	fdc080e7          	jalr	-36(ra) # 800014cc <scheduler>
    consoleinit();
    800004f8:	00005097          	auipc	ra,0x5
    800004fc:	772080e7          	jalr	1906(ra) # 80005c6a <consoleinit>
    printfinit();
    80000500:	00006097          	auipc	ra,0x6
    80000504:	a88080e7          	jalr	-1400(ra) # 80005f88 <printfinit>
    printf("\n");
    80000508:	00008517          	auipc	a0,0x8
    8000050c:	b4050513          	addi	a0,a0,-1216 # 80008048 <etext+0x48>
    80000510:	00006097          	auipc	ra,0x6
    80000514:	892080e7          	jalr	-1902(ra) # 80005da2 <printf>
    printf("xv6 kernel is booting\n");
    80000518:	00008517          	auipc	a0,0x8
    8000051c:	b0850513          	addi	a0,a0,-1272 # 80008020 <etext+0x20>
    80000520:	00006097          	auipc	ra,0x6
    80000524:	882080e7          	jalr	-1918(ra) # 80005da2 <printf>
    printf("\n");
    80000528:	00008517          	auipc	a0,0x8
    8000052c:	b2050513          	addi	a0,a0,-1248 # 80008048 <etext+0x48>
    80000530:	00006097          	auipc	ra,0x6
    80000534:	872080e7          	jalr	-1934(ra) # 80005da2 <printf>
    kinit();         // physical page allocator
    80000538:	00000097          	auipc	ra,0x0
    8000053c:	cbc080e7          	jalr	-836(ra) # 800001f4 <kinit>
    kvminit();       // create kernel page table
    80000540:	00000097          	auipc	ra,0x0
    80000544:	322080e7          	jalr	802(ra) # 80000862 <kvminit>
    kvminithart();   // turn on paging
    80000548:	00000097          	auipc	ra,0x0
    8000054c:	068080e7          	jalr	104(ra) # 800005b0 <kvminithart>
    procinit();      // process table
    80000550:	00001097          	auipc	ra,0x1
    80000554:	996080e7          	jalr	-1642(ra) # 80000ee6 <procinit>
    trapinit();      // trap vectors
    80000558:	00001097          	auipc	ra,0x1
    8000055c:	68e080e7          	jalr	1678(ra) # 80001be6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000560:	00001097          	auipc	ra,0x1
    80000564:	6ae080e7          	jalr	1710(ra) # 80001c0e <trapinithart>
    plicinit();      // set up interrupt controller
    80000568:	00005097          	auipc	ra,0x5
    8000056c:	cb2080e7          	jalr	-846(ra) # 8000521a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000570:	00005097          	auipc	ra,0x5
    80000574:	cc0080e7          	jalr	-832(ra) # 80005230 <plicinithart>
    binit();         // buffer cache
    80000578:	00002097          	auipc	ra,0x2
    8000057c:	ea0080e7          	jalr	-352(ra) # 80002418 <binit>
    iinit();         // inode table
    80000580:	00002097          	auipc	ra,0x2
    80000584:	530080e7          	jalr	1328(ra) # 80002ab0 <iinit>
    fileinit();      // file table
    80000588:	00003097          	auipc	ra,0x3
    8000058c:	4da080e7          	jalr	1242(ra) # 80003a62 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000590:	00005097          	auipc	ra,0x5
    80000594:	dc2080e7          	jalr	-574(ra) # 80005352 <virtio_disk_init>
    userinit();      // first user process
    80000598:	00001097          	auipc	ra,0x1
    8000059c:	d02080e7          	jalr	-766(ra) # 8000129a <userinit>
    __sync_synchronize();
    800005a0:	0ff0000f          	fence
    started = 1;
    800005a4:	4785                	li	a5,1
    800005a6:	00009717          	auipc	a4,0x9
    800005aa:	a4f72d23          	sw	a5,-1446(a4) # 80009000 <started>
    800005ae:	b789                	j	800004f0 <main+0x56>

00000000800005b0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800005b0:	1141                	addi	sp,sp,-16
    800005b2:	e422                	sd	s0,8(sp)
    800005b4:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800005b6:	00009797          	auipc	a5,0x9
    800005ba:	a527b783          	ld	a5,-1454(a5) # 80009008 <kernel_pagetable>
    800005be:	83b1                	srli	a5,a5,0xc
    800005c0:	577d                	li	a4,-1
    800005c2:	177e                	slli	a4,a4,0x3f
    800005c4:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005c6:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005ca:	12000073          	sfence.vma
  sfence_vma();
}
    800005ce:	6422                	ld	s0,8(sp)
    800005d0:	0141                	addi	sp,sp,16
    800005d2:	8082                	ret

00000000800005d4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005d4:	7139                	addi	sp,sp,-64
    800005d6:	fc06                	sd	ra,56(sp)
    800005d8:	f822                	sd	s0,48(sp)
    800005da:	f426                	sd	s1,40(sp)
    800005dc:	f04a                	sd	s2,32(sp)
    800005de:	ec4e                	sd	s3,24(sp)
    800005e0:	e852                	sd	s4,16(sp)
    800005e2:	e456                	sd	s5,8(sp)
    800005e4:	e05a                	sd	s6,0(sp)
    800005e6:	0080                	addi	s0,sp,64
    800005e8:	84aa                	mv	s1,a0
    800005ea:	89ae                	mv	s3,a1
    800005ec:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005ee:	57fd                	li	a5,-1
    800005f0:	83e9                	srli	a5,a5,0x1a
    800005f2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005f4:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005f6:	04b7f263          	bgeu	a5,a1,8000063a <walk+0x66>
    panic("walk");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a5650513          	addi	a0,a0,-1450 # 80008050 <etext+0x50>
    80000602:	00005097          	auipc	ra,0x5
    80000606:	756080e7          	jalr	1878(ra) # 80005d58 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000060a:	060a8663          	beqz	s5,80000676 <walk+0xa2>
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	c64080e7          	jalr	-924(ra) # 80000272 <kalloc>
    80000616:	84aa                	mv	s1,a0
    80000618:	c529                	beqz	a0,80000662 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000061a:	6605                	lui	a2,0x1
    8000061c:	4581                	li	a1,0
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	cce080e7          	jalr	-818(ra) # 800002ec <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000626:	00c4d793          	srli	a5,s1,0xc
    8000062a:	07aa                	slli	a5,a5,0xa
    8000062c:	0017e793          	ori	a5,a5,1
    80000630:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000634:	3a5d                	addiw	s4,s4,-9
    80000636:	036a0063          	beq	s4,s6,80000656 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000063a:	0149d933          	srl	s2,s3,s4
    8000063e:	1ff97913          	andi	s2,s2,511
    80000642:	090e                	slli	s2,s2,0x3
    80000644:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000646:	00093483          	ld	s1,0(s2)
    8000064a:	0014f793          	andi	a5,s1,1
    8000064e:	dfd5                	beqz	a5,8000060a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000650:	80a9                	srli	s1,s1,0xa
    80000652:	04b2                	slli	s1,s1,0xc
    80000654:	b7c5                	j	80000634 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000656:	00c9d513          	srli	a0,s3,0xc
    8000065a:	1ff57513          	andi	a0,a0,511
    8000065e:	050e                	slli	a0,a0,0x3
    80000660:	9526                	add	a0,a0,s1
}
    80000662:	70e2                	ld	ra,56(sp)
    80000664:	7442                	ld	s0,48(sp)
    80000666:	74a2                	ld	s1,40(sp)
    80000668:	7902                	ld	s2,32(sp)
    8000066a:	69e2                	ld	s3,24(sp)
    8000066c:	6a42                	ld	s4,16(sp)
    8000066e:	6aa2                	ld	s5,8(sp)
    80000670:	6b02                	ld	s6,0(sp)
    80000672:	6121                	addi	sp,sp,64
    80000674:	8082                	ret
        return 0;
    80000676:	4501                	li	a0,0
    80000678:	b7ed                	j	80000662 <walk+0x8e>

000000008000067a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000067a:	57fd                	li	a5,-1
    8000067c:	83e9                	srli	a5,a5,0x1a
    8000067e:	00b7f463          	bgeu	a5,a1,80000686 <walkaddr+0xc>
    return 0;
    80000682:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000684:	8082                	ret
{
    80000686:	1141                	addi	sp,sp,-16
    80000688:	e406                	sd	ra,8(sp)
    8000068a:	e022                	sd	s0,0(sp)
    8000068c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000068e:	4601                	li	a2,0
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f44080e7          	jalr	-188(ra) # 800005d4 <walk>
  if(pte == 0)
    80000698:	c105                	beqz	a0,800006b8 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000069a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000069c:	0117f693          	andi	a3,a5,17
    800006a0:	4745                	li	a4,17
    return 0;
    800006a2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800006a4:	00e68663          	beq	a3,a4,800006b0 <walkaddr+0x36>
}
    800006a8:	60a2                	ld	ra,8(sp)
    800006aa:	6402                	ld	s0,0(sp)
    800006ac:	0141                	addi	sp,sp,16
    800006ae:	8082                	ret
  pa = PTE2PA(*pte);
    800006b0:	00a7d513          	srli	a0,a5,0xa
    800006b4:	0532                	slli	a0,a0,0xc
  return pa;
    800006b6:	bfcd                	j	800006a8 <walkaddr+0x2e>
    return 0;
    800006b8:	4501                	li	a0,0
    800006ba:	b7fd                	j	800006a8 <walkaddr+0x2e>

00000000800006bc <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006bc:	715d                	addi	sp,sp,-80
    800006be:	e486                	sd	ra,72(sp)
    800006c0:	e0a2                	sd	s0,64(sp)
    800006c2:	fc26                	sd	s1,56(sp)
    800006c4:	f84a                	sd	s2,48(sp)
    800006c6:	f44e                	sd	s3,40(sp)
    800006c8:	f052                	sd	s4,32(sp)
    800006ca:	ec56                	sd	s5,24(sp)
    800006cc:	e85a                	sd	s6,16(sp)
    800006ce:	e45e                	sd	s7,8(sp)
    800006d0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800006d2:	c205                	beqz	a2,800006f2 <mappages+0x36>
    800006d4:	8aaa                	mv	s5,a0
    800006d6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800006d8:	77fd                	lui	a5,0xfffff
    800006da:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800006de:	15fd                	addi	a1,a1,-1
    800006e0:	00c589b3          	add	s3,a1,a2
    800006e4:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800006e8:	8952                	mv	s2,s4
    800006ea:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006ee:	6b85                	lui	s7,0x1
    800006f0:	a015                	j	80000714 <mappages+0x58>
    panic("mappages: size");
    800006f2:	00008517          	auipc	a0,0x8
    800006f6:	96650513          	addi	a0,a0,-1690 # 80008058 <etext+0x58>
    800006fa:	00005097          	auipc	ra,0x5
    800006fe:	65e080e7          	jalr	1630(ra) # 80005d58 <panic>
      panic("mappages: remap");
    80000702:	00008517          	auipc	a0,0x8
    80000706:	96650513          	addi	a0,a0,-1690 # 80008068 <etext+0x68>
    8000070a:	00005097          	auipc	ra,0x5
    8000070e:	64e080e7          	jalr	1614(ra) # 80005d58 <panic>
    a += PGSIZE;
    80000712:	995e                	add	s2,s2,s7
  for(;;){
    80000714:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000718:	4605                	li	a2,1
    8000071a:	85ca                	mv	a1,s2
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	eb6080e7          	jalr	-330(ra) # 800005d4 <walk>
    80000726:	cd19                	beqz	a0,80000744 <mappages+0x88>
    if(*pte & PTE_V)
    80000728:	611c                	ld	a5,0(a0)
    8000072a:	8b85                	andi	a5,a5,1
    8000072c:	fbf9                	bnez	a5,80000702 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000072e:	80b1                	srli	s1,s1,0xc
    80000730:	04aa                	slli	s1,s1,0xa
    80000732:	0164e4b3          	or	s1,s1,s6
    80000736:	0014e493          	ori	s1,s1,1
    8000073a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000073c:	fd391be3          	bne	s2,s3,80000712 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000740:	4501                	li	a0,0
    80000742:	a011                	j	80000746 <mappages+0x8a>
      return -1;
    80000744:	557d                	li	a0,-1
}
    80000746:	60a6                	ld	ra,72(sp)
    80000748:	6406                	ld	s0,64(sp)
    8000074a:	74e2                	ld	s1,56(sp)
    8000074c:	7942                	ld	s2,48(sp)
    8000074e:	79a2                	ld	s3,40(sp)
    80000750:	7a02                	ld	s4,32(sp)
    80000752:	6ae2                	ld	s5,24(sp)
    80000754:	6b42                	ld	s6,16(sp)
    80000756:	6ba2                	ld	s7,8(sp)
    80000758:	6161                	addi	sp,sp,80
    8000075a:	8082                	ret

000000008000075c <kvmmap>:
{
    8000075c:	1141                	addi	sp,sp,-16
    8000075e:	e406                	sd	ra,8(sp)
    80000760:	e022                	sd	s0,0(sp)
    80000762:	0800                	addi	s0,sp,16
    80000764:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000766:	86b2                	mv	a3,a2
    80000768:	863e                	mv	a2,a5
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	f52080e7          	jalr	-174(ra) # 800006bc <mappages>
    80000772:	e509                	bnez	a0,8000077c <kvmmap+0x20>
}
    80000774:	60a2                	ld	ra,8(sp)
    80000776:	6402                	ld	s0,0(sp)
    80000778:	0141                	addi	sp,sp,16
    8000077a:	8082                	ret
    panic("kvmmap");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	8fc50513          	addi	a0,a0,-1796 # 80008078 <etext+0x78>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	5d4080e7          	jalr	1492(ra) # 80005d58 <panic>

000000008000078c <kvmmake>:
{
    8000078c:	1101                	addi	sp,sp,-32
    8000078e:	ec06                	sd	ra,24(sp)
    80000790:	e822                	sd	s0,16(sp)
    80000792:	e426                	sd	s1,8(sp)
    80000794:	e04a                	sd	s2,0(sp)
    80000796:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	ada080e7          	jalr	-1318(ra) # 80000272 <kalloc>
    800007a0:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800007a2:	6605                	lui	a2,0x1
    800007a4:	4581                	li	a1,0
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	b46080e7          	jalr	-1210(ra) # 800002ec <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007ae:	4719                	li	a4,6
    800007b0:	6685                	lui	a3,0x1
    800007b2:	10000637          	lui	a2,0x10000
    800007b6:	100005b7          	lui	a1,0x10000
    800007ba:	8526                	mv	a0,s1
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	fa0080e7          	jalr	-96(ra) # 8000075c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007c4:	4719                	li	a4,6
    800007c6:	6685                	lui	a3,0x1
    800007c8:	10001637          	lui	a2,0x10001
    800007cc:	100015b7          	lui	a1,0x10001
    800007d0:	8526                	mv	a0,s1
    800007d2:	00000097          	auipc	ra,0x0
    800007d6:	f8a080e7          	jalr	-118(ra) # 8000075c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007da:	4719                	li	a4,6
    800007dc:	004006b7          	lui	a3,0x400
    800007e0:	0c000637          	lui	a2,0xc000
    800007e4:	0c0005b7          	lui	a1,0xc000
    800007e8:	8526                	mv	a0,s1
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f72080e7          	jalr	-142(ra) # 8000075c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007f2:	00008917          	auipc	s2,0x8
    800007f6:	80e90913          	addi	s2,s2,-2034 # 80008000 <etext>
    800007fa:	4729                	li	a4,10
    800007fc:	80008697          	auipc	a3,0x80008
    80000800:	80468693          	addi	a3,a3,-2044 # 8000 <_entry-0x7fff8000>
    80000804:	4605                	li	a2,1
    80000806:	067e                	slli	a2,a2,0x1f
    80000808:	85b2                	mv	a1,a2
    8000080a:	8526                	mv	a0,s1
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	f50080e7          	jalr	-176(ra) # 8000075c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000814:	4719                	li	a4,6
    80000816:	46c5                	li	a3,17
    80000818:	06ee                	slli	a3,a3,0x1b
    8000081a:	412686b3          	sub	a3,a3,s2
    8000081e:	864a                	mv	a2,s2
    80000820:	85ca                	mv	a1,s2
    80000822:	8526                	mv	a0,s1
    80000824:	00000097          	auipc	ra,0x0
    80000828:	f38080e7          	jalr	-200(ra) # 8000075c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000082c:	4729                	li	a4,10
    8000082e:	6685                	lui	a3,0x1
    80000830:	00006617          	auipc	a2,0x6
    80000834:	7d060613          	addi	a2,a2,2000 # 80007000 <_trampoline>
    80000838:	040005b7          	lui	a1,0x4000
    8000083c:	15fd                	addi	a1,a1,-1
    8000083e:	05b2                	slli	a1,a1,0xc
    80000840:	8526                	mv	a0,s1
    80000842:	00000097          	auipc	ra,0x0
    80000846:	f1a080e7          	jalr	-230(ra) # 8000075c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000084a:	8526                	mv	a0,s1
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	604080e7          	jalr	1540(ra) # 80000e50 <proc_mapstacks>
}
    80000854:	8526                	mv	a0,s1
    80000856:	60e2                	ld	ra,24(sp)
    80000858:	6442                	ld	s0,16(sp)
    8000085a:	64a2                	ld	s1,8(sp)
    8000085c:	6902                	ld	s2,0(sp)
    8000085e:	6105                	addi	sp,sp,32
    80000860:	8082                	ret

0000000080000862 <kvminit>:
{
    80000862:	1141                	addi	sp,sp,-16
    80000864:	e406                	sd	ra,8(sp)
    80000866:	e022                	sd	s0,0(sp)
    80000868:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000086a:	00000097          	auipc	ra,0x0
    8000086e:	f22080e7          	jalr	-222(ra) # 8000078c <kvmmake>
    80000872:	00008797          	auipc	a5,0x8
    80000876:	78a7bb23          	sd	a0,1942(a5) # 80009008 <kernel_pagetable>
}
    8000087a:	60a2                	ld	ra,8(sp)
    8000087c:	6402                	ld	s0,0(sp)
    8000087e:	0141                	addi	sp,sp,16
    80000880:	8082                	ret

0000000080000882 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000882:	715d                	addi	sp,sp,-80
    80000884:	e486                	sd	ra,72(sp)
    80000886:	e0a2                	sd	s0,64(sp)
    80000888:	fc26                	sd	s1,56(sp)
    8000088a:	f84a                	sd	s2,48(sp)
    8000088c:	f44e                	sd	s3,40(sp)
    8000088e:	f052                	sd	s4,32(sp)
    80000890:	ec56                	sd	s5,24(sp)
    80000892:	e85a                	sd	s6,16(sp)
    80000894:	e45e                	sd	s7,8(sp)
    80000896:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000898:	03459793          	slli	a5,a1,0x34
    8000089c:	e795                	bnez	a5,800008c8 <uvmunmap+0x46>
    8000089e:	8a2a                	mv	s4,a0
    800008a0:	892e                	mv	s2,a1
    800008a2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a4:	0632                	slli	a2,a2,0xc
    800008a6:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008aa:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008ac:	6b05                	lui	s6,0x1
    800008ae:	0735e863          	bltu	a1,s3,8000091e <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008b2:	60a6                	ld	ra,72(sp)
    800008b4:	6406                	ld	s0,64(sp)
    800008b6:	74e2                	ld	s1,56(sp)
    800008b8:	7942                	ld	s2,48(sp)
    800008ba:	79a2                	ld	s3,40(sp)
    800008bc:	7a02                	ld	s4,32(sp)
    800008be:	6ae2                	ld	s5,24(sp)
    800008c0:	6b42                	ld	s6,16(sp)
    800008c2:	6ba2                	ld	s7,8(sp)
    800008c4:	6161                	addi	sp,sp,80
    800008c6:	8082                	ret
    panic("uvmunmap: not aligned");
    800008c8:	00007517          	auipc	a0,0x7
    800008cc:	7b850513          	addi	a0,a0,1976 # 80008080 <etext+0x80>
    800008d0:	00005097          	auipc	ra,0x5
    800008d4:	488080e7          	jalr	1160(ra) # 80005d58 <panic>
      panic("uvmunmap: walk");
    800008d8:	00007517          	auipc	a0,0x7
    800008dc:	7c050513          	addi	a0,a0,1984 # 80008098 <etext+0x98>
    800008e0:	00005097          	auipc	ra,0x5
    800008e4:	478080e7          	jalr	1144(ra) # 80005d58 <panic>
      panic("uvmunmap: not mapped");
    800008e8:	00007517          	auipc	a0,0x7
    800008ec:	7c050513          	addi	a0,a0,1984 # 800080a8 <etext+0xa8>
    800008f0:	00005097          	auipc	ra,0x5
    800008f4:	468080e7          	jalr	1128(ra) # 80005d58 <panic>
      panic("uvmunmap: not a leaf");
    800008f8:	00007517          	auipc	a0,0x7
    800008fc:	7c850513          	addi	a0,a0,1992 # 800080c0 <etext+0xc0>
    80000900:	00005097          	auipc	ra,0x5
    80000904:	458080e7          	jalr	1112(ra) # 80005d58 <panic>
      uint64 pa = PTE2PA(*pte);
    80000908:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000090a:	0532                	slli	a0,a0,0xc
    8000090c:	fffff097          	auipc	ra,0xfffff
    80000910:	7ee080e7          	jalr	2030(ra) # 800000fa <kfree>
    *pte = 0;
    80000914:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000918:	995a                	add	s2,s2,s6
    8000091a:	f9397ce3          	bgeu	s2,s3,800008b2 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000091e:	4601                	li	a2,0
    80000920:	85ca                	mv	a1,s2
    80000922:	8552                	mv	a0,s4
    80000924:	00000097          	auipc	ra,0x0
    80000928:	cb0080e7          	jalr	-848(ra) # 800005d4 <walk>
    8000092c:	84aa                	mv	s1,a0
    8000092e:	d54d                	beqz	a0,800008d8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000930:	6108                	ld	a0,0(a0)
    80000932:	00157793          	andi	a5,a0,1
    80000936:	dbcd                	beqz	a5,800008e8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000938:	3ff57793          	andi	a5,a0,1023
    8000093c:	fb778ee3          	beq	a5,s7,800008f8 <uvmunmap+0x76>
    if(do_free){
    80000940:	fc0a8ae3          	beqz	s5,80000914 <uvmunmap+0x92>
    80000944:	b7d1                	j	80000908 <uvmunmap+0x86>

0000000080000946 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000946:	1101                	addi	sp,sp,-32
    80000948:	ec06                	sd	ra,24(sp)
    8000094a:	e822                	sd	s0,16(sp)
    8000094c:	e426                	sd	s1,8(sp)
    8000094e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000950:	00000097          	auipc	ra,0x0
    80000954:	922080e7          	jalr	-1758(ra) # 80000272 <kalloc>
    80000958:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000095a:	c519                	beqz	a0,80000968 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000095c:	6605                	lui	a2,0x1
    8000095e:	4581                	li	a1,0
    80000960:	00000097          	auipc	ra,0x0
    80000964:	98c080e7          	jalr	-1652(ra) # 800002ec <memset>
  return pagetable;
}
    80000968:	8526                	mv	a0,s1
    8000096a:	60e2                	ld	ra,24(sp)
    8000096c:	6442                	ld	s0,16(sp)
    8000096e:	64a2                	ld	s1,8(sp)
    80000970:	6105                	addi	sp,sp,32
    80000972:	8082                	ret

0000000080000974 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000974:	7179                	addi	sp,sp,-48
    80000976:	f406                	sd	ra,40(sp)
    80000978:	f022                	sd	s0,32(sp)
    8000097a:	ec26                	sd	s1,24(sp)
    8000097c:	e84a                	sd	s2,16(sp)
    8000097e:	e44e                	sd	s3,8(sp)
    80000980:	e052                	sd	s4,0(sp)
    80000982:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000984:	6785                	lui	a5,0x1
    80000986:	04f67863          	bgeu	a2,a5,800009d6 <uvminit+0x62>
    8000098a:	8a2a                	mv	s4,a0
    8000098c:	89ae                	mv	s3,a1
    8000098e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000990:	00000097          	auipc	ra,0x0
    80000994:	8e2080e7          	jalr	-1822(ra) # 80000272 <kalloc>
    80000998:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000099a:	6605                	lui	a2,0x1
    8000099c:	4581                	li	a1,0
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	94e080e7          	jalr	-1714(ra) # 800002ec <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009a6:	4779                	li	a4,30
    800009a8:	86ca                	mv	a3,s2
    800009aa:	6605                	lui	a2,0x1
    800009ac:	4581                	li	a1,0
    800009ae:	8552                	mv	a0,s4
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	d0c080e7          	jalr	-756(ra) # 800006bc <mappages>
  memmove(mem, src, sz);
    800009b8:	8626                	mv	a2,s1
    800009ba:	85ce                	mv	a1,s3
    800009bc:	854a                	mv	a0,s2
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	98e080e7          	jalr	-1650(ra) # 8000034c <memmove>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret
    panic("inituvm: more than a page");
    800009d6:	00007517          	auipc	a0,0x7
    800009da:	70250513          	addi	a0,a0,1794 # 800080d8 <etext+0xd8>
    800009de:	00005097          	auipc	ra,0x5
    800009e2:	37a080e7          	jalr	890(ra) # 80005d58 <panic>

00000000800009e6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009e6:	1101                	addi	sp,sp,-32
    800009e8:	ec06                	sd	ra,24(sp)
    800009ea:	e822                	sd	s0,16(sp)
    800009ec:	e426                	sd	s1,8(sp)
    800009ee:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009f0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009f2:	00b67d63          	bgeu	a2,a1,80000a0c <uvmdealloc+0x26>
    800009f6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1
    800009fc:	00f60733          	add	a4,a2,a5
    80000a00:	767d                	lui	a2,0xfffff
    80000a02:	8f71                	and	a4,a4,a2
    80000a04:	97ae                	add	a5,a5,a1
    80000a06:	8ff1                	and	a5,a5,a2
    80000a08:	00f76863          	bltu	a4,a5,80000a18 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	60e2                	ld	ra,24(sp)
    80000a10:	6442                	ld	s0,16(sp)
    80000a12:	64a2                	ld	s1,8(sp)
    80000a14:	6105                	addi	sp,sp,32
    80000a16:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a18:	8f99                	sub	a5,a5,a4
    80000a1a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a1c:	4685                	li	a3,1
    80000a1e:	0007861b          	sext.w	a2,a5
    80000a22:	85ba                	mv	a1,a4
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	e5e080e7          	jalr	-418(ra) # 80000882 <uvmunmap>
    80000a2c:	b7c5                	j	80000a0c <uvmdealloc+0x26>

0000000080000a2e <uvmalloc>:
  if(newsz < oldsz)
    80000a2e:	0ab66163          	bltu	a2,a1,80000ad0 <uvmalloc+0xa2>
{
    80000a32:	7139                	addi	sp,sp,-64
    80000a34:	fc06                	sd	ra,56(sp)
    80000a36:	f822                	sd	s0,48(sp)
    80000a38:	f426                	sd	s1,40(sp)
    80000a3a:	f04a                	sd	s2,32(sp)
    80000a3c:	ec4e                	sd	s3,24(sp)
    80000a3e:	e852                	sd	s4,16(sp)
    80000a40:	e456                	sd	s5,8(sp)
    80000a42:	0080                	addi	s0,sp,64
    80000a44:	8aaa                	mv	s5,a0
    80000a46:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a48:	6985                	lui	s3,0x1
    80000a4a:	19fd                	addi	s3,s3,-1
    80000a4c:	95ce                	add	a1,a1,s3
    80000a4e:	79fd                	lui	s3,0xfffff
    80000a50:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a54:	08c9f063          	bgeu	s3,a2,80000ad4 <uvmalloc+0xa6>
    80000a58:	894e                	mv	s2,s3
    mem = kalloc();
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	818080e7          	jalr	-2024(ra) # 80000272 <kalloc>
    80000a62:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a64:	c51d                	beqz	a0,80000a92 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a66:	6605                	lui	a2,0x1
    80000a68:	4581                	li	a1,0
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	882080e7          	jalr	-1918(ra) # 800002ec <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a72:	4779                	li	a4,30
    80000a74:	86a6                	mv	a3,s1
    80000a76:	6605                	lui	a2,0x1
    80000a78:	85ca                	mv	a1,s2
    80000a7a:	8556                	mv	a0,s5
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	c40080e7          	jalr	-960(ra) # 800006bc <mappages>
    80000a84:	e905                	bnez	a0,80000ab4 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a86:	6785                	lui	a5,0x1
    80000a88:	993e                	add	s2,s2,a5
    80000a8a:	fd4968e3          	bltu	s2,s4,80000a5a <uvmalloc+0x2c>
  return newsz;
    80000a8e:	8552                	mv	a0,s4
    80000a90:	a809                	j	80000aa2 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a92:	864e                	mv	a2,s3
    80000a94:	85ca                	mv	a1,s2
    80000a96:	8556                	mv	a0,s5
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	f4e080e7          	jalr	-178(ra) # 800009e6 <uvmdealloc>
      return 0;
    80000aa0:	4501                	li	a0,0
}
    80000aa2:	70e2                	ld	ra,56(sp)
    80000aa4:	7442                	ld	s0,48(sp)
    80000aa6:	74a2                	ld	s1,40(sp)
    80000aa8:	7902                	ld	s2,32(sp)
    80000aaa:	69e2                	ld	s3,24(sp)
    80000aac:	6a42                	ld	s4,16(sp)
    80000aae:	6aa2                	ld	s5,8(sp)
    80000ab0:	6121                	addi	sp,sp,64
    80000ab2:	8082                	ret
      kfree(mem);
    80000ab4:	8526                	mv	a0,s1
    80000ab6:	fffff097          	auipc	ra,0xfffff
    80000aba:	644080e7          	jalr	1604(ra) # 800000fa <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000abe:	864e                	mv	a2,s3
    80000ac0:	85ca                	mv	a1,s2
    80000ac2:	8556                	mv	a0,s5
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	f22080e7          	jalr	-222(ra) # 800009e6 <uvmdealloc>
      return 0;
    80000acc:	4501                	li	a0,0
    80000ace:	bfd1                	j	80000aa2 <uvmalloc+0x74>
    return oldsz;
    80000ad0:	852e                	mv	a0,a1
}
    80000ad2:	8082                	ret
  return newsz;
    80000ad4:	8532                	mv	a0,a2
    80000ad6:	b7f1                	j	80000aa2 <uvmalloc+0x74>

0000000080000ad8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000ad8:	7179                	addi	sp,sp,-48
    80000ada:	f406                	sd	ra,40(sp)
    80000adc:	f022                	sd	s0,32(sp)
    80000ade:	ec26                	sd	s1,24(sp)
    80000ae0:	e84a                	sd	s2,16(sp)
    80000ae2:	e44e                	sd	s3,8(sp)
    80000ae4:	e052                	sd	s4,0(sp)
    80000ae6:	1800                	addi	s0,sp,48
    80000ae8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000aea:	84aa                	mv	s1,a0
    80000aec:	6905                	lui	s2,0x1
    80000aee:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000af0:	4985                	li	s3,1
    80000af2:	a821                	j	80000b0a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000af4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000af6:	0532                	slli	a0,a0,0xc
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	fe0080e7          	jalr	-32(ra) # 80000ad8 <freewalk>
      pagetable[i] = 0;
    80000b00:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b04:	04a1                	addi	s1,s1,8
    80000b06:	03248163          	beq	s1,s2,80000b28 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b0a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b0c:	00f57793          	andi	a5,a0,15
    80000b10:	ff3782e3          	beq	a5,s3,80000af4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b14:	8905                	andi	a0,a0,1
    80000b16:	d57d                	beqz	a0,80000b04 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000b18:	00007517          	auipc	a0,0x7
    80000b1c:	5e050513          	addi	a0,a0,1504 # 800080f8 <etext+0xf8>
    80000b20:	00005097          	auipc	ra,0x5
    80000b24:	238080e7          	jalr	568(ra) # 80005d58 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b28:	8552                	mv	a0,s4
    80000b2a:	fffff097          	auipc	ra,0xfffff
    80000b2e:	5d0080e7          	jalr	1488(ra) # 800000fa <kfree>
}
    80000b32:	70a2                	ld	ra,40(sp)
    80000b34:	7402                	ld	s0,32(sp)
    80000b36:	64e2                	ld	s1,24(sp)
    80000b38:	6942                	ld	s2,16(sp)
    80000b3a:	69a2                	ld	s3,8(sp)
    80000b3c:	6a02                	ld	s4,0(sp)
    80000b3e:	6145                	addi	sp,sp,48
    80000b40:	8082                	ret

0000000080000b42 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b42:	1101                	addi	sp,sp,-32
    80000b44:	ec06                	sd	ra,24(sp)
    80000b46:	e822                	sd	s0,16(sp)
    80000b48:	e426                	sd	s1,8(sp)
    80000b4a:	1000                	addi	s0,sp,32
    80000b4c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b4e:	e999                	bnez	a1,80000b64 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b50:	8526                	mv	a0,s1
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	f86080e7          	jalr	-122(ra) # 80000ad8 <freewalk>
}
    80000b5a:	60e2                	ld	ra,24(sp)
    80000b5c:	6442                	ld	s0,16(sp)
    80000b5e:	64a2                	ld	s1,8(sp)
    80000b60:	6105                	addi	sp,sp,32
    80000b62:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b64:	6605                	lui	a2,0x1
    80000b66:	167d                	addi	a2,a2,-1
    80000b68:	962e                	add	a2,a2,a1
    80000b6a:	4685                	li	a3,1
    80000b6c:	8231                	srli	a2,a2,0xc
    80000b6e:	4581                	li	a1,0
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	d12080e7          	jalr	-750(ra) # 80000882 <uvmunmap>
    80000b78:	bfe1                	j	80000b50 <uvmfree+0xe>

0000000080000b7a <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b7a:	7139                	addi	sp,sp,-64
    80000b7c:	fc06                	sd	ra,56(sp)
    80000b7e:	f822                	sd	s0,48(sp)
    80000b80:	f426                	sd	s1,40(sp)
    80000b82:	f04a                	sd	s2,32(sp)
    80000b84:	ec4e                	sd	s3,24(sp)
    80000b86:	e852                	sd	s4,16(sp)
    80000b88:	e456                	sd	s5,8(sp)
    80000b8a:	e05a                	sd	s6,0(sp)
    80000b8c:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000b8e:	c655                	beqz	a2,80000c3a <uvmcopy+0xc0>
    80000b90:	8b2a                	mv	s6,a0
    80000b92:	8aae                	mv	s5,a1
    80000b94:	8a32                	mv	s4,a2
    80000b96:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b98:	4601                	li	a2,0
    80000b9a:	85a6                	mv	a1,s1
    80000b9c:	855a                	mv	a0,s6
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	a36080e7          	jalr	-1482(ra) # 800005d4 <walk>
    80000ba6:	c529                	beqz	a0,80000bf0 <uvmcopy+0x76>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000ba8:	6118                	ld	a4,0(a0)
    80000baa:	00177793          	andi	a5,a4,1
    80000bae:	cba9                	beqz	a5,80000c00 <uvmcopy+0x86>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000bb0:	00a75913          	srli	s2,a4,0xa
    80000bb4:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);

    // Mark the parent page table entry read-only and cow page
    *pte = (*pte | PTE_RSW) & ~PTE_W;
    80000bb6:	efb77793          	andi	a5,a4,-261
    80000bba:	1007e793          	ori	a5,a5,256
    80000bbe:	e11c                	sd	a5,0(a0)
    
    // Mark the child page table read only
    flags &= (~PTE_W);

    // Map child's page with page unwritable
    if(mappages(new, i, PGSIZE, pa, (flags & (~PTE_W)) | PTE_RSW) != 0){
    80000bc0:	2fb77713          	andi	a4,a4,763
    80000bc4:	10076713          	ori	a4,a4,256
    80000bc8:	86ca                	mv	a3,s2
    80000bca:	6605                	lui	a2,0x1
    80000bcc:	85a6                	mv	a1,s1
    80000bce:	8556                	mv	a0,s5
    80000bd0:	00000097          	auipc	ra,0x0
    80000bd4:	aec080e7          	jalr	-1300(ra) # 800006bc <mappages>
    80000bd8:	89aa                	mv	s3,a0
    80000bda:	e91d                	bnez	a0,80000c10 <uvmcopy+0x96>
      goto err;
    }
    // Increase reference count
    inc_ref((void*)pa); 
    80000bdc:	854a                	mv	a0,s2
    80000bde:	fffff097          	auipc	ra,0xfffff
    80000be2:	478080e7          	jalr	1144(ra) # 80000056 <inc_ref>
  for(i = 0; i < sz; i += PGSIZE){
    80000be6:	6785                	lui	a5,0x1
    80000be8:	94be                	add	s1,s1,a5
    80000bea:	fb44e7e3          	bltu	s1,s4,80000b98 <uvmcopy+0x1e>
    80000bee:	a81d                	j	80000c24 <uvmcopy+0xaa>
      panic("uvmcopy: pte should exist");
    80000bf0:	00007517          	auipc	a0,0x7
    80000bf4:	51850513          	addi	a0,a0,1304 # 80008108 <etext+0x108>
    80000bf8:	00005097          	auipc	ra,0x5
    80000bfc:	160080e7          	jalr	352(ra) # 80005d58 <panic>
      panic("uvmcopy: page not present");
    80000c00:	00007517          	auipc	a0,0x7
    80000c04:	52850513          	addi	a0,a0,1320 # 80008128 <etext+0x128>
    80000c08:	00005097          	auipc	ra,0x5
    80000c0c:	150080e7          	jalr	336(ra) # 80005d58 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c10:	4685                	li	a3,1
    80000c12:	00c4d613          	srli	a2,s1,0xc
    80000c16:	4581                	li	a1,0
    80000c18:	8556                	mv	a0,s5
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	c68080e7          	jalr	-920(ra) # 80000882 <uvmunmap>
  return -1;
    80000c22:	59fd                	li	s3,-1
}
    80000c24:	854e                	mv	a0,s3
    80000c26:	70e2                	ld	ra,56(sp)
    80000c28:	7442                	ld	s0,48(sp)
    80000c2a:	74a2                	ld	s1,40(sp)
    80000c2c:	7902                	ld	s2,32(sp)
    80000c2e:	69e2                	ld	s3,24(sp)
    80000c30:	6a42                	ld	s4,16(sp)
    80000c32:	6aa2                	ld	s5,8(sp)
    80000c34:	6b02                	ld	s6,0(sp)
    80000c36:	6121                	addi	sp,sp,64
    80000c38:	8082                	ret
  return 0;
    80000c3a:	4981                	li	s3,0
    80000c3c:	b7e5                	j	80000c24 <uvmcopy+0xaa>

0000000080000c3e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c3e:	1141                	addi	sp,sp,-16
    80000c40:	e406                	sd	ra,8(sp)
    80000c42:	e022                	sd	s0,0(sp)
    80000c44:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c46:	4601                	li	a2,0
    80000c48:	00000097          	auipc	ra,0x0
    80000c4c:	98c080e7          	jalr	-1652(ra) # 800005d4 <walk>
  if(pte == 0)
    80000c50:	c901                	beqz	a0,80000c60 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c52:	611c                	ld	a5,0(a0)
    80000c54:	9bbd                	andi	a5,a5,-17
    80000c56:	e11c                	sd	a5,0(a0)
}
    80000c58:	60a2                	ld	ra,8(sp)
    80000c5a:	6402                	ld	s0,0(sp)
    80000c5c:	0141                	addi	sp,sp,16
    80000c5e:	8082                	ret
    panic("uvmclear");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	4e850513          	addi	a0,a0,1256 # 80008148 <etext+0x148>
    80000c68:	00005097          	auipc	ra,0x5
    80000c6c:	0f0080e7          	jalr	240(ra) # 80005d58 <panic>

0000000080000c70 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c70:	cebd                	beqz	a3,80000cee <copyout+0x7e>
{
    80000c72:	715d                	addi	sp,sp,-80
    80000c74:	e486                	sd	ra,72(sp)
    80000c76:	e0a2                	sd	s0,64(sp)
    80000c78:	fc26                	sd	s1,56(sp)
    80000c7a:	f84a                	sd	s2,48(sp)
    80000c7c:	f44e                	sd	s3,40(sp)
    80000c7e:	f052                	sd	s4,32(sp)
    80000c80:	ec56                	sd	s5,24(sp)
    80000c82:	e85a                	sd	s6,16(sp)
    80000c84:	e45e                	sd	s7,8(sp)
    80000c86:	e062                	sd	s8,0(sp)
    80000c88:	0880                	addi	s0,sp,80
    80000c8a:	8b2a                	mv	s6,a0
    80000c8c:	892e                	mv	s2,a1
    80000c8e:	8ab2                	mv	s5,a2
    80000c90:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva); 
    80000c92:	7c7d                	lui	s8,0xfffff
    if (cowhandler(pagetable, va0) < 0)
      return -1;
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c94:	6b85                	lui	s7,0x1
    80000c96:	a015                	j	80000cba <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c98:	41390933          	sub	s2,s2,s3
    80000c9c:	0004861b          	sext.w	a2,s1
    80000ca0:	85d6                	mv	a1,s5
    80000ca2:	954a                	add	a0,a0,s2
    80000ca4:	fffff097          	auipc	ra,0xfffff
    80000ca8:	6a8080e7          	jalr	1704(ra) # 8000034c <memmove>

    len -= n;
    80000cac:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000cb0:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000cb2:	01798933          	add	s2,s3,s7
  while(len > 0){
    80000cb6:	020a0a63          	beqz	s4,80000cea <copyout+0x7a>
    va0 = PGROUNDDOWN(dstva); 
    80000cba:	018979b3          	and	s3,s2,s8
    if (cowhandler(pagetable, va0) < 0)
    80000cbe:	85ce                	mv	a1,s3
    80000cc0:	855a                	mv	a0,s6
    80000cc2:	00001097          	auipc	ra,0x1
    80000cc6:	1b6080e7          	jalr	438(ra) # 80001e78 <cowhandler>
    80000cca:	02054463          	bltz	a0,80000cf2 <copyout+0x82>
    pa0 = walkaddr(pagetable, va0);
    80000cce:	85ce                	mv	a1,s3
    80000cd0:	855a                	mv	a0,s6
    80000cd2:	00000097          	auipc	ra,0x0
    80000cd6:	9a8080e7          	jalr	-1624(ra) # 8000067a <walkaddr>
    if(pa0 == 0)
    80000cda:	c90d                	beqz	a0,80000d0c <copyout+0x9c>
    n = PGSIZE - (dstva - va0);
    80000cdc:	412984b3          	sub	s1,s3,s2
    80000ce0:	94de                	add	s1,s1,s7
    if(n > len)
    80000ce2:	fa9a7be3          	bgeu	s4,s1,80000c98 <copyout+0x28>
    80000ce6:	84d2                	mv	s1,s4
    80000ce8:	bf45                	j	80000c98 <copyout+0x28>
  }
  return 0;
    80000cea:	4501                	li	a0,0
    80000cec:	a021                	j	80000cf4 <copyout+0x84>
    80000cee:	4501                	li	a0,0
}
    80000cf0:	8082                	ret
      return -1;
    80000cf2:	557d                	li	a0,-1
}
    80000cf4:	60a6                	ld	ra,72(sp)
    80000cf6:	6406                	ld	s0,64(sp)
    80000cf8:	74e2                	ld	s1,56(sp)
    80000cfa:	7942                	ld	s2,48(sp)
    80000cfc:	79a2                	ld	s3,40(sp)
    80000cfe:	7a02                	ld	s4,32(sp)
    80000d00:	6ae2                	ld	s5,24(sp)
    80000d02:	6b42                	ld	s6,16(sp)
    80000d04:	6ba2                	ld	s7,8(sp)
    80000d06:	6c02                	ld	s8,0(sp)
    80000d08:	6161                	addi	sp,sp,80
    80000d0a:	8082                	ret
      return -1;
    80000d0c:	557d                	li	a0,-1
    80000d0e:	b7dd                	j	80000cf4 <copyout+0x84>

0000000080000d10 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d10:	c6bd                	beqz	a3,80000d7e <copyin+0x6e>
{
    80000d12:	715d                	addi	sp,sp,-80
    80000d14:	e486                	sd	ra,72(sp)
    80000d16:	e0a2                	sd	s0,64(sp)
    80000d18:	fc26                	sd	s1,56(sp)
    80000d1a:	f84a                	sd	s2,48(sp)
    80000d1c:	f44e                	sd	s3,40(sp)
    80000d1e:	f052                	sd	s4,32(sp)
    80000d20:	ec56                	sd	s5,24(sp)
    80000d22:	e85a                	sd	s6,16(sp)
    80000d24:	e45e                	sd	s7,8(sp)
    80000d26:	e062                	sd	s8,0(sp)
    80000d28:	0880                	addi	s0,sp,80
    80000d2a:	8b2a                	mv	s6,a0
    80000d2c:	8a2e                	mv	s4,a1
    80000d2e:	8c32                	mv	s8,a2
    80000d30:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d32:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d34:	6a85                	lui	s5,0x1
    80000d36:	a015                	j	80000d5a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d38:	9562                	add	a0,a0,s8
    80000d3a:	0004861b          	sext.w	a2,s1
    80000d3e:	412505b3          	sub	a1,a0,s2
    80000d42:	8552                	mv	a0,s4
    80000d44:	fffff097          	auipc	ra,0xfffff
    80000d48:	608080e7          	jalr	1544(ra) # 8000034c <memmove>

    len -= n;
    80000d4c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d50:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d52:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d56:	02098263          	beqz	s3,80000d7a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d5a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d5e:	85ca                	mv	a1,s2
    80000d60:	855a                	mv	a0,s6
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	918080e7          	jalr	-1768(ra) # 8000067a <walkaddr>
    if(pa0 == 0)
    80000d6a:	cd01                	beqz	a0,80000d82 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d6c:	418904b3          	sub	s1,s2,s8
    80000d70:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d72:	fc99f3e3          	bgeu	s3,s1,80000d38 <copyin+0x28>
    80000d76:	84ce                	mv	s1,s3
    80000d78:	b7c1                	j	80000d38 <copyin+0x28>
  }
  return 0;
    80000d7a:	4501                	li	a0,0
    80000d7c:	a021                	j	80000d84 <copyin+0x74>
    80000d7e:	4501                	li	a0,0
}
    80000d80:	8082                	ret
      return -1;
    80000d82:	557d                	li	a0,-1
}
    80000d84:	60a6                	ld	ra,72(sp)
    80000d86:	6406                	ld	s0,64(sp)
    80000d88:	74e2                	ld	s1,56(sp)
    80000d8a:	7942                	ld	s2,48(sp)
    80000d8c:	79a2                	ld	s3,40(sp)
    80000d8e:	7a02                	ld	s4,32(sp)
    80000d90:	6ae2                	ld	s5,24(sp)
    80000d92:	6b42                	ld	s6,16(sp)
    80000d94:	6ba2                	ld	s7,8(sp)
    80000d96:	6c02                	ld	s8,0(sp)
    80000d98:	6161                	addi	sp,sp,80
    80000d9a:	8082                	ret

0000000080000d9c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d9c:	c6c5                	beqz	a3,80000e44 <copyinstr+0xa8>
{
    80000d9e:	715d                	addi	sp,sp,-80
    80000da0:	e486                	sd	ra,72(sp)
    80000da2:	e0a2                	sd	s0,64(sp)
    80000da4:	fc26                	sd	s1,56(sp)
    80000da6:	f84a                	sd	s2,48(sp)
    80000da8:	f44e                	sd	s3,40(sp)
    80000daa:	f052                	sd	s4,32(sp)
    80000dac:	ec56                	sd	s5,24(sp)
    80000dae:	e85a                	sd	s6,16(sp)
    80000db0:	e45e                	sd	s7,8(sp)
    80000db2:	0880                	addi	s0,sp,80
    80000db4:	8a2a                	mv	s4,a0
    80000db6:	8b2e                	mv	s6,a1
    80000db8:	8bb2                	mv	s7,a2
    80000dba:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dbc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dbe:	6985                	lui	s3,0x1
    80000dc0:	a035                	j	80000dec <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dc2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000dc6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000dc8:	0017b793          	seqz	a5,a5
    80000dcc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000dd0:	60a6                	ld	ra,72(sp)
    80000dd2:	6406                	ld	s0,64(sp)
    80000dd4:	74e2                	ld	s1,56(sp)
    80000dd6:	7942                	ld	s2,48(sp)
    80000dd8:	79a2                	ld	s3,40(sp)
    80000dda:	7a02                	ld	s4,32(sp)
    80000ddc:	6ae2                	ld	s5,24(sp)
    80000dde:	6b42                	ld	s6,16(sp)
    80000de0:	6ba2                	ld	s7,8(sp)
    80000de2:	6161                	addi	sp,sp,80
    80000de4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000de6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dea:	c8a9                	beqz	s1,80000e3c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dec:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000df0:	85ca                	mv	a1,s2
    80000df2:	8552                	mv	a0,s4
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	886080e7          	jalr	-1914(ra) # 8000067a <walkaddr>
    if(pa0 == 0)
    80000dfc:	c131                	beqz	a0,80000e40 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000dfe:	41790833          	sub	a6,s2,s7
    80000e02:	984e                	add	a6,a6,s3
    if(n > max)
    80000e04:	0104f363          	bgeu	s1,a6,80000e0a <copyinstr+0x6e>
    80000e08:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e0a:	955e                	add	a0,a0,s7
    80000e0c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e10:	fc080be3          	beqz	a6,80000de6 <copyinstr+0x4a>
    80000e14:	985a                	add	a6,a6,s6
    80000e16:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e18:	41650633          	sub	a2,a0,s6
    80000e1c:	14fd                	addi	s1,s1,-1
    80000e1e:	9b26                	add	s6,s6,s1
    80000e20:	00f60733          	add	a4,a2,a5
    80000e24:	00074703          	lbu	a4,0(a4)
    80000e28:	df49                	beqz	a4,80000dc2 <copyinstr+0x26>
        *dst = *p;
    80000e2a:	00e78023          	sb	a4,0(a5)
      --max;
    80000e2e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e32:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e34:	ff0796e3          	bne	a5,a6,80000e20 <copyinstr+0x84>
      dst++;
    80000e38:	8b42                	mv	s6,a6
    80000e3a:	b775                	j	80000de6 <copyinstr+0x4a>
    80000e3c:	4781                	li	a5,0
    80000e3e:	b769                	j	80000dc8 <copyinstr+0x2c>
      return -1;
    80000e40:	557d                	li	a0,-1
    80000e42:	b779                	j	80000dd0 <copyinstr+0x34>
  int got_null = 0;
    80000e44:	4781                	li	a5,0
  if(got_null){
    80000e46:	0017b793          	seqz	a5,a5
    80000e4a:	40f00533          	neg	a0,a5
}
    80000e4e:	8082                	ret

0000000080000e50 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e50:	7139                	addi	sp,sp,-64
    80000e52:	fc06                	sd	ra,56(sp)
    80000e54:	f822                	sd	s0,48(sp)
    80000e56:	f426                	sd	s1,40(sp)
    80000e58:	f04a                	sd	s2,32(sp)
    80000e5a:	ec4e                	sd	s3,24(sp)
    80000e5c:	e852                	sd	s4,16(sp)
    80000e5e:	e456                	sd	s5,8(sp)
    80000e60:	e05a                	sd	s6,0(sp)
    80000e62:	0080                	addi	s0,sp,64
    80000e64:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e66:	00228497          	auipc	s1,0x228
    80000e6a:	61a48493          	addi	s1,s1,1562 # 80229480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e6e:	8b26                	mv	s6,s1
    80000e70:	00007a97          	auipc	s5,0x7
    80000e74:	190a8a93          	addi	s5,s5,400 # 80008000 <etext>
    80000e78:	04000937          	lui	s2,0x4000
    80000e7c:	197d                	addi	s2,s2,-1
    80000e7e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e80:	0022ea17          	auipc	s4,0x22e
    80000e84:	000a0a13          	mv	s4,s4
    char *pa = kalloc();
    80000e88:	fffff097          	auipc	ra,0xfffff
    80000e8c:	3ea080e7          	jalr	1002(ra) # 80000272 <kalloc>
    80000e90:	862a                	mv	a2,a0
    if(pa == 0)
    80000e92:	c131                	beqz	a0,80000ed6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e94:	416485b3          	sub	a1,s1,s6
    80000e98:	858d                	srai	a1,a1,0x3
    80000e9a:	000ab783          	ld	a5,0(s5)
    80000e9e:	02f585b3          	mul	a1,a1,a5
    80000ea2:	2585                	addiw	a1,a1,1
    80000ea4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ea8:	4719                	li	a4,6
    80000eaa:	6685                	lui	a3,0x1
    80000eac:	40b905b3          	sub	a1,s2,a1
    80000eb0:	854e                	mv	a0,s3
    80000eb2:	00000097          	auipc	ra,0x0
    80000eb6:	8aa080e7          	jalr	-1878(ra) # 8000075c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eba:	16848493          	addi	s1,s1,360
    80000ebe:	fd4495e3          	bne	s1,s4,80000e88 <proc_mapstacks+0x38>
  }
}
    80000ec2:	70e2                	ld	ra,56(sp)
    80000ec4:	7442                	ld	s0,48(sp)
    80000ec6:	74a2                	ld	s1,40(sp)
    80000ec8:	7902                	ld	s2,32(sp)
    80000eca:	69e2                	ld	s3,24(sp)
    80000ecc:	6a42                	ld	s4,16(sp)
    80000ece:	6aa2                	ld	s5,8(sp)
    80000ed0:	6b02                	ld	s6,0(sp)
    80000ed2:	6121                	addi	sp,sp,64
    80000ed4:	8082                	ret
      panic("kalloc");
    80000ed6:	00007517          	auipc	a0,0x7
    80000eda:	28250513          	addi	a0,a0,642 # 80008158 <etext+0x158>
    80000ede:	00005097          	auipc	ra,0x5
    80000ee2:	e7a080e7          	jalr	-390(ra) # 80005d58 <panic>

0000000080000ee6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ee6:	7139                	addi	sp,sp,-64
    80000ee8:	fc06                	sd	ra,56(sp)
    80000eea:	f822                	sd	s0,48(sp)
    80000eec:	f426                	sd	s1,40(sp)
    80000eee:	f04a                	sd	s2,32(sp)
    80000ef0:	ec4e                	sd	s3,24(sp)
    80000ef2:	e852                	sd	s4,16(sp)
    80000ef4:	e456                	sd	s5,8(sp)
    80000ef6:	e05a                	sd	s6,0(sp)
    80000ef8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000efa:	00007597          	auipc	a1,0x7
    80000efe:	26658593          	addi	a1,a1,614 # 80008160 <etext+0x160>
    80000f02:	00228517          	auipc	a0,0x228
    80000f06:	14e50513          	addi	a0,a0,334 # 80229050 <pid_lock>
    80000f0a:	00005097          	auipc	ra,0x5
    80000f0e:	308080e7          	jalr	776(ra) # 80006212 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f12:	00007597          	auipc	a1,0x7
    80000f16:	25658593          	addi	a1,a1,598 # 80008168 <etext+0x168>
    80000f1a:	00228517          	auipc	a0,0x228
    80000f1e:	14e50513          	addi	a0,a0,334 # 80229068 <wait_lock>
    80000f22:	00005097          	auipc	ra,0x5
    80000f26:	2f0080e7          	jalr	752(ra) # 80006212 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	00228497          	auipc	s1,0x228
    80000f2e:	55648493          	addi	s1,s1,1366 # 80229480 <proc>
      initlock(&p->lock, "proc");
    80000f32:	00007b17          	auipc	s6,0x7
    80000f36:	246b0b13          	addi	s6,s6,582 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000f3a:	8aa6                	mv	s5,s1
    80000f3c:	00007a17          	auipc	s4,0x7
    80000f40:	0c4a0a13          	addi	s4,s4,196 # 80008000 <etext>
    80000f44:	04000937          	lui	s2,0x4000
    80000f48:	197d                	addi	s2,s2,-1
    80000f4a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4c:	0022e997          	auipc	s3,0x22e
    80000f50:	f3498993          	addi	s3,s3,-204 # 8022ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000f54:	85da                	mv	a1,s6
    80000f56:	8526                	mv	a0,s1
    80000f58:	00005097          	auipc	ra,0x5
    80000f5c:	2ba080e7          	jalr	698(ra) # 80006212 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f60:	415487b3          	sub	a5,s1,s5
    80000f64:	878d                	srai	a5,a5,0x3
    80000f66:	000a3703          	ld	a4,0(s4)
    80000f6a:	02e787b3          	mul	a5,a5,a4
    80000f6e:	2785                	addiw	a5,a5,1
    80000f70:	00d7979b          	slliw	a5,a5,0xd
    80000f74:	40f907b3          	sub	a5,s2,a5
    80000f78:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7a:	16848493          	addi	s1,s1,360
    80000f7e:	fd349be3          	bne	s1,s3,80000f54 <procinit+0x6e>
  }
}
    80000f82:	70e2                	ld	ra,56(sp)
    80000f84:	7442                	ld	s0,48(sp)
    80000f86:	74a2                	ld	s1,40(sp)
    80000f88:	7902                	ld	s2,32(sp)
    80000f8a:	69e2                	ld	s3,24(sp)
    80000f8c:	6a42                	ld	s4,16(sp)
    80000f8e:	6aa2                	ld	s5,8(sp)
    80000f90:	6b02                	ld	s6,0(sp)
    80000f92:	6121                	addi	sp,sp,64
    80000f94:	8082                	ret

0000000080000f96 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f96:	1141                	addi	sp,sp,-16
    80000f98:	e422                	sd	s0,8(sp)
    80000f9a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f9c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f9e:	2501                	sext.w	a0,a0
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fa6:	1141                	addi	sp,sp,-16
    80000fa8:	e422                	sd	s0,8(sp)
    80000faa:	0800                	addi	s0,sp,16
    80000fac:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fae:	2781                	sext.w	a5,a5
    80000fb0:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fb2:	00228517          	auipc	a0,0x228
    80000fb6:	0ce50513          	addi	a0,a0,206 # 80229080 <cpus>
    80000fba:	953e                	add	a0,a0,a5
    80000fbc:	6422                	ld	s0,8(sp)
    80000fbe:	0141                	addi	sp,sp,16
    80000fc0:	8082                	ret

0000000080000fc2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fc2:	1101                	addi	sp,sp,-32
    80000fc4:	ec06                	sd	ra,24(sp)
    80000fc6:	e822                	sd	s0,16(sp)
    80000fc8:	e426                	sd	s1,8(sp)
    80000fca:	1000                	addi	s0,sp,32
  push_off();
    80000fcc:	00005097          	auipc	ra,0x5
    80000fd0:	28a080e7          	jalr	650(ra) # 80006256 <push_off>
    80000fd4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fd6:	2781                	sext.w	a5,a5
    80000fd8:	079e                	slli	a5,a5,0x7
    80000fda:	00228717          	auipc	a4,0x228
    80000fde:	07670713          	addi	a4,a4,118 # 80229050 <pid_lock>
    80000fe2:	97ba                	add	a5,a5,a4
    80000fe4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	310080e7          	jalr	784(ra) # 800062f6 <pop_off>
  return p;
}
    80000fee:	8526                	mv	a0,s1
    80000ff0:	60e2                	ld	ra,24(sp)
    80000ff2:	6442                	ld	s0,16(sp)
    80000ff4:	64a2                	ld	s1,8(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ffa:	1141                	addi	sp,sp,-16
    80000ffc:	e406                	sd	ra,8(sp)
    80000ffe:	e022                	sd	s0,0(sp)
    80001000:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001002:	00000097          	auipc	ra,0x0
    80001006:	fc0080e7          	jalr	-64(ra) # 80000fc2 <myproc>
    8000100a:	00005097          	auipc	ra,0x5
    8000100e:	34c080e7          	jalr	844(ra) # 80006356 <release>

  if (first) {
    80001012:	00007797          	auipc	a5,0x7
    80001016:	7fe7a783          	lw	a5,2046(a5) # 80008810 <first.1685>
    8000101a:	eb89                	bnez	a5,8000102c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000101c:	00001097          	auipc	ra,0x1
    80001020:	c0a080e7          	jalr	-1014(ra) # 80001c26 <usertrapret>
}
    80001024:	60a2                	ld	ra,8(sp)
    80001026:	6402                	ld	s0,0(sp)
    80001028:	0141                	addi	sp,sp,16
    8000102a:	8082                	ret
    first = 0;
    8000102c:	00007797          	auipc	a5,0x7
    80001030:	7e07a223          	sw	zero,2020(a5) # 80008810 <first.1685>
    fsinit(ROOTDEV);
    80001034:	4505                	li	a0,1
    80001036:	00002097          	auipc	ra,0x2
    8000103a:	9fa080e7          	jalr	-1542(ra) # 80002a30 <fsinit>
    8000103e:	bff9                	j	8000101c <forkret+0x22>

0000000080001040 <allocpid>:
allocpid() {
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	e04a                	sd	s2,0(sp)
    8000104a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000104c:	00228917          	auipc	s2,0x228
    80001050:	00490913          	addi	s2,s2,4 # 80229050 <pid_lock>
    80001054:	854a                	mv	a0,s2
    80001056:	00005097          	auipc	ra,0x5
    8000105a:	24c080e7          	jalr	588(ra) # 800062a2 <acquire>
  pid = nextpid;
    8000105e:	00007797          	auipc	a5,0x7
    80001062:	7b678793          	addi	a5,a5,1974 # 80008814 <nextpid>
    80001066:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001068:	0014871b          	addiw	a4,s1,1
    8000106c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000106e:	854a                	mv	a0,s2
    80001070:	00005097          	auipc	ra,0x5
    80001074:	2e6080e7          	jalr	742(ra) # 80006356 <release>
}
    80001078:	8526                	mv	a0,s1
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <proc_pagetable>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
    80001092:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001094:	00000097          	auipc	ra,0x0
    80001098:	8b2080e7          	jalr	-1870(ra) # 80000946 <uvmcreate>
    8000109c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000109e:	c121                	beqz	a0,800010de <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010a0:	4729                	li	a4,10
    800010a2:	00006697          	auipc	a3,0x6
    800010a6:	f5e68693          	addi	a3,a3,-162 # 80007000 <_trampoline>
    800010aa:	6605                	lui	a2,0x1
    800010ac:	040005b7          	lui	a1,0x4000
    800010b0:	15fd                	addi	a1,a1,-1
    800010b2:	05b2                	slli	a1,a1,0xc
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	608080e7          	jalr	1544(ra) # 800006bc <mappages>
    800010bc:	02054863          	bltz	a0,800010ec <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010c0:	4719                	li	a4,6
    800010c2:	05893683          	ld	a3,88(s2)
    800010c6:	6605                	lui	a2,0x1
    800010c8:	020005b7          	lui	a1,0x2000
    800010cc:	15fd                	addi	a1,a1,-1
    800010ce:	05b6                	slli	a1,a1,0xd
    800010d0:	8526                	mv	a0,s1
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	5ea080e7          	jalr	1514(ra) # 800006bc <mappages>
    800010da:	02054163          	bltz	a0,800010fc <proc_pagetable+0x76>
}
    800010de:	8526                	mv	a0,s1
    800010e0:	60e2                	ld	ra,24(sp)
    800010e2:	6442                	ld	s0,16(sp)
    800010e4:	64a2                	ld	s1,8(sp)
    800010e6:	6902                	ld	s2,0(sp)
    800010e8:	6105                	addi	sp,sp,32
    800010ea:	8082                	ret
    uvmfree(pagetable, 0);
    800010ec:	4581                	li	a1,0
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	a52080e7          	jalr	-1454(ra) # 80000b42 <uvmfree>
    return 0;
    800010f8:	4481                	li	s1,0
    800010fa:	b7d5                	j	800010de <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010fc:	4681                	li	a3,0
    800010fe:	4605                	li	a2,1
    80001100:	040005b7          	lui	a1,0x4000
    80001104:	15fd                	addi	a1,a1,-1
    80001106:	05b2                	slli	a1,a1,0xc
    80001108:	8526                	mv	a0,s1
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	778080e7          	jalr	1912(ra) # 80000882 <uvmunmap>
    uvmfree(pagetable, 0);
    80001112:	4581                	li	a1,0
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	a2c080e7          	jalr	-1492(ra) # 80000b42 <uvmfree>
    return 0;
    8000111e:	4481                	li	s1,0
    80001120:	bf7d                	j	800010de <proc_pagetable+0x58>

0000000080001122 <proc_freepagetable>:
{
    80001122:	1101                	addi	sp,sp,-32
    80001124:	ec06                	sd	ra,24(sp)
    80001126:	e822                	sd	s0,16(sp)
    80001128:	e426                	sd	s1,8(sp)
    8000112a:	e04a                	sd	s2,0(sp)
    8000112c:	1000                	addi	s0,sp,32
    8000112e:	84aa                	mv	s1,a0
    80001130:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001132:	4681                	li	a3,0
    80001134:	4605                	li	a2,1
    80001136:	040005b7          	lui	a1,0x4000
    8000113a:	15fd                	addi	a1,a1,-1
    8000113c:	05b2                	slli	a1,a1,0xc
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	744080e7          	jalr	1860(ra) # 80000882 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001146:	4681                	li	a3,0
    80001148:	4605                	li	a2,1
    8000114a:	020005b7          	lui	a1,0x2000
    8000114e:	15fd                	addi	a1,a1,-1
    80001150:	05b6                	slli	a1,a1,0xd
    80001152:	8526                	mv	a0,s1
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	72e080e7          	jalr	1838(ra) # 80000882 <uvmunmap>
  uvmfree(pagetable, sz);
    8000115c:	85ca                	mv	a1,s2
    8000115e:	8526                	mv	a0,s1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	9e2080e7          	jalr	-1566(ra) # 80000b42 <uvmfree>
}
    80001168:	60e2                	ld	ra,24(sp)
    8000116a:	6442                	ld	s0,16(sp)
    8000116c:	64a2                	ld	s1,8(sp)
    8000116e:	6902                	ld	s2,0(sp)
    80001170:	6105                	addi	sp,sp,32
    80001172:	8082                	ret

0000000080001174 <freeproc>:
{
    80001174:	1101                	addi	sp,sp,-32
    80001176:	ec06                	sd	ra,24(sp)
    80001178:	e822                	sd	s0,16(sp)
    8000117a:	e426                	sd	s1,8(sp)
    8000117c:	1000                	addi	s0,sp,32
    8000117e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001180:	6d28                	ld	a0,88(a0)
    80001182:	c509                	beqz	a0,8000118c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001184:	fffff097          	auipc	ra,0xfffff
    80001188:	f76080e7          	jalr	-138(ra) # 800000fa <kfree>
  p->trapframe = 0;
    8000118c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001190:	68a8                	ld	a0,80(s1)
    80001192:	c511                	beqz	a0,8000119e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001194:	64ac                	ld	a1,72(s1)
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	f8c080e7          	jalr	-116(ra) # 80001122 <proc_freepagetable>
  p->pagetable = 0;
    8000119e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011a2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011a6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011aa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011ae:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011b2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011b6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011ba:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011be:	0004ac23          	sw	zero,24(s1)
}
    800011c2:	60e2                	ld	ra,24(sp)
    800011c4:	6442                	ld	s0,16(sp)
    800011c6:	64a2                	ld	s1,8(sp)
    800011c8:	6105                	addi	sp,sp,32
    800011ca:	8082                	ret

00000000800011cc <allocproc>:
{
    800011cc:	1101                	addi	sp,sp,-32
    800011ce:	ec06                	sd	ra,24(sp)
    800011d0:	e822                	sd	s0,16(sp)
    800011d2:	e426                	sd	s1,8(sp)
    800011d4:	e04a                	sd	s2,0(sp)
    800011d6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d8:	00228497          	auipc	s1,0x228
    800011dc:	2a848493          	addi	s1,s1,680 # 80229480 <proc>
    800011e0:	0022e917          	auipc	s2,0x22e
    800011e4:	ca090913          	addi	s2,s2,-864 # 8022ee80 <tickslock>
    acquire(&p->lock);
    800011e8:	8526                	mv	a0,s1
    800011ea:	00005097          	auipc	ra,0x5
    800011ee:	0b8080e7          	jalr	184(ra) # 800062a2 <acquire>
    if(p->state == UNUSED) {
    800011f2:	4c9c                	lw	a5,24(s1)
    800011f4:	cf81                	beqz	a5,8000120c <allocproc+0x40>
      release(&p->lock);
    800011f6:	8526                	mv	a0,s1
    800011f8:	00005097          	auipc	ra,0x5
    800011fc:	15e080e7          	jalr	350(ra) # 80006356 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001200:	16848493          	addi	s1,s1,360
    80001204:	ff2492e3          	bne	s1,s2,800011e8 <allocproc+0x1c>
  return 0;
    80001208:	4481                	li	s1,0
    8000120a:	a889                	j	8000125c <allocproc+0x90>
  p->pid = allocpid();
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	e34080e7          	jalr	-460(ra) # 80001040 <allocpid>
    80001214:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001216:	4785                	li	a5,1
    80001218:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	058080e7          	jalr	88(ra) # 80000272 <kalloc>
    80001222:	892a                	mv	s2,a0
    80001224:	eca8                	sd	a0,88(s1)
    80001226:	c131                	beqz	a0,8000126a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001228:	8526                	mv	a0,s1
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	e5c080e7          	jalr	-420(ra) # 80001086 <proc_pagetable>
    80001232:	892a                	mv	s2,a0
    80001234:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001236:	c531                	beqz	a0,80001282 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001238:	07000613          	li	a2,112
    8000123c:	4581                	li	a1,0
    8000123e:	06048513          	addi	a0,s1,96
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	0aa080e7          	jalr	170(ra) # 800002ec <memset>
  p->context.ra = (uint64)forkret;
    8000124a:	00000797          	auipc	a5,0x0
    8000124e:	db078793          	addi	a5,a5,-592 # 80000ffa <forkret>
    80001252:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001254:	60bc                	ld	a5,64(s1)
    80001256:	6705                	lui	a4,0x1
    80001258:	97ba                	add	a5,a5,a4
    8000125a:	f4bc                	sd	a5,104(s1)
}
    8000125c:	8526                	mv	a0,s1
    8000125e:	60e2                	ld	ra,24(sp)
    80001260:	6442                	ld	s0,16(sp)
    80001262:	64a2                	ld	s1,8(sp)
    80001264:	6902                	ld	s2,0(sp)
    80001266:	6105                	addi	sp,sp,32
    80001268:	8082                	ret
    freeproc(p);
    8000126a:	8526                	mv	a0,s1
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	f08080e7          	jalr	-248(ra) # 80001174 <freeproc>
    release(&p->lock);
    80001274:	8526                	mv	a0,s1
    80001276:	00005097          	auipc	ra,0x5
    8000127a:	0e0080e7          	jalr	224(ra) # 80006356 <release>
    return 0;
    8000127e:	84ca                	mv	s1,s2
    80001280:	bff1                	j	8000125c <allocproc+0x90>
    freeproc(p);
    80001282:	8526                	mv	a0,s1
    80001284:	00000097          	auipc	ra,0x0
    80001288:	ef0080e7          	jalr	-272(ra) # 80001174 <freeproc>
    release(&p->lock);
    8000128c:	8526                	mv	a0,s1
    8000128e:	00005097          	auipc	ra,0x5
    80001292:	0c8080e7          	jalr	200(ra) # 80006356 <release>
    return 0;
    80001296:	84ca                	mv	s1,s2
    80001298:	b7d1                	j	8000125c <allocproc+0x90>

000000008000129a <userinit>:
{
    8000129a:	1101                	addi	sp,sp,-32
    8000129c:	ec06                	sd	ra,24(sp)
    8000129e:	e822                	sd	s0,16(sp)
    800012a0:	e426                	sd	s1,8(sp)
    800012a2:	1000                	addi	s0,sp,32
  p = allocproc();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	f28080e7          	jalr	-216(ra) # 800011cc <allocproc>
    800012ac:	84aa                	mv	s1,a0
  initproc = p;
    800012ae:	00008797          	auipc	a5,0x8
    800012b2:	d6a7b123          	sd	a0,-670(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012b6:	03400613          	li	a2,52
    800012ba:	00007597          	auipc	a1,0x7
    800012be:	56658593          	addi	a1,a1,1382 # 80008820 <initcode>
    800012c2:	6928                	ld	a0,80(a0)
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	6b0080e7          	jalr	1712(ra) # 80000974 <uvminit>
  p->sz = PGSIZE;
    800012cc:	6785                	lui	a5,0x1
    800012ce:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012d0:	6cb8                	ld	a4,88(s1)
    800012d2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012d6:	6cb8                	ld	a4,88(s1)
    800012d8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012da:	4641                	li	a2,16
    800012dc:	00007597          	auipc	a1,0x7
    800012e0:	ea458593          	addi	a1,a1,-348 # 80008180 <etext+0x180>
    800012e4:	15848513          	addi	a0,s1,344
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	156080e7          	jalr	342(ra) # 8000043e <safestrcpy>
  p->cwd = namei("/");
    800012f0:	00007517          	auipc	a0,0x7
    800012f4:	ea050513          	addi	a0,a0,-352 # 80008190 <etext+0x190>
    800012f8:	00002097          	auipc	ra,0x2
    800012fc:	166080e7          	jalr	358(ra) # 8000345e <namei>
    80001300:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001304:	478d                	li	a5,3
    80001306:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001308:	8526                	mv	a0,s1
    8000130a:	00005097          	auipc	ra,0x5
    8000130e:	04c080e7          	jalr	76(ra) # 80006356 <release>
}
    80001312:	60e2                	ld	ra,24(sp)
    80001314:	6442                	ld	s0,16(sp)
    80001316:	64a2                	ld	s1,8(sp)
    80001318:	6105                	addi	sp,sp,32
    8000131a:	8082                	ret

000000008000131c <growproc>:
{
    8000131c:	1101                	addi	sp,sp,-32
    8000131e:	ec06                	sd	ra,24(sp)
    80001320:	e822                	sd	s0,16(sp)
    80001322:	e426                	sd	s1,8(sp)
    80001324:	e04a                	sd	s2,0(sp)
    80001326:	1000                	addi	s0,sp,32
    80001328:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	c98080e7          	jalr	-872(ra) # 80000fc2 <myproc>
    80001332:	892a                	mv	s2,a0
  sz = p->sz;
    80001334:	652c                	ld	a1,72(a0)
    80001336:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000133a:	00904f63          	bgtz	s1,80001358 <growproc+0x3c>
  } else if(n < 0){
    8000133e:	0204cc63          	bltz	s1,80001376 <growproc+0x5a>
  p->sz = sz;
    80001342:	1602                	slli	a2,a2,0x20
    80001344:	9201                	srli	a2,a2,0x20
    80001346:	04c93423          	sd	a2,72(s2)
  return 0;
    8000134a:	4501                	li	a0,0
}
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6902                	ld	s2,0(sp)
    80001354:	6105                	addi	sp,sp,32
    80001356:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001358:	9e25                	addw	a2,a2,s1
    8000135a:	1602                	slli	a2,a2,0x20
    8000135c:	9201                	srli	a2,a2,0x20
    8000135e:	1582                	slli	a1,a1,0x20
    80001360:	9181                	srli	a1,a1,0x20
    80001362:	6928                	ld	a0,80(a0)
    80001364:	fffff097          	auipc	ra,0xfffff
    80001368:	6ca080e7          	jalr	1738(ra) # 80000a2e <uvmalloc>
    8000136c:	0005061b          	sext.w	a2,a0
    80001370:	fa69                	bnez	a2,80001342 <growproc+0x26>
      return -1;
    80001372:	557d                	li	a0,-1
    80001374:	bfe1                	j	8000134c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001376:	9e25                	addw	a2,a2,s1
    80001378:	1602                	slli	a2,a2,0x20
    8000137a:	9201                	srli	a2,a2,0x20
    8000137c:	1582                	slli	a1,a1,0x20
    8000137e:	9181                	srli	a1,a1,0x20
    80001380:	6928                	ld	a0,80(a0)
    80001382:	fffff097          	auipc	ra,0xfffff
    80001386:	664080e7          	jalr	1636(ra) # 800009e6 <uvmdealloc>
    8000138a:	0005061b          	sext.w	a2,a0
    8000138e:	bf55                	j	80001342 <growproc+0x26>

0000000080001390 <fork>:
{
    80001390:	7179                	addi	sp,sp,-48
    80001392:	f406                	sd	ra,40(sp)
    80001394:	f022                	sd	s0,32(sp)
    80001396:	ec26                	sd	s1,24(sp)
    80001398:	e84a                	sd	s2,16(sp)
    8000139a:	e44e                	sd	s3,8(sp)
    8000139c:	e052                	sd	s4,0(sp)
    8000139e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	c22080e7          	jalr	-990(ra) # 80000fc2 <myproc>
    800013a8:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013aa:	00000097          	auipc	ra,0x0
    800013ae:	e22080e7          	jalr	-478(ra) # 800011cc <allocproc>
    800013b2:	10050b63          	beqz	a0,800014c8 <fork+0x138>
    800013b6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013b8:	04893603          	ld	a2,72(s2)
    800013bc:	692c                	ld	a1,80(a0)
    800013be:	05093503          	ld	a0,80(s2)
    800013c2:	fffff097          	auipc	ra,0xfffff
    800013c6:	7b8080e7          	jalr	1976(ra) # 80000b7a <uvmcopy>
    800013ca:	04054663          	bltz	a0,80001416 <fork+0x86>
  np->sz = p->sz;
    800013ce:	04893783          	ld	a5,72(s2)
    800013d2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013d6:	05893683          	ld	a3,88(s2)
    800013da:	87b6                	mv	a5,a3
    800013dc:	0589b703          	ld	a4,88(s3)
    800013e0:	12068693          	addi	a3,a3,288
    800013e4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013e8:	6788                	ld	a0,8(a5)
    800013ea:	6b8c                	ld	a1,16(a5)
    800013ec:	6f90                	ld	a2,24(a5)
    800013ee:	01073023          	sd	a6,0(a4)
    800013f2:	e708                	sd	a0,8(a4)
    800013f4:	eb0c                	sd	a1,16(a4)
    800013f6:	ef10                	sd	a2,24(a4)
    800013f8:	02078793          	addi	a5,a5,32
    800013fc:	02070713          	addi	a4,a4,32
    80001400:	fed792e3          	bne	a5,a3,800013e4 <fork+0x54>
  np->trapframe->a0 = 0;
    80001404:	0589b783          	ld	a5,88(s3)
    80001408:	0607b823          	sd	zero,112(a5)
    8000140c:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001410:	15000a13          	li	s4,336
    80001414:	a03d                	j	80001442 <fork+0xb2>
    freeproc(np);
    80001416:	854e                	mv	a0,s3
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	d5c080e7          	jalr	-676(ra) # 80001174 <freeproc>
    release(&np->lock);
    80001420:	854e                	mv	a0,s3
    80001422:	00005097          	auipc	ra,0x5
    80001426:	f34080e7          	jalr	-204(ra) # 80006356 <release>
    return -1;
    8000142a:	5a7d                	li	s4,-1
    8000142c:	a069                	j	800014b6 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000142e:	00002097          	auipc	ra,0x2
    80001432:	6c6080e7          	jalr	1734(ra) # 80003af4 <filedup>
    80001436:	009987b3          	add	a5,s3,s1
    8000143a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000143c:	04a1                	addi	s1,s1,8
    8000143e:	01448763          	beq	s1,s4,8000144c <fork+0xbc>
    if(p->ofile[i])
    80001442:	009907b3          	add	a5,s2,s1
    80001446:	6388                	ld	a0,0(a5)
    80001448:	f17d                	bnez	a0,8000142e <fork+0x9e>
    8000144a:	bfcd                	j	8000143c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000144c:	15093503          	ld	a0,336(s2)
    80001450:	00002097          	auipc	ra,0x2
    80001454:	81a080e7          	jalr	-2022(ra) # 80002c6a <idup>
    80001458:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000145c:	4641                	li	a2,16
    8000145e:	15890593          	addi	a1,s2,344
    80001462:	15898513          	addi	a0,s3,344
    80001466:	fffff097          	auipc	ra,0xfffff
    8000146a:	fd8080e7          	jalr	-40(ra) # 8000043e <safestrcpy>
  pid = np->pid;
    8000146e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001472:	854e                	mv	a0,s3
    80001474:	00005097          	auipc	ra,0x5
    80001478:	ee2080e7          	jalr	-286(ra) # 80006356 <release>
  acquire(&wait_lock);
    8000147c:	00228497          	auipc	s1,0x228
    80001480:	bec48493          	addi	s1,s1,-1044 # 80229068 <wait_lock>
    80001484:	8526                	mv	a0,s1
    80001486:	00005097          	auipc	ra,0x5
    8000148a:	e1c080e7          	jalr	-484(ra) # 800062a2 <acquire>
  np->parent = p;
    8000148e:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001492:	8526                	mv	a0,s1
    80001494:	00005097          	auipc	ra,0x5
    80001498:	ec2080e7          	jalr	-318(ra) # 80006356 <release>
  acquire(&np->lock);
    8000149c:	854e                	mv	a0,s3
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	e04080e7          	jalr	-508(ra) # 800062a2 <acquire>
  np->state = RUNNABLE;
    800014a6:	478d                	li	a5,3
    800014a8:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014ac:	854e                	mv	a0,s3
    800014ae:	00005097          	auipc	ra,0x5
    800014b2:	ea8080e7          	jalr	-344(ra) # 80006356 <release>
}
    800014b6:	8552                	mv	a0,s4
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6a02                	ld	s4,0(sp)
    800014c4:	6145                	addi	sp,sp,48
    800014c6:	8082                	ret
    return -1;
    800014c8:	5a7d                	li	s4,-1
    800014ca:	b7f5                	j	800014b6 <fork+0x126>

00000000800014cc <scheduler>:
{
    800014cc:	7139                	addi	sp,sp,-64
    800014ce:	fc06                	sd	ra,56(sp)
    800014d0:	f822                	sd	s0,48(sp)
    800014d2:	f426                	sd	s1,40(sp)
    800014d4:	f04a                	sd	s2,32(sp)
    800014d6:	ec4e                	sd	s3,24(sp)
    800014d8:	e852                	sd	s4,16(sp)
    800014da:	e456                	sd	s5,8(sp)
    800014dc:	e05a                	sd	s6,0(sp)
    800014de:	0080                	addi	s0,sp,64
    800014e0:	8792                	mv	a5,tp
  int id = r_tp();
    800014e2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014e4:	00779a93          	slli	s5,a5,0x7
    800014e8:	00228717          	auipc	a4,0x228
    800014ec:	b6870713          	addi	a4,a4,-1176 # 80229050 <pid_lock>
    800014f0:	9756                	add	a4,a4,s5
    800014f2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014f6:	00228717          	auipc	a4,0x228
    800014fa:	b9270713          	addi	a4,a4,-1134 # 80229088 <cpus+0x8>
    800014fe:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001500:	498d                	li	s3,3
        p->state = RUNNING;
    80001502:	4b11                	li	s6,4
        c->proc = p;
    80001504:	079e                	slli	a5,a5,0x7
    80001506:	00228a17          	auipc	s4,0x228
    8000150a:	b4aa0a13          	addi	s4,s4,-1206 # 80229050 <pid_lock>
    8000150e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001510:	0022e917          	auipc	s2,0x22e
    80001514:	97090913          	addi	s2,s2,-1680 # 8022ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001518:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000151c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001520:	10079073          	csrw	sstatus,a5
    80001524:	00228497          	auipc	s1,0x228
    80001528:	f5c48493          	addi	s1,s1,-164 # 80229480 <proc>
    8000152c:	a03d                	j	8000155a <scheduler+0x8e>
        p->state = RUNNING;
    8000152e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001532:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001536:	06048593          	addi	a1,s1,96
    8000153a:	8556                	mv	a0,s5
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	640080e7          	jalr	1600(ra) # 80001b7c <swtch>
        c->proc = 0;
    80001544:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	e0c080e7          	jalr	-500(ra) # 80006356 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001552:	16848493          	addi	s1,s1,360
    80001556:	fd2481e3          	beq	s1,s2,80001518 <scheduler+0x4c>
      acquire(&p->lock);
    8000155a:	8526                	mv	a0,s1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	d46080e7          	jalr	-698(ra) # 800062a2 <acquire>
      if(p->state == RUNNABLE) {
    80001564:	4c9c                	lw	a5,24(s1)
    80001566:	ff3791e3          	bne	a5,s3,80001548 <scheduler+0x7c>
    8000156a:	b7d1                	j	8000152e <scheduler+0x62>

000000008000156c <sched>:
{
    8000156c:	7179                	addi	sp,sp,-48
    8000156e:	f406                	sd	ra,40(sp)
    80001570:	f022                	sd	s0,32(sp)
    80001572:	ec26                	sd	s1,24(sp)
    80001574:	e84a                	sd	s2,16(sp)
    80001576:	e44e                	sd	s3,8(sp)
    80001578:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000157a:	00000097          	auipc	ra,0x0
    8000157e:	a48080e7          	jalr	-1464(ra) # 80000fc2 <myproc>
    80001582:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001584:	00005097          	auipc	ra,0x5
    80001588:	ca4080e7          	jalr	-860(ra) # 80006228 <holding>
    8000158c:	c93d                	beqz	a0,80001602 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000158e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001590:	2781                	sext.w	a5,a5
    80001592:	079e                	slli	a5,a5,0x7
    80001594:	00228717          	auipc	a4,0x228
    80001598:	abc70713          	addi	a4,a4,-1348 # 80229050 <pid_lock>
    8000159c:	97ba                	add	a5,a5,a4
    8000159e:	0a87a703          	lw	a4,168(a5)
    800015a2:	4785                	li	a5,1
    800015a4:	06f71763          	bne	a4,a5,80001612 <sched+0xa6>
  if(p->state == RUNNING)
    800015a8:	4c98                	lw	a4,24(s1)
    800015aa:	4791                	li	a5,4
    800015ac:	06f70b63          	beq	a4,a5,80001622 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015b0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015b4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015b6:	efb5                	bnez	a5,80001632 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015b8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015ba:	00228917          	auipc	s2,0x228
    800015be:	a9690913          	addi	s2,s2,-1386 # 80229050 <pid_lock>
    800015c2:	2781                	sext.w	a5,a5
    800015c4:	079e                	slli	a5,a5,0x7
    800015c6:	97ca                	add	a5,a5,s2
    800015c8:	0ac7a983          	lw	s3,172(a5)
    800015cc:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ce:	2781                	sext.w	a5,a5
    800015d0:	079e                	slli	a5,a5,0x7
    800015d2:	00228597          	auipc	a1,0x228
    800015d6:	ab658593          	addi	a1,a1,-1354 # 80229088 <cpus+0x8>
    800015da:	95be                	add	a1,a1,a5
    800015dc:	06048513          	addi	a0,s1,96
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	59c080e7          	jalr	1436(ra) # 80001b7c <swtch>
    800015e8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015ea:	2781                	sext.w	a5,a5
    800015ec:	079e                	slli	a5,a5,0x7
    800015ee:	97ca                	add	a5,a5,s2
    800015f0:	0b37a623          	sw	s3,172(a5)
}
    800015f4:	70a2                	ld	ra,40(sp)
    800015f6:	7402                	ld	s0,32(sp)
    800015f8:	64e2                	ld	s1,24(sp)
    800015fa:	6942                	ld	s2,16(sp)
    800015fc:	69a2                	ld	s3,8(sp)
    800015fe:	6145                	addi	sp,sp,48
    80001600:	8082                	ret
    panic("sched p->lock");
    80001602:	00007517          	auipc	a0,0x7
    80001606:	b9650513          	addi	a0,a0,-1130 # 80008198 <etext+0x198>
    8000160a:	00004097          	auipc	ra,0x4
    8000160e:	74e080e7          	jalr	1870(ra) # 80005d58 <panic>
    panic("sched locks");
    80001612:	00007517          	auipc	a0,0x7
    80001616:	b9650513          	addi	a0,a0,-1130 # 800081a8 <etext+0x1a8>
    8000161a:	00004097          	auipc	ra,0x4
    8000161e:	73e080e7          	jalr	1854(ra) # 80005d58 <panic>
    panic("sched running");
    80001622:	00007517          	auipc	a0,0x7
    80001626:	b9650513          	addi	a0,a0,-1130 # 800081b8 <etext+0x1b8>
    8000162a:	00004097          	auipc	ra,0x4
    8000162e:	72e080e7          	jalr	1838(ra) # 80005d58 <panic>
    panic("sched interruptible");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	b9650513          	addi	a0,a0,-1130 # 800081c8 <etext+0x1c8>
    8000163a:	00004097          	auipc	ra,0x4
    8000163e:	71e080e7          	jalr	1822(ra) # 80005d58 <panic>

0000000080001642 <yield>:
{
    80001642:	1101                	addi	sp,sp,-32
    80001644:	ec06                	sd	ra,24(sp)
    80001646:	e822                	sd	s0,16(sp)
    80001648:	e426                	sd	s1,8(sp)
    8000164a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	976080e7          	jalr	-1674(ra) # 80000fc2 <myproc>
    80001654:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	c4c080e7          	jalr	-948(ra) # 800062a2 <acquire>
  p->state = RUNNABLE;
    8000165e:	478d                	li	a5,3
    80001660:	cc9c                	sw	a5,24(s1)
  sched();
    80001662:	00000097          	auipc	ra,0x0
    80001666:	f0a080e7          	jalr	-246(ra) # 8000156c <sched>
  release(&p->lock);
    8000166a:	8526                	mv	a0,s1
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	cea080e7          	jalr	-790(ra) # 80006356 <release>
}
    80001674:	60e2                	ld	ra,24(sp)
    80001676:	6442                	ld	s0,16(sp)
    80001678:	64a2                	ld	s1,8(sp)
    8000167a:	6105                	addi	sp,sp,32
    8000167c:	8082                	ret

000000008000167e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000167e:	7179                	addi	sp,sp,-48
    80001680:	f406                	sd	ra,40(sp)
    80001682:	f022                	sd	s0,32(sp)
    80001684:	ec26                	sd	s1,24(sp)
    80001686:	e84a                	sd	s2,16(sp)
    80001688:	e44e                	sd	s3,8(sp)
    8000168a:	1800                	addi	s0,sp,48
    8000168c:	89aa                	mv	s3,a0
    8000168e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001690:	00000097          	auipc	ra,0x0
    80001694:	932080e7          	jalr	-1742(ra) # 80000fc2 <myproc>
    80001698:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000169a:	00005097          	auipc	ra,0x5
    8000169e:	c08080e7          	jalr	-1016(ra) # 800062a2 <acquire>
  release(lk);
    800016a2:	854a                	mv	a0,s2
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	cb2080e7          	jalr	-846(ra) # 80006356 <release>

  // Go to sleep.
  p->chan = chan;
    800016ac:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016b0:	4789                	li	a5,2
    800016b2:	cc9c                	sw	a5,24(s1)

  sched();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	eb8080e7          	jalr	-328(ra) # 8000156c <sched>

  // Tidy up.
  p->chan = 0;
    800016bc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016c0:	8526                	mv	a0,s1
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	c94080e7          	jalr	-876(ra) # 80006356 <release>
  acquire(lk);
    800016ca:	854a                	mv	a0,s2
    800016cc:	00005097          	auipc	ra,0x5
    800016d0:	bd6080e7          	jalr	-1066(ra) # 800062a2 <acquire>
}
    800016d4:	70a2                	ld	ra,40(sp)
    800016d6:	7402                	ld	s0,32(sp)
    800016d8:	64e2                	ld	s1,24(sp)
    800016da:	6942                	ld	s2,16(sp)
    800016dc:	69a2                	ld	s3,8(sp)
    800016de:	6145                	addi	sp,sp,48
    800016e0:	8082                	ret

00000000800016e2 <wait>:
{
    800016e2:	715d                	addi	sp,sp,-80
    800016e4:	e486                	sd	ra,72(sp)
    800016e6:	e0a2                	sd	s0,64(sp)
    800016e8:	fc26                	sd	s1,56(sp)
    800016ea:	f84a                	sd	s2,48(sp)
    800016ec:	f44e                	sd	s3,40(sp)
    800016ee:	f052                	sd	s4,32(sp)
    800016f0:	ec56                	sd	s5,24(sp)
    800016f2:	e85a                	sd	s6,16(sp)
    800016f4:	e45e                	sd	s7,8(sp)
    800016f6:	e062                	sd	s8,0(sp)
    800016f8:	0880                	addi	s0,sp,80
    800016fa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	8c6080e7          	jalr	-1850(ra) # 80000fc2 <myproc>
    80001704:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001706:	00228517          	auipc	a0,0x228
    8000170a:	96250513          	addi	a0,a0,-1694 # 80229068 <wait_lock>
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	b94080e7          	jalr	-1132(ra) # 800062a2 <acquire>
    havekids = 0;
    80001716:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001718:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000171a:	0022d997          	auipc	s3,0x22d
    8000171e:	76698993          	addi	s3,s3,1894 # 8022ee80 <tickslock>
        havekids = 1;
    80001722:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001724:	00228c17          	auipc	s8,0x228
    80001728:	944c0c13          	addi	s8,s8,-1724 # 80229068 <wait_lock>
    havekids = 0;
    8000172c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000172e:	00228497          	auipc	s1,0x228
    80001732:	d5248493          	addi	s1,s1,-686 # 80229480 <proc>
    80001736:	a0bd                	j	800017a4 <wait+0xc2>
          pid = np->pid;
    80001738:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000173c:	000b0e63          	beqz	s6,80001758 <wait+0x76>
    80001740:	4691                	li	a3,4
    80001742:	02c48613          	addi	a2,s1,44
    80001746:	85da                	mv	a1,s6
    80001748:	05093503          	ld	a0,80(s2)
    8000174c:	fffff097          	auipc	ra,0xfffff
    80001750:	524080e7          	jalr	1316(ra) # 80000c70 <copyout>
    80001754:	02054563          	bltz	a0,8000177e <wait+0x9c>
          freeproc(np);
    80001758:	8526                	mv	a0,s1
    8000175a:	00000097          	auipc	ra,0x0
    8000175e:	a1a080e7          	jalr	-1510(ra) # 80001174 <freeproc>
          release(&np->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	bf2080e7          	jalr	-1038(ra) # 80006356 <release>
          release(&wait_lock);
    8000176c:	00228517          	auipc	a0,0x228
    80001770:	8fc50513          	addi	a0,a0,-1796 # 80229068 <wait_lock>
    80001774:	00005097          	auipc	ra,0x5
    80001778:	be2080e7          	jalr	-1054(ra) # 80006356 <release>
          return pid;
    8000177c:	a09d                	j	800017e2 <wait+0x100>
            release(&np->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00005097          	auipc	ra,0x5
    80001784:	bd6080e7          	jalr	-1066(ra) # 80006356 <release>
            release(&wait_lock);
    80001788:	00228517          	auipc	a0,0x228
    8000178c:	8e050513          	addi	a0,a0,-1824 # 80229068 <wait_lock>
    80001790:	00005097          	auipc	ra,0x5
    80001794:	bc6080e7          	jalr	-1082(ra) # 80006356 <release>
            return -1;
    80001798:	59fd                	li	s3,-1
    8000179a:	a0a1                	j	800017e2 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000179c:	16848493          	addi	s1,s1,360
    800017a0:	03348463          	beq	s1,s3,800017c8 <wait+0xe6>
      if(np->parent == p){
    800017a4:	7c9c                	ld	a5,56(s1)
    800017a6:	ff279be3          	bne	a5,s2,8000179c <wait+0xba>
        acquire(&np->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	af6080e7          	jalr	-1290(ra) # 800062a2 <acquire>
        if(np->state == ZOMBIE){
    800017b4:	4c9c                	lw	a5,24(s1)
    800017b6:	f94781e3          	beq	a5,s4,80001738 <wait+0x56>
        release(&np->lock);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	b9a080e7          	jalr	-1126(ra) # 80006356 <release>
        havekids = 1;
    800017c4:	8756                	mv	a4,s5
    800017c6:	bfd9                	j	8000179c <wait+0xba>
    if(!havekids || p->killed){
    800017c8:	c701                	beqz	a4,800017d0 <wait+0xee>
    800017ca:	02892783          	lw	a5,40(s2)
    800017ce:	c79d                	beqz	a5,800017fc <wait+0x11a>
      release(&wait_lock);
    800017d0:	00228517          	auipc	a0,0x228
    800017d4:	89850513          	addi	a0,a0,-1896 # 80229068 <wait_lock>
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	b7e080e7          	jalr	-1154(ra) # 80006356 <release>
      return -1;
    800017e0:	59fd                	li	s3,-1
}
    800017e2:	854e                	mv	a0,s3
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6c02                	ld	s8,0(sp)
    800017f8:	6161                	addi	sp,sp,80
    800017fa:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fc:	85e2                	mv	a1,s8
    800017fe:	854a                	mv	a0,s2
    80001800:	00000097          	auipc	ra,0x0
    80001804:	e7e080e7          	jalr	-386(ra) # 8000167e <sleep>
    havekids = 0;
    80001808:	b715                	j	8000172c <wait+0x4a>

000000008000180a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000180a:	7139                	addi	sp,sp,-64
    8000180c:	fc06                	sd	ra,56(sp)
    8000180e:	f822                	sd	s0,48(sp)
    80001810:	f426                	sd	s1,40(sp)
    80001812:	f04a                	sd	s2,32(sp)
    80001814:	ec4e                	sd	s3,24(sp)
    80001816:	e852                	sd	s4,16(sp)
    80001818:	e456                	sd	s5,8(sp)
    8000181a:	0080                	addi	s0,sp,64
    8000181c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000181e:	00228497          	auipc	s1,0x228
    80001822:	c6248493          	addi	s1,s1,-926 # 80229480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001826:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001828:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000182a:	0022d917          	auipc	s2,0x22d
    8000182e:	65690913          	addi	s2,s2,1622 # 8022ee80 <tickslock>
    80001832:	a821                	j	8000184a <wakeup+0x40>
        p->state = RUNNABLE;
    80001834:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001838:	8526                	mv	a0,s1
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	b1c080e7          	jalr	-1252(ra) # 80006356 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001842:	16848493          	addi	s1,s1,360
    80001846:	03248463          	beq	s1,s2,8000186e <wakeup+0x64>
    if(p != myproc()){
    8000184a:	fffff097          	auipc	ra,0xfffff
    8000184e:	778080e7          	jalr	1912(ra) # 80000fc2 <myproc>
    80001852:	fea488e3          	beq	s1,a0,80001842 <wakeup+0x38>
      acquire(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	a4a080e7          	jalr	-1462(ra) # 800062a2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001860:	4c9c                	lw	a5,24(s1)
    80001862:	fd379be3          	bne	a5,s3,80001838 <wakeup+0x2e>
    80001866:	709c                	ld	a5,32(s1)
    80001868:	fd4798e3          	bne	a5,s4,80001838 <wakeup+0x2e>
    8000186c:	b7e1                	j	80001834 <wakeup+0x2a>
    }
  }
}
    8000186e:	70e2                	ld	ra,56(sp)
    80001870:	7442                	ld	s0,48(sp)
    80001872:	74a2                	ld	s1,40(sp)
    80001874:	7902                	ld	s2,32(sp)
    80001876:	69e2                	ld	s3,24(sp)
    80001878:	6a42                	ld	s4,16(sp)
    8000187a:	6aa2                	ld	s5,8(sp)
    8000187c:	6121                	addi	sp,sp,64
    8000187e:	8082                	ret

0000000080001880 <reparent>:
{
    80001880:	7179                	addi	sp,sp,-48
    80001882:	f406                	sd	ra,40(sp)
    80001884:	f022                	sd	s0,32(sp)
    80001886:	ec26                	sd	s1,24(sp)
    80001888:	e84a                	sd	s2,16(sp)
    8000188a:	e44e                	sd	s3,8(sp)
    8000188c:	e052                	sd	s4,0(sp)
    8000188e:	1800                	addi	s0,sp,48
    80001890:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001892:	00228497          	auipc	s1,0x228
    80001896:	bee48493          	addi	s1,s1,-1042 # 80229480 <proc>
      pp->parent = initproc;
    8000189a:	00007a17          	auipc	s4,0x7
    8000189e:	776a0a13          	addi	s4,s4,1910 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018a2:	0022d997          	auipc	s3,0x22d
    800018a6:	5de98993          	addi	s3,s3,1502 # 8022ee80 <tickslock>
    800018aa:	a029                	j	800018b4 <reparent+0x34>
    800018ac:	16848493          	addi	s1,s1,360
    800018b0:	01348d63          	beq	s1,s3,800018ca <reparent+0x4a>
    if(pp->parent == p){
    800018b4:	7c9c                	ld	a5,56(s1)
    800018b6:	ff279be3          	bne	a5,s2,800018ac <reparent+0x2c>
      pp->parent = initproc;
    800018ba:	000a3503          	ld	a0,0(s4)
    800018be:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	f4a080e7          	jalr	-182(ra) # 8000180a <wakeup>
    800018c8:	b7d5                	j	800018ac <reparent+0x2c>
}
    800018ca:	70a2                	ld	ra,40(sp)
    800018cc:	7402                	ld	s0,32(sp)
    800018ce:	64e2                	ld	s1,24(sp)
    800018d0:	6942                	ld	s2,16(sp)
    800018d2:	69a2                	ld	s3,8(sp)
    800018d4:	6a02                	ld	s4,0(sp)
    800018d6:	6145                	addi	sp,sp,48
    800018d8:	8082                	ret

00000000800018da <exit>:
{
    800018da:	7179                	addi	sp,sp,-48
    800018dc:	f406                	sd	ra,40(sp)
    800018de:	f022                	sd	s0,32(sp)
    800018e0:	ec26                	sd	s1,24(sp)
    800018e2:	e84a                	sd	s2,16(sp)
    800018e4:	e44e                	sd	s3,8(sp)
    800018e6:	e052                	sd	s4,0(sp)
    800018e8:	1800                	addi	s0,sp,48
    800018ea:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018ec:	fffff097          	auipc	ra,0xfffff
    800018f0:	6d6080e7          	jalr	1750(ra) # 80000fc2 <myproc>
    800018f4:	89aa                	mv	s3,a0
  if(p == initproc)
    800018f6:	00007797          	auipc	a5,0x7
    800018fa:	71a7b783          	ld	a5,1818(a5) # 80009010 <initproc>
    800018fe:	0d050493          	addi	s1,a0,208
    80001902:	15050913          	addi	s2,a0,336
    80001906:	02a79363          	bne	a5,a0,8000192c <exit+0x52>
    panic("init exiting");
    8000190a:	00007517          	auipc	a0,0x7
    8000190e:	8d650513          	addi	a0,a0,-1834 # 800081e0 <etext+0x1e0>
    80001912:	00004097          	auipc	ra,0x4
    80001916:	446080e7          	jalr	1094(ra) # 80005d58 <panic>
      fileclose(f);
    8000191a:	00002097          	auipc	ra,0x2
    8000191e:	22c080e7          	jalr	556(ra) # 80003b46 <fileclose>
      p->ofile[fd] = 0;
    80001922:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001926:	04a1                	addi	s1,s1,8
    80001928:	01248563          	beq	s1,s2,80001932 <exit+0x58>
    if(p->ofile[fd]){
    8000192c:	6088                	ld	a0,0(s1)
    8000192e:	f575                	bnez	a0,8000191a <exit+0x40>
    80001930:	bfdd                	j	80001926 <exit+0x4c>
  begin_op();
    80001932:	00002097          	auipc	ra,0x2
    80001936:	d48080e7          	jalr	-696(ra) # 8000367a <begin_op>
  iput(p->cwd);
    8000193a:	1509b503          	ld	a0,336(s3)
    8000193e:	00001097          	auipc	ra,0x1
    80001942:	524080e7          	jalr	1316(ra) # 80002e62 <iput>
  end_op();
    80001946:	00002097          	auipc	ra,0x2
    8000194a:	db4080e7          	jalr	-588(ra) # 800036fa <end_op>
  p->cwd = 0;
    8000194e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001952:	00227497          	auipc	s1,0x227
    80001956:	71648493          	addi	s1,s1,1814 # 80229068 <wait_lock>
    8000195a:	8526                	mv	a0,s1
    8000195c:	00005097          	auipc	ra,0x5
    80001960:	946080e7          	jalr	-1722(ra) # 800062a2 <acquire>
  reparent(p);
    80001964:	854e                	mv	a0,s3
    80001966:	00000097          	auipc	ra,0x0
    8000196a:	f1a080e7          	jalr	-230(ra) # 80001880 <reparent>
  wakeup(p->parent);
    8000196e:	0389b503          	ld	a0,56(s3)
    80001972:	00000097          	auipc	ra,0x0
    80001976:	e98080e7          	jalr	-360(ra) # 8000180a <wakeup>
  acquire(&p->lock);
    8000197a:	854e                	mv	a0,s3
    8000197c:	00005097          	auipc	ra,0x5
    80001980:	926080e7          	jalr	-1754(ra) # 800062a2 <acquire>
  p->xstate = status;
    80001984:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001988:	4795                	li	a5,5
    8000198a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	00005097          	auipc	ra,0x5
    80001994:	9c6080e7          	jalr	-1594(ra) # 80006356 <release>
  sched();
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	bd4080e7          	jalr	-1068(ra) # 8000156c <sched>
  panic("zombie exit");
    800019a0:	00007517          	auipc	a0,0x7
    800019a4:	85050513          	addi	a0,a0,-1968 # 800081f0 <etext+0x1f0>
    800019a8:	00004097          	auipc	ra,0x4
    800019ac:	3b0080e7          	jalr	944(ra) # 80005d58 <panic>

00000000800019b0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019b0:	7179                	addi	sp,sp,-48
    800019b2:	f406                	sd	ra,40(sp)
    800019b4:	f022                	sd	s0,32(sp)
    800019b6:	ec26                	sd	s1,24(sp)
    800019b8:	e84a                	sd	s2,16(sp)
    800019ba:	e44e                	sd	s3,8(sp)
    800019bc:	1800                	addi	s0,sp,48
    800019be:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019c0:	00228497          	auipc	s1,0x228
    800019c4:	ac048493          	addi	s1,s1,-1344 # 80229480 <proc>
    800019c8:	0022d997          	auipc	s3,0x22d
    800019cc:	4b898993          	addi	s3,s3,1208 # 8022ee80 <tickslock>
    acquire(&p->lock);
    800019d0:	8526                	mv	a0,s1
    800019d2:	00005097          	auipc	ra,0x5
    800019d6:	8d0080e7          	jalr	-1840(ra) # 800062a2 <acquire>
    if(p->pid == pid){
    800019da:	589c                	lw	a5,48(s1)
    800019dc:	01278d63          	beq	a5,s2,800019f6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	974080e7          	jalr	-1676(ra) # 80006356 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ea:	16848493          	addi	s1,s1,360
    800019ee:	ff3491e3          	bne	s1,s3,800019d0 <kill+0x20>
  }
  return -1;
    800019f2:	557d                	li	a0,-1
    800019f4:	a829                	j	80001a0e <kill+0x5e>
      p->killed = 1;
    800019f6:	4785                	li	a5,1
    800019f8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019fa:	4c98                	lw	a4,24(s1)
    800019fc:	4789                	li	a5,2
    800019fe:	00f70f63          	beq	a4,a5,80001a1c <kill+0x6c>
      release(&p->lock);
    80001a02:	8526                	mv	a0,s1
    80001a04:	00005097          	auipc	ra,0x5
    80001a08:	952080e7          	jalr	-1710(ra) # 80006356 <release>
      return 0;
    80001a0c:	4501                	li	a0,0
}
    80001a0e:	70a2                	ld	ra,40(sp)
    80001a10:	7402                	ld	s0,32(sp)
    80001a12:	64e2                	ld	s1,24(sp)
    80001a14:	6942                	ld	s2,16(sp)
    80001a16:	69a2                	ld	s3,8(sp)
    80001a18:	6145                	addi	sp,sp,48
    80001a1a:	8082                	ret
        p->state = RUNNABLE;
    80001a1c:	478d                	li	a5,3
    80001a1e:	cc9c                	sw	a5,24(s1)
    80001a20:	b7cd                	j	80001a02 <kill+0x52>

0000000080001a22 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a22:	7179                	addi	sp,sp,-48
    80001a24:	f406                	sd	ra,40(sp)
    80001a26:	f022                	sd	s0,32(sp)
    80001a28:	ec26                	sd	s1,24(sp)
    80001a2a:	e84a                	sd	s2,16(sp)
    80001a2c:	e44e                	sd	s3,8(sp)
    80001a2e:	e052                	sd	s4,0(sp)
    80001a30:	1800                	addi	s0,sp,48
    80001a32:	84aa                	mv	s1,a0
    80001a34:	892e                	mv	s2,a1
    80001a36:	89b2                	mv	s3,a2
    80001a38:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	588080e7          	jalr	1416(ra) # 80000fc2 <myproc>
  if(user_dst){
    80001a42:	c08d                	beqz	s1,80001a64 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a44:	86d2                	mv	a3,s4
    80001a46:	864e                	mv	a2,s3
    80001a48:	85ca                	mv	a1,s2
    80001a4a:	6928                	ld	a0,80(a0)
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	224080e7          	jalr	548(ra) # 80000c70 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a54:	70a2                	ld	ra,40(sp)
    80001a56:	7402                	ld	s0,32(sp)
    80001a58:	64e2                	ld	s1,24(sp)
    80001a5a:	6942                	ld	s2,16(sp)
    80001a5c:	69a2                	ld	s3,8(sp)
    80001a5e:	6a02                	ld	s4,0(sp)
    80001a60:	6145                	addi	sp,sp,48
    80001a62:	8082                	ret
    memmove((char *)dst, src, len);
    80001a64:	000a061b          	sext.w	a2,s4
    80001a68:	85ce                	mv	a1,s3
    80001a6a:	854a                	mv	a0,s2
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	8e0080e7          	jalr	-1824(ra) # 8000034c <memmove>
    return 0;
    80001a74:	8526                	mv	a0,s1
    80001a76:	bff9                	j	80001a54 <either_copyout+0x32>

0000000080001a78 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a78:	7179                	addi	sp,sp,-48
    80001a7a:	f406                	sd	ra,40(sp)
    80001a7c:	f022                	sd	s0,32(sp)
    80001a7e:	ec26                	sd	s1,24(sp)
    80001a80:	e84a                	sd	s2,16(sp)
    80001a82:	e44e                	sd	s3,8(sp)
    80001a84:	e052                	sd	s4,0(sp)
    80001a86:	1800                	addi	s0,sp,48
    80001a88:	892a                	mv	s2,a0
    80001a8a:	84ae                	mv	s1,a1
    80001a8c:	89b2                	mv	s3,a2
    80001a8e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	532080e7          	jalr	1330(ra) # 80000fc2 <myproc>
  if(user_src){
    80001a98:	c08d                	beqz	s1,80001aba <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a9a:	86d2                	mv	a3,s4
    80001a9c:	864e                	mv	a2,s3
    80001a9e:	85ca                	mv	a1,s2
    80001aa0:	6928                	ld	a0,80(a0)
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	26e080e7          	jalr	622(ra) # 80000d10 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001aaa:	70a2                	ld	ra,40(sp)
    80001aac:	7402                	ld	s0,32(sp)
    80001aae:	64e2                	ld	s1,24(sp)
    80001ab0:	6942                	ld	s2,16(sp)
    80001ab2:	69a2                	ld	s3,8(sp)
    80001ab4:	6a02                	ld	s4,0(sp)
    80001ab6:	6145                	addi	sp,sp,48
    80001ab8:	8082                	ret
    memmove(dst, (char*)src, len);
    80001aba:	000a061b          	sext.w	a2,s4
    80001abe:	85ce                	mv	a1,s3
    80001ac0:	854a                	mv	a0,s2
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	88a080e7          	jalr	-1910(ra) # 8000034c <memmove>
    return 0;
    80001aca:	8526                	mv	a0,s1
    80001acc:	bff9                	j	80001aaa <either_copyin+0x32>

0000000080001ace <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ace:	715d                	addi	sp,sp,-80
    80001ad0:	e486                	sd	ra,72(sp)
    80001ad2:	e0a2                	sd	s0,64(sp)
    80001ad4:	fc26                	sd	s1,56(sp)
    80001ad6:	f84a                	sd	s2,48(sp)
    80001ad8:	f44e                	sd	s3,40(sp)
    80001ada:	f052                	sd	s4,32(sp)
    80001adc:	ec56                	sd	s5,24(sp)
    80001ade:	e85a                	sd	s6,16(sp)
    80001ae0:	e45e                	sd	s7,8(sp)
    80001ae2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ae4:	00006517          	auipc	a0,0x6
    80001ae8:	56450513          	addi	a0,a0,1380 # 80008048 <etext+0x48>
    80001aec:	00004097          	auipc	ra,0x4
    80001af0:	2b6080e7          	jalr	694(ra) # 80005da2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001af4:	00228497          	auipc	s1,0x228
    80001af8:	ae448493          	addi	s1,s1,-1308 # 802295d8 <proc+0x158>
    80001afc:	0022d917          	auipc	s2,0x22d
    80001b00:	4dc90913          	addi	s2,s2,1244 # 8022efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b04:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b06:	00006997          	auipc	s3,0x6
    80001b0a:	6fa98993          	addi	s3,s3,1786 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001b0e:	00006a97          	auipc	s5,0x6
    80001b12:	6faa8a93          	addi	s5,s5,1786 # 80008208 <etext+0x208>
    printf("\n");
    80001b16:	00006a17          	auipc	s4,0x6
    80001b1a:	532a0a13          	addi	s4,s4,1330 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b1e:	00006b97          	auipc	s7,0x6
    80001b22:	722b8b93          	addi	s7,s7,1826 # 80008240 <states.1722>
    80001b26:	a00d                	j	80001b48 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b28:	ed86a583          	lw	a1,-296(a3)
    80001b2c:	8556                	mv	a0,s5
    80001b2e:	00004097          	auipc	ra,0x4
    80001b32:	274080e7          	jalr	628(ra) # 80005da2 <printf>
    printf("\n");
    80001b36:	8552                	mv	a0,s4
    80001b38:	00004097          	auipc	ra,0x4
    80001b3c:	26a080e7          	jalr	618(ra) # 80005da2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b40:	16848493          	addi	s1,s1,360
    80001b44:	03248163          	beq	s1,s2,80001b66 <procdump+0x98>
    if(p->state == UNUSED)
    80001b48:	86a6                	mv	a3,s1
    80001b4a:	ec04a783          	lw	a5,-320(s1)
    80001b4e:	dbed                	beqz	a5,80001b40 <procdump+0x72>
      state = "???";
    80001b50:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b52:	fcfb6be3          	bltu	s6,a5,80001b28 <procdump+0x5a>
    80001b56:	1782                	slli	a5,a5,0x20
    80001b58:	9381                	srli	a5,a5,0x20
    80001b5a:	078e                	slli	a5,a5,0x3
    80001b5c:	97de                	add	a5,a5,s7
    80001b5e:	6390                	ld	a2,0(a5)
    80001b60:	f661                	bnez	a2,80001b28 <procdump+0x5a>
      state = "???";
    80001b62:	864e                	mv	a2,s3
    80001b64:	b7d1                	j	80001b28 <procdump+0x5a>
  }
}
    80001b66:	60a6                	ld	ra,72(sp)
    80001b68:	6406                	ld	s0,64(sp)
    80001b6a:	74e2                	ld	s1,56(sp)
    80001b6c:	7942                	ld	s2,48(sp)
    80001b6e:	79a2                	ld	s3,40(sp)
    80001b70:	7a02                	ld	s4,32(sp)
    80001b72:	6ae2                	ld	s5,24(sp)
    80001b74:	6b42                	ld	s6,16(sp)
    80001b76:	6ba2                	ld	s7,8(sp)
    80001b78:	6161                	addi	sp,sp,80
    80001b7a:	8082                	ret

0000000080001b7c <swtch>:
    80001b7c:	00153023          	sd	ra,0(a0)
    80001b80:	00253423          	sd	sp,8(a0)
    80001b84:	e900                	sd	s0,16(a0)
    80001b86:	ed04                	sd	s1,24(a0)
    80001b88:	03253023          	sd	s2,32(a0)
    80001b8c:	03353423          	sd	s3,40(a0)
    80001b90:	03453823          	sd	s4,48(a0)
    80001b94:	03553c23          	sd	s5,56(a0)
    80001b98:	05653023          	sd	s6,64(a0)
    80001b9c:	05753423          	sd	s7,72(a0)
    80001ba0:	05853823          	sd	s8,80(a0)
    80001ba4:	05953c23          	sd	s9,88(a0)
    80001ba8:	07a53023          	sd	s10,96(a0)
    80001bac:	07b53423          	sd	s11,104(a0)
    80001bb0:	0005b083          	ld	ra,0(a1)
    80001bb4:	0085b103          	ld	sp,8(a1)
    80001bb8:	6980                	ld	s0,16(a1)
    80001bba:	6d84                	ld	s1,24(a1)
    80001bbc:	0205b903          	ld	s2,32(a1)
    80001bc0:	0285b983          	ld	s3,40(a1)
    80001bc4:	0305ba03          	ld	s4,48(a1)
    80001bc8:	0385ba83          	ld	s5,56(a1)
    80001bcc:	0405bb03          	ld	s6,64(a1)
    80001bd0:	0485bb83          	ld	s7,72(a1)
    80001bd4:	0505bc03          	ld	s8,80(a1)
    80001bd8:	0585bc83          	ld	s9,88(a1)
    80001bdc:	0605bd03          	ld	s10,96(a1)
    80001be0:	0685bd83          	ld	s11,104(a1)
    80001be4:	8082                	ret

0000000080001be6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001be6:	1141                	addi	sp,sp,-16
    80001be8:	e406                	sd	ra,8(sp)
    80001bea:	e022                	sd	s0,0(sp)
    80001bec:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bee:	00006597          	auipc	a1,0x6
    80001bf2:	68258593          	addi	a1,a1,1666 # 80008270 <states.1722+0x30>
    80001bf6:	0022d517          	auipc	a0,0x22d
    80001bfa:	28a50513          	addi	a0,a0,650 # 8022ee80 <tickslock>
    80001bfe:	00004097          	auipc	ra,0x4
    80001c02:	614080e7          	jalr	1556(ra) # 80006212 <initlock>
}
    80001c06:	60a2                	ld	ra,8(sp)
    80001c08:	6402                	ld	s0,0(sp)
    80001c0a:	0141                	addi	sp,sp,16
    80001c0c:	8082                	ret

0000000080001c0e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c0e:	1141                	addi	sp,sp,-16
    80001c10:	e422                	sd	s0,8(sp)
    80001c12:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c14:	00003797          	auipc	a5,0x3
    80001c18:	54c78793          	addi	a5,a5,1356 # 80005160 <kernelvec>
    80001c1c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c20:	6422                	ld	s0,8(sp)
    80001c22:	0141                	addi	sp,sp,16
    80001c24:	8082                	ret

0000000080001c26 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c26:	1141                	addi	sp,sp,-16
    80001c28:	e406                	sd	ra,8(sp)
    80001c2a:	e022                	sd	s0,0(sp)
    80001c2c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c2e:	fffff097          	auipc	ra,0xfffff
    80001c32:	394080e7          	jalr	916(ra) # 80000fc2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c36:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c3a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c3c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c40:	00005617          	auipc	a2,0x5
    80001c44:	3c060613          	addi	a2,a2,960 # 80007000 <_trampoline>
    80001c48:	00005697          	auipc	a3,0x5
    80001c4c:	3b868693          	addi	a3,a3,952 # 80007000 <_trampoline>
    80001c50:	8e91                	sub	a3,a3,a2
    80001c52:	040007b7          	lui	a5,0x4000
    80001c56:	17fd                	addi	a5,a5,-1
    80001c58:	07b2                	slli	a5,a5,0xc
    80001c5a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c5c:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c60:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c62:	180026f3          	csrr	a3,satp
    80001c66:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c68:	6d38                	ld	a4,88(a0)
    80001c6a:	6134                	ld	a3,64(a0)
    80001c6c:	6585                	lui	a1,0x1
    80001c6e:	96ae                	add	a3,a3,a1
    80001c70:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c72:	6d38                	ld	a4,88(a0)
    80001c74:	00000697          	auipc	a3,0x0
    80001c78:	2aa68693          	addi	a3,a3,682 # 80001f1e <usertrap>
    80001c7c:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c7e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c80:	8692                	mv	a3,tp
    80001c82:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c84:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c88:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c8c:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c90:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c94:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c96:	6f18                	ld	a4,24(a4)
    80001c98:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c9c:	692c                	ld	a1,80(a0)
    80001c9e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001ca0:	00005717          	auipc	a4,0x5
    80001ca4:	3f070713          	addi	a4,a4,1008 # 80007090 <userret>
    80001ca8:	8f11                	sub	a4,a4,a2
    80001caa:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cac:	577d                	li	a4,-1
    80001cae:	177e                	slli	a4,a4,0x3f
    80001cb0:	8dd9                	or	a1,a1,a4
    80001cb2:	02000537          	lui	a0,0x2000
    80001cb6:	157d                	addi	a0,a0,-1
    80001cb8:	0536                	slli	a0,a0,0xd
    80001cba:	9782                	jalr	a5
}
    80001cbc:	60a2                	ld	ra,8(sp)
    80001cbe:	6402                	ld	s0,0(sp)
    80001cc0:	0141                	addi	sp,sp,16
    80001cc2:	8082                	ret

0000000080001cc4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cc4:	1101                	addi	sp,sp,-32
    80001cc6:	ec06                	sd	ra,24(sp)
    80001cc8:	e822                	sd	s0,16(sp)
    80001cca:	e426                	sd	s1,8(sp)
    80001ccc:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cce:	0022d497          	auipc	s1,0x22d
    80001cd2:	1b248493          	addi	s1,s1,434 # 8022ee80 <tickslock>
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	5ca080e7          	jalr	1482(ra) # 800062a2 <acquire>
  ticks++;
    80001ce0:	00007517          	auipc	a0,0x7
    80001ce4:	33850513          	addi	a0,a0,824 # 80009018 <ticks>
    80001ce8:	411c                	lw	a5,0(a0)
    80001cea:	2785                	addiw	a5,a5,1
    80001cec:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	b1c080e7          	jalr	-1252(ra) # 8000180a <wakeup>
  release(&tickslock);
    80001cf6:	8526                	mv	a0,s1
    80001cf8:	00004097          	auipc	ra,0x4
    80001cfc:	65e080e7          	jalr	1630(ra) # 80006356 <release>
}
    80001d00:	60e2                	ld	ra,24(sp)
    80001d02:	6442                	ld	s0,16(sp)
    80001d04:	64a2                	ld	s1,8(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret

0000000080001d0a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d0a:	1101                	addi	sp,sp,-32
    80001d0c:	ec06                	sd	ra,24(sp)
    80001d0e:	e822                	sd	s0,16(sp)
    80001d10:	e426                	sd	s1,8(sp)
    80001d12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d14:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d18:	00074d63          	bltz	a4,80001d32 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d1c:	57fd                	li	a5,-1
    80001d1e:	17fe                	slli	a5,a5,0x3f
    80001d20:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d22:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d24:	06f70363          	beq	a4,a5,80001d8a <devintr+0x80>
  }
}
    80001d28:	60e2                	ld	ra,24(sp)
    80001d2a:	6442                	ld	s0,16(sp)
    80001d2c:	64a2                	ld	s1,8(sp)
    80001d2e:	6105                	addi	sp,sp,32
    80001d30:	8082                	ret
     (scause & 0xff) == 9){
    80001d32:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d36:	46a5                	li	a3,9
    80001d38:	fed792e3          	bne	a5,a3,80001d1c <devintr+0x12>
    int irq = plic_claim();
    80001d3c:	00003097          	auipc	ra,0x3
    80001d40:	52c080e7          	jalr	1324(ra) # 80005268 <plic_claim>
    80001d44:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d46:	47a9                	li	a5,10
    80001d48:	02f50763          	beq	a0,a5,80001d76 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d4c:	4785                	li	a5,1
    80001d4e:	02f50963          	beq	a0,a5,80001d80 <devintr+0x76>
    return 1;
    80001d52:	4505                	li	a0,1
    } else if(irq){
    80001d54:	d8f1                	beqz	s1,80001d28 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d56:	85a6                	mv	a1,s1
    80001d58:	00006517          	auipc	a0,0x6
    80001d5c:	52050513          	addi	a0,a0,1312 # 80008278 <states.1722+0x38>
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	042080e7          	jalr	66(ra) # 80005da2 <printf>
      plic_complete(irq);
    80001d68:	8526                	mv	a0,s1
    80001d6a:	00003097          	auipc	ra,0x3
    80001d6e:	522080e7          	jalr	1314(ra) # 8000528c <plic_complete>
    return 1;
    80001d72:	4505                	li	a0,1
    80001d74:	bf55                	j	80001d28 <devintr+0x1e>
      uartintr();
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	44c080e7          	jalr	1100(ra) # 800061c2 <uartintr>
    80001d7e:	b7ed                	j	80001d68 <devintr+0x5e>
      virtio_disk_intr();
    80001d80:	00004097          	auipc	ra,0x4
    80001d84:	9ec080e7          	jalr	-1556(ra) # 8000576c <virtio_disk_intr>
    80001d88:	b7c5                	j	80001d68 <devintr+0x5e>
    if(cpuid() == 0){
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	20c080e7          	jalr	524(ra) # 80000f96 <cpuid>
    80001d92:	c901                	beqz	a0,80001da2 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d94:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d9a:	14479073          	csrw	sip,a5
    return 2;
    80001d9e:	4509                	li	a0,2
    80001da0:	b761                	j	80001d28 <devintr+0x1e>
      clockintr();
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	f22080e7          	jalr	-222(ra) # 80001cc4 <clockintr>
    80001daa:	b7ed                	j	80001d94 <devintr+0x8a>

0000000080001dac <kerneltrap>:
{
    80001dac:	7179                	addi	sp,sp,-48
    80001dae:	f406                	sd	ra,40(sp)
    80001db0:	f022                	sd	s0,32(sp)
    80001db2:	ec26                	sd	s1,24(sp)
    80001db4:	e84a                	sd	s2,16(sp)
    80001db6:	e44e                	sd	s3,8(sp)
    80001db8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dbe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dc6:	1004f793          	andi	a5,s1,256
    80001dca:	cb85                	beqz	a5,80001dfa <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dd2:	ef85                	bnez	a5,80001e0a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	f36080e7          	jalr	-202(ra) # 80001d0a <devintr>
    80001ddc:	cd1d                	beqz	a0,80001e1a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dde:	4789                	li	a5,2
    80001de0:	06f50a63          	beq	a0,a5,80001e54 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001de4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de8:	10049073          	csrw	sstatus,s1
}
    80001dec:	70a2                	ld	ra,40(sp)
    80001dee:	7402                	ld	s0,32(sp)
    80001df0:	64e2                	ld	s1,24(sp)
    80001df2:	6942                	ld	s2,16(sp)
    80001df4:	69a2                	ld	s3,8(sp)
    80001df6:	6145                	addi	sp,sp,48
    80001df8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	49e50513          	addi	a0,a0,1182 # 80008298 <states.1722+0x58>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	f56080e7          	jalr	-170(ra) # 80005d58 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e0a:	00006517          	auipc	a0,0x6
    80001e0e:	4b650513          	addi	a0,a0,1206 # 800082c0 <states.1722+0x80>
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	f46080e7          	jalr	-186(ra) # 80005d58 <panic>
    printf("scause %p\n", scause);
    80001e1a:	85ce                	mv	a1,s3
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	4c450513          	addi	a0,a0,1220 # 800082e0 <states.1722+0xa0>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	f7e080e7          	jalr	-130(ra) # 80005da2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e30:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	4bc50513          	addi	a0,a0,1212 # 800082f0 <states.1722+0xb0>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	f66080e7          	jalr	-154(ra) # 80005da2 <printf>
    panic("kerneltrap");
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	4c450513          	addi	a0,a0,1220 # 80008308 <states.1722+0xc8>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	f0c080e7          	jalr	-244(ra) # 80005d58 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	16e080e7          	jalr	366(ra) # 80000fc2 <myproc>
    80001e5c:	d541                	beqz	a0,80001de4 <kerneltrap+0x38>
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	164080e7          	jalr	356(ra) # 80000fc2 <myproc>
    80001e66:	4d18                	lw	a4,24(a0)
    80001e68:	4791                	li	a5,4
    80001e6a:	f6f71de3          	bne	a4,a5,80001de4 <kerneltrap+0x38>
    yield();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	7d4080e7          	jalr	2004(ra) # 80001642 <yield>
    80001e76:	b7bd                	j	80001de4 <kerneltrap+0x38>

0000000080001e78 <cowhandler>:

int cowhandler(pagetable_t pagetable, uint64 va) {
  // Check if va is within the limits
  va = PGROUNDDOWN(va);
    80001e78:	77fd                	lui	a5,0xfffff
    80001e7a:	8dfd                	and	a1,a1,a5
  if (va >= MAXVA)  
    80001e7c:	57fd                	li	a5,-1
    80001e7e:	83e9                	srli	a5,a5,0x1a
    80001e80:	00b7f463          	bgeu	a5,a1,80001e88 <cowhandler+0x10>
    return -1;
    80001e84:	557d                	li	a0,-1
    kfree((void*)pa);
    return 0;
  } else {
    return -1;
  }
}
    80001e86:	8082                	ret
int cowhandler(pagetable_t pagetable, uint64 va) {
    80001e88:	7179                	addi	sp,sp,-48
    80001e8a:	f406                	sd	ra,40(sp)
    80001e8c:	f022                	sd	s0,32(sp)
    80001e8e:	ec26                	sd	s1,24(sp)
    80001e90:	e84a                	sd	s2,16(sp)
    80001e92:	e44e                	sd	s3,8(sp)
    80001e94:	e052                	sd	s4,0(sp)
    80001e96:	1800                	addi	s0,sp,48
  if ((pte = walk(pagetable, va, 0)) == 0)
    80001e98:	4601                	li	a2,0
    80001e9a:	ffffe097          	auipc	ra,0xffffe
    80001e9e:	73a080e7          	jalr	1850(ra) # 800005d4 <walk>
    80001ea2:	84aa                	mv	s1,a0
    80001ea4:	c93d                	beqz	a0,80001f1a <cowhandler+0xa2>
  if ((*pte & PTE_RSW) == 0)
    80001ea6:	00053903          	ld	s2,0(a0)
    80001eaa:	10097793          	andi	a5,s2,256
    return 1;
    80001eae:	4505                	li	a0,1
  if ((*pte & PTE_RSW) == 0)
    80001eb0:	c799                	beqz	a5,80001ebe <cowhandler+0x46>
  if ((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80001eb2:	01197793          	andi	a5,s2,17
    80001eb6:	4745                	li	a4,17
    return -1;
    80001eb8:	557d                	li	a0,-1
  if ((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80001eba:	00e78a63          	beq	a5,a4,80001ece <cowhandler+0x56>
}
    80001ebe:	70a2                	ld	ra,40(sp)
    80001ec0:	7402                	ld	s0,32(sp)
    80001ec2:	64e2                	ld	s1,24(sp)
    80001ec4:	6942                	ld	s2,16(sp)
    80001ec6:	69a2                	ld	s3,8(sp)
    80001ec8:	6a02                	ld	s4,0(sp)
    80001eca:	6145                	addi	sp,sp,48
    80001ecc:	8082                	ret
  char *mem = kalloc();
    80001ece:	ffffe097          	auipc	ra,0xffffe
    80001ed2:	3a4080e7          	jalr	932(ra) # 80000272 <kalloc>
    80001ed6:	89aa                	mv	s3,a0
    return -1;
    80001ed8:	557d                	li	a0,-1
  if (mem != 0) {
    80001eda:	fe0982e3          	beqz	s3,80001ebe <cowhandler+0x46>
    uint64 pa = PTE2PA(*pte);
    80001ede:	0004ba03          	ld	s4,0(s1)
    80001ee2:	00aa5a13          	srli	s4,s4,0xa
    80001ee6:	0a32                	slli	s4,s4,0xc
    memmove(mem, (char*)pa, PGSIZE);
    80001ee8:	6605                	lui	a2,0x1
    80001eea:	85d2                	mv	a1,s4
    80001eec:	854e                	mv	a0,s3
    80001eee:	ffffe097          	auipc	ra,0xffffe
    80001ef2:	45e080e7          	jalr	1118(ra) # 8000034c <memmove>
    *pte = PA2PTE(mem) | ((flags & (~PTE_RSW)) | PTE_W);
    80001ef6:	00c9d993          	srli	s3,s3,0xc
    80001efa:	09aa                	slli	s3,s3,0xa
    80001efc:	2fb97913          	andi	s2,s2,763
    80001f00:	0129e933          	or	s2,s3,s2
    80001f04:	00496913          	ori	s2,s2,4
    80001f08:	0124b023          	sd	s2,0(s1)
    kfree((void*)pa);
    80001f0c:	8552                	mv	a0,s4
    80001f0e:	ffffe097          	auipc	ra,0xffffe
    80001f12:	1ec080e7          	jalr	492(ra) # 800000fa <kfree>
    return 0;
    80001f16:	4501                	li	a0,0
    80001f18:	b75d                	j	80001ebe <cowhandler+0x46>
    return -1;
    80001f1a:	557d                	li	a0,-1
    80001f1c:	b74d                	j	80001ebe <cowhandler+0x46>

0000000080001f1e <usertrap>:
{
    80001f1e:	1101                	addi	sp,sp,-32
    80001f20:	ec06                	sd	ra,24(sp)
    80001f22:	e822                	sd	s0,16(sp)
    80001f24:	e426                	sd	s1,8(sp)
    80001f26:	e04a                	sd	s2,0(sp)
    80001f28:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f2e:	1007f793          	andi	a5,a5,256
    80001f32:	e3b9                	bnez	a5,80001f78 <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f34:	00003797          	auipc	a5,0x3
    80001f38:	22c78793          	addi	a5,a5,556 # 80005160 <kernelvec>
    80001f3c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	082080e7          	jalr	130(ra) # 80000fc2 <myproc>
    80001f48:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f4a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f4c:	14102773          	csrr	a4,sepc
    80001f50:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f52:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f56:	47a1                	li	a5,8
    80001f58:	02f70863          	beq	a4,a5,80001f88 <usertrap+0x6a>
    80001f5c:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15) {
    80001f60:	47bd                	li	a5,15
    80001f62:	06f70563          	beq	a4,a5,80001fcc <usertrap+0xae>
  } else if((which_dev = devintr()) != 0){
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	da4080e7          	jalr	-604(ra) # 80001d0a <devintr>
    80001f6e:	892a                	mv	s2,a0
    80001f70:	c92d                	beqz	a0,80001fe2 <usertrap+0xc4>
  if(p->killed)
    80001f72:	549c                	lw	a5,40(s1)
    80001f74:	c7d5                	beqz	a5,80002020 <usertrap+0x102>
    80001f76:	a045                	j	80002016 <usertrap+0xf8>
    panic("usertrap: not from user mode");
    80001f78:	00006517          	auipc	a0,0x6
    80001f7c:	3a050513          	addi	a0,a0,928 # 80008318 <states.1722+0xd8>
    80001f80:	00004097          	auipc	ra,0x4
    80001f84:	dd8080e7          	jalr	-552(ra) # 80005d58 <panic>
    if(p->killed)
    80001f88:	551c                	lw	a5,40(a0)
    80001f8a:	eb9d                	bnez	a5,80001fc0 <usertrap+0xa2>
    p->trapframe->epc += 4;
    80001f8c:	6cb8                	ld	a4,88(s1)
    80001f8e:	6f1c                	ld	a5,24(a4)
    80001f90:	0791                	addi	a5,a5,4
    80001f92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	20a080e7          	jalr	522(ra) # 800021aa <syscall>
  if(p->killed)
    80001fa8:	549c                	lw	a5,40(s1)
    80001faa:	e3d9                	bnez	a5,80002030 <usertrap+0x112>
  usertrapret();
    80001fac:	00000097          	auipc	ra,0x0
    80001fb0:	c7a080e7          	jalr	-902(ra) # 80001c26 <usertrapret>
}
    80001fb4:	60e2                	ld	ra,24(sp)
    80001fb6:	6442                	ld	s0,16(sp)
    80001fb8:	64a2                	ld	s1,8(sp)
    80001fba:	6902                	ld	s2,0(sp)
    80001fbc:	6105                	addi	sp,sp,32
    80001fbe:	8082                	ret
      exit(-1);
    80001fc0:	557d                	li	a0,-1
    80001fc2:	00000097          	auipc	ra,0x0
    80001fc6:	918080e7          	jalr	-1768(ra) # 800018da <exit>
    80001fca:	b7c9                	j	80001f8c <usertrap+0x6e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fcc:	143025f3          	csrr	a1,stval
    if (cowhandler(p->pagetable, va) != 0) {
    80001fd0:	6928                	ld	a0,80(a0)
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	ea6080e7          	jalr	-346(ra) # 80001e78 <cowhandler>
    80001fda:	d579                	beqz	a0,80001fa8 <usertrap+0x8a>
      p->killed = 1;
    80001fdc:	4785                	li	a5,1
    80001fde:	d49c                	sw	a5,40(s1)
    80001fe0:	a815                	j	80002014 <usertrap+0xf6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fe2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fe6:	5890                	lw	a2,48(s1)
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	35050513          	addi	a0,a0,848 # 80008338 <states.1722+0xf8>
    80001ff0:	00004097          	auipc	ra,0x4
    80001ff4:	db2080e7          	jalr	-590(ra) # 80005da2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ff8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ffc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002000:	00006517          	auipc	a0,0x6
    80002004:	36850513          	addi	a0,a0,872 # 80008368 <states.1722+0x128>
    80002008:	00004097          	auipc	ra,0x4
    8000200c:	d9a080e7          	jalr	-614(ra) # 80005da2 <printf>
    p->killed = 1;
    80002010:	4785                	li	a5,1
    80002012:	d49c                	sw	a5,40(s1)
{
    80002014:	4901                	li	s2,0
    exit(-1);
    80002016:	557d                	li	a0,-1
    80002018:	00000097          	auipc	ra,0x0
    8000201c:	8c2080e7          	jalr	-1854(ra) # 800018da <exit>
  if(which_dev == 2)
    80002020:	4789                	li	a5,2
    80002022:	f8f915e3          	bne	s2,a5,80001fac <usertrap+0x8e>
    yield();
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	61c080e7          	jalr	1564(ra) # 80001642 <yield>
    8000202e:	bfbd                	j	80001fac <usertrap+0x8e>
  if(p->killed)
    80002030:	4901                	li	s2,0
    80002032:	b7d5                	j	80002016 <usertrap+0xf8>

0000000080002034 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	1000                	addi	s0,sp,32
    8000203e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	f82080e7          	jalr	-126(ra) # 80000fc2 <myproc>
  switch (n) {
    80002048:	4795                	li	a5,5
    8000204a:	0497e163          	bltu	a5,s1,8000208c <argraw+0x58>
    8000204e:	048a                	slli	s1,s1,0x2
    80002050:	00006717          	auipc	a4,0x6
    80002054:	36070713          	addi	a4,a4,864 # 800083b0 <states.1722+0x170>
    80002058:	94ba                	add	s1,s1,a4
    8000205a:	409c                	lw	a5,0(s1)
    8000205c:	97ba                	add	a5,a5,a4
    8000205e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002060:	6d3c                	ld	a5,88(a0)
    80002062:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6105                	addi	sp,sp,32
    8000206c:	8082                	ret
    return p->trapframe->a1;
    8000206e:	6d3c                	ld	a5,88(a0)
    80002070:	7fa8                	ld	a0,120(a5)
    80002072:	bfcd                	j	80002064 <argraw+0x30>
    return p->trapframe->a2;
    80002074:	6d3c                	ld	a5,88(a0)
    80002076:	63c8                	ld	a0,128(a5)
    80002078:	b7f5                	j	80002064 <argraw+0x30>
    return p->trapframe->a3;
    8000207a:	6d3c                	ld	a5,88(a0)
    8000207c:	67c8                	ld	a0,136(a5)
    8000207e:	b7dd                	j	80002064 <argraw+0x30>
    return p->trapframe->a4;
    80002080:	6d3c                	ld	a5,88(a0)
    80002082:	6bc8                	ld	a0,144(a5)
    80002084:	b7c5                	j	80002064 <argraw+0x30>
    return p->trapframe->a5;
    80002086:	6d3c                	ld	a5,88(a0)
    80002088:	6fc8                	ld	a0,152(a5)
    8000208a:	bfe9                	j	80002064 <argraw+0x30>
  panic("argraw");
    8000208c:	00006517          	auipc	a0,0x6
    80002090:	2fc50513          	addi	a0,a0,764 # 80008388 <states.1722+0x148>
    80002094:	00004097          	auipc	ra,0x4
    80002098:	cc4080e7          	jalr	-828(ra) # 80005d58 <panic>

000000008000209c <fetchaddr>:
{
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	e426                	sd	s1,8(sp)
    800020a4:	e04a                	sd	s2,0(sp)
    800020a6:	1000                	addi	s0,sp,32
    800020a8:	84aa                	mv	s1,a0
    800020aa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	f16080e7          	jalr	-234(ra) # 80000fc2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020b4:	653c                	ld	a5,72(a0)
    800020b6:	02f4f863          	bgeu	s1,a5,800020e6 <fetchaddr+0x4a>
    800020ba:	00848713          	addi	a4,s1,8
    800020be:	02e7e663          	bltu	a5,a4,800020ea <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020c2:	46a1                	li	a3,8
    800020c4:	8626                	mv	a2,s1
    800020c6:	85ca                	mv	a1,s2
    800020c8:	6928                	ld	a0,80(a0)
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	c46080e7          	jalr	-954(ra) # 80000d10 <copyin>
    800020d2:	00a03533          	snez	a0,a0
    800020d6:	40a00533          	neg	a0,a0
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	64a2                	ld	s1,8(sp)
    800020e0:	6902                	ld	s2,0(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret
    return -1;
    800020e6:	557d                	li	a0,-1
    800020e8:	bfcd                	j	800020da <fetchaddr+0x3e>
    800020ea:	557d                	li	a0,-1
    800020ec:	b7fd                	j	800020da <fetchaddr+0x3e>

00000000800020ee <fetchstr>:
{
    800020ee:	7179                	addi	sp,sp,-48
    800020f0:	f406                	sd	ra,40(sp)
    800020f2:	f022                	sd	s0,32(sp)
    800020f4:	ec26                	sd	s1,24(sp)
    800020f6:	e84a                	sd	s2,16(sp)
    800020f8:	e44e                	sd	s3,8(sp)
    800020fa:	1800                	addi	s0,sp,48
    800020fc:	892a                	mv	s2,a0
    800020fe:	84ae                	mv	s1,a1
    80002100:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	ec0080e7          	jalr	-320(ra) # 80000fc2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000210a:	86ce                	mv	a3,s3
    8000210c:	864a                	mv	a2,s2
    8000210e:	85a6                	mv	a1,s1
    80002110:	6928                	ld	a0,80(a0)
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	c8a080e7          	jalr	-886(ra) # 80000d9c <copyinstr>
  if(err < 0)
    8000211a:	00054763          	bltz	a0,80002128 <fetchstr+0x3a>
  return strlen(buf);
    8000211e:	8526                	mv	a0,s1
    80002120:	ffffe097          	auipc	ra,0xffffe
    80002124:	350080e7          	jalr	848(ra) # 80000470 <strlen>
}
    80002128:	70a2                	ld	ra,40(sp)
    8000212a:	7402                	ld	s0,32(sp)
    8000212c:	64e2                	ld	s1,24(sp)
    8000212e:	6942                	ld	s2,16(sp)
    80002130:	69a2                	ld	s3,8(sp)
    80002132:	6145                	addi	sp,sp,48
    80002134:	8082                	ret

0000000080002136 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002136:	1101                	addi	sp,sp,-32
    80002138:	ec06                	sd	ra,24(sp)
    8000213a:	e822                	sd	s0,16(sp)
    8000213c:	e426                	sd	s1,8(sp)
    8000213e:	1000                	addi	s0,sp,32
    80002140:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002142:	00000097          	auipc	ra,0x0
    80002146:	ef2080e7          	jalr	-270(ra) # 80002034 <argraw>
    8000214a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000214c:	4501                	li	a0,0
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	64a2                	ld	s1,8(sp)
    80002154:	6105                	addi	sp,sp,32
    80002156:	8082                	ret

0000000080002158 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002158:	1101                	addi	sp,sp,-32
    8000215a:	ec06                	sd	ra,24(sp)
    8000215c:	e822                	sd	s0,16(sp)
    8000215e:	e426                	sd	s1,8(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002164:	00000097          	auipc	ra,0x0
    80002168:	ed0080e7          	jalr	-304(ra) # 80002034 <argraw>
    8000216c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000216e:	4501                	li	a0,0
    80002170:	60e2                	ld	ra,24(sp)
    80002172:	6442                	ld	s0,16(sp)
    80002174:	64a2                	ld	s1,8(sp)
    80002176:	6105                	addi	sp,sp,32
    80002178:	8082                	ret

000000008000217a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000217a:	1101                	addi	sp,sp,-32
    8000217c:	ec06                	sd	ra,24(sp)
    8000217e:	e822                	sd	s0,16(sp)
    80002180:	e426                	sd	s1,8(sp)
    80002182:	e04a                	sd	s2,0(sp)
    80002184:	1000                	addi	s0,sp,32
    80002186:	84ae                	mv	s1,a1
    80002188:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	eaa080e7          	jalr	-342(ra) # 80002034 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002192:	864a                	mv	a2,s2
    80002194:	85a6                	mv	a1,s1
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	f58080e7          	jalr	-168(ra) # 800020ee <fetchstr>
}
    8000219e:	60e2                	ld	ra,24(sp)
    800021a0:	6442                	ld	s0,16(sp)
    800021a2:	64a2                	ld	s1,8(sp)
    800021a4:	6902                	ld	s2,0(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800021aa:	1101                	addi	sp,sp,-32
    800021ac:	ec06                	sd	ra,24(sp)
    800021ae:	e822                	sd	s0,16(sp)
    800021b0:	e426                	sd	s1,8(sp)
    800021b2:	e04a                	sd	s2,0(sp)
    800021b4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	e0c080e7          	jalr	-500(ra) # 80000fc2 <myproc>
    800021be:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021c0:	05853903          	ld	s2,88(a0)
    800021c4:	0a893783          	ld	a5,168(s2)
    800021c8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021cc:	37fd                	addiw	a5,a5,-1
    800021ce:	4751                	li	a4,20
    800021d0:	00f76f63          	bltu	a4,a5,800021ee <syscall+0x44>
    800021d4:	00369713          	slli	a4,a3,0x3
    800021d8:	00006797          	auipc	a5,0x6
    800021dc:	1f078793          	addi	a5,a5,496 # 800083c8 <syscalls>
    800021e0:	97ba                	add	a5,a5,a4
    800021e2:	639c                	ld	a5,0(a5)
    800021e4:	c789                	beqz	a5,800021ee <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021e6:	9782                	jalr	a5
    800021e8:	06a93823          	sd	a0,112(s2)
    800021ec:	a839                	j	8000220a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021ee:	15848613          	addi	a2,s1,344
    800021f2:	588c                	lw	a1,48(s1)
    800021f4:	00006517          	auipc	a0,0x6
    800021f8:	19c50513          	addi	a0,a0,412 # 80008390 <states.1722+0x150>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	ba6080e7          	jalr	-1114(ra) # 80005da2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002204:	6cbc                	ld	a5,88(s1)
    80002206:	577d                	li	a4,-1
    80002208:	fbb8                	sd	a4,112(a5)
  }
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	64a2                	ld	s1,8(sp)
    80002210:	6902                	ld	s2,0(sp)
    80002212:	6105                	addi	sp,sp,32
    80002214:	8082                	ret

0000000080002216 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002216:	1101                	addi	sp,sp,-32
    80002218:	ec06                	sd	ra,24(sp)
    8000221a:	e822                	sd	s0,16(sp)
    8000221c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000221e:	fec40593          	addi	a1,s0,-20
    80002222:	4501                	li	a0,0
    80002224:	00000097          	auipc	ra,0x0
    80002228:	f12080e7          	jalr	-238(ra) # 80002136 <argint>
    return -1;
    8000222c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000222e:	00054963          	bltz	a0,80002240 <sys_exit+0x2a>
  exit(n);
    80002232:	fec42503          	lw	a0,-20(s0)
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	6a4080e7          	jalr	1700(ra) # 800018da <exit>
  return 0;  // not reached
    8000223e:	4781                	li	a5,0
}
    80002240:	853e                	mv	a0,a5
    80002242:	60e2                	ld	ra,24(sp)
    80002244:	6442                	ld	s0,16(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000224a:	1141                	addi	sp,sp,-16
    8000224c:	e406                	sd	ra,8(sp)
    8000224e:	e022                	sd	s0,0(sp)
    80002250:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	d70080e7          	jalr	-656(ra) # 80000fc2 <myproc>
}
    8000225a:	5908                	lw	a0,48(a0)
    8000225c:	60a2                	ld	ra,8(sp)
    8000225e:	6402                	ld	s0,0(sp)
    80002260:	0141                	addi	sp,sp,16
    80002262:	8082                	ret

0000000080002264 <sys_fork>:

uint64
sys_fork(void)
{
    80002264:	1141                	addi	sp,sp,-16
    80002266:	e406                	sd	ra,8(sp)
    80002268:	e022                	sd	s0,0(sp)
    8000226a:	0800                	addi	s0,sp,16
  return fork();
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	124080e7          	jalr	292(ra) # 80001390 <fork>
}
    80002274:	60a2                	ld	ra,8(sp)
    80002276:	6402                	ld	s0,0(sp)
    80002278:	0141                	addi	sp,sp,16
    8000227a:	8082                	ret

000000008000227c <sys_wait>:

uint64
sys_wait(void)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002284:	fe840593          	addi	a1,s0,-24
    80002288:	4501                	li	a0,0
    8000228a:	00000097          	auipc	ra,0x0
    8000228e:	ece080e7          	jalr	-306(ra) # 80002158 <argaddr>
    80002292:	87aa                	mv	a5,a0
    return -1;
    80002294:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002296:	0007c863          	bltz	a5,800022a6 <sys_wait+0x2a>
  return wait(p);
    8000229a:	fe843503          	ld	a0,-24(s0)
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	444080e7          	jalr	1092(ra) # 800016e2 <wait>
}
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022b8:	fdc40593          	addi	a1,s0,-36
    800022bc:	4501                	li	a0,0
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	e78080e7          	jalr	-392(ra) # 80002136 <argint>
    800022c6:	87aa                	mv	a5,a0
    return -1;
    800022c8:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022ca:	0207c063          	bltz	a5,800022ea <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	cf4080e7          	jalr	-780(ra) # 80000fc2 <myproc>
    800022d6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022d8:	fdc42503          	lw	a0,-36(s0)
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	040080e7          	jalr	64(ra) # 8000131c <growproc>
    800022e4:	00054863          	bltz	a0,800022f4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022e8:	8526                	mv	a0,s1
}
    800022ea:	70a2                	ld	ra,40(sp)
    800022ec:	7402                	ld	s0,32(sp)
    800022ee:	64e2                	ld	s1,24(sp)
    800022f0:	6145                	addi	sp,sp,48
    800022f2:	8082                	ret
    return -1;
    800022f4:	557d                	li	a0,-1
    800022f6:	bfd5                	j	800022ea <sys_sbrk+0x3c>

00000000800022f8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022f8:	7139                	addi	sp,sp,-64
    800022fa:	fc06                	sd	ra,56(sp)
    800022fc:	f822                	sd	s0,48(sp)
    800022fe:	f426                	sd	s1,40(sp)
    80002300:	f04a                	sd	s2,32(sp)
    80002302:	ec4e                	sd	s3,24(sp)
    80002304:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002306:	fcc40593          	addi	a1,s0,-52
    8000230a:	4501                	li	a0,0
    8000230c:	00000097          	auipc	ra,0x0
    80002310:	e2a080e7          	jalr	-470(ra) # 80002136 <argint>
    return -1;
    80002314:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002316:	06054563          	bltz	a0,80002380 <sys_sleep+0x88>
  acquire(&tickslock);
    8000231a:	0022d517          	auipc	a0,0x22d
    8000231e:	b6650513          	addi	a0,a0,-1178 # 8022ee80 <tickslock>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	f80080e7          	jalr	-128(ra) # 800062a2 <acquire>
  ticks0 = ticks;
    8000232a:	00007917          	auipc	s2,0x7
    8000232e:	cee92903          	lw	s2,-786(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002332:	fcc42783          	lw	a5,-52(s0)
    80002336:	cf85                	beqz	a5,8000236e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002338:	0022d997          	auipc	s3,0x22d
    8000233c:	b4898993          	addi	s3,s3,-1208 # 8022ee80 <tickslock>
    80002340:	00007497          	auipc	s1,0x7
    80002344:	cd848493          	addi	s1,s1,-808 # 80009018 <ticks>
    if(myproc()->killed){
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	c7a080e7          	jalr	-902(ra) # 80000fc2 <myproc>
    80002350:	551c                	lw	a5,40(a0)
    80002352:	ef9d                	bnez	a5,80002390 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002354:	85ce                	mv	a1,s3
    80002356:	8526                	mv	a0,s1
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	326080e7          	jalr	806(ra) # 8000167e <sleep>
  while(ticks - ticks0 < n){
    80002360:	409c                	lw	a5,0(s1)
    80002362:	412787bb          	subw	a5,a5,s2
    80002366:	fcc42703          	lw	a4,-52(s0)
    8000236a:	fce7efe3          	bltu	a5,a4,80002348 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000236e:	0022d517          	auipc	a0,0x22d
    80002372:	b1250513          	addi	a0,a0,-1262 # 8022ee80 <tickslock>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	fe0080e7          	jalr	-32(ra) # 80006356 <release>
  return 0;
    8000237e:	4781                	li	a5,0
}
    80002380:	853e                	mv	a0,a5
    80002382:	70e2                	ld	ra,56(sp)
    80002384:	7442                	ld	s0,48(sp)
    80002386:	74a2                	ld	s1,40(sp)
    80002388:	7902                	ld	s2,32(sp)
    8000238a:	69e2                	ld	s3,24(sp)
    8000238c:	6121                	addi	sp,sp,64
    8000238e:	8082                	ret
      release(&tickslock);
    80002390:	0022d517          	auipc	a0,0x22d
    80002394:	af050513          	addi	a0,a0,-1296 # 8022ee80 <tickslock>
    80002398:	00004097          	auipc	ra,0x4
    8000239c:	fbe080e7          	jalr	-66(ra) # 80006356 <release>
      return -1;
    800023a0:	57fd                	li	a5,-1
    800023a2:	bff9                	j	80002380 <sys_sleep+0x88>

00000000800023a4 <sys_kill>:

uint64
sys_kill(void)
{
    800023a4:	1101                	addi	sp,sp,-32
    800023a6:	ec06                	sd	ra,24(sp)
    800023a8:	e822                	sd	s0,16(sp)
    800023aa:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023ac:	fec40593          	addi	a1,s0,-20
    800023b0:	4501                	li	a0,0
    800023b2:	00000097          	auipc	ra,0x0
    800023b6:	d84080e7          	jalr	-636(ra) # 80002136 <argint>
    800023ba:	87aa                	mv	a5,a0
    return -1;
    800023bc:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023be:	0007c863          	bltz	a5,800023ce <sys_kill+0x2a>
  return kill(pid);
    800023c2:	fec42503          	lw	a0,-20(s0)
    800023c6:	fffff097          	auipc	ra,0xfffff
    800023ca:	5ea080e7          	jalr	1514(ra) # 800019b0 <kill>
}
    800023ce:	60e2                	ld	ra,24(sp)
    800023d0:	6442                	ld	s0,16(sp)
    800023d2:	6105                	addi	sp,sp,32
    800023d4:	8082                	ret

00000000800023d6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023d6:	1101                	addi	sp,sp,-32
    800023d8:	ec06                	sd	ra,24(sp)
    800023da:	e822                	sd	s0,16(sp)
    800023dc:	e426                	sd	s1,8(sp)
    800023de:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023e0:	0022d517          	auipc	a0,0x22d
    800023e4:	aa050513          	addi	a0,a0,-1376 # 8022ee80 <tickslock>
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	eba080e7          	jalr	-326(ra) # 800062a2 <acquire>
  xticks = ticks;
    800023f0:	00007497          	auipc	s1,0x7
    800023f4:	c284a483          	lw	s1,-984(s1) # 80009018 <ticks>
  release(&tickslock);
    800023f8:	0022d517          	auipc	a0,0x22d
    800023fc:	a8850513          	addi	a0,a0,-1400 # 8022ee80 <tickslock>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	f56080e7          	jalr	-170(ra) # 80006356 <release>
  return xticks;
}
    80002408:	02049513          	slli	a0,s1,0x20
    8000240c:	9101                	srli	a0,a0,0x20
    8000240e:	60e2                	ld	ra,24(sp)
    80002410:	6442                	ld	s0,16(sp)
    80002412:	64a2                	ld	s1,8(sp)
    80002414:	6105                	addi	sp,sp,32
    80002416:	8082                	ret

0000000080002418 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002418:	7179                	addi	sp,sp,-48
    8000241a:	f406                	sd	ra,40(sp)
    8000241c:	f022                	sd	s0,32(sp)
    8000241e:	ec26                	sd	s1,24(sp)
    80002420:	e84a                	sd	s2,16(sp)
    80002422:	e44e                	sd	s3,8(sp)
    80002424:	e052                	sd	s4,0(sp)
    80002426:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002428:	00006597          	auipc	a1,0x6
    8000242c:	05058593          	addi	a1,a1,80 # 80008478 <syscalls+0xb0>
    80002430:	0022d517          	auipc	a0,0x22d
    80002434:	a6850513          	addi	a0,a0,-1432 # 8022ee98 <bcache>
    80002438:	00004097          	auipc	ra,0x4
    8000243c:	dda080e7          	jalr	-550(ra) # 80006212 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002440:	00235797          	auipc	a5,0x235
    80002444:	a5878793          	addi	a5,a5,-1448 # 80236e98 <bcache+0x8000>
    80002448:	00235717          	auipc	a4,0x235
    8000244c:	cb870713          	addi	a4,a4,-840 # 80237100 <bcache+0x8268>
    80002450:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002454:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002458:	0022d497          	auipc	s1,0x22d
    8000245c:	a5848493          	addi	s1,s1,-1448 # 8022eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002460:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002462:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002464:	00006a17          	auipc	s4,0x6
    80002468:	01ca0a13          	addi	s4,s4,28 # 80008480 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000246c:	2b893783          	ld	a5,696(s2)
    80002470:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002472:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002476:	85d2                	mv	a1,s4
    80002478:	01048513          	addi	a0,s1,16
    8000247c:	00001097          	auipc	ra,0x1
    80002480:	4bc080e7          	jalr	1212(ra) # 80003938 <initsleeplock>
    bcache.head.next->prev = b;
    80002484:	2b893783          	ld	a5,696(s2)
    80002488:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000248a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000248e:	45848493          	addi	s1,s1,1112
    80002492:	fd349de3          	bne	s1,s3,8000246c <binit+0x54>
  }
}
    80002496:	70a2                	ld	ra,40(sp)
    80002498:	7402                	ld	s0,32(sp)
    8000249a:	64e2                	ld	s1,24(sp)
    8000249c:	6942                	ld	s2,16(sp)
    8000249e:	69a2                	ld	s3,8(sp)
    800024a0:	6a02                	ld	s4,0(sp)
    800024a2:	6145                	addi	sp,sp,48
    800024a4:	8082                	ret

00000000800024a6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024a6:	7179                	addi	sp,sp,-48
    800024a8:	f406                	sd	ra,40(sp)
    800024aa:	f022                	sd	s0,32(sp)
    800024ac:	ec26                	sd	s1,24(sp)
    800024ae:	e84a                	sd	s2,16(sp)
    800024b0:	e44e                	sd	s3,8(sp)
    800024b2:	1800                	addi	s0,sp,48
    800024b4:	89aa                	mv	s3,a0
    800024b6:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024b8:	0022d517          	auipc	a0,0x22d
    800024bc:	9e050513          	addi	a0,a0,-1568 # 8022ee98 <bcache>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	de2080e7          	jalr	-542(ra) # 800062a2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024c8:	00235497          	auipc	s1,0x235
    800024cc:	c884b483          	ld	s1,-888(s1) # 80237150 <bcache+0x82b8>
    800024d0:	00235797          	auipc	a5,0x235
    800024d4:	c3078793          	addi	a5,a5,-976 # 80237100 <bcache+0x8268>
    800024d8:	02f48f63          	beq	s1,a5,80002516 <bread+0x70>
    800024dc:	873e                	mv	a4,a5
    800024de:	a021                	j	800024e6 <bread+0x40>
    800024e0:	68a4                	ld	s1,80(s1)
    800024e2:	02e48a63          	beq	s1,a4,80002516 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024e6:	449c                	lw	a5,8(s1)
    800024e8:	ff379ce3          	bne	a5,s3,800024e0 <bread+0x3a>
    800024ec:	44dc                	lw	a5,12(s1)
    800024ee:	ff2799e3          	bne	a5,s2,800024e0 <bread+0x3a>
      b->refcnt++;
    800024f2:	40bc                	lw	a5,64(s1)
    800024f4:	2785                	addiw	a5,a5,1
    800024f6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024f8:	0022d517          	auipc	a0,0x22d
    800024fc:	9a050513          	addi	a0,a0,-1632 # 8022ee98 <bcache>
    80002500:	00004097          	auipc	ra,0x4
    80002504:	e56080e7          	jalr	-426(ra) # 80006356 <release>
      acquiresleep(&b->lock);
    80002508:	01048513          	addi	a0,s1,16
    8000250c:	00001097          	auipc	ra,0x1
    80002510:	466080e7          	jalr	1126(ra) # 80003972 <acquiresleep>
      return b;
    80002514:	a8b9                	j	80002572 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002516:	00235497          	auipc	s1,0x235
    8000251a:	c324b483          	ld	s1,-974(s1) # 80237148 <bcache+0x82b0>
    8000251e:	00235797          	auipc	a5,0x235
    80002522:	be278793          	addi	a5,a5,-1054 # 80237100 <bcache+0x8268>
    80002526:	00f48863          	beq	s1,a5,80002536 <bread+0x90>
    8000252a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000252c:	40bc                	lw	a5,64(s1)
    8000252e:	cf81                	beqz	a5,80002546 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002530:	64a4                	ld	s1,72(s1)
    80002532:	fee49de3          	bne	s1,a4,8000252c <bread+0x86>
  panic("bget: no buffers");
    80002536:	00006517          	auipc	a0,0x6
    8000253a:	f5250513          	addi	a0,a0,-174 # 80008488 <syscalls+0xc0>
    8000253e:	00004097          	auipc	ra,0x4
    80002542:	81a080e7          	jalr	-2022(ra) # 80005d58 <panic>
      b->dev = dev;
    80002546:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000254a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000254e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002552:	4785                	li	a5,1
    80002554:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002556:	0022d517          	auipc	a0,0x22d
    8000255a:	94250513          	addi	a0,a0,-1726 # 8022ee98 <bcache>
    8000255e:	00004097          	auipc	ra,0x4
    80002562:	df8080e7          	jalr	-520(ra) # 80006356 <release>
      acquiresleep(&b->lock);
    80002566:	01048513          	addi	a0,s1,16
    8000256a:	00001097          	auipc	ra,0x1
    8000256e:	408080e7          	jalr	1032(ra) # 80003972 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002572:	409c                	lw	a5,0(s1)
    80002574:	cb89                	beqz	a5,80002586 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002576:	8526                	mv	a0,s1
    80002578:	70a2                	ld	ra,40(sp)
    8000257a:	7402                	ld	s0,32(sp)
    8000257c:	64e2                	ld	s1,24(sp)
    8000257e:	6942                	ld	s2,16(sp)
    80002580:	69a2                	ld	s3,8(sp)
    80002582:	6145                	addi	sp,sp,48
    80002584:	8082                	ret
    virtio_disk_rw(b, 0);
    80002586:	4581                	li	a1,0
    80002588:	8526                	mv	a0,s1
    8000258a:	00003097          	auipc	ra,0x3
    8000258e:	f0c080e7          	jalr	-244(ra) # 80005496 <virtio_disk_rw>
    b->valid = 1;
    80002592:	4785                	li	a5,1
    80002594:	c09c                	sw	a5,0(s1)
  return b;
    80002596:	b7c5                	j	80002576 <bread+0xd0>

0000000080002598 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002598:	1101                	addi	sp,sp,-32
    8000259a:	ec06                	sd	ra,24(sp)
    8000259c:	e822                	sd	s0,16(sp)
    8000259e:	e426                	sd	s1,8(sp)
    800025a0:	1000                	addi	s0,sp,32
    800025a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a4:	0541                	addi	a0,a0,16
    800025a6:	00001097          	auipc	ra,0x1
    800025aa:	466080e7          	jalr	1126(ra) # 80003a0c <holdingsleep>
    800025ae:	cd01                	beqz	a0,800025c6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025b0:	4585                	li	a1,1
    800025b2:	8526                	mv	a0,s1
    800025b4:	00003097          	auipc	ra,0x3
    800025b8:	ee2080e7          	jalr	-286(ra) # 80005496 <virtio_disk_rw>
}
    800025bc:	60e2                	ld	ra,24(sp)
    800025be:	6442                	ld	s0,16(sp)
    800025c0:	64a2                	ld	s1,8(sp)
    800025c2:	6105                	addi	sp,sp,32
    800025c4:	8082                	ret
    panic("bwrite");
    800025c6:	00006517          	auipc	a0,0x6
    800025ca:	eda50513          	addi	a0,a0,-294 # 800084a0 <syscalls+0xd8>
    800025ce:	00003097          	auipc	ra,0x3
    800025d2:	78a080e7          	jalr	1930(ra) # 80005d58 <panic>

00000000800025d6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	e04a                	sd	s2,0(sp)
    800025e0:	1000                	addi	s0,sp,32
    800025e2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025e4:	01050913          	addi	s2,a0,16
    800025e8:	854a                	mv	a0,s2
    800025ea:	00001097          	auipc	ra,0x1
    800025ee:	422080e7          	jalr	1058(ra) # 80003a0c <holdingsleep>
    800025f2:	c92d                	beqz	a0,80002664 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	3d2080e7          	jalr	978(ra) # 800039c8 <releasesleep>

  acquire(&bcache.lock);
    800025fe:	0022d517          	auipc	a0,0x22d
    80002602:	89a50513          	addi	a0,a0,-1894 # 8022ee98 <bcache>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	c9c080e7          	jalr	-868(ra) # 800062a2 <acquire>
  b->refcnt--;
    8000260e:	40bc                	lw	a5,64(s1)
    80002610:	37fd                	addiw	a5,a5,-1
    80002612:	0007871b          	sext.w	a4,a5
    80002616:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002618:	eb05                	bnez	a4,80002648 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000261a:	68bc                	ld	a5,80(s1)
    8000261c:	64b8                	ld	a4,72(s1)
    8000261e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002620:	64bc                	ld	a5,72(s1)
    80002622:	68b8                	ld	a4,80(s1)
    80002624:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002626:	00235797          	auipc	a5,0x235
    8000262a:	87278793          	addi	a5,a5,-1934 # 80236e98 <bcache+0x8000>
    8000262e:	2b87b703          	ld	a4,696(a5)
    80002632:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002634:	00235717          	auipc	a4,0x235
    80002638:	acc70713          	addi	a4,a4,-1332 # 80237100 <bcache+0x8268>
    8000263c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000263e:	2b87b703          	ld	a4,696(a5)
    80002642:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002644:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002648:	0022d517          	auipc	a0,0x22d
    8000264c:	85050513          	addi	a0,a0,-1968 # 8022ee98 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	d06080e7          	jalr	-762(ra) # 80006356 <release>
}
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	64a2                	ld	s1,8(sp)
    8000265e:	6902                	ld	s2,0(sp)
    80002660:	6105                	addi	sp,sp,32
    80002662:	8082                	ret
    panic("brelse");
    80002664:	00006517          	auipc	a0,0x6
    80002668:	e4450513          	addi	a0,a0,-444 # 800084a8 <syscalls+0xe0>
    8000266c:	00003097          	auipc	ra,0x3
    80002670:	6ec080e7          	jalr	1772(ra) # 80005d58 <panic>

0000000080002674 <bpin>:

void
bpin(struct buf *b) {
    80002674:	1101                	addi	sp,sp,-32
    80002676:	ec06                	sd	ra,24(sp)
    80002678:	e822                	sd	s0,16(sp)
    8000267a:	e426                	sd	s1,8(sp)
    8000267c:	1000                	addi	s0,sp,32
    8000267e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002680:	0022d517          	auipc	a0,0x22d
    80002684:	81850513          	addi	a0,a0,-2024 # 8022ee98 <bcache>
    80002688:	00004097          	auipc	ra,0x4
    8000268c:	c1a080e7          	jalr	-998(ra) # 800062a2 <acquire>
  b->refcnt++;
    80002690:	40bc                	lw	a5,64(s1)
    80002692:	2785                	addiw	a5,a5,1
    80002694:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002696:	0022d517          	auipc	a0,0x22d
    8000269a:	80250513          	addi	a0,a0,-2046 # 8022ee98 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	cb8080e7          	jalr	-840(ra) # 80006356 <release>
}
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6105                	addi	sp,sp,32
    800026ae:	8082                	ret

00000000800026b0 <bunpin>:

void
bunpin(struct buf *b) {
    800026b0:	1101                	addi	sp,sp,-32
    800026b2:	ec06                	sd	ra,24(sp)
    800026b4:	e822                	sd	s0,16(sp)
    800026b6:	e426                	sd	s1,8(sp)
    800026b8:	1000                	addi	s0,sp,32
    800026ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026bc:	0022c517          	auipc	a0,0x22c
    800026c0:	7dc50513          	addi	a0,a0,2012 # 8022ee98 <bcache>
    800026c4:	00004097          	auipc	ra,0x4
    800026c8:	bde080e7          	jalr	-1058(ra) # 800062a2 <acquire>
  b->refcnt--;
    800026cc:	40bc                	lw	a5,64(s1)
    800026ce:	37fd                	addiw	a5,a5,-1
    800026d0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026d2:	0022c517          	auipc	a0,0x22c
    800026d6:	7c650513          	addi	a0,a0,1990 # 8022ee98 <bcache>
    800026da:	00004097          	auipc	ra,0x4
    800026de:	c7c080e7          	jalr	-900(ra) # 80006356 <release>
}
    800026e2:	60e2                	ld	ra,24(sp)
    800026e4:	6442                	ld	s0,16(sp)
    800026e6:	64a2                	ld	s1,8(sp)
    800026e8:	6105                	addi	sp,sp,32
    800026ea:	8082                	ret

00000000800026ec <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026ec:	1101                	addi	sp,sp,-32
    800026ee:	ec06                	sd	ra,24(sp)
    800026f0:	e822                	sd	s0,16(sp)
    800026f2:	e426                	sd	s1,8(sp)
    800026f4:	e04a                	sd	s2,0(sp)
    800026f6:	1000                	addi	s0,sp,32
    800026f8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026fa:	00d5d59b          	srliw	a1,a1,0xd
    800026fe:	00235797          	auipc	a5,0x235
    80002702:	e767a783          	lw	a5,-394(a5) # 80237574 <sb+0x1c>
    80002706:	9dbd                	addw	a1,a1,a5
    80002708:	00000097          	auipc	ra,0x0
    8000270c:	d9e080e7          	jalr	-610(ra) # 800024a6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002710:	0074f713          	andi	a4,s1,7
    80002714:	4785                	li	a5,1
    80002716:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000271a:	14ce                	slli	s1,s1,0x33
    8000271c:	90d9                	srli	s1,s1,0x36
    8000271e:	00950733          	add	a4,a0,s1
    80002722:	05874703          	lbu	a4,88(a4)
    80002726:	00e7f6b3          	and	a3,a5,a4
    8000272a:	c69d                	beqz	a3,80002758 <bfree+0x6c>
    8000272c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000272e:	94aa                	add	s1,s1,a0
    80002730:	fff7c793          	not	a5,a5
    80002734:	8ff9                	and	a5,a5,a4
    80002736:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000273a:	00001097          	auipc	ra,0x1
    8000273e:	118080e7          	jalr	280(ra) # 80003852 <log_write>
  brelse(bp);
    80002742:	854a                	mv	a0,s2
    80002744:	00000097          	auipc	ra,0x0
    80002748:	e92080e7          	jalr	-366(ra) # 800025d6 <brelse>
}
    8000274c:	60e2                	ld	ra,24(sp)
    8000274e:	6442                	ld	s0,16(sp)
    80002750:	64a2                	ld	s1,8(sp)
    80002752:	6902                	ld	s2,0(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret
    panic("freeing free block");
    80002758:	00006517          	auipc	a0,0x6
    8000275c:	d5850513          	addi	a0,a0,-680 # 800084b0 <syscalls+0xe8>
    80002760:	00003097          	auipc	ra,0x3
    80002764:	5f8080e7          	jalr	1528(ra) # 80005d58 <panic>

0000000080002768 <balloc>:
{
    80002768:	711d                	addi	sp,sp,-96
    8000276a:	ec86                	sd	ra,88(sp)
    8000276c:	e8a2                	sd	s0,80(sp)
    8000276e:	e4a6                	sd	s1,72(sp)
    80002770:	e0ca                	sd	s2,64(sp)
    80002772:	fc4e                	sd	s3,56(sp)
    80002774:	f852                	sd	s4,48(sp)
    80002776:	f456                	sd	s5,40(sp)
    80002778:	f05a                	sd	s6,32(sp)
    8000277a:	ec5e                	sd	s7,24(sp)
    8000277c:	e862                	sd	s8,16(sp)
    8000277e:	e466                	sd	s9,8(sp)
    80002780:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002782:	00235797          	auipc	a5,0x235
    80002786:	dda7a783          	lw	a5,-550(a5) # 8023755c <sb+0x4>
    8000278a:	cbd1                	beqz	a5,8000281e <balloc+0xb6>
    8000278c:	8baa                	mv	s7,a0
    8000278e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002790:	00235b17          	auipc	s6,0x235
    80002794:	dc8b0b13          	addi	s6,s6,-568 # 80237558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002798:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000279a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000279e:	6c89                	lui	s9,0x2
    800027a0:	a831                	j	800027bc <balloc+0x54>
    brelse(bp);
    800027a2:	854a                	mv	a0,s2
    800027a4:	00000097          	auipc	ra,0x0
    800027a8:	e32080e7          	jalr	-462(ra) # 800025d6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027ac:	015c87bb          	addw	a5,s9,s5
    800027b0:	00078a9b          	sext.w	s5,a5
    800027b4:	004b2703          	lw	a4,4(s6)
    800027b8:	06eaf363          	bgeu	s5,a4,8000281e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027bc:	41fad79b          	sraiw	a5,s5,0x1f
    800027c0:	0137d79b          	srliw	a5,a5,0x13
    800027c4:	015787bb          	addw	a5,a5,s5
    800027c8:	40d7d79b          	sraiw	a5,a5,0xd
    800027cc:	01cb2583          	lw	a1,28(s6)
    800027d0:	9dbd                	addw	a1,a1,a5
    800027d2:	855e                	mv	a0,s7
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	cd2080e7          	jalr	-814(ra) # 800024a6 <bread>
    800027dc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027de:	004b2503          	lw	a0,4(s6)
    800027e2:	000a849b          	sext.w	s1,s5
    800027e6:	8662                	mv	a2,s8
    800027e8:	faa4fde3          	bgeu	s1,a0,800027a2 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027ec:	41f6579b          	sraiw	a5,a2,0x1f
    800027f0:	01d7d69b          	srliw	a3,a5,0x1d
    800027f4:	00c6873b          	addw	a4,a3,a2
    800027f8:	00777793          	andi	a5,a4,7
    800027fc:	9f95                	subw	a5,a5,a3
    800027fe:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002802:	4037571b          	sraiw	a4,a4,0x3
    80002806:	00e906b3          	add	a3,s2,a4
    8000280a:	0586c683          	lbu	a3,88(a3)
    8000280e:	00d7f5b3          	and	a1,a5,a3
    80002812:	cd91                	beqz	a1,8000282e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002814:	2605                	addiw	a2,a2,1
    80002816:	2485                	addiw	s1,s1,1
    80002818:	fd4618e3          	bne	a2,s4,800027e8 <balloc+0x80>
    8000281c:	b759                	j	800027a2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000281e:	00006517          	auipc	a0,0x6
    80002822:	caa50513          	addi	a0,a0,-854 # 800084c8 <syscalls+0x100>
    80002826:	00003097          	auipc	ra,0x3
    8000282a:	532080e7          	jalr	1330(ra) # 80005d58 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000282e:	974a                	add	a4,a4,s2
    80002830:	8fd5                	or	a5,a5,a3
    80002832:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002836:	854a                	mv	a0,s2
    80002838:	00001097          	auipc	ra,0x1
    8000283c:	01a080e7          	jalr	26(ra) # 80003852 <log_write>
        brelse(bp);
    80002840:	854a                	mv	a0,s2
    80002842:	00000097          	auipc	ra,0x0
    80002846:	d94080e7          	jalr	-620(ra) # 800025d6 <brelse>
  bp = bread(dev, bno);
    8000284a:	85a6                	mv	a1,s1
    8000284c:	855e                	mv	a0,s7
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	c58080e7          	jalr	-936(ra) # 800024a6 <bread>
    80002856:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002858:	40000613          	li	a2,1024
    8000285c:	4581                	li	a1,0
    8000285e:	05850513          	addi	a0,a0,88
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	a8a080e7          	jalr	-1398(ra) # 800002ec <memset>
  log_write(bp);
    8000286a:	854a                	mv	a0,s2
    8000286c:	00001097          	auipc	ra,0x1
    80002870:	fe6080e7          	jalr	-26(ra) # 80003852 <log_write>
  brelse(bp);
    80002874:	854a                	mv	a0,s2
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	d60080e7          	jalr	-672(ra) # 800025d6 <brelse>
}
    8000287e:	8526                	mv	a0,s1
    80002880:	60e6                	ld	ra,88(sp)
    80002882:	6446                	ld	s0,80(sp)
    80002884:	64a6                	ld	s1,72(sp)
    80002886:	6906                	ld	s2,64(sp)
    80002888:	79e2                	ld	s3,56(sp)
    8000288a:	7a42                	ld	s4,48(sp)
    8000288c:	7aa2                	ld	s5,40(sp)
    8000288e:	7b02                	ld	s6,32(sp)
    80002890:	6be2                	ld	s7,24(sp)
    80002892:	6c42                	ld	s8,16(sp)
    80002894:	6ca2                	ld	s9,8(sp)
    80002896:	6125                	addi	sp,sp,96
    80002898:	8082                	ret

000000008000289a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000289a:	7179                	addi	sp,sp,-48
    8000289c:	f406                	sd	ra,40(sp)
    8000289e:	f022                	sd	s0,32(sp)
    800028a0:	ec26                	sd	s1,24(sp)
    800028a2:	e84a                	sd	s2,16(sp)
    800028a4:	e44e                	sd	s3,8(sp)
    800028a6:	e052                	sd	s4,0(sp)
    800028a8:	1800                	addi	s0,sp,48
    800028aa:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028ac:	47ad                	li	a5,11
    800028ae:	04b7fe63          	bgeu	a5,a1,8000290a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028b2:	ff45849b          	addiw	s1,a1,-12
    800028b6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028ba:	0ff00793          	li	a5,255
    800028be:	0ae7e363          	bltu	a5,a4,80002964 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028c2:	08052583          	lw	a1,128(a0)
    800028c6:	c5ad                	beqz	a1,80002930 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028c8:	00092503          	lw	a0,0(s2)
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	bda080e7          	jalr	-1062(ra) # 800024a6 <bread>
    800028d4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028d6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028da:	02049593          	slli	a1,s1,0x20
    800028de:	9181                	srli	a1,a1,0x20
    800028e0:	058a                	slli	a1,a1,0x2
    800028e2:	00b784b3          	add	s1,a5,a1
    800028e6:	0004a983          	lw	s3,0(s1)
    800028ea:	04098d63          	beqz	s3,80002944 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028ee:	8552                	mv	a0,s4
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	ce6080e7          	jalr	-794(ra) # 800025d6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028f8:	854e                	mv	a0,s3
    800028fa:	70a2                	ld	ra,40(sp)
    800028fc:	7402                	ld	s0,32(sp)
    800028fe:	64e2                	ld	s1,24(sp)
    80002900:	6942                	ld	s2,16(sp)
    80002902:	69a2                	ld	s3,8(sp)
    80002904:	6a02                	ld	s4,0(sp)
    80002906:	6145                	addi	sp,sp,48
    80002908:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000290a:	02059493          	slli	s1,a1,0x20
    8000290e:	9081                	srli	s1,s1,0x20
    80002910:	048a                	slli	s1,s1,0x2
    80002912:	94aa                	add	s1,s1,a0
    80002914:	0504a983          	lw	s3,80(s1)
    80002918:	fe0990e3          	bnez	s3,800028f8 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000291c:	4108                	lw	a0,0(a0)
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	e4a080e7          	jalr	-438(ra) # 80002768 <balloc>
    80002926:	0005099b          	sext.w	s3,a0
    8000292a:	0534a823          	sw	s3,80(s1)
    8000292e:	b7e9                	j	800028f8 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002930:	4108                	lw	a0,0(a0)
    80002932:	00000097          	auipc	ra,0x0
    80002936:	e36080e7          	jalr	-458(ra) # 80002768 <balloc>
    8000293a:	0005059b          	sext.w	a1,a0
    8000293e:	08b92023          	sw	a1,128(s2)
    80002942:	b759                	j	800028c8 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002944:	00092503          	lw	a0,0(s2)
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	e20080e7          	jalr	-480(ra) # 80002768 <balloc>
    80002950:	0005099b          	sext.w	s3,a0
    80002954:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002958:	8552                	mv	a0,s4
    8000295a:	00001097          	auipc	ra,0x1
    8000295e:	ef8080e7          	jalr	-264(ra) # 80003852 <log_write>
    80002962:	b771                	j	800028ee <bmap+0x54>
  panic("bmap: out of range");
    80002964:	00006517          	auipc	a0,0x6
    80002968:	b7c50513          	addi	a0,a0,-1156 # 800084e0 <syscalls+0x118>
    8000296c:	00003097          	auipc	ra,0x3
    80002970:	3ec080e7          	jalr	1004(ra) # 80005d58 <panic>

0000000080002974 <iget>:
{
    80002974:	7179                	addi	sp,sp,-48
    80002976:	f406                	sd	ra,40(sp)
    80002978:	f022                	sd	s0,32(sp)
    8000297a:	ec26                	sd	s1,24(sp)
    8000297c:	e84a                	sd	s2,16(sp)
    8000297e:	e44e                	sd	s3,8(sp)
    80002980:	e052                	sd	s4,0(sp)
    80002982:	1800                	addi	s0,sp,48
    80002984:	89aa                	mv	s3,a0
    80002986:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002988:	00235517          	auipc	a0,0x235
    8000298c:	bf050513          	addi	a0,a0,-1040 # 80237578 <itable>
    80002990:	00004097          	auipc	ra,0x4
    80002994:	912080e7          	jalr	-1774(ra) # 800062a2 <acquire>
  empty = 0;
    80002998:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000299a:	00235497          	auipc	s1,0x235
    8000299e:	bf648493          	addi	s1,s1,-1034 # 80237590 <itable+0x18>
    800029a2:	00236697          	auipc	a3,0x236
    800029a6:	67e68693          	addi	a3,a3,1662 # 80239020 <log>
    800029aa:	a039                	j	800029b8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ac:	02090b63          	beqz	s2,800029e2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029b0:	08848493          	addi	s1,s1,136
    800029b4:	02d48a63          	beq	s1,a3,800029e8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029b8:	449c                	lw	a5,8(s1)
    800029ba:	fef059e3          	blez	a5,800029ac <iget+0x38>
    800029be:	4098                	lw	a4,0(s1)
    800029c0:	ff3716e3          	bne	a4,s3,800029ac <iget+0x38>
    800029c4:	40d8                	lw	a4,4(s1)
    800029c6:	ff4713e3          	bne	a4,s4,800029ac <iget+0x38>
      ip->ref++;
    800029ca:	2785                	addiw	a5,a5,1
    800029cc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ce:	00235517          	auipc	a0,0x235
    800029d2:	baa50513          	addi	a0,a0,-1110 # 80237578 <itable>
    800029d6:	00004097          	auipc	ra,0x4
    800029da:	980080e7          	jalr	-1664(ra) # 80006356 <release>
      return ip;
    800029de:	8926                	mv	s2,s1
    800029e0:	a03d                	j	80002a0e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029e2:	f7f9                	bnez	a5,800029b0 <iget+0x3c>
    800029e4:	8926                	mv	s2,s1
    800029e6:	b7e9                	j	800029b0 <iget+0x3c>
  if(empty == 0)
    800029e8:	02090c63          	beqz	s2,80002a20 <iget+0xac>
  ip->dev = dev;
    800029ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029f4:	4785                	li	a5,1
    800029f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029fe:	00235517          	auipc	a0,0x235
    80002a02:	b7a50513          	addi	a0,a0,-1158 # 80237578 <itable>
    80002a06:	00004097          	auipc	ra,0x4
    80002a0a:	950080e7          	jalr	-1712(ra) # 80006356 <release>
}
    80002a0e:	854a                	mv	a0,s2
    80002a10:	70a2                	ld	ra,40(sp)
    80002a12:	7402                	ld	s0,32(sp)
    80002a14:	64e2                	ld	s1,24(sp)
    80002a16:	6942                	ld	s2,16(sp)
    80002a18:	69a2                	ld	s3,8(sp)
    80002a1a:	6a02                	ld	s4,0(sp)
    80002a1c:	6145                	addi	sp,sp,48
    80002a1e:	8082                	ret
    panic("iget: no inodes");
    80002a20:	00006517          	auipc	a0,0x6
    80002a24:	ad850513          	addi	a0,a0,-1320 # 800084f8 <syscalls+0x130>
    80002a28:	00003097          	auipc	ra,0x3
    80002a2c:	330080e7          	jalr	816(ra) # 80005d58 <panic>

0000000080002a30 <fsinit>:
fsinit(int dev) {
    80002a30:	7179                	addi	sp,sp,-48
    80002a32:	f406                	sd	ra,40(sp)
    80002a34:	f022                	sd	s0,32(sp)
    80002a36:	ec26                	sd	s1,24(sp)
    80002a38:	e84a                	sd	s2,16(sp)
    80002a3a:	e44e                	sd	s3,8(sp)
    80002a3c:	1800                	addi	s0,sp,48
    80002a3e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a40:	4585                	li	a1,1
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	a64080e7          	jalr	-1436(ra) # 800024a6 <bread>
    80002a4a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a4c:	00235997          	auipc	s3,0x235
    80002a50:	b0c98993          	addi	s3,s3,-1268 # 80237558 <sb>
    80002a54:	02000613          	li	a2,32
    80002a58:	05850593          	addi	a1,a0,88
    80002a5c:	854e                	mv	a0,s3
    80002a5e:	ffffe097          	auipc	ra,0xffffe
    80002a62:	8ee080e7          	jalr	-1810(ra) # 8000034c <memmove>
  brelse(bp);
    80002a66:	8526                	mv	a0,s1
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	b6e080e7          	jalr	-1170(ra) # 800025d6 <brelse>
  if(sb.magic != FSMAGIC)
    80002a70:	0009a703          	lw	a4,0(s3)
    80002a74:	102037b7          	lui	a5,0x10203
    80002a78:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a7c:	02f71263          	bne	a4,a5,80002aa0 <fsinit+0x70>
  initlog(dev, &sb);
    80002a80:	00235597          	auipc	a1,0x235
    80002a84:	ad858593          	addi	a1,a1,-1320 # 80237558 <sb>
    80002a88:	854a                	mv	a0,s2
    80002a8a:	00001097          	auipc	ra,0x1
    80002a8e:	b4c080e7          	jalr	-1204(ra) # 800035d6 <initlog>
}
    80002a92:	70a2                	ld	ra,40(sp)
    80002a94:	7402                	ld	s0,32(sp)
    80002a96:	64e2                	ld	s1,24(sp)
    80002a98:	6942                	ld	s2,16(sp)
    80002a9a:	69a2                	ld	s3,8(sp)
    80002a9c:	6145                	addi	sp,sp,48
    80002a9e:	8082                	ret
    panic("invalid file system");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	a6850513          	addi	a0,a0,-1432 # 80008508 <syscalls+0x140>
    80002aa8:	00003097          	auipc	ra,0x3
    80002aac:	2b0080e7          	jalr	688(ra) # 80005d58 <panic>

0000000080002ab0 <iinit>:
{
    80002ab0:	7179                	addi	sp,sp,-48
    80002ab2:	f406                	sd	ra,40(sp)
    80002ab4:	f022                	sd	s0,32(sp)
    80002ab6:	ec26                	sd	s1,24(sp)
    80002ab8:	e84a                	sd	s2,16(sp)
    80002aba:	e44e                	sd	s3,8(sp)
    80002abc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002abe:	00006597          	auipc	a1,0x6
    80002ac2:	a6258593          	addi	a1,a1,-1438 # 80008520 <syscalls+0x158>
    80002ac6:	00235517          	auipc	a0,0x235
    80002aca:	ab250513          	addi	a0,a0,-1358 # 80237578 <itable>
    80002ace:	00003097          	auipc	ra,0x3
    80002ad2:	744080e7          	jalr	1860(ra) # 80006212 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ad6:	00235497          	auipc	s1,0x235
    80002ada:	aca48493          	addi	s1,s1,-1334 # 802375a0 <itable+0x28>
    80002ade:	00236997          	auipc	s3,0x236
    80002ae2:	55298993          	addi	s3,s3,1362 # 80239030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ae6:	00006917          	auipc	s2,0x6
    80002aea:	a4290913          	addi	s2,s2,-1470 # 80008528 <syscalls+0x160>
    80002aee:	85ca                	mv	a1,s2
    80002af0:	8526                	mv	a0,s1
    80002af2:	00001097          	auipc	ra,0x1
    80002af6:	e46080e7          	jalr	-442(ra) # 80003938 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002afa:	08848493          	addi	s1,s1,136
    80002afe:	ff3498e3          	bne	s1,s3,80002aee <iinit+0x3e>
}
    80002b02:	70a2                	ld	ra,40(sp)
    80002b04:	7402                	ld	s0,32(sp)
    80002b06:	64e2                	ld	s1,24(sp)
    80002b08:	6942                	ld	s2,16(sp)
    80002b0a:	69a2                	ld	s3,8(sp)
    80002b0c:	6145                	addi	sp,sp,48
    80002b0e:	8082                	ret

0000000080002b10 <ialloc>:
{
    80002b10:	715d                	addi	sp,sp,-80
    80002b12:	e486                	sd	ra,72(sp)
    80002b14:	e0a2                	sd	s0,64(sp)
    80002b16:	fc26                	sd	s1,56(sp)
    80002b18:	f84a                	sd	s2,48(sp)
    80002b1a:	f44e                	sd	s3,40(sp)
    80002b1c:	f052                	sd	s4,32(sp)
    80002b1e:	ec56                	sd	s5,24(sp)
    80002b20:	e85a                	sd	s6,16(sp)
    80002b22:	e45e                	sd	s7,8(sp)
    80002b24:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b26:	00235717          	auipc	a4,0x235
    80002b2a:	a3e72703          	lw	a4,-1474(a4) # 80237564 <sb+0xc>
    80002b2e:	4785                	li	a5,1
    80002b30:	04e7fa63          	bgeu	a5,a4,80002b84 <ialloc+0x74>
    80002b34:	8aaa                	mv	s5,a0
    80002b36:	8bae                	mv	s7,a1
    80002b38:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b3a:	00235a17          	auipc	s4,0x235
    80002b3e:	a1ea0a13          	addi	s4,s4,-1506 # 80237558 <sb>
    80002b42:	00048b1b          	sext.w	s6,s1
    80002b46:	0044d593          	srli	a1,s1,0x4
    80002b4a:	018a2783          	lw	a5,24(s4)
    80002b4e:	9dbd                	addw	a1,a1,a5
    80002b50:	8556                	mv	a0,s5
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	954080e7          	jalr	-1708(ra) # 800024a6 <bread>
    80002b5a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b5c:	05850993          	addi	s3,a0,88
    80002b60:	00f4f793          	andi	a5,s1,15
    80002b64:	079a                	slli	a5,a5,0x6
    80002b66:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b68:	00099783          	lh	a5,0(s3)
    80002b6c:	c785                	beqz	a5,80002b94 <ialloc+0x84>
    brelse(bp);
    80002b6e:	00000097          	auipc	ra,0x0
    80002b72:	a68080e7          	jalr	-1432(ra) # 800025d6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b76:	0485                	addi	s1,s1,1
    80002b78:	00ca2703          	lw	a4,12(s4)
    80002b7c:	0004879b          	sext.w	a5,s1
    80002b80:	fce7e1e3          	bltu	a5,a4,80002b42 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b84:	00006517          	auipc	a0,0x6
    80002b88:	9ac50513          	addi	a0,a0,-1620 # 80008530 <syscalls+0x168>
    80002b8c:	00003097          	auipc	ra,0x3
    80002b90:	1cc080e7          	jalr	460(ra) # 80005d58 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b94:	04000613          	li	a2,64
    80002b98:	4581                	li	a1,0
    80002b9a:	854e                	mv	a0,s3
    80002b9c:	ffffd097          	auipc	ra,0xffffd
    80002ba0:	750080e7          	jalr	1872(ra) # 800002ec <memset>
      dip->type = type;
    80002ba4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ba8:	854a                	mv	a0,s2
    80002baa:	00001097          	auipc	ra,0x1
    80002bae:	ca8080e7          	jalr	-856(ra) # 80003852 <log_write>
      brelse(bp);
    80002bb2:	854a                	mv	a0,s2
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	a22080e7          	jalr	-1502(ra) # 800025d6 <brelse>
      return iget(dev, inum);
    80002bbc:	85da                	mv	a1,s6
    80002bbe:	8556                	mv	a0,s5
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	db4080e7          	jalr	-588(ra) # 80002974 <iget>
}
    80002bc8:	60a6                	ld	ra,72(sp)
    80002bca:	6406                	ld	s0,64(sp)
    80002bcc:	74e2                	ld	s1,56(sp)
    80002bce:	7942                	ld	s2,48(sp)
    80002bd0:	79a2                	ld	s3,40(sp)
    80002bd2:	7a02                	ld	s4,32(sp)
    80002bd4:	6ae2                	ld	s5,24(sp)
    80002bd6:	6b42                	ld	s6,16(sp)
    80002bd8:	6ba2                	ld	s7,8(sp)
    80002bda:	6161                	addi	sp,sp,80
    80002bdc:	8082                	ret

0000000080002bde <iupdate>:
{
    80002bde:	1101                	addi	sp,sp,-32
    80002be0:	ec06                	sd	ra,24(sp)
    80002be2:	e822                	sd	s0,16(sp)
    80002be4:	e426                	sd	s1,8(sp)
    80002be6:	e04a                	sd	s2,0(sp)
    80002be8:	1000                	addi	s0,sp,32
    80002bea:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bec:	415c                	lw	a5,4(a0)
    80002bee:	0047d79b          	srliw	a5,a5,0x4
    80002bf2:	00235597          	auipc	a1,0x235
    80002bf6:	97e5a583          	lw	a1,-1666(a1) # 80237570 <sb+0x18>
    80002bfa:	9dbd                	addw	a1,a1,a5
    80002bfc:	4108                	lw	a0,0(a0)
    80002bfe:	00000097          	auipc	ra,0x0
    80002c02:	8a8080e7          	jalr	-1880(ra) # 800024a6 <bread>
    80002c06:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c08:	05850793          	addi	a5,a0,88
    80002c0c:	40c8                	lw	a0,4(s1)
    80002c0e:	893d                	andi	a0,a0,15
    80002c10:	051a                	slli	a0,a0,0x6
    80002c12:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c14:	04449703          	lh	a4,68(s1)
    80002c18:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c1c:	04649703          	lh	a4,70(s1)
    80002c20:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c24:	04849703          	lh	a4,72(s1)
    80002c28:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c2c:	04a49703          	lh	a4,74(s1)
    80002c30:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c34:	44f8                	lw	a4,76(s1)
    80002c36:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c38:	03400613          	li	a2,52
    80002c3c:	05048593          	addi	a1,s1,80
    80002c40:	0531                	addi	a0,a0,12
    80002c42:	ffffd097          	auipc	ra,0xffffd
    80002c46:	70a080e7          	jalr	1802(ra) # 8000034c <memmove>
  log_write(bp);
    80002c4a:	854a                	mv	a0,s2
    80002c4c:	00001097          	auipc	ra,0x1
    80002c50:	c06080e7          	jalr	-1018(ra) # 80003852 <log_write>
  brelse(bp);
    80002c54:	854a                	mv	a0,s2
    80002c56:	00000097          	auipc	ra,0x0
    80002c5a:	980080e7          	jalr	-1664(ra) # 800025d6 <brelse>
}
    80002c5e:	60e2                	ld	ra,24(sp)
    80002c60:	6442                	ld	s0,16(sp)
    80002c62:	64a2                	ld	s1,8(sp)
    80002c64:	6902                	ld	s2,0(sp)
    80002c66:	6105                	addi	sp,sp,32
    80002c68:	8082                	ret

0000000080002c6a <idup>:
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	e426                	sd	s1,8(sp)
    80002c72:	1000                	addi	s0,sp,32
    80002c74:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c76:	00235517          	auipc	a0,0x235
    80002c7a:	90250513          	addi	a0,a0,-1790 # 80237578 <itable>
    80002c7e:	00003097          	auipc	ra,0x3
    80002c82:	624080e7          	jalr	1572(ra) # 800062a2 <acquire>
  ip->ref++;
    80002c86:	449c                	lw	a5,8(s1)
    80002c88:	2785                	addiw	a5,a5,1
    80002c8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c8c:	00235517          	auipc	a0,0x235
    80002c90:	8ec50513          	addi	a0,a0,-1812 # 80237578 <itable>
    80002c94:	00003097          	auipc	ra,0x3
    80002c98:	6c2080e7          	jalr	1730(ra) # 80006356 <release>
}
    80002c9c:	8526                	mv	a0,s1
    80002c9e:	60e2                	ld	ra,24(sp)
    80002ca0:	6442                	ld	s0,16(sp)
    80002ca2:	64a2                	ld	s1,8(sp)
    80002ca4:	6105                	addi	sp,sp,32
    80002ca6:	8082                	ret

0000000080002ca8 <ilock>:
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cb4:	c115                	beqz	a0,80002cd8 <ilock+0x30>
    80002cb6:	84aa                	mv	s1,a0
    80002cb8:	451c                	lw	a5,8(a0)
    80002cba:	00f05f63          	blez	a5,80002cd8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cbe:	0541                	addi	a0,a0,16
    80002cc0:	00001097          	auipc	ra,0x1
    80002cc4:	cb2080e7          	jalr	-846(ra) # 80003972 <acquiresleep>
  if(ip->valid == 0){
    80002cc8:	40bc                	lw	a5,64(s1)
    80002cca:	cf99                	beqz	a5,80002ce8 <ilock+0x40>
}
    80002ccc:	60e2                	ld	ra,24(sp)
    80002cce:	6442                	ld	s0,16(sp)
    80002cd0:	64a2                	ld	s1,8(sp)
    80002cd2:	6902                	ld	s2,0(sp)
    80002cd4:	6105                	addi	sp,sp,32
    80002cd6:	8082                	ret
    panic("ilock");
    80002cd8:	00006517          	auipc	a0,0x6
    80002cdc:	87050513          	addi	a0,a0,-1936 # 80008548 <syscalls+0x180>
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	078080e7          	jalr	120(ra) # 80005d58 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ce8:	40dc                	lw	a5,4(s1)
    80002cea:	0047d79b          	srliw	a5,a5,0x4
    80002cee:	00235597          	auipc	a1,0x235
    80002cf2:	8825a583          	lw	a1,-1918(a1) # 80237570 <sb+0x18>
    80002cf6:	9dbd                	addw	a1,a1,a5
    80002cf8:	4088                	lw	a0,0(s1)
    80002cfa:	fffff097          	auipc	ra,0xfffff
    80002cfe:	7ac080e7          	jalr	1964(ra) # 800024a6 <bread>
    80002d02:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d04:	05850593          	addi	a1,a0,88
    80002d08:	40dc                	lw	a5,4(s1)
    80002d0a:	8bbd                	andi	a5,a5,15
    80002d0c:	079a                	slli	a5,a5,0x6
    80002d0e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d10:	00059783          	lh	a5,0(a1)
    80002d14:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d18:	00259783          	lh	a5,2(a1)
    80002d1c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d20:	00459783          	lh	a5,4(a1)
    80002d24:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d28:	00659783          	lh	a5,6(a1)
    80002d2c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d30:	459c                	lw	a5,8(a1)
    80002d32:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d34:	03400613          	li	a2,52
    80002d38:	05b1                	addi	a1,a1,12
    80002d3a:	05048513          	addi	a0,s1,80
    80002d3e:	ffffd097          	auipc	ra,0xffffd
    80002d42:	60e080e7          	jalr	1550(ra) # 8000034c <memmove>
    brelse(bp);
    80002d46:	854a                	mv	a0,s2
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	88e080e7          	jalr	-1906(ra) # 800025d6 <brelse>
    ip->valid = 1;
    80002d50:	4785                	li	a5,1
    80002d52:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d54:	04449783          	lh	a5,68(s1)
    80002d58:	fbb5                	bnez	a5,80002ccc <ilock+0x24>
      panic("ilock: no type");
    80002d5a:	00005517          	auipc	a0,0x5
    80002d5e:	7f650513          	addi	a0,a0,2038 # 80008550 <syscalls+0x188>
    80002d62:	00003097          	auipc	ra,0x3
    80002d66:	ff6080e7          	jalr	-10(ra) # 80005d58 <panic>

0000000080002d6a <iunlock>:
{
    80002d6a:	1101                	addi	sp,sp,-32
    80002d6c:	ec06                	sd	ra,24(sp)
    80002d6e:	e822                	sd	s0,16(sp)
    80002d70:	e426                	sd	s1,8(sp)
    80002d72:	e04a                	sd	s2,0(sp)
    80002d74:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d76:	c905                	beqz	a0,80002da6 <iunlock+0x3c>
    80002d78:	84aa                	mv	s1,a0
    80002d7a:	01050913          	addi	s2,a0,16
    80002d7e:	854a                	mv	a0,s2
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	c8c080e7          	jalr	-884(ra) # 80003a0c <holdingsleep>
    80002d88:	cd19                	beqz	a0,80002da6 <iunlock+0x3c>
    80002d8a:	449c                	lw	a5,8(s1)
    80002d8c:	00f05d63          	blez	a5,80002da6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d90:	854a                	mv	a0,s2
    80002d92:	00001097          	auipc	ra,0x1
    80002d96:	c36080e7          	jalr	-970(ra) # 800039c8 <releasesleep>
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6902                	ld	s2,0(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret
    panic("iunlock");
    80002da6:	00005517          	auipc	a0,0x5
    80002daa:	7ba50513          	addi	a0,a0,1978 # 80008560 <syscalls+0x198>
    80002dae:	00003097          	auipc	ra,0x3
    80002db2:	faa080e7          	jalr	-86(ra) # 80005d58 <panic>

0000000080002db6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002db6:	7179                	addi	sp,sp,-48
    80002db8:	f406                	sd	ra,40(sp)
    80002dba:	f022                	sd	s0,32(sp)
    80002dbc:	ec26                	sd	s1,24(sp)
    80002dbe:	e84a                	sd	s2,16(sp)
    80002dc0:	e44e                	sd	s3,8(sp)
    80002dc2:	e052                	sd	s4,0(sp)
    80002dc4:	1800                	addi	s0,sp,48
    80002dc6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dc8:	05050493          	addi	s1,a0,80
    80002dcc:	08050913          	addi	s2,a0,128
    80002dd0:	a021                	j	80002dd8 <itrunc+0x22>
    80002dd2:	0491                	addi	s1,s1,4
    80002dd4:	01248d63          	beq	s1,s2,80002dee <itrunc+0x38>
    if(ip->addrs[i]){
    80002dd8:	408c                	lw	a1,0(s1)
    80002dda:	dde5                	beqz	a1,80002dd2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ddc:	0009a503          	lw	a0,0(s3)
    80002de0:	00000097          	auipc	ra,0x0
    80002de4:	90c080e7          	jalr	-1780(ra) # 800026ec <bfree>
      ip->addrs[i] = 0;
    80002de8:	0004a023          	sw	zero,0(s1)
    80002dec:	b7dd                	j	80002dd2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dee:	0809a583          	lw	a1,128(s3)
    80002df2:	e185                	bnez	a1,80002e12 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002df4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002df8:	854e                	mv	a0,s3
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	de4080e7          	jalr	-540(ra) # 80002bde <iupdate>
}
    80002e02:	70a2                	ld	ra,40(sp)
    80002e04:	7402                	ld	s0,32(sp)
    80002e06:	64e2                	ld	s1,24(sp)
    80002e08:	6942                	ld	s2,16(sp)
    80002e0a:	69a2                	ld	s3,8(sp)
    80002e0c:	6a02                	ld	s4,0(sp)
    80002e0e:	6145                	addi	sp,sp,48
    80002e10:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e12:	0009a503          	lw	a0,0(s3)
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	690080e7          	jalr	1680(ra) # 800024a6 <bread>
    80002e1e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e20:	05850493          	addi	s1,a0,88
    80002e24:	45850913          	addi	s2,a0,1112
    80002e28:	a811                	j	80002e3c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e2a:	0009a503          	lw	a0,0(s3)
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	8be080e7          	jalr	-1858(ra) # 800026ec <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e36:	0491                	addi	s1,s1,4
    80002e38:	01248563          	beq	s1,s2,80002e42 <itrunc+0x8c>
      if(a[j])
    80002e3c:	408c                	lw	a1,0(s1)
    80002e3e:	dde5                	beqz	a1,80002e36 <itrunc+0x80>
    80002e40:	b7ed                	j	80002e2a <itrunc+0x74>
    brelse(bp);
    80002e42:	8552                	mv	a0,s4
    80002e44:	fffff097          	auipc	ra,0xfffff
    80002e48:	792080e7          	jalr	1938(ra) # 800025d6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e4c:	0809a583          	lw	a1,128(s3)
    80002e50:	0009a503          	lw	a0,0(s3)
    80002e54:	00000097          	auipc	ra,0x0
    80002e58:	898080e7          	jalr	-1896(ra) # 800026ec <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e5c:	0809a023          	sw	zero,128(s3)
    80002e60:	bf51                	j	80002df4 <itrunc+0x3e>

0000000080002e62 <iput>:
{
    80002e62:	1101                	addi	sp,sp,-32
    80002e64:	ec06                	sd	ra,24(sp)
    80002e66:	e822                	sd	s0,16(sp)
    80002e68:	e426                	sd	s1,8(sp)
    80002e6a:	e04a                	sd	s2,0(sp)
    80002e6c:	1000                	addi	s0,sp,32
    80002e6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e70:	00234517          	auipc	a0,0x234
    80002e74:	70850513          	addi	a0,a0,1800 # 80237578 <itable>
    80002e78:	00003097          	auipc	ra,0x3
    80002e7c:	42a080e7          	jalr	1066(ra) # 800062a2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e80:	4498                	lw	a4,8(s1)
    80002e82:	4785                	li	a5,1
    80002e84:	02f70363          	beq	a4,a5,80002eaa <iput+0x48>
  ip->ref--;
    80002e88:	449c                	lw	a5,8(s1)
    80002e8a:	37fd                	addiw	a5,a5,-1
    80002e8c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e8e:	00234517          	auipc	a0,0x234
    80002e92:	6ea50513          	addi	a0,a0,1770 # 80237578 <itable>
    80002e96:	00003097          	auipc	ra,0x3
    80002e9a:	4c0080e7          	jalr	1216(ra) # 80006356 <release>
}
    80002e9e:	60e2                	ld	ra,24(sp)
    80002ea0:	6442                	ld	s0,16(sp)
    80002ea2:	64a2                	ld	s1,8(sp)
    80002ea4:	6902                	ld	s2,0(sp)
    80002ea6:	6105                	addi	sp,sp,32
    80002ea8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eaa:	40bc                	lw	a5,64(s1)
    80002eac:	dff1                	beqz	a5,80002e88 <iput+0x26>
    80002eae:	04a49783          	lh	a5,74(s1)
    80002eb2:	fbf9                	bnez	a5,80002e88 <iput+0x26>
    acquiresleep(&ip->lock);
    80002eb4:	01048913          	addi	s2,s1,16
    80002eb8:	854a                	mv	a0,s2
    80002eba:	00001097          	auipc	ra,0x1
    80002ebe:	ab8080e7          	jalr	-1352(ra) # 80003972 <acquiresleep>
    release(&itable.lock);
    80002ec2:	00234517          	auipc	a0,0x234
    80002ec6:	6b650513          	addi	a0,a0,1718 # 80237578 <itable>
    80002eca:	00003097          	auipc	ra,0x3
    80002ece:	48c080e7          	jalr	1164(ra) # 80006356 <release>
    itrunc(ip);
    80002ed2:	8526                	mv	a0,s1
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	ee2080e7          	jalr	-286(ra) # 80002db6 <itrunc>
    ip->type = 0;
    80002edc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ee0:	8526                	mv	a0,s1
    80002ee2:	00000097          	auipc	ra,0x0
    80002ee6:	cfc080e7          	jalr	-772(ra) # 80002bde <iupdate>
    ip->valid = 0;
    80002eea:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eee:	854a                	mv	a0,s2
    80002ef0:	00001097          	auipc	ra,0x1
    80002ef4:	ad8080e7          	jalr	-1320(ra) # 800039c8 <releasesleep>
    acquire(&itable.lock);
    80002ef8:	00234517          	auipc	a0,0x234
    80002efc:	68050513          	addi	a0,a0,1664 # 80237578 <itable>
    80002f00:	00003097          	auipc	ra,0x3
    80002f04:	3a2080e7          	jalr	930(ra) # 800062a2 <acquire>
    80002f08:	b741                	j	80002e88 <iput+0x26>

0000000080002f0a <iunlockput>:
{
    80002f0a:	1101                	addi	sp,sp,-32
    80002f0c:	ec06                	sd	ra,24(sp)
    80002f0e:	e822                	sd	s0,16(sp)
    80002f10:	e426                	sd	s1,8(sp)
    80002f12:	1000                	addi	s0,sp,32
    80002f14:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f16:	00000097          	auipc	ra,0x0
    80002f1a:	e54080e7          	jalr	-428(ra) # 80002d6a <iunlock>
  iput(ip);
    80002f1e:	8526                	mv	a0,s1
    80002f20:	00000097          	auipc	ra,0x0
    80002f24:	f42080e7          	jalr	-190(ra) # 80002e62 <iput>
}
    80002f28:	60e2                	ld	ra,24(sp)
    80002f2a:	6442                	ld	s0,16(sp)
    80002f2c:	64a2                	ld	s1,8(sp)
    80002f2e:	6105                	addi	sp,sp,32
    80002f30:	8082                	ret

0000000080002f32 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f32:	1141                	addi	sp,sp,-16
    80002f34:	e422                	sd	s0,8(sp)
    80002f36:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f38:	411c                	lw	a5,0(a0)
    80002f3a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f3c:	415c                	lw	a5,4(a0)
    80002f3e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f40:	04451783          	lh	a5,68(a0)
    80002f44:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f48:	04a51783          	lh	a5,74(a0)
    80002f4c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f50:	04c56783          	lwu	a5,76(a0)
    80002f54:	e99c                	sd	a5,16(a1)
}
    80002f56:	6422                	ld	s0,8(sp)
    80002f58:	0141                	addi	sp,sp,16
    80002f5a:	8082                	ret

0000000080002f5c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f5c:	457c                	lw	a5,76(a0)
    80002f5e:	0ed7e963          	bltu	a5,a3,80003050 <readi+0xf4>
{
    80002f62:	7159                	addi	sp,sp,-112
    80002f64:	f486                	sd	ra,104(sp)
    80002f66:	f0a2                	sd	s0,96(sp)
    80002f68:	eca6                	sd	s1,88(sp)
    80002f6a:	e8ca                	sd	s2,80(sp)
    80002f6c:	e4ce                	sd	s3,72(sp)
    80002f6e:	e0d2                	sd	s4,64(sp)
    80002f70:	fc56                	sd	s5,56(sp)
    80002f72:	f85a                	sd	s6,48(sp)
    80002f74:	f45e                	sd	s7,40(sp)
    80002f76:	f062                	sd	s8,32(sp)
    80002f78:	ec66                	sd	s9,24(sp)
    80002f7a:	e86a                	sd	s10,16(sp)
    80002f7c:	e46e                	sd	s11,8(sp)
    80002f7e:	1880                	addi	s0,sp,112
    80002f80:	8baa                	mv	s7,a0
    80002f82:	8c2e                	mv	s8,a1
    80002f84:	8ab2                	mv	s5,a2
    80002f86:	84b6                	mv	s1,a3
    80002f88:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f8a:	9f35                	addw	a4,a4,a3
    return 0;
    80002f8c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f8e:	0ad76063          	bltu	a4,a3,8000302e <readi+0xd2>
  if(off + n > ip->size)
    80002f92:	00e7f463          	bgeu	a5,a4,80002f9a <readi+0x3e>
    n = ip->size - off;
    80002f96:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f9a:	0a0b0963          	beqz	s6,8000304c <readi+0xf0>
    80002f9e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fa4:	5cfd                	li	s9,-1
    80002fa6:	a82d                	j	80002fe0 <readi+0x84>
    80002fa8:	020a1d93          	slli	s11,s4,0x20
    80002fac:	020ddd93          	srli	s11,s11,0x20
    80002fb0:	05890613          	addi	a2,s2,88
    80002fb4:	86ee                	mv	a3,s11
    80002fb6:	963a                	add	a2,a2,a4
    80002fb8:	85d6                	mv	a1,s5
    80002fba:	8562                	mv	a0,s8
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	a66080e7          	jalr	-1434(ra) # 80001a22 <either_copyout>
    80002fc4:	05950d63          	beq	a0,s9,8000301e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fc8:	854a                	mv	a0,s2
    80002fca:	fffff097          	auipc	ra,0xfffff
    80002fce:	60c080e7          	jalr	1548(ra) # 800025d6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd2:	013a09bb          	addw	s3,s4,s3
    80002fd6:	009a04bb          	addw	s1,s4,s1
    80002fda:	9aee                	add	s5,s5,s11
    80002fdc:	0569f763          	bgeu	s3,s6,8000302a <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fe0:	000ba903          	lw	s2,0(s7)
    80002fe4:	00a4d59b          	srliw	a1,s1,0xa
    80002fe8:	855e                	mv	a0,s7
    80002fea:	00000097          	auipc	ra,0x0
    80002fee:	8b0080e7          	jalr	-1872(ra) # 8000289a <bmap>
    80002ff2:	0005059b          	sext.w	a1,a0
    80002ff6:	854a                	mv	a0,s2
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	4ae080e7          	jalr	1198(ra) # 800024a6 <bread>
    80003000:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003002:	3ff4f713          	andi	a4,s1,1023
    80003006:	40ed07bb          	subw	a5,s10,a4
    8000300a:	413b06bb          	subw	a3,s6,s3
    8000300e:	8a3e                	mv	s4,a5
    80003010:	2781                	sext.w	a5,a5
    80003012:	0006861b          	sext.w	a2,a3
    80003016:	f8f679e3          	bgeu	a2,a5,80002fa8 <readi+0x4c>
    8000301a:	8a36                	mv	s4,a3
    8000301c:	b771                	j	80002fa8 <readi+0x4c>
      brelse(bp);
    8000301e:	854a                	mv	a0,s2
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	5b6080e7          	jalr	1462(ra) # 800025d6 <brelse>
      tot = -1;
    80003028:	59fd                	li	s3,-1
  }
  return tot;
    8000302a:	0009851b          	sext.w	a0,s3
}
    8000302e:	70a6                	ld	ra,104(sp)
    80003030:	7406                	ld	s0,96(sp)
    80003032:	64e6                	ld	s1,88(sp)
    80003034:	6946                	ld	s2,80(sp)
    80003036:	69a6                	ld	s3,72(sp)
    80003038:	6a06                	ld	s4,64(sp)
    8000303a:	7ae2                	ld	s5,56(sp)
    8000303c:	7b42                	ld	s6,48(sp)
    8000303e:	7ba2                	ld	s7,40(sp)
    80003040:	7c02                	ld	s8,32(sp)
    80003042:	6ce2                	ld	s9,24(sp)
    80003044:	6d42                	ld	s10,16(sp)
    80003046:	6da2                	ld	s11,8(sp)
    80003048:	6165                	addi	sp,sp,112
    8000304a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304c:	89da                	mv	s3,s6
    8000304e:	bff1                	j	8000302a <readi+0xce>
    return 0;
    80003050:	4501                	li	a0,0
}
    80003052:	8082                	ret

0000000080003054 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003054:	457c                	lw	a5,76(a0)
    80003056:	10d7e863          	bltu	a5,a3,80003166 <writei+0x112>
{
    8000305a:	7159                	addi	sp,sp,-112
    8000305c:	f486                	sd	ra,104(sp)
    8000305e:	f0a2                	sd	s0,96(sp)
    80003060:	eca6                	sd	s1,88(sp)
    80003062:	e8ca                	sd	s2,80(sp)
    80003064:	e4ce                	sd	s3,72(sp)
    80003066:	e0d2                	sd	s4,64(sp)
    80003068:	fc56                	sd	s5,56(sp)
    8000306a:	f85a                	sd	s6,48(sp)
    8000306c:	f45e                	sd	s7,40(sp)
    8000306e:	f062                	sd	s8,32(sp)
    80003070:	ec66                	sd	s9,24(sp)
    80003072:	e86a                	sd	s10,16(sp)
    80003074:	e46e                	sd	s11,8(sp)
    80003076:	1880                	addi	s0,sp,112
    80003078:	8b2a                	mv	s6,a0
    8000307a:	8c2e                	mv	s8,a1
    8000307c:	8ab2                	mv	s5,a2
    8000307e:	8936                	mv	s2,a3
    80003080:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003082:	00e687bb          	addw	a5,a3,a4
    80003086:	0ed7e263          	bltu	a5,a3,8000316a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000308a:	00043737          	lui	a4,0x43
    8000308e:	0ef76063          	bltu	a4,a5,8000316e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003092:	0c0b8863          	beqz	s7,80003162 <writei+0x10e>
    80003096:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003098:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000309c:	5cfd                	li	s9,-1
    8000309e:	a091                	j	800030e2 <writei+0x8e>
    800030a0:	02099d93          	slli	s11,s3,0x20
    800030a4:	020ddd93          	srli	s11,s11,0x20
    800030a8:	05848513          	addi	a0,s1,88
    800030ac:	86ee                	mv	a3,s11
    800030ae:	8656                	mv	a2,s5
    800030b0:	85e2                	mv	a1,s8
    800030b2:	953a                	add	a0,a0,a4
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	9c4080e7          	jalr	-1596(ra) # 80001a78 <either_copyin>
    800030bc:	07950263          	beq	a0,s9,80003120 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030c0:	8526                	mv	a0,s1
    800030c2:	00000097          	auipc	ra,0x0
    800030c6:	790080e7          	jalr	1936(ra) # 80003852 <log_write>
    brelse(bp);
    800030ca:	8526                	mv	a0,s1
    800030cc:	fffff097          	auipc	ra,0xfffff
    800030d0:	50a080e7          	jalr	1290(ra) # 800025d6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d4:	01498a3b          	addw	s4,s3,s4
    800030d8:	0129893b          	addw	s2,s3,s2
    800030dc:	9aee                	add	s5,s5,s11
    800030de:	057a7663          	bgeu	s4,s7,8000312a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030e2:	000b2483          	lw	s1,0(s6)
    800030e6:	00a9559b          	srliw	a1,s2,0xa
    800030ea:	855a                	mv	a0,s6
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	7ae080e7          	jalr	1966(ra) # 8000289a <bmap>
    800030f4:	0005059b          	sext.w	a1,a0
    800030f8:	8526                	mv	a0,s1
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	3ac080e7          	jalr	940(ra) # 800024a6 <bread>
    80003102:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003104:	3ff97713          	andi	a4,s2,1023
    80003108:	40ed07bb          	subw	a5,s10,a4
    8000310c:	414b86bb          	subw	a3,s7,s4
    80003110:	89be                	mv	s3,a5
    80003112:	2781                	sext.w	a5,a5
    80003114:	0006861b          	sext.w	a2,a3
    80003118:	f8f674e3          	bgeu	a2,a5,800030a0 <writei+0x4c>
    8000311c:	89b6                	mv	s3,a3
    8000311e:	b749                	j	800030a0 <writei+0x4c>
      brelse(bp);
    80003120:	8526                	mv	a0,s1
    80003122:	fffff097          	auipc	ra,0xfffff
    80003126:	4b4080e7          	jalr	1204(ra) # 800025d6 <brelse>
  }

  if(off > ip->size)
    8000312a:	04cb2783          	lw	a5,76(s6)
    8000312e:	0127f463          	bgeu	a5,s2,80003136 <writei+0xe2>
    ip->size = off;
    80003132:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003136:	855a                	mv	a0,s6
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	aa6080e7          	jalr	-1370(ra) # 80002bde <iupdate>

  return tot;
    80003140:	000a051b          	sext.w	a0,s4
}
    80003144:	70a6                	ld	ra,104(sp)
    80003146:	7406                	ld	s0,96(sp)
    80003148:	64e6                	ld	s1,88(sp)
    8000314a:	6946                	ld	s2,80(sp)
    8000314c:	69a6                	ld	s3,72(sp)
    8000314e:	6a06                	ld	s4,64(sp)
    80003150:	7ae2                	ld	s5,56(sp)
    80003152:	7b42                	ld	s6,48(sp)
    80003154:	7ba2                	ld	s7,40(sp)
    80003156:	7c02                	ld	s8,32(sp)
    80003158:	6ce2                	ld	s9,24(sp)
    8000315a:	6d42                	ld	s10,16(sp)
    8000315c:	6da2                	ld	s11,8(sp)
    8000315e:	6165                	addi	sp,sp,112
    80003160:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003162:	8a5e                	mv	s4,s7
    80003164:	bfc9                	j	80003136 <writei+0xe2>
    return -1;
    80003166:	557d                	li	a0,-1
}
    80003168:	8082                	ret
    return -1;
    8000316a:	557d                	li	a0,-1
    8000316c:	bfe1                	j	80003144 <writei+0xf0>
    return -1;
    8000316e:	557d                	li	a0,-1
    80003170:	bfd1                	j	80003144 <writei+0xf0>

0000000080003172 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003172:	1141                	addi	sp,sp,-16
    80003174:	e406                	sd	ra,8(sp)
    80003176:	e022                	sd	s0,0(sp)
    80003178:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000317a:	4639                	li	a2,14
    8000317c:	ffffd097          	auipc	ra,0xffffd
    80003180:	248080e7          	jalr	584(ra) # 800003c4 <strncmp>
}
    80003184:	60a2                	ld	ra,8(sp)
    80003186:	6402                	ld	s0,0(sp)
    80003188:	0141                	addi	sp,sp,16
    8000318a:	8082                	ret

000000008000318c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000318c:	7139                	addi	sp,sp,-64
    8000318e:	fc06                	sd	ra,56(sp)
    80003190:	f822                	sd	s0,48(sp)
    80003192:	f426                	sd	s1,40(sp)
    80003194:	f04a                	sd	s2,32(sp)
    80003196:	ec4e                	sd	s3,24(sp)
    80003198:	e852                	sd	s4,16(sp)
    8000319a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000319c:	04451703          	lh	a4,68(a0)
    800031a0:	4785                	li	a5,1
    800031a2:	00f71a63          	bne	a4,a5,800031b6 <dirlookup+0x2a>
    800031a6:	892a                	mv	s2,a0
    800031a8:	89ae                	mv	s3,a1
    800031aa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ac:	457c                	lw	a5,76(a0)
    800031ae:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031b0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b2:	e79d                	bnez	a5,800031e0 <dirlookup+0x54>
    800031b4:	a8a5                	j	8000322c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031b6:	00005517          	auipc	a0,0x5
    800031ba:	3b250513          	addi	a0,a0,946 # 80008568 <syscalls+0x1a0>
    800031be:	00003097          	auipc	ra,0x3
    800031c2:	b9a080e7          	jalr	-1126(ra) # 80005d58 <panic>
      panic("dirlookup read");
    800031c6:	00005517          	auipc	a0,0x5
    800031ca:	3ba50513          	addi	a0,a0,954 # 80008580 <syscalls+0x1b8>
    800031ce:	00003097          	auipc	ra,0x3
    800031d2:	b8a080e7          	jalr	-1142(ra) # 80005d58 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031d6:	24c1                	addiw	s1,s1,16
    800031d8:	04c92783          	lw	a5,76(s2)
    800031dc:	04f4f763          	bgeu	s1,a5,8000322a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031e0:	4741                	li	a4,16
    800031e2:	86a6                	mv	a3,s1
    800031e4:	fc040613          	addi	a2,s0,-64
    800031e8:	4581                	li	a1,0
    800031ea:	854a                	mv	a0,s2
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	d70080e7          	jalr	-656(ra) # 80002f5c <readi>
    800031f4:	47c1                	li	a5,16
    800031f6:	fcf518e3          	bne	a0,a5,800031c6 <dirlookup+0x3a>
    if(de.inum == 0)
    800031fa:	fc045783          	lhu	a5,-64(s0)
    800031fe:	dfe1                	beqz	a5,800031d6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003200:	fc240593          	addi	a1,s0,-62
    80003204:	854e                	mv	a0,s3
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	f6c080e7          	jalr	-148(ra) # 80003172 <namecmp>
    8000320e:	f561                	bnez	a0,800031d6 <dirlookup+0x4a>
      if(poff)
    80003210:	000a0463          	beqz	s4,80003218 <dirlookup+0x8c>
        *poff = off;
    80003214:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003218:	fc045583          	lhu	a1,-64(s0)
    8000321c:	00092503          	lw	a0,0(s2)
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	754080e7          	jalr	1876(ra) # 80002974 <iget>
    80003228:	a011                	j	8000322c <dirlookup+0xa0>
  return 0;
    8000322a:	4501                	li	a0,0
}
    8000322c:	70e2                	ld	ra,56(sp)
    8000322e:	7442                	ld	s0,48(sp)
    80003230:	74a2                	ld	s1,40(sp)
    80003232:	7902                	ld	s2,32(sp)
    80003234:	69e2                	ld	s3,24(sp)
    80003236:	6a42                	ld	s4,16(sp)
    80003238:	6121                	addi	sp,sp,64
    8000323a:	8082                	ret

000000008000323c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000323c:	711d                	addi	sp,sp,-96
    8000323e:	ec86                	sd	ra,88(sp)
    80003240:	e8a2                	sd	s0,80(sp)
    80003242:	e4a6                	sd	s1,72(sp)
    80003244:	e0ca                	sd	s2,64(sp)
    80003246:	fc4e                	sd	s3,56(sp)
    80003248:	f852                	sd	s4,48(sp)
    8000324a:	f456                	sd	s5,40(sp)
    8000324c:	f05a                	sd	s6,32(sp)
    8000324e:	ec5e                	sd	s7,24(sp)
    80003250:	e862                	sd	s8,16(sp)
    80003252:	e466                	sd	s9,8(sp)
    80003254:	1080                	addi	s0,sp,96
    80003256:	84aa                	mv	s1,a0
    80003258:	8b2e                	mv	s6,a1
    8000325a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000325c:	00054703          	lbu	a4,0(a0)
    80003260:	02f00793          	li	a5,47
    80003264:	02f70363          	beq	a4,a5,8000328a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003268:	ffffe097          	auipc	ra,0xffffe
    8000326c:	d5a080e7          	jalr	-678(ra) # 80000fc2 <myproc>
    80003270:	15053503          	ld	a0,336(a0)
    80003274:	00000097          	auipc	ra,0x0
    80003278:	9f6080e7          	jalr	-1546(ra) # 80002c6a <idup>
    8000327c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000327e:	02f00913          	li	s2,47
  len = path - s;
    80003282:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003284:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003286:	4c05                	li	s8,1
    80003288:	a865                	j	80003340 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000328a:	4585                	li	a1,1
    8000328c:	4505                	li	a0,1
    8000328e:	fffff097          	auipc	ra,0xfffff
    80003292:	6e6080e7          	jalr	1766(ra) # 80002974 <iget>
    80003296:	89aa                	mv	s3,a0
    80003298:	b7dd                	j	8000327e <namex+0x42>
      iunlockput(ip);
    8000329a:	854e                	mv	a0,s3
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	c6e080e7          	jalr	-914(ra) # 80002f0a <iunlockput>
      return 0;
    800032a4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032a6:	854e                	mv	a0,s3
    800032a8:	60e6                	ld	ra,88(sp)
    800032aa:	6446                	ld	s0,80(sp)
    800032ac:	64a6                	ld	s1,72(sp)
    800032ae:	6906                	ld	s2,64(sp)
    800032b0:	79e2                	ld	s3,56(sp)
    800032b2:	7a42                	ld	s4,48(sp)
    800032b4:	7aa2                	ld	s5,40(sp)
    800032b6:	7b02                	ld	s6,32(sp)
    800032b8:	6be2                	ld	s7,24(sp)
    800032ba:	6c42                	ld	s8,16(sp)
    800032bc:	6ca2                	ld	s9,8(sp)
    800032be:	6125                	addi	sp,sp,96
    800032c0:	8082                	ret
      iunlock(ip);
    800032c2:	854e                	mv	a0,s3
    800032c4:	00000097          	auipc	ra,0x0
    800032c8:	aa6080e7          	jalr	-1370(ra) # 80002d6a <iunlock>
      return ip;
    800032cc:	bfe9                	j	800032a6 <namex+0x6a>
      iunlockput(ip);
    800032ce:	854e                	mv	a0,s3
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	c3a080e7          	jalr	-966(ra) # 80002f0a <iunlockput>
      return 0;
    800032d8:	89d2                	mv	s3,s4
    800032da:	b7f1                	j	800032a6 <namex+0x6a>
  len = path - s;
    800032dc:	40b48633          	sub	a2,s1,a1
    800032e0:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032e4:	094cd463          	bge	s9,s4,8000336c <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032e8:	4639                	li	a2,14
    800032ea:	8556                	mv	a0,s5
    800032ec:	ffffd097          	auipc	ra,0xffffd
    800032f0:	060080e7          	jalr	96(ra) # 8000034c <memmove>
  while(*path == '/')
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	01279763          	bne	a5,s2,80003306 <namex+0xca>
    path++;
    800032fc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	ff278de3          	beq	a5,s2,800032fc <namex+0xc0>
    ilock(ip);
    80003306:	854e                	mv	a0,s3
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	9a0080e7          	jalr	-1632(ra) # 80002ca8 <ilock>
    if(ip->type != T_DIR){
    80003310:	04499783          	lh	a5,68(s3)
    80003314:	f98793e3          	bne	a5,s8,8000329a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003318:	000b0563          	beqz	s6,80003322 <namex+0xe6>
    8000331c:	0004c783          	lbu	a5,0(s1)
    80003320:	d3cd                	beqz	a5,800032c2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003322:	865e                	mv	a2,s7
    80003324:	85d6                	mv	a1,s5
    80003326:	854e                	mv	a0,s3
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	e64080e7          	jalr	-412(ra) # 8000318c <dirlookup>
    80003330:	8a2a                	mv	s4,a0
    80003332:	dd51                	beqz	a0,800032ce <namex+0x92>
    iunlockput(ip);
    80003334:	854e                	mv	a0,s3
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	bd4080e7          	jalr	-1068(ra) # 80002f0a <iunlockput>
    ip = next;
    8000333e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003340:	0004c783          	lbu	a5,0(s1)
    80003344:	05279763          	bne	a5,s2,80003392 <namex+0x156>
    path++;
    80003348:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000334a:	0004c783          	lbu	a5,0(s1)
    8000334e:	ff278de3          	beq	a5,s2,80003348 <namex+0x10c>
  if(*path == 0)
    80003352:	c79d                	beqz	a5,80003380 <namex+0x144>
    path++;
    80003354:	85a6                	mv	a1,s1
  len = path - s;
    80003356:	8a5e                	mv	s4,s7
    80003358:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000335a:	01278963          	beq	a5,s2,8000336c <namex+0x130>
    8000335e:	dfbd                	beqz	a5,800032dc <namex+0xa0>
    path++;
    80003360:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003362:	0004c783          	lbu	a5,0(s1)
    80003366:	ff279ce3          	bne	a5,s2,8000335e <namex+0x122>
    8000336a:	bf8d                	j	800032dc <namex+0xa0>
    memmove(name, s, len);
    8000336c:	2601                	sext.w	a2,a2
    8000336e:	8556                	mv	a0,s5
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	fdc080e7          	jalr	-36(ra) # 8000034c <memmove>
    name[len] = 0;
    80003378:	9a56                	add	s4,s4,s5
    8000337a:	000a0023          	sb	zero,0(s4)
    8000337e:	bf9d                	j	800032f4 <namex+0xb8>
  if(nameiparent){
    80003380:	f20b03e3          	beqz	s6,800032a6 <namex+0x6a>
    iput(ip);
    80003384:	854e                	mv	a0,s3
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	adc080e7          	jalr	-1316(ra) # 80002e62 <iput>
    return 0;
    8000338e:	4981                	li	s3,0
    80003390:	bf19                	j	800032a6 <namex+0x6a>
  if(*path == 0)
    80003392:	d7fd                	beqz	a5,80003380 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003394:	0004c783          	lbu	a5,0(s1)
    80003398:	85a6                	mv	a1,s1
    8000339a:	b7d1                	j	8000335e <namex+0x122>

000000008000339c <dirlink>:
{
    8000339c:	7139                	addi	sp,sp,-64
    8000339e:	fc06                	sd	ra,56(sp)
    800033a0:	f822                	sd	s0,48(sp)
    800033a2:	f426                	sd	s1,40(sp)
    800033a4:	f04a                	sd	s2,32(sp)
    800033a6:	ec4e                	sd	s3,24(sp)
    800033a8:	e852                	sd	s4,16(sp)
    800033aa:	0080                	addi	s0,sp,64
    800033ac:	892a                	mv	s2,a0
    800033ae:	8a2e                	mv	s4,a1
    800033b0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033b2:	4601                	li	a2,0
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	dd8080e7          	jalr	-552(ra) # 8000318c <dirlookup>
    800033bc:	e93d                	bnez	a0,80003432 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033be:	04c92483          	lw	s1,76(s2)
    800033c2:	c49d                	beqz	s1,800033f0 <dirlink+0x54>
    800033c4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c6:	4741                	li	a4,16
    800033c8:	86a6                	mv	a3,s1
    800033ca:	fc040613          	addi	a2,s0,-64
    800033ce:	4581                	li	a1,0
    800033d0:	854a                	mv	a0,s2
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	b8a080e7          	jalr	-1142(ra) # 80002f5c <readi>
    800033da:	47c1                	li	a5,16
    800033dc:	06f51163          	bne	a0,a5,8000343e <dirlink+0xa2>
    if(de.inum == 0)
    800033e0:	fc045783          	lhu	a5,-64(s0)
    800033e4:	c791                	beqz	a5,800033f0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033e6:	24c1                	addiw	s1,s1,16
    800033e8:	04c92783          	lw	a5,76(s2)
    800033ec:	fcf4ede3          	bltu	s1,a5,800033c6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033f0:	4639                	li	a2,14
    800033f2:	85d2                	mv	a1,s4
    800033f4:	fc240513          	addi	a0,s0,-62
    800033f8:	ffffd097          	auipc	ra,0xffffd
    800033fc:	008080e7          	jalr	8(ra) # 80000400 <strncpy>
  de.inum = inum;
    80003400:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003404:	4741                	li	a4,16
    80003406:	86a6                	mv	a3,s1
    80003408:	fc040613          	addi	a2,s0,-64
    8000340c:	4581                	li	a1,0
    8000340e:	854a                	mv	a0,s2
    80003410:	00000097          	auipc	ra,0x0
    80003414:	c44080e7          	jalr	-956(ra) # 80003054 <writei>
    80003418:	872a                	mv	a4,a0
    8000341a:	47c1                	li	a5,16
  return 0;
    8000341c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000341e:	02f71863          	bne	a4,a5,8000344e <dirlink+0xb2>
}
    80003422:	70e2                	ld	ra,56(sp)
    80003424:	7442                	ld	s0,48(sp)
    80003426:	74a2                	ld	s1,40(sp)
    80003428:	7902                	ld	s2,32(sp)
    8000342a:	69e2                	ld	s3,24(sp)
    8000342c:	6a42                	ld	s4,16(sp)
    8000342e:	6121                	addi	sp,sp,64
    80003430:	8082                	ret
    iput(ip);
    80003432:	00000097          	auipc	ra,0x0
    80003436:	a30080e7          	jalr	-1488(ra) # 80002e62 <iput>
    return -1;
    8000343a:	557d                	li	a0,-1
    8000343c:	b7dd                	j	80003422 <dirlink+0x86>
      panic("dirlink read");
    8000343e:	00005517          	auipc	a0,0x5
    80003442:	15250513          	addi	a0,a0,338 # 80008590 <syscalls+0x1c8>
    80003446:	00003097          	auipc	ra,0x3
    8000344a:	912080e7          	jalr	-1774(ra) # 80005d58 <panic>
    panic("dirlink");
    8000344e:	00005517          	auipc	a0,0x5
    80003452:	25250513          	addi	a0,a0,594 # 800086a0 <syscalls+0x2d8>
    80003456:	00003097          	auipc	ra,0x3
    8000345a:	902080e7          	jalr	-1790(ra) # 80005d58 <panic>

000000008000345e <namei>:

struct inode*
namei(char *path)
{
    8000345e:	1101                	addi	sp,sp,-32
    80003460:	ec06                	sd	ra,24(sp)
    80003462:	e822                	sd	s0,16(sp)
    80003464:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003466:	fe040613          	addi	a2,s0,-32
    8000346a:	4581                	li	a1,0
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	dd0080e7          	jalr	-560(ra) # 8000323c <namex>
}
    80003474:	60e2                	ld	ra,24(sp)
    80003476:	6442                	ld	s0,16(sp)
    80003478:	6105                	addi	sp,sp,32
    8000347a:	8082                	ret

000000008000347c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000347c:	1141                	addi	sp,sp,-16
    8000347e:	e406                	sd	ra,8(sp)
    80003480:	e022                	sd	s0,0(sp)
    80003482:	0800                	addi	s0,sp,16
    80003484:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003486:	4585                	li	a1,1
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	db4080e7          	jalr	-588(ra) # 8000323c <namex>
}
    80003490:	60a2                	ld	ra,8(sp)
    80003492:	6402                	ld	s0,0(sp)
    80003494:	0141                	addi	sp,sp,16
    80003496:	8082                	ret

0000000080003498 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003498:	1101                	addi	sp,sp,-32
    8000349a:	ec06                	sd	ra,24(sp)
    8000349c:	e822                	sd	s0,16(sp)
    8000349e:	e426                	sd	s1,8(sp)
    800034a0:	e04a                	sd	s2,0(sp)
    800034a2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034a4:	00236917          	auipc	s2,0x236
    800034a8:	b7c90913          	addi	s2,s2,-1156 # 80239020 <log>
    800034ac:	01892583          	lw	a1,24(s2)
    800034b0:	02892503          	lw	a0,40(s2)
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	ff2080e7          	jalr	-14(ra) # 800024a6 <bread>
    800034bc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034be:	02c92683          	lw	a3,44(s2)
    800034c2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034c4:	02d05763          	blez	a3,800034f2 <write_head+0x5a>
    800034c8:	00236797          	auipc	a5,0x236
    800034cc:	b8878793          	addi	a5,a5,-1144 # 80239050 <log+0x30>
    800034d0:	05c50713          	addi	a4,a0,92
    800034d4:	36fd                	addiw	a3,a3,-1
    800034d6:	1682                	slli	a3,a3,0x20
    800034d8:	9281                	srli	a3,a3,0x20
    800034da:	068a                	slli	a3,a3,0x2
    800034dc:	00236617          	auipc	a2,0x236
    800034e0:	b7860613          	addi	a2,a2,-1160 # 80239054 <log+0x34>
    800034e4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034e6:	4390                	lw	a2,0(a5)
    800034e8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034ea:	0791                	addi	a5,a5,4
    800034ec:	0711                	addi	a4,a4,4
    800034ee:	fed79ce3          	bne	a5,a3,800034e6 <write_head+0x4e>
  }
  bwrite(buf);
    800034f2:	8526                	mv	a0,s1
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	0a4080e7          	jalr	164(ra) # 80002598 <bwrite>
  brelse(buf);
    800034fc:	8526                	mv	a0,s1
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	0d8080e7          	jalr	216(ra) # 800025d6 <brelse>
}
    80003506:	60e2                	ld	ra,24(sp)
    80003508:	6442                	ld	s0,16(sp)
    8000350a:	64a2                	ld	s1,8(sp)
    8000350c:	6902                	ld	s2,0(sp)
    8000350e:	6105                	addi	sp,sp,32
    80003510:	8082                	ret

0000000080003512 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003512:	00236797          	auipc	a5,0x236
    80003516:	b3a7a783          	lw	a5,-1222(a5) # 8023904c <log+0x2c>
    8000351a:	0af05d63          	blez	a5,800035d4 <install_trans+0xc2>
{
    8000351e:	7139                	addi	sp,sp,-64
    80003520:	fc06                	sd	ra,56(sp)
    80003522:	f822                	sd	s0,48(sp)
    80003524:	f426                	sd	s1,40(sp)
    80003526:	f04a                	sd	s2,32(sp)
    80003528:	ec4e                	sd	s3,24(sp)
    8000352a:	e852                	sd	s4,16(sp)
    8000352c:	e456                	sd	s5,8(sp)
    8000352e:	e05a                	sd	s6,0(sp)
    80003530:	0080                	addi	s0,sp,64
    80003532:	8b2a                	mv	s6,a0
    80003534:	00236a97          	auipc	s5,0x236
    80003538:	b1ca8a93          	addi	s5,s5,-1252 # 80239050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000353c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000353e:	00236997          	auipc	s3,0x236
    80003542:	ae298993          	addi	s3,s3,-1310 # 80239020 <log>
    80003546:	a035                	j	80003572 <install_trans+0x60>
      bunpin(dbuf);
    80003548:	8526                	mv	a0,s1
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	166080e7          	jalr	358(ra) # 800026b0 <bunpin>
    brelse(lbuf);
    80003552:	854a                	mv	a0,s2
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	082080e7          	jalr	130(ra) # 800025d6 <brelse>
    brelse(dbuf);
    8000355c:	8526                	mv	a0,s1
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	078080e7          	jalr	120(ra) # 800025d6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003566:	2a05                	addiw	s4,s4,1
    80003568:	0a91                	addi	s5,s5,4
    8000356a:	02c9a783          	lw	a5,44(s3)
    8000356e:	04fa5963          	bge	s4,a5,800035c0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003572:	0189a583          	lw	a1,24(s3)
    80003576:	014585bb          	addw	a1,a1,s4
    8000357a:	2585                	addiw	a1,a1,1
    8000357c:	0289a503          	lw	a0,40(s3)
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	f26080e7          	jalr	-218(ra) # 800024a6 <bread>
    80003588:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000358a:	000aa583          	lw	a1,0(s5)
    8000358e:	0289a503          	lw	a0,40(s3)
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	f14080e7          	jalr	-236(ra) # 800024a6 <bread>
    8000359a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000359c:	40000613          	li	a2,1024
    800035a0:	05890593          	addi	a1,s2,88
    800035a4:	05850513          	addi	a0,a0,88
    800035a8:	ffffd097          	auipc	ra,0xffffd
    800035ac:	da4080e7          	jalr	-604(ra) # 8000034c <memmove>
    bwrite(dbuf);  // write dst to disk
    800035b0:	8526                	mv	a0,s1
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	fe6080e7          	jalr	-26(ra) # 80002598 <bwrite>
    if(recovering == 0)
    800035ba:	f80b1ce3          	bnez	s6,80003552 <install_trans+0x40>
    800035be:	b769                	j	80003548 <install_trans+0x36>
}
    800035c0:	70e2                	ld	ra,56(sp)
    800035c2:	7442                	ld	s0,48(sp)
    800035c4:	74a2                	ld	s1,40(sp)
    800035c6:	7902                	ld	s2,32(sp)
    800035c8:	69e2                	ld	s3,24(sp)
    800035ca:	6a42                	ld	s4,16(sp)
    800035cc:	6aa2                	ld	s5,8(sp)
    800035ce:	6b02                	ld	s6,0(sp)
    800035d0:	6121                	addi	sp,sp,64
    800035d2:	8082                	ret
    800035d4:	8082                	ret

00000000800035d6 <initlog>:
{
    800035d6:	7179                	addi	sp,sp,-48
    800035d8:	f406                	sd	ra,40(sp)
    800035da:	f022                	sd	s0,32(sp)
    800035dc:	ec26                	sd	s1,24(sp)
    800035de:	e84a                	sd	s2,16(sp)
    800035e0:	e44e                	sd	s3,8(sp)
    800035e2:	1800                	addi	s0,sp,48
    800035e4:	892a                	mv	s2,a0
    800035e6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035e8:	00236497          	auipc	s1,0x236
    800035ec:	a3848493          	addi	s1,s1,-1480 # 80239020 <log>
    800035f0:	00005597          	auipc	a1,0x5
    800035f4:	fb058593          	addi	a1,a1,-80 # 800085a0 <syscalls+0x1d8>
    800035f8:	8526                	mv	a0,s1
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	c18080e7          	jalr	-1000(ra) # 80006212 <initlock>
  log.start = sb->logstart;
    80003602:	0149a583          	lw	a1,20(s3)
    80003606:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003608:	0109a783          	lw	a5,16(s3)
    8000360c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000360e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003612:	854a                	mv	a0,s2
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	e92080e7          	jalr	-366(ra) # 800024a6 <bread>
  log.lh.n = lh->n;
    8000361c:	4d3c                	lw	a5,88(a0)
    8000361e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003620:	02f05563          	blez	a5,8000364a <initlog+0x74>
    80003624:	05c50713          	addi	a4,a0,92
    80003628:	00236697          	auipc	a3,0x236
    8000362c:	a2868693          	addi	a3,a3,-1496 # 80239050 <log+0x30>
    80003630:	37fd                	addiw	a5,a5,-1
    80003632:	1782                	slli	a5,a5,0x20
    80003634:	9381                	srli	a5,a5,0x20
    80003636:	078a                	slli	a5,a5,0x2
    80003638:	06050613          	addi	a2,a0,96
    8000363c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000363e:	4310                	lw	a2,0(a4)
    80003640:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003642:	0711                	addi	a4,a4,4
    80003644:	0691                	addi	a3,a3,4
    80003646:	fef71ce3          	bne	a4,a5,8000363e <initlog+0x68>
  brelse(buf);
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	f8c080e7          	jalr	-116(ra) # 800025d6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003652:	4505                	li	a0,1
    80003654:	00000097          	auipc	ra,0x0
    80003658:	ebe080e7          	jalr	-322(ra) # 80003512 <install_trans>
  log.lh.n = 0;
    8000365c:	00236797          	auipc	a5,0x236
    80003660:	9e07a823          	sw	zero,-1552(a5) # 8023904c <log+0x2c>
  write_head(); // clear the log
    80003664:	00000097          	auipc	ra,0x0
    80003668:	e34080e7          	jalr	-460(ra) # 80003498 <write_head>
}
    8000366c:	70a2                	ld	ra,40(sp)
    8000366e:	7402                	ld	s0,32(sp)
    80003670:	64e2                	ld	s1,24(sp)
    80003672:	6942                	ld	s2,16(sp)
    80003674:	69a2                	ld	s3,8(sp)
    80003676:	6145                	addi	sp,sp,48
    80003678:	8082                	ret

000000008000367a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000367a:	1101                	addi	sp,sp,-32
    8000367c:	ec06                	sd	ra,24(sp)
    8000367e:	e822                	sd	s0,16(sp)
    80003680:	e426                	sd	s1,8(sp)
    80003682:	e04a                	sd	s2,0(sp)
    80003684:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003686:	00236517          	auipc	a0,0x236
    8000368a:	99a50513          	addi	a0,a0,-1638 # 80239020 <log>
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	c14080e7          	jalr	-1004(ra) # 800062a2 <acquire>
  while(1){
    if(log.committing){
    80003696:	00236497          	auipc	s1,0x236
    8000369a:	98a48493          	addi	s1,s1,-1654 # 80239020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000369e:	4979                	li	s2,30
    800036a0:	a039                	j	800036ae <begin_op+0x34>
      sleep(&log, &log.lock);
    800036a2:	85a6                	mv	a1,s1
    800036a4:	8526                	mv	a0,s1
    800036a6:	ffffe097          	auipc	ra,0xffffe
    800036aa:	fd8080e7          	jalr	-40(ra) # 8000167e <sleep>
    if(log.committing){
    800036ae:	50dc                	lw	a5,36(s1)
    800036b0:	fbed                	bnez	a5,800036a2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036b2:	509c                	lw	a5,32(s1)
    800036b4:	0017871b          	addiw	a4,a5,1
    800036b8:	0007069b          	sext.w	a3,a4
    800036bc:	0027179b          	slliw	a5,a4,0x2
    800036c0:	9fb9                	addw	a5,a5,a4
    800036c2:	0017979b          	slliw	a5,a5,0x1
    800036c6:	54d8                	lw	a4,44(s1)
    800036c8:	9fb9                	addw	a5,a5,a4
    800036ca:	00f95963          	bge	s2,a5,800036dc <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036ce:	85a6                	mv	a1,s1
    800036d0:	8526                	mv	a0,s1
    800036d2:	ffffe097          	auipc	ra,0xffffe
    800036d6:	fac080e7          	jalr	-84(ra) # 8000167e <sleep>
    800036da:	bfd1                	j	800036ae <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036dc:	00236517          	auipc	a0,0x236
    800036e0:	94450513          	addi	a0,a0,-1724 # 80239020 <log>
    800036e4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036e6:	00003097          	auipc	ra,0x3
    800036ea:	c70080e7          	jalr	-912(ra) # 80006356 <release>
      break;
    }
  }
}
    800036ee:	60e2                	ld	ra,24(sp)
    800036f0:	6442                	ld	s0,16(sp)
    800036f2:	64a2                	ld	s1,8(sp)
    800036f4:	6902                	ld	s2,0(sp)
    800036f6:	6105                	addi	sp,sp,32
    800036f8:	8082                	ret

00000000800036fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036fa:	7139                	addi	sp,sp,-64
    800036fc:	fc06                	sd	ra,56(sp)
    800036fe:	f822                	sd	s0,48(sp)
    80003700:	f426                	sd	s1,40(sp)
    80003702:	f04a                	sd	s2,32(sp)
    80003704:	ec4e                	sd	s3,24(sp)
    80003706:	e852                	sd	s4,16(sp)
    80003708:	e456                	sd	s5,8(sp)
    8000370a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000370c:	00236497          	auipc	s1,0x236
    80003710:	91448493          	addi	s1,s1,-1772 # 80239020 <log>
    80003714:	8526                	mv	a0,s1
    80003716:	00003097          	auipc	ra,0x3
    8000371a:	b8c080e7          	jalr	-1140(ra) # 800062a2 <acquire>
  log.outstanding -= 1;
    8000371e:	509c                	lw	a5,32(s1)
    80003720:	37fd                	addiw	a5,a5,-1
    80003722:	0007891b          	sext.w	s2,a5
    80003726:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003728:	50dc                	lw	a5,36(s1)
    8000372a:	efb9                	bnez	a5,80003788 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000372c:	06091663          	bnez	s2,80003798 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003730:	00236497          	auipc	s1,0x236
    80003734:	8f048493          	addi	s1,s1,-1808 # 80239020 <log>
    80003738:	4785                	li	a5,1
    8000373a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000373c:	8526                	mv	a0,s1
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	c18080e7          	jalr	-1000(ra) # 80006356 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003746:	54dc                	lw	a5,44(s1)
    80003748:	06f04763          	bgtz	a5,800037b6 <end_op+0xbc>
    acquire(&log.lock);
    8000374c:	00236497          	auipc	s1,0x236
    80003750:	8d448493          	addi	s1,s1,-1836 # 80239020 <log>
    80003754:	8526                	mv	a0,s1
    80003756:	00003097          	auipc	ra,0x3
    8000375a:	b4c080e7          	jalr	-1204(ra) # 800062a2 <acquire>
    log.committing = 0;
    8000375e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003762:	8526                	mv	a0,s1
    80003764:	ffffe097          	auipc	ra,0xffffe
    80003768:	0a6080e7          	jalr	166(ra) # 8000180a <wakeup>
    release(&log.lock);
    8000376c:	8526                	mv	a0,s1
    8000376e:	00003097          	auipc	ra,0x3
    80003772:	be8080e7          	jalr	-1048(ra) # 80006356 <release>
}
    80003776:	70e2                	ld	ra,56(sp)
    80003778:	7442                	ld	s0,48(sp)
    8000377a:	74a2                	ld	s1,40(sp)
    8000377c:	7902                	ld	s2,32(sp)
    8000377e:	69e2                	ld	s3,24(sp)
    80003780:	6a42                	ld	s4,16(sp)
    80003782:	6aa2                	ld	s5,8(sp)
    80003784:	6121                	addi	sp,sp,64
    80003786:	8082                	ret
    panic("log.committing");
    80003788:	00005517          	auipc	a0,0x5
    8000378c:	e2050513          	addi	a0,a0,-480 # 800085a8 <syscalls+0x1e0>
    80003790:	00002097          	auipc	ra,0x2
    80003794:	5c8080e7          	jalr	1480(ra) # 80005d58 <panic>
    wakeup(&log);
    80003798:	00236497          	auipc	s1,0x236
    8000379c:	88848493          	addi	s1,s1,-1912 # 80239020 <log>
    800037a0:	8526                	mv	a0,s1
    800037a2:	ffffe097          	auipc	ra,0xffffe
    800037a6:	068080e7          	jalr	104(ra) # 8000180a <wakeup>
  release(&log.lock);
    800037aa:	8526                	mv	a0,s1
    800037ac:	00003097          	auipc	ra,0x3
    800037b0:	baa080e7          	jalr	-1110(ra) # 80006356 <release>
  if(do_commit){
    800037b4:	b7c9                	j	80003776 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037b6:	00236a97          	auipc	s5,0x236
    800037ba:	89aa8a93          	addi	s5,s5,-1894 # 80239050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037be:	00236a17          	auipc	s4,0x236
    800037c2:	862a0a13          	addi	s4,s4,-1950 # 80239020 <log>
    800037c6:	018a2583          	lw	a1,24(s4)
    800037ca:	012585bb          	addw	a1,a1,s2
    800037ce:	2585                	addiw	a1,a1,1
    800037d0:	028a2503          	lw	a0,40(s4)
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	cd2080e7          	jalr	-814(ra) # 800024a6 <bread>
    800037dc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037de:	000aa583          	lw	a1,0(s5)
    800037e2:	028a2503          	lw	a0,40(s4)
    800037e6:	fffff097          	auipc	ra,0xfffff
    800037ea:	cc0080e7          	jalr	-832(ra) # 800024a6 <bread>
    800037ee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037f0:	40000613          	li	a2,1024
    800037f4:	05850593          	addi	a1,a0,88
    800037f8:	05848513          	addi	a0,s1,88
    800037fc:	ffffd097          	auipc	ra,0xffffd
    80003800:	b50080e7          	jalr	-1200(ra) # 8000034c <memmove>
    bwrite(to);  // write the log
    80003804:	8526                	mv	a0,s1
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	d92080e7          	jalr	-622(ra) # 80002598 <bwrite>
    brelse(from);
    8000380e:	854e                	mv	a0,s3
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	dc6080e7          	jalr	-570(ra) # 800025d6 <brelse>
    brelse(to);
    80003818:	8526                	mv	a0,s1
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	dbc080e7          	jalr	-580(ra) # 800025d6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003822:	2905                	addiw	s2,s2,1
    80003824:	0a91                	addi	s5,s5,4
    80003826:	02ca2783          	lw	a5,44(s4)
    8000382a:	f8f94ee3          	blt	s2,a5,800037c6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000382e:	00000097          	auipc	ra,0x0
    80003832:	c6a080e7          	jalr	-918(ra) # 80003498 <write_head>
    install_trans(0); // Now install writes to home locations
    80003836:	4501                	li	a0,0
    80003838:	00000097          	auipc	ra,0x0
    8000383c:	cda080e7          	jalr	-806(ra) # 80003512 <install_trans>
    log.lh.n = 0;
    80003840:	00236797          	auipc	a5,0x236
    80003844:	8007a623          	sw	zero,-2036(a5) # 8023904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003848:	00000097          	auipc	ra,0x0
    8000384c:	c50080e7          	jalr	-944(ra) # 80003498 <write_head>
    80003850:	bdf5                	j	8000374c <end_op+0x52>

0000000080003852 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003852:	1101                	addi	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	e04a                	sd	s2,0(sp)
    8000385c:	1000                	addi	s0,sp,32
    8000385e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003860:	00235917          	auipc	s2,0x235
    80003864:	7c090913          	addi	s2,s2,1984 # 80239020 <log>
    80003868:	854a                	mv	a0,s2
    8000386a:	00003097          	auipc	ra,0x3
    8000386e:	a38080e7          	jalr	-1480(ra) # 800062a2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003872:	02c92603          	lw	a2,44(s2)
    80003876:	47f5                	li	a5,29
    80003878:	06c7c563          	blt	a5,a2,800038e2 <log_write+0x90>
    8000387c:	00235797          	auipc	a5,0x235
    80003880:	7c07a783          	lw	a5,1984(a5) # 8023903c <log+0x1c>
    80003884:	37fd                	addiw	a5,a5,-1
    80003886:	04f65e63          	bge	a2,a5,800038e2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000388a:	00235797          	auipc	a5,0x235
    8000388e:	7b67a783          	lw	a5,1974(a5) # 80239040 <log+0x20>
    80003892:	06f05063          	blez	a5,800038f2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003896:	4781                	li	a5,0
    80003898:	06c05563          	blez	a2,80003902 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000389c:	44cc                	lw	a1,12(s1)
    8000389e:	00235717          	auipc	a4,0x235
    800038a2:	7b270713          	addi	a4,a4,1970 # 80239050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038a6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038a8:	4314                	lw	a3,0(a4)
    800038aa:	04b68c63          	beq	a3,a1,80003902 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038ae:	2785                	addiw	a5,a5,1
    800038b0:	0711                	addi	a4,a4,4
    800038b2:	fef61be3          	bne	a2,a5,800038a8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038b6:	0621                	addi	a2,a2,8
    800038b8:	060a                	slli	a2,a2,0x2
    800038ba:	00235797          	auipc	a5,0x235
    800038be:	76678793          	addi	a5,a5,1894 # 80239020 <log>
    800038c2:	963e                	add	a2,a2,a5
    800038c4:	44dc                	lw	a5,12(s1)
    800038c6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038c8:	8526                	mv	a0,s1
    800038ca:	fffff097          	auipc	ra,0xfffff
    800038ce:	daa080e7          	jalr	-598(ra) # 80002674 <bpin>
    log.lh.n++;
    800038d2:	00235717          	auipc	a4,0x235
    800038d6:	74e70713          	addi	a4,a4,1870 # 80239020 <log>
    800038da:	575c                	lw	a5,44(a4)
    800038dc:	2785                	addiw	a5,a5,1
    800038de:	d75c                	sw	a5,44(a4)
    800038e0:	a835                	j	8000391c <log_write+0xca>
    panic("too big a transaction");
    800038e2:	00005517          	auipc	a0,0x5
    800038e6:	cd650513          	addi	a0,a0,-810 # 800085b8 <syscalls+0x1f0>
    800038ea:	00002097          	auipc	ra,0x2
    800038ee:	46e080e7          	jalr	1134(ra) # 80005d58 <panic>
    panic("log_write outside of trans");
    800038f2:	00005517          	auipc	a0,0x5
    800038f6:	cde50513          	addi	a0,a0,-802 # 800085d0 <syscalls+0x208>
    800038fa:	00002097          	auipc	ra,0x2
    800038fe:	45e080e7          	jalr	1118(ra) # 80005d58 <panic>
  log.lh.block[i] = b->blockno;
    80003902:	00878713          	addi	a4,a5,8
    80003906:	00271693          	slli	a3,a4,0x2
    8000390a:	00235717          	auipc	a4,0x235
    8000390e:	71670713          	addi	a4,a4,1814 # 80239020 <log>
    80003912:	9736                	add	a4,a4,a3
    80003914:	44d4                	lw	a3,12(s1)
    80003916:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003918:	faf608e3          	beq	a2,a5,800038c8 <log_write+0x76>
  }
  release(&log.lock);
    8000391c:	00235517          	auipc	a0,0x235
    80003920:	70450513          	addi	a0,a0,1796 # 80239020 <log>
    80003924:	00003097          	auipc	ra,0x3
    80003928:	a32080e7          	jalr	-1486(ra) # 80006356 <release>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003938:	1101                	addi	sp,sp,-32
    8000393a:	ec06                	sd	ra,24(sp)
    8000393c:	e822                	sd	s0,16(sp)
    8000393e:	e426                	sd	s1,8(sp)
    80003940:	e04a                	sd	s2,0(sp)
    80003942:	1000                	addi	s0,sp,32
    80003944:	84aa                	mv	s1,a0
    80003946:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003948:	00005597          	auipc	a1,0x5
    8000394c:	ca858593          	addi	a1,a1,-856 # 800085f0 <syscalls+0x228>
    80003950:	0521                	addi	a0,a0,8
    80003952:	00003097          	auipc	ra,0x3
    80003956:	8c0080e7          	jalr	-1856(ra) # 80006212 <initlock>
  lk->name = name;
    8000395a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000395e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003962:	0204a423          	sw	zero,40(s1)
}
    80003966:	60e2                	ld	ra,24(sp)
    80003968:	6442                	ld	s0,16(sp)
    8000396a:	64a2                	ld	s1,8(sp)
    8000396c:	6902                	ld	s2,0(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret

0000000080003972 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003972:	1101                	addi	sp,sp,-32
    80003974:	ec06                	sd	ra,24(sp)
    80003976:	e822                	sd	s0,16(sp)
    80003978:	e426                	sd	s1,8(sp)
    8000397a:	e04a                	sd	s2,0(sp)
    8000397c:	1000                	addi	s0,sp,32
    8000397e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003980:	00850913          	addi	s2,a0,8
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	91c080e7          	jalr	-1764(ra) # 800062a2 <acquire>
  while (lk->locked) {
    8000398e:	409c                	lw	a5,0(s1)
    80003990:	cb89                	beqz	a5,800039a2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003992:	85ca                	mv	a1,s2
    80003994:	8526                	mv	a0,s1
    80003996:	ffffe097          	auipc	ra,0xffffe
    8000399a:	ce8080e7          	jalr	-792(ra) # 8000167e <sleep>
  while (lk->locked) {
    8000399e:	409c                	lw	a5,0(s1)
    800039a0:	fbed                	bnez	a5,80003992 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039a2:	4785                	li	a5,1
    800039a4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039a6:	ffffd097          	auipc	ra,0xffffd
    800039aa:	61c080e7          	jalr	1564(ra) # 80000fc2 <myproc>
    800039ae:	591c                	lw	a5,48(a0)
    800039b0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039b2:	854a                	mv	a0,s2
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	9a2080e7          	jalr	-1630(ra) # 80006356 <release>
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6902                	ld	s2,0(sp)
    800039c4:	6105                	addi	sp,sp,32
    800039c6:	8082                	ret

00000000800039c8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039c8:	1101                	addi	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	e04a                	sd	s2,0(sp)
    800039d2:	1000                	addi	s0,sp,32
    800039d4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039d6:	00850913          	addi	s2,a0,8
    800039da:	854a                	mv	a0,s2
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	8c6080e7          	jalr	-1850(ra) # 800062a2 <acquire>
  lk->locked = 0;
    800039e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039e8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039ec:	8526                	mv	a0,s1
    800039ee:	ffffe097          	auipc	ra,0xffffe
    800039f2:	e1c080e7          	jalr	-484(ra) # 8000180a <wakeup>
  release(&lk->lk);
    800039f6:	854a                	mv	a0,s2
    800039f8:	00003097          	auipc	ra,0x3
    800039fc:	95e080e7          	jalr	-1698(ra) # 80006356 <release>
}
    80003a00:	60e2                	ld	ra,24(sp)
    80003a02:	6442                	ld	s0,16(sp)
    80003a04:	64a2                	ld	s1,8(sp)
    80003a06:	6902                	ld	s2,0(sp)
    80003a08:	6105                	addi	sp,sp,32
    80003a0a:	8082                	ret

0000000080003a0c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a0c:	7179                	addi	sp,sp,-48
    80003a0e:	f406                	sd	ra,40(sp)
    80003a10:	f022                	sd	s0,32(sp)
    80003a12:	ec26                	sd	s1,24(sp)
    80003a14:	e84a                	sd	s2,16(sp)
    80003a16:	e44e                	sd	s3,8(sp)
    80003a18:	1800                	addi	s0,sp,48
    80003a1a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a1c:	00850913          	addi	s2,a0,8
    80003a20:	854a                	mv	a0,s2
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	880080e7          	jalr	-1920(ra) # 800062a2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a2a:	409c                	lw	a5,0(s1)
    80003a2c:	ef99                	bnez	a5,80003a4a <holdingsleep+0x3e>
    80003a2e:	4481                	li	s1,0
  release(&lk->lk);
    80003a30:	854a                	mv	a0,s2
    80003a32:	00003097          	auipc	ra,0x3
    80003a36:	924080e7          	jalr	-1756(ra) # 80006356 <release>
  return r;
}
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	70a2                	ld	ra,40(sp)
    80003a3e:	7402                	ld	s0,32(sp)
    80003a40:	64e2                	ld	s1,24(sp)
    80003a42:	6942                	ld	s2,16(sp)
    80003a44:	69a2                	ld	s3,8(sp)
    80003a46:	6145                	addi	sp,sp,48
    80003a48:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a4a:	0284a983          	lw	s3,40(s1)
    80003a4e:	ffffd097          	auipc	ra,0xffffd
    80003a52:	574080e7          	jalr	1396(ra) # 80000fc2 <myproc>
    80003a56:	5904                	lw	s1,48(a0)
    80003a58:	413484b3          	sub	s1,s1,s3
    80003a5c:	0014b493          	seqz	s1,s1
    80003a60:	bfc1                	j	80003a30 <holdingsleep+0x24>

0000000080003a62 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a62:	1141                	addi	sp,sp,-16
    80003a64:	e406                	sd	ra,8(sp)
    80003a66:	e022                	sd	s0,0(sp)
    80003a68:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a6a:	00005597          	auipc	a1,0x5
    80003a6e:	b9658593          	addi	a1,a1,-1130 # 80008600 <syscalls+0x238>
    80003a72:	00235517          	auipc	a0,0x235
    80003a76:	6f650513          	addi	a0,a0,1782 # 80239168 <ftable>
    80003a7a:	00002097          	auipc	ra,0x2
    80003a7e:	798080e7          	jalr	1944(ra) # 80006212 <initlock>
}
    80003a82:	60a2                	ld	ra,8(sp)
    80003a84:	6402                	ld	s0,0(sp)
    80003a86:	0141                	addi	sp,sp,16
    80003a88:	8082                	ret

0000000080003a8a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a8a:	1101                	addi	sp,sp,-32
    80003a8c:	ec06                	sd	ra,24(sp)
    80003a8e:	e822                	sd	s0,16(sp)
    80003a90:	e426                	sd	s1,8(sp)
    80003a92:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a94:	00235517          	auipc	a0,0x235
    80003a98:	6d450513          	addi	a0,a0,1748 # 80239168 <ftable>
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	806080e7          	jalr	-2042(ra) # 800062a2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aa4:	00235497          	auipc	s1,0x235
    80003aa8:	6dc48493          	addi	s1,s1,1756 # 80239180 <ftable+0x18>
    80003aac:	00236717          	auipc	a4,0x236
    80003ab0:	67470713          	addi	a4,a4,1652 # 8023a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003ab4:	40dc                	lw	a5,4(s1)
    80003ab6:	cf99                	beqz	a5,80003ad4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ab8:	02848493          	addi	s1,s1,40
    80003abc:	fee49ce3          	bne	s1,a4,80003ab4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ac0:	00235517          	auipc	a0,0x235
    80003ac4:	6a850513          	addi	a0,a0,1704 # 80239168 <ftable>
    80003ac8:	00003097          	auipc	ra,0x3
    80003acc:	88e080e7          	jalr	-1906(ra) # 80006356 <release>
  return 0;
    80003ad0:	4481                	li	s1,0
    80003ad2:	a819                	j	80003ae8 <filealloc+0x5e>
      f->ref = 1;
    80003ad4:	4785                	li	a5,1
    80003ad6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ad8:	00235517          	auipc	a0,0x235
    80003adc:	69050513          	addi	a0,a0,1680 # 80239168 <ftable>
    80003ae0:	00003097          	auipc	ra,0x3
    80003ae4:	876080e7          	jalr	-1930(ra) # 80006356 <release>
}
    80003ae8:	8526                	mv	a0,s1
    80003aea:	60e2                	ld	ra,24(sp)
    80003aec:	6442                	ld	s0,16(sp)
    80003aee:	64a2                	ld	s1,8(sp)
    80003af0:	6105                	addi	sp,sp,32
    80003af2:	8082                	ret

0000000080003af4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003af4:	1101                	addi	sp,sp,-32
    80003af6:	ec06                	sd	ra,24(sp)
    80003af8:	e822                	sd	s0,16(sp)
    80003afa:	e426                	sd	s1,8(sp)
    80003afc:	1000                	addi	s0,sp,32
    80003afe:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b00:	00235517          	auipc	a0,0x235
    80003b04:	66850513          	addi	a0,a0,1640 # 80239168 <ftable>
    80003b08:	00002097          	auipc	ra,0x2
    80003b0c:	79a080e7          	jalr	1946(ra) # 800062a2 <acquire>
  if(f->ref < 1)
    80003b10:	40dc                	lw	a5,4(s1)
    80003b12:	02f05263          	blez	a5,80003b36 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b16:	2785                	addiw	a5,a5,1
    80003b18:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b1a:	00235517          	auipc	a0,0x235
    80003b1e:	64e50513          	addi	a0,a0,1614 # 80239168 <ftable>
    80003b22:	00003097          	auipc	ra,0x3
    80003b26:	834080e7          	jalr	-1996(ra) # 80006356 <release>
  return f;
}
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	60e2                	ld	ra,24(sp)
    80003b2e:	6442                	ld	s0,16(sp)
    80003b30:	64a2                	ld	s1,8(sp)
    80003b32:	6105                	addi	sp,sp,32
    80003b34:	8082                	ret
    panic("filedup");
    80003b36:	00005517          	auipc	a0,0x5
    80003b3a:	ad250513          	addi	a0,a0,-1326 # 80008608 <syscalls+0x240>
    80003b3e:	00002097          	auipc	ra,0x2
    80003b42:	21a080e7          	jalr	538(ra) # 80005d58 <panic>

0000000080003b46 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b46:	7139                	addi	sp,sp,-64
    80003b48:	fc06                	sd	ra,56(sp)
    80003b4a:	f822                	sd	s0,48(sp)
    80003b4c:	f426                	sd	s1,40(sp)
    80003b4e:	f04a                	sd	s2,32(sp)
    80003b50:	ec4e                	sd	s3,24(sp)
    80003b52:	e852                	sd	s4,16(sp)
    80003b54:	e456                	sd	s5,8(sp)
    80003b56:	0080                	addi	s0,sp,64
    80003b58:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b5a:	00235517          	auipc	a0,0x235
    80003b5e:	60e50513          	addi	a0,a0,1550 # 80239168 <ftable>
    80003b62:	00002097          	auipc	ra,0x2
    80003b66:	740080e7          	jalr	1856(ra) # 800062a2 <acquire>
  if(f->ref < 1)
    80003b6a:	40dc                	lw	a5,4(s1)
    80003b6c:	06f05163          	blez	a5,80003bce <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b70:	37fd                	addiw	a5,a5,-1
    80003b72:	0007871b          	sext.w	a4,a5
    80003b76:	c0dc                	sw	a5,4(s1)
    80003b78:	06e04363          	bgtz	a4,80003bde <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b7c:	0004a903          	lw	s2,0(s1)
    80003b80:	0094ca83          	lbu	s5,9(s1)
    80003b84:	0104ba03          	ld	s4,16(s1)
    80003b88:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b8c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b90:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b94:	00235517          	auipc	a0,0x235
    80003b98:	5d450513          	addi	a0,a0,1492 # 80239168 <ftable>
    80003b9c:	00002097          	auipc	ra,0x2
    80003ba0:	7ba080e7          	jalr	1978(ra) # 80006356 <release>

  if(ff.type == FD_PIPE){
    80003ba4:	4785                	li	a5,1
    80003ba6:	04f90d63          	beq	s2,a5,80003c00 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003baa:	3979                	addiw	s2,s2,-2
    80003bac:	4785                	li	a5,1
    80003bae:	0527e063          	bltu	a5,s2,80003bee <fileclose+0xa8>
    begin_op();
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	ac8080e7          	jalr	-1336(ra) # 8000367a <begin_op>
    iput(ff.ip);
    80003bba:	854e                	mv	a0,s3
    80003bbc:	fffff097          	auipc	ra,0xfffff
    80003bc0:	2a6080e7          	jalr	678(ra) # 80002e62 <iput>
    end_op();
    80003bc4:	00000097          	auipc	ra,0x0
    80003bc8:	b36080e7          	jalr	-1226(ra) # 800036fa <end_op>
    80003bcc:	a00d                	j	80003bee <fileclose+0xa8>
    panic("fileclose");
    80003bce:	00005517          	auipc	a0,0x5
    80003bd2:	a4250513          	addi	a0,a0,-1470 # 80008610 <syscalls+0x248>
    80003bd6:	00002097          	auipc	ra,0x2
    80003bda:	182080e7          	jalr	386(ra) # 80005d58 <panic>
    release(&ftable.lock);
    80003bde:	00235517          	auipc	a0,0x235
    80003be2:	58a50513          	addi	a0,a0,1418 # 80239168 <ftable>
    80003be6:	00002097          	auipc	ra,0x2
    80003bea:	770080e7          	jalr	1904(ra) # 80006356 <release>
  }
}
    80003bee:	70e2                	ld	ra,56(sp)
    80003bf0:	7442                	ld	s0,48(sp)
    80003bf2:	74a2                	ld	s1,40(sp)
    80003bf4:	7902                	ld	s2,32(sp)
    80003bf6:	69e2                	ld	s3,24(sp)
    80003bf8:	6a42                	ld	s4,16(sp)
    80003bfa:	6aa2                	ld	s5,8(sp)
    80003bfc:	6121                	addi	sp,sp,64
    80003bfe:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c00:	85d6                	mv	a1,s5
    80003c02:	8552                	mv	a0,s4
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	34c080e7          	jalr	844(ra) # 80003f50 <pipeclose>
    80003c0c:	b7cd                	j	80003bee <fileclose+0xa8>

0000000080003c0e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c0e:	715d                	addi	sp,sp,-80
    80003c10:	e486                	sd	ra,72(sp)
    80003c12:	e0a2                	sd	s0,64(sp)
    80003c14:	fc26                	sd	s1,56(sp)
    80003c16:	f84a                	sd	s2,48(sp)
    80003c18:	f44e                	sd	s3,40(sp)
    80003c1a:	0880                	addi	s0,sp,80
    80003c1c:	84aa                	mv	s1,a0
    80003c1e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c20:	ffffd097          	auipc	ra,0xffffd
    80003c24:	3a2080e7          	jalr	930(ra) # 80000fc2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c28:	409c                	lw	a5,0(s1)
    80003c2a:	37f9                	addiw	a5,a5,-2
    80003c2c:	4705                	li	a4,1
    80003c2e:	04f76763          	bltu	a4,a5,80003c7c <filestat+0x6e>
    80003c32:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c34:	6c88                	ld	a0,24(s1)
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	072080e7          	jalr	114(ra) # 80002ca8 <ilock>
    stati(f->ip, &st);
    80003c3e:	fb840593          	addi	a1,s0,-72
    80003c42:	6c88                	ld	a0,24(s1)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	2ee080e7          	jalr	750(ra) # 80002f32 <stati>
    iunlock(f->ip);
    80003c4c:	6c88                	ld	a0,24(s1)
    80003c4e:	fffff097          	auipc	ra,0xfffff
    80003c52:	11c080e7          	jalr	284(ra) # 80002d6a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c56:	46e1                	li	a3,24
    80003c58:	fb840613          	addi	a2,s0,-72
    80003c5c:	85ce                	mv	a1,s3
    80003c5e:	05093503          	ld	a0,80(s2)
    80003c62:	ffffd097          	auipc	ra,0xffffd
    80003c66:	00e080e7          	jalr	14(ra) # 80000c70 <copyout>
    80003c6a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c6e:	60a6                	ld	ra,72(sp)
    80003c70:	6406                	ld	s0,64(sp)
    80003c72:	74e2                	ld	s1,56(sp)
    80003c74:	7942                	ld	s2,48(sp)
    80003c76:	79a2                	ld	s3,40(sp)
    80003c78:	6161                	addi	sp,sp,80
    80003c7a:	8082                	ret
  return -1;
    80003c7c:	557d                	li	a0,-1
    80003c7e:	bfc5                	j	80003c6e <filestat+0x60>

0000000080003c80 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c80:	7179                	addi	sp,sp,-48
    80003c82:	f406                	sd	ra,40(sp)
    80003c84:	f022                	sd	s0,32(sp)
    80003c86:	ec26                	sd	s1,24(sp)
    80003c88:	e84a                	sd	s2,16(sp)
    80003c8a:	e44e                	sd	s3,8(sp)
    80003c8c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c8e:	00854783          	lbu	a5,8(a0)
    80003c92:	c3d5                	beqz	a5,80003d36 <fileread+0xb6>
    80003c94:	84aa                	mv	s1,a0
    80003c96:	89ae                	mv	s3,a1
    80003c98:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c9a:	411c                	lw	a5,0(a0)
    80003c9c:	4705                	li	a4,1
    80003c9e:	04e78963          	beq	a5,a4,80003cf0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ca2:	470d                	li	a4,3
    80003ca4:	04e78d63          	beq	a5,a4,80003cfe <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca8:	4709                	li	a4,2
    80003caa:	06e79e63          	bne	a5,a4,80003d26 <fileread+0xa6>
    ilock(f->ip);
    80003cae:	6d08                	ld	a0,24(a0)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	ff8080e7          	jalr	-8(ra) # 80002ca8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cb8:	874a                	mv	a4,s2
    80003cba:	5094                	lw	a3,32(s1)
    80003cbc:	864e                	mv	a2,s3
    80003cbe:	4585                	li	a1,1
    80003cc0:	6c88                	ld	a0,24(s1)
    80003cc2:	fffff097          	auipc	ra,0xfffff
    80003cc6:	29a080e7          	jalr	666(ra) # 80002f5c <readi>
    80003cca:	892a                	mv	s2,a0
    80003ccc:	00a05563          	blez	a0,80003cd6 <fileread+0x56>
      f->off += r;
    80003cd0:	509c                	lw	a5,32(s1)
    80003cd2:	9fa9                	addw	a5,a5,a0
    80003cd4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cd6:	6c88                	ld	a0,24(s1)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	092080e7          	jalr	146(ra) # 80002d6a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ce0:	854a                	mv	a0,s2
    80003ce2:	70a2                	ld	ra,40(sp)
    80003ce4:	7402                	ld	s0,32(sp)
    80003ce6:	64e2                	ld	s1,24(sp)
    80003ce8:	6942                	ld	s2,16(sp)
    80003cea:	69a2                	ld	s3,8(sp)
    80003cec:	6145                	addi	sp,sp,48
    80003cee:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cf0:	6908                	ld	a0,16(a0)
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	3c8080e7          	jalr	968(ra) # 800040ba <piperead>
    80003cfa:	892a                	mv	s2,a0
    80003cfc:	b7d5                	j	80003ce0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cfe:	02451783          	lh	a5,36(a0)
    80003d02:	03079693          	slli	a3,a5,0x30
    80003d06:	92c1                	srli	a3,a3,0x30
    80003d08:	4725                	li	a4,9
    80003d0a:	02d76863          	bltu	a4,a3,80003d3a <fileread+0xba>
    80003d0e:	0792                	slli	a5,a5,0x4
    80003d10:	00235717          	auipc	a4,0x235
    80003d14:	3b870713          	addi	a4,a4,952 # 802390c8 <devsw>
    80003d18:	97ba                	add	a5,a5,a4
    80003d1a:	639c                	ld	a5,0(a5)
    80003d1c:	c38d                	beqz	a5,80003d3e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d1e:	4505                	li	a0,1
    80003d20:	9782                	jalr	a5
    80003d22:	892a                	mv	s2,a0
    80003d24:	bf75                	j	80003ce0 <fileread+0x60>
    panic("fileread");
    80003d26:	00005517          	auipc	a0,0x5
    80003d2a:	8fa50513          	addi	a0,a0,-1798 # 80008620 <syscalls+0x258>
    80003d2e:	00002097          	auipc	ra,0x2
    80003d32:	02a080e7          	jalr	42(ra) # 80005d58 <panic>
    return -1;
    80003d36:	597d                	li	s2,-1
    80003d38:	b765                	j	80003ce0 <fileread+0x60>
      return -1;
    80003d3a:	597d                	li	s2,-1
    80003d3c:	b755                	j	80003ce0 <fileread+0x60>
    80003d3e:	597d                	li	s2,-1
    80003d40:	b745                	j	80003ce0 <fileread+0x60>

0000000080003d42 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d42:	715d                	addi	sp,sp,-80
    80003d44:	e486                	sd	ra,72(sp)
    80003d46:	e0a2                	sd	s0,64(sp)
    80003d48:	fc26                	sd	s1,56(sp)
    80003d4a:	f84a                	sd	s2,48(sp)
    80003d4c:	f44e                	sd	s3,40(sp)
    80003d4e:	f052                	sd	s4,32(sp)
    80003d50:	ec56                	sd	s5,24(sp)
    80003d52:	e85a                	sd	s6,16(sp)
    80003d54:	e45e                	sd	s7,8(sp)
    80003d56:	e062                	sd	s8,0(sp)
    80003d58:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d5a:	00954783          	lbu	a5,9(a0)
    80003d5e:	10078663          	beqz	a5,80003e6a <filewrite+0x128>
    80003d62:	892a                	mv	s2,a0
    80003d64:	8aae                	mv	s5,a1
    80003d66:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d68:	411c                	lw	a5,0(a0)
    80003d6a:	4705                	li	a4,1
    80003d6c:	02e78263          	beq	a5,a4,80003d90 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d70:	470d                	li	a4,3
    80003d72:	02e78663          	beq	a5,a4,80003d9e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d76:	4709                	li	a4,2
    80003d78:	0ee79163          	bne	a5,a4,80003e5a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d7c:	0ac05d63          	blez	a2,80003e36 <filewrite+0xf4>
    int i = 0;
    80003d80:	4981                	li	s3,0
    80003d82:	6b05                	lui	s6,0x1
    80003d84:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d88:	6b85                	lui	s7,0x1
    80003d8a:	c00b8b9b          	addiw	s7,s7,-1024
    80003d8e:	a861                	j	80003e26 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d90:	6908                	ld	a0,16(a0)
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	22e080e7          	jalr	558(ra) # 80003fc0 <pipewrite>
    80003d9a:	8a2a                	mv	s4,a0
    80003d9c:	a045                	j	80003e3c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d9e:	02451783          	lh	a5,36(a0)
    80003da2:	03079693          	slli	a3,a5,0x30
    80003da6:	92c1                	srli	a3,a3,0x30
    80003da8:	4725                	li	a4,9
    80003daa:	0cd76263          	bltu	a4,a3,80003e6e <filewrite+0x12c>
    80003dae:	0792                	slli	a5,a5,0x4
    80003db0:	00235717          	auipc	a4,0x235
    80003db4:	31870713          	addi	a4,a4,792 # 802390c8 <devsw>
    80003db8:	97ba                	add	a5,a5,a4
    80003dba:	679c                	ld	a5,8(a5)
    80003dbc:	cbdd                	beqz	a5,80003e72 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dbe:	4505                	li	a0,1
    80003dc0:	9782                	jalr	a5
    80003dc2:	8a2a                	mv	s4,a0
    80003dc4:	a8a5                	j	80003e3c <filewrite+0xfa>
    80003dc6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	8b0080e7          	jalr	-1872(ra) # 8000367a <begin_op>
      ilock(f->ip);
    80003dd2:	01893503          	ld	a0,24(s2)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	ed2080e7          	jalr	-302(ra) # 80002ca8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dde:	8762                	mv	a4,s8
    80003de0:	02092683          	lw	a3,32(s2)
    80003de4:	01598633          	add	a2,s3,s5
    80003de8:	4585                	li	a1,1
    80003dea:	01893503          	ld	a0,24(s2)
    80003dee:	fffff097          	auipc	ra,0xfffff
    80003df2:	266080e7          	jalr	614(ra) # 80003054 <writei>
    80003df6:	84aa                	mv	s1,a0
    80003df8:	00a05763          	blez	a0,80003e06 <filewrite+0xc4>
        f->off += r;
    80003dfc:	02092783          	lw	a5,32(s2)
    80003e00:	9fa9                	addw	a5,a5,a0
    80003e02:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e06:	01893503          	ld	a0,24(s2)
    80003e0a:	fffff097          	auipc	ra,0xfffff
    80003e0e:	f60080e7          	jalr	-160(ra) # 80002d6a <iunlock>
      end_op();
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	8e8080e7          	jalr	-1816(ra) # 800036fa <end_op>

      if(r != n1){
    80003e1a:	009c1f63          	bne	s8,s1,80003e38 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e1e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e22:	0149db63          	bge	s3,s4,80003e38 <filewrite+0xf6>
      int n1 = n - i;
    80003e26:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e2a:	84be                	mv	s1,a5
    80003e2c:	2781                	sext.w	a5,a5
    80003e2e:	f8fb5ce3          	bge	s6,a5,80003dc6 <filewrite+0x84>
    80003e32:	84de                	mv	s1,s7
    80003e34:	bf49                	j	80003dc6 <filewrite+0x84>
    int i = 0;
    80003e36:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e38:	013a1f63          	bne	s4,s3,80003e56 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e3c:	8552                	mv	a0,s4
    80003e3e:	60a6                	ld	ra,72(sp)
    80003e40:	6406                	ld	s0,64(sp)
    80003e42:	74e2                	ld	s1,56(sp)
    80003e44:	7942                	ld	s2,48(sp)
    80003e46:	79a2                	ld	s3,40(sp)
    80003e48:	7a02                	ld	s4,32(sp)
    80003e4a:	6ae2                	ld	s5,24(sp)
    80003e4c:	6b42                	ld	s6,16(sp)
    80003e4e:	6ba2                	ld	s7,8(sp)
    80003e50:	6c02                	ld	s8,0(sp)
    80003e52:	6161                	addi	sp,sp,80
    80003e54:	8082                	ret
    ret = (i == n ? n : -1);
    80003e56:	5a7d                	li	s4,-1
    80003e58:	b7d5                	j	80003e3c <filewrite+0xfa>
    panic("filewrite");
    80003e5a:	00004517          	auipc	a0,0x4
    80003e5e:	7d650513          	addi	a0,a0,2006 # 80008630 <syscalls+0x268>
    80003e62:	00002097          	auipc	ra,0x2
    80003e66:	ef6080e7          	jalr	-266(ra) # 80005d58 <panic>
    return -1;
    80003e6a:	5a7d                	li	s4,-1
    80003e6c:	bfc1                	j	80003e3c <filewrite+0xfa>
      return -1;
    80003e6e:	5a7d                	li	s4,-1
    80003e70:	b7f1                	j	80003e3c <filewrite+0xfa>
    80003e72:	5a7d                	li	s4,-1
    80003e74:	b7e1                	j	80003e3c <filewrite+0xfa>

0000000080003e76 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e76:	7179                	addi	sp,sp,-48
    80003e78:	f406                	sd	ra,40(sp)
    80003e7a:	f022                	sd	s0,32(sp)
    80003e7c:	ec26                	sd	s1,24(sp)
    80003e7e:	e84a                	sd	s2,16(sp)
    80003e80:	e44e                	sd	s3,8(sp)
    80003e82:	e052                	sd	s4,0(sp)
    80003e84:	1800                	addi	s0,sp,48
    80003e86:	84aa                	mv	s1,a0
    80003e88:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e8a:	0005b023          	sd	zero,0(a1)
    80003e8e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	bf8080e7          	jalr	-1032(ra) # 80003a8a <filealloc>
    80003e9a:	e088                	sd	a0,0(s1)
    80003e9c:	c551                	beqz	a0,80003f28 <pipealloc+0xb2>
    80003e9e:	00000097          	auipc	ra,0x0
    80003ea2:	bec080e7          	jalr	-1044(ra) # 80003a8a <filealloc>
    80003ea6:	00aa3023          	sd	a0,0(s4)
    80003eaa:	c92d                	beqz	a0,80003f1c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003eac:	ffffc097          	auipc	ra,0xffffc
    80003eb0:	3c6080e7          	jalr	966(ra) # 80000272 <kalloc>
    80003eb4:	892a                	mv	s2,a0
    80003eb6:	c125                	beqz	a0,80003f16 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003eb8:	4985                	li	s3,1
    80003eba:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ebe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ec2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ec6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003eca:	00004597          	auipc	a1,0x4
    80003ece:	77658593          	addi	a1,a1,1910 # 80008640 <syscalls+0x278>
    80003ed2:	00002097          	auipc	ra,0x2
    80003ed6:	340080e7          	jalr	832(ra) # 80006212 <initlock>
  (*f0)->type = FD_PIPE;
    80003eda:	609c                	ld	a5,0(s1)
    80003edc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ee0:	609c                	ld	a5,0(s1)
    80003ee2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ee6:	609c                	ld	a5,0(s1)
    80003ee8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eec:	609c                	ld	a5,0(s1)
    80003eee:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ef2:	000a3783          	ld	a5,0(s4)
    80003ef6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003efa:	000a3783          	ld	a5,0(s4)
    80003efe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f02:	000a3783          	ld	a5,0(s4)
    80003f06:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f0a:	000a3783          	ld	a5,0(s4)
    80003f0e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f12:	4501                	li	a0,0
    80003f14:	a025                	j	80003f3c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f16:	6088                	ld	a0,0(s1)
    80003f18:	e501                	bnez	a0,80003f20 <pipealloc+0xaa>
    80003f1a:	a039                	j	80003f28 <pipealloc+0xb2>
    80003f1c:	6088                	ld	a0,0(s1)
    80003f1e:	c51d                	beqz	a0,80003f4c <pipealloc+0xd6>
    fileclose(*f0);
    80003f20:	00000097          	auipc	ra,0x0
    80003f24:	c26080e7          	jalr	-986(ra) # 80003b46 <fileclose>
  if(*f1)
    80003f28:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f2c:	557d                	li	a0,-1
  if(*f1)
    80003f2e:	c799                	beqz	a5,80003f3c <pipealloc+0xc6>
    fileclose(*f1);
    80003f30:	853e                	mv	a0,a5
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	c14080e7          	jalr	-1004(ra) # 80003b46 <fileclose>
  return -1;
    80003f3a:	557d                	li	a0,-1
}
    80003f3c:	70a2                	ld	ra,40(sp)
    80003f3e:	7402                	ld	s0,32(sp)
    80003f40:	64e2                	ld	s1,24(sp)
    80003f42:	6942                	ld	s2,16(sp)
    80003f44:	69a2                	ld	s3,8(sp)
    80003f46:	6a02                	ld	s4,0(sp)
    80003f48:	6145                	addi	sp,sp,48
    80003f4a:	8082                	ret
  return -1;
    80003f4c:	557d                	li	a0,-1
    80003f4e:	b7fd                	j	80003f3c <pipealloc+0xc6>

0000000080003f50 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f50:	1101                	addi	sp,sp,-32
    80003f52:	ec06                	sd	ra,24(sp)
    80003f54:	e822                	sd	s0,16(sp)
    80003f56:	e426                	sd	s1,8(sp)
    80003f58:	e04a                	sd	s2,0(sp)
    80003f5a:	1000                	addi	s0,sp,32
    80003f5c:	84aa                	mv	s1,a0
    80003f5e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f60:	00002097          	auipc	ra,0x2
    80003f64:	342080e7          	jalr	834(ra) # 800062a2 <acquire>
  if(writable){
    80003f68:	02090d63          	beqz	s2,80003fa2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f6c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f70:	21848513          	addi	a0,s1,536
    80003f74:	ffffe097          	auipc	ra,0xffffe
    80003f78:	896080e7          	jalr	-1898(ra) # 8000180a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f7c:	2204b783          	ld	a5,544(s1)
    80003f80:	eb95                	bnez	a5,80003fb4 <pipeclose+0x64>
    release(&pi->lock);
    80003f82:	8526                	mv	a0,s1
    80003f84:	00002097          	auipc	ra,0x2
    80003f88:	3d2080e7          	jalr	978(ra) # 80006356 <release>
    kfree((char*)pi);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	ffffc097          	auipc	ra,0xffffc
    80003f92:	16c080e7          	jalr	364(ra) # 800000fa <kfree>
  } else
    release(&pi->lock);
}
    80003f96:	60e2                	ld	ra,24(sp)
    80003f98:	6442                	ld	s0,16(sp)
    80003f9a:	64a2                	ld	s1,8(sp)
    80003f9c:	6902                	ld	s2,0(sp)
    80003f9e:	6105                	addi	sp,sp,32
    80003fa0:	8082                	ret
    pi->readopen = 0;
    80003fa2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fa6:	21c48513          	addi	a0,s1,540
    80003faa:	ffffe097          	auipc	ra,0xffffe
    80003fae:	860080e7          	jalr	-1952(ra) # 8000180a <wakeup>
    80003fb2:	b7e9                	j	80003f7c <pipeclose+0x2c>
    release(&pi->lock);
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	00002097          	auipc	ra,0x2
    80003fba:	3a0080e7          	jalr	928(ra) # 80006356 <release>
}
    80003fbe:	bfe1                	j	80003f96 <pipeclose+0x46>

0000000080003fc0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fc0:	7159                	addi	sp,sp,-112
    80003fc2:	f486                	sd	ra,104(sp)
    80003fc4:	f0a2                	sd	s0,96(sp)
    80003fc6:	eca6                	sd	s1,88(sp)
    80003fc8:	e8ca                	sd	s2,80(sp)
    80003fca:	e4ce                	sd	s3,72(sp)
    80003fcc:	e0d2                	sd	s4,64(sp)
    80003fce:	fc56                	sd	s5,56(sp)
    80003fd0:	f85a                	sd	s6,48(sp)
    80003fd2:	f45e                	sd	s7,40(sp)
    80003fd4:	f062                	sd	s8,32(sp)
    80003fd6:	ec66                	sd	s9,24(sp)
    80003fd8:	1880                	addi	s0,sp,112
    80003fda:	84aa                	mv	s1,a0
    80003fdc:	8aae                	mv	s5,a1
    80003fde:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	fe2080e7          	jalr	-30(ra) # 80000fc2 <myproc>
    80003fe8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fea:	8526                	mv	a0,s1
    80003fec:	00002097          	auipc	ra,0x2
    80003ff0:	2b6080e7          	jalr	694(ra) # 800062a2 <acquire>
  while(i < n){
    80003ff4:	0d405163          	blez	s4,800040b6 <pipewrite+0xf6>
    80003ff8:	8ba6                	mv	s7,s1
  int i = 0;
    80003ffa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ffc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ffe:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004002:	21c48c13          	addi	s8,s1,540
    80004006:	a08d                	j	80004068 <pipewrite+0xa8>
      release(&pi->lock);
    80004008:	8526                	mv	a0,s1
    8000400a:	00002097          	auipc	ra,0x2
    8000400e:	34c080e7          	jalr	844(ra) # 80006356 <release>
      return -1;
    80004012:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004014:	854a                	mv	a0,s2
    80004016:	70a6                	ld	ra,104(sp)
    80004018:	7406                	ld	s0,96(sp)
    8000401a:	64e6                	ld	s1,88(sp)
    8000401c:	6946                	ld	s2,80(sp)
    8000401e:	69a6                	ld	s3,72(sp)
    80004020:	6a06                	ld	s4,64(sp)
    80004022:	7ae2                	ld	s5,56(sp)
    80004024:	7b42                	ld	s6,48(sp)
    80004026:	7ba2                	ld	s7,40(sp)
    80004028:	7c02                	ld	s8,32(sp)
    8000402a:	6ce2                	ld	s9,24(sp)
    8000402c:	6165                	addi	sp,sp,112
    8000402e:	8082                	ret
      wakeup(&pi->nread);
    80004030:	8566                	mv	a0,s9
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	7d8080e7          	jalr	2008(ra) # 8000180a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000403a:	85de                	mv	a1,s7
    8000403c:	8562                	mv	a0,s8
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	640080e7          	jalr	1600(ra) # 8000167e <sleep>
    80004046:	a839                	j	80004064 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004048:	21c4a783          	lw	a5,540(s1)
    8000404c:	0017871b          	addiw	a4,a5,1
    80004050:	20e4ae23          	sw	a4,540(s1)
    80004054:	1ff7f793          	andi	a5,a5,511
    80004058:	97a6                	add	a5,a5,s1
    8000405a:	f9f44703          	lbu	a4,-97(s0)
    8000405e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004062:	2905                	addiw	s2,s2,1
  while(i < n){
    80004064:	03495d63          	bge	s2,s4,8000409e <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004068:	2204a783          	lw	a5,544(s1)
    8000406c:	dfd1                	beqz	a5,80004008 <pipewrite+0x48>
    8000406e:	0289a783          	lw	a5,40(s3)
    80004072:	fbd9                	bnez	a5,80004008 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004074:	2184a783          	lw	a5,536(s1)
    80004078:	21c4a703          	lw	a4,540(s1)
    8000407c:	2007879b          	addiw	a5,a5,512
    80004080:	faf708e3          	beq	a4,a5,80004030 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004084:	4685                	li	a3,1
    80004086:	01590633          	add	a2,s2,s5
    8000408a:	f9f40593          	addi	a1,s0,-97
    8000408e:	0509b503          	ld	a0,80(s3)
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	c7e080e7          	jalr	-898(ra) # 80000d10 <copyin>
    8000409a:	fb6517e3          	bne	a0,s6,80004048 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000409e:	21848513          	addi	a0,s1,536
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	768080e7          	jalr	1896(ra) # 8000180a <wakeup>
  release(&pi->lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	2aa080e7          	jalr	682(ra) # 80006356 <release>
  return i;
    800040b4:	b785                	j	80004014 <pipewrite+0x54>
  int i = 0;
    800040b6:	4901                	li	s2,0
    800040b8:	b7dd                	j	8000409e <pipewrite+0xde>

00000000800040ba <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040ba:	715d                	addi	sp,sp,-80
    800040bc:	e486                	sd	ra,72(sp)
    800040be:	e0a2                	sd	s0,64(sp)
    800040c0:	fc26                	sd	s1,56(sp)
    800040c2:	f84a                	sd	s2,48(sp)
    800040c4:	f44e                	sd	s3,40(sp)
    800040c6:	f052                	sd	s4,32(sp)
    800040c8:	ec56                	sd	s5,24(sp)
    800040ca:	e85a                	sd	s6,16(sp)
    800040cc:	0880                	addi	s0,sp,80
    800040ce:	84aa                	mv	s1,a0
    800040d0:	892e                	mv	s2,a1
    800040d2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	eee080e7          	jalr	-274(ra) # 80000fc2 <myproc>
    800040dc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040de:	8b26                	mv	s6,s1
    800040e0:	8526                	mv	a0,s1
    800040e2:	00002097          	auipc	ra,0x2
    800040e6:	1c0080e7          	jalr	448(ra) # 800062a2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ea:	2184a703          	lw	a4,536(s1)
    800040ee:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040f2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040f6:	02f71463          	bne	a4,a5,8000411e <piperead+0x64>
    800040fa:	2244a783          	lw	a5,548(s1)
    800040fe:	c385                	beqz	a5,8000411e <piperead+0x64>
    if(pr->killed){
    80004100:	028a2783          	lw	a5,40(s4)
    80004104:	ebc1                	bnez	a5,80004194 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004106:	85da                	mv	a1,s6
    80004108:	854e                	mv	a0,s3
    8000410a:	ffffd097          	auipc	ra,0xffffd
    8000410e:	574080e7          	jalr	1396(ra) # 8000167e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004112:	2184a703          	lw	a4,536(s1)
    80004116:	21c4a783          	lw	a5,540(s1)
    8000411a:	fef700e3          	beq	a4,a5,800040fa <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000411e:	09505263          	blez	s5,800041a2 <piperead+0xe8>
    80004122:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004124:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004126:	2184a783          	lw	a5,536(s1)
    8000412a:	21c4a703          	lw	a4,540(s1)
    8000412e:	02f70d63          	beq	a4,a5,80004168 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004132:	0017871b          	addiw	a4,a5,1
    80004136:	20e4ac23          	sw	a4,536(s1)
    8000413a:	1ff7f793          	andi	a5,a5,511
    8000413e:	97a6                	add	a5,a5,s1
    80004140:	0187c783          	lbu	a5,24(a5)
    80004144:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004148:	4685                	li	a3,1
    8000414a:	fbf40613          	addi	a2,s0,-65
    8000414e:	85ca                	mv	a1,s2
    80004150:	050a3503          	ld	a0,80(s4)
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	b1c080e7          	jalr	-1252(ra) # 80000c70 <copyout>
    8000415c:	01650663          	beq	a0,s6,80004168 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004160:	2985                	addiw	s3,s3,1
    80004162:	0905                	addi	s2,s2,1
    80004164:	fd3a91e3          	bne	s5,s3,80004126 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004168:	21c48513          	addi	a0,s1,540
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	69e080e7          	jalr	1694(ra) # 8000180a <wakeup>
  release(&pi->lock);
    80004174:	8526                	mv	a0,s1
    80004176:	00002097          	auipc	ra,0x2
    8000417a:	1e0080e7          	jalr	480(ra) # 80006356 <release>
  return i;
}
    8000417e:	854e                	mv	a0,s3
    80004180:	60a6                	ld	ra,72(sp)
    80004182:	6406                	ld	s0,64(sp)
    80004184:	74e2                	ld	s1,56(sp)
    80004186:	7942                	ld	s2,48(sp)
    80004188:	79a2                	ld	s3,40(sp)
    8000418a:	7a02                	ld	s4,32(sp)
    8000418c:	6ae2                	ld	s5,24(sp)
    8000418e:	6b42                	ld	s6,16(sp)
    80004190:	6161                	addi	sp,sp,80
    80004192:	8082                	ret
      release(&pi->lock);
    80004194:	8526                	mv	a0,s1
    80004196:	00002097          	auipc	ra,0x2
    8000419a:	1c0080e7          	jalr	448(ra) # 80006356 <release>
      return -1;
    8000419e:	59fd                	li	s3,-1
    800041a0:	bff9                	j	8000417e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a2:	4981                	li	s3,0
    800041a4:	b7d1                	j	80004168 <piperead+0xae>

00000000800041a6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041a6:	df010113          	addi	sp,sp,-528
    800041aa:	20113423          	sd	ra,520(sp)
    800041ae:	20813023          	sd	s0,512(sp)
    800041b2:	ffa6                	sd	s1,504(sp)
    800041b4:	fbca                	sd	s2,496(sp)
    800041b6:	f7ce                	sd	s3,488(sp)
    800041b8:	f3d2                	sd	s4,480(sp)
    800041ba:	efd6                	sd	s5,472(sp)
    800041bc:	ebda                	sd	s6,464(sp)
    800041be:	e7de                	sd	s7,456(sp)
    800041c0:	e3e2                	sd	s8,448(sp)
    800041c2:	ff66                	sd	s9,440(sp)
    800041c4:	fb6a                	sd	s10,432(sp)
    800041c6:	f76e                	sd	s11,424(sp)
    800041c8:	0c00                	addi	s0,sp,528
    800041ca:	84aa                	mv	s1,a0
    800041cc:	dea43c23          	sd	a0,-520(s0)
    800041d0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	dee080e7          	jalr	-530(ra) # 80000fc2 <myproc>
    800041dc:	892a                	mv	s2,a0

  begin_op();
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	49c080e7          	jalr	1180(ra) # 8000367a <begin_op>

  if((ip = namei(path)) == 0){
    800041e6:	8526                	mv	a0,s1
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	276080e7          	jalr	630(ra) # 8000345e <namei>
    800041f0:	c92d                	beqz	a0,80004262 <exec+0xbc>
    800041f2:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	ab4080e7          	jalr	-1356(ra) # 80002ca8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041fc:	04000713          	li	a4,64
    80004200:	4681                	li	a3,0
    80004202:	e5040613          	addi	a2,s0,-432
    80004206:	4581                	li	a1,0
    80004208:	8526                	mv	a0,s1
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	d52080e7          	jalr	-686(ra) # 80002f5c <readi>
    80004212:	04000793          	li	a5,64
    80004216:	00f51a63          	bne	a0,a5,8000422a <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000421a:	e5042703          	lw	a4,-432(s0)
    8000421e:	464c47b7          	lui	a5,0x464c4
    80004222:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004226:	04f70463          	beq	a4,a5,8000426e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000422a:	8526                	mv	a0,s1
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	cde080e7          	jalr	-802(ra) # 80002f0a <iunlockput>
    end_op();
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	4c6080e7          	jalr	1222(ra) # 800036fa <end_op>
  }
  return -1;
    8000423c:	557d                	li	a0,-1
}
    8000423e:	20813083          	ld	ra,520(sp)
    80004242:	20013403          	ld	s0,512(sp)
    80004246:	74fe                	ld	s1,504(sp)
    80004248:	795e                	ld	s2,496(sp)
    8000424a:	79be                	ld	s3,488(sp)
    8000424c:	7a1e                	ld	s4,480(sp)
    8000424e:	6afe                	ld	s5,472(sp)
    80004250:	6b5e                	ld	s6,464(sp)
    80004252:	6bbe                	ld	s7,456(sp)
    80004254:	6c1e                	ld	s8,448(sp)
    80004256:	7cfa                	ld	s9,440(sp)
    80004258:	7d5a                	ld	s10,432(sp)
    8000425a:	7dba                	ld	s11,424(sp)
    8000425c:	21010113          	addi	sp,sp,528
    80004260:	8082                	ret
    end_op();
    80004262:	fffff097          	auipc	ra,0xfffff
    80004266:	498080e7          	jalr	1176(ra) # 800036fa <end_op>
    return -1;
    8000426a:	557d                	li	a0,-1
    8000426c:	bfc9                	j	8000423e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000426e:	854a                	mv	a0,s2
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	e16080e7          	jalr	-490(ra) # 80001086 <proc_pagetable>
    80004278:	8baa                	mv	s7,a0
    8000427a:	d945                	beqz	a0,8000422a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000427c:	e7042983          	lw	s3,-400(s0)
    80004280:	e8845783          	lhu	a5,-376(s0)
    80004284:	c7ad                	beqz	a5,800042ee <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004286:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004288:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000428a:	6c85                	lui	s9,0x1
    8000428c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004290:	def43823          	sd	a5,-528(s0)
    80004294:	a42d                	j	800044be <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004296:	00004517          	auipc	a0,0x4
    8000429a:	3b250513          	addi	a0,a0,946 # 80008648 <syscalls+0x280>
    8000429e:	00002097          	auipc	ra,0x2
    800042a2:	aba080e7          	jalr	-1350(ra) # 80005d58 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042a6:	8756                	mv	a4,s5
    800042a8:	012d86bb          	addw	a3,s11,s2
    800042ac:	4581                	li	a1,0
    800042ae:	8526                	mv	a0,s1
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	cac080e7          	jalr	-852(ra) # 80002f5c <readi>
    800042b8:	2501                	sext.w	a0,a0
    800042ba:	1aaa9963          	bne	s5,a0,8000446c <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042be:	6785                	lui	a5,0x1
    800042c0:	0127893b          	addw	s2,a5,s2
    800042c4:	77fd                	lui	a5,0xfffff
    800042c6:	01478a3b          	addw	s4,a5,s4
    800042ca:	1f897163          	bgeu	s2,s8,800044ac <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042ce:	02091593          	slli	a1,s2,0x20
    800042d2:	9181                	srli	a1,a1,0x20
    800042d4:	95ea                	add	a1,a1,s10
    800042d6:	855e                	mv	a0,s7
    800042d8:	ffffc097          	auipc	ra,0xffffc
    800042dc:	3a2080e7          	jalr	930(ra) # 8000067a <walkaddr>
    800042e0:	862a                	mv	a2,a0
    if(pa == 0)
    800042e2:	d955                	beqz	a0,80004296 <exec+0xf0>
      n = PGSIZE;
    800042e4:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042e6:	fd9a70e3          	bgeu	s4,s9,800042a6 <exec+0x100>
      n = sz - i;
    800042ea:	8ad2                	mv	s5,s4
    800042ec:	bf6d                	j	800042a6 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ee:	4901                	li	s2,0
  iunlockput(ip);
    800042f0:	8526                	mv	a0,s1
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	c18080e7          	jalr	-1000(ra) # 80002f0a <iunlockput>
  end_op();
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	400080e7          	jalr	1024(ra) # 800036fa <end_op>
  p = myproc();
    80004302:	ffffd097          	auipc	ra,0xffffd
    80004306:	cc0080e7          	jalr	-832(ra) # 80000fc2 <myproc>
    8000430a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000430c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004310:	6785                	lui	a5,0x1
    80004312:	17fd                	addi	a5,a5,-1
    80004314:	993e                	add	s2,s2,a5
    80004316:	757d                	lui	a0,0xfffff
    80004318:	00a977b3          	and	a5,s2,a0
    8000431c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004320:	6609                	lui	a2,0x2
    80004322:	963e                	add	a2,a2,a5
    80004324:	85be                	mv	a1,a5
    80004326:	855e                	mv	a0,s7
    80004328:	ffffc097          	auipc	ra,0xffffc
    8000432c:	706080e7          	jalr	1798(ra) # 80000a2e <uvmalloc>
    80004330:	8b2a                	mv	s6,a0
  ip = 0;
    80004332:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004334:	12050c63          	beqz	a0,8000446c <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004338:	75f9                	lui	a1,0xffffe
    8000433a:	95aa                	add	a1,a1,a0
    8000433c:	855e                	mv	a0,s7
    8000433e:	ffffd097          	auipc	ra,0xffffd
    80004342:	900080e7          	jalr	-1792(ra) # 80000c3e <uvmclear>
  stackbase = sp - PGSIZE;
    80004346:	7c7d                	lui	s8,0xfffff
    80004348:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000434a:	e0043783          	ld	a5,-512(s0)
    8000434e:	6388                	ld	a0,0(a5)
    80004350:	c535                	beqz	a0,800043bc <exec+0x216>
    80004352:	e9040993          	addi	s3,s0,-368
    80004356:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000435a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000435c:	ffffc097          	auipc	ra,0xffffc
    80004360:	114080e7          	jalr	276(ra) # 80000470 <strlen>
    80004364:	2505                	addiw	a0,a0,1
    80004366:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000436a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000436e:	13896363          	bltu	s2,s8,80004494 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004372:	e0043d83          	ld	s11,-512(s0)
    80004376:	000dba03          	ld	s4,0(s11)
    8000437a:	8552                	mv	a0,s4
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	0f4080e7          	jalr	244(ra) # 80000470 <strlen>
    80004384:	0015069b          	addiw	a3,a0,1
    80004388:	8652                	mv	a2,s4
    8000438a:	85ca                	mv	a1,s2
    8000438c:	855e                	mv	a0,s7
    8000438e:	ffffd097          	auipc	ra,0xffffd
    80004392:	8e2080e7          	jalr	-1822(ra) # 80000c70 <copyout>
    80004396:	10054363          	bltz	a0,8000449c <exec+0x2f6>
    ustack[argc] = sp;
    8000439a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000439e:	0485                	addi	s1,s1,1
    800043a0:	008d8793          	addi	a5,s11,8
    800043a4:	e0f43023          	sd	a5,-512(s0)
    800043a8:	008db503          	ld	a0,8(s11)
    800043ac:	c911                	beqz	a0,800043c0 <exec+0x21a>
    if(argc >= MAXARG)
    800043ae:	09a1                	addi	s3,s3,8
    800043b0:	fb3c96e3          	bne	s9,s3,8000435c <exec+0x1b6>
  sz = sz1;
    800043b4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043b8:	4481                	li	s1,0
    800043ba:	a84d                	j	8000446c <exec+0x2c6>
  sp = sz;
    800043bc:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043be:	4481                	li	s1,0
  ustack[argc] = 0;
    800043c0:	00349793          	slli	a5,s1,0x3
    800043c4:	f9040713          	addi	a4,s0,-112
    800043c8:	97ba                	add	a5,a5,a4
    800043ca:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043ce:	00148693          	addi	a3,s1,1
    800043d2:	068e                	slli	a3,a3,0x3
    800043d4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043d8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043dc:	01897663          	bgeu	s2,s8,800043e8 <exec+0x242>
  sz = sz1;
    800043e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e4:	4481                	li	s1,0
    800043e6:	a059                	j	8000446c <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043e8:	e9040613          	addi	a2,s0,-368
    800043ec:	85ca                	mv	a1,s2
    800043ee:	855e                	mv	a0,s7
    800043f0:	ffffd097          	auipc	ra,0xffffd
    800043f4:	880080e7          	jalr	-1920(ra) # 80000c70 <copyout>
    800043f8:	0a054663          	bltz	a0,800044a4 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800043fc:	058ab783          	ld	a5,88(s5)
    80004400:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004404:	df843783          	ld	a5,-520(s0)
    80004408:	0007c703          	lbu	a4,0(a5)
    8000440c:	cf11                	beqz	a4,80004428 <exec+0x282>
    8000440e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004410:	02f00693          	li	a3,47
    80004414:	a039                	j	80004422 <exec+0x27c>
      last = s+1;
    80004416:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000441a:	0785                	addi	a5,a5,1
    8000441c:	fff7c703          	lbu	a4,-1(a5)
    80004420:	c701                	beqz	a4,80004428 <exec+0x282>
    if(*s == '/')
    80004422:	fed71ce3          	bne	a4,a3,8000441a <exec+0x274>
    80004426:	bfc5                	j	80004416 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004428:	4641                	li	a2,16
    8000442a:	df843583          	ld	a1,-520(s0)
    8000442e:	158a8513          	addi	a0,s5,344
    80004432:	ffffc097          	auipc	ra,0xffffc
    80004436:	00c080e7          	jalr	12(ra) # 8000043e <safestrcpy>
  oldpagetable = p->pagetable;
    8000443a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000443e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004442:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004446:	058ab783          	ld	a5,88(s5)
    8000444a:	e6843703          	ld	a4,-408(s0)
    8000444e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004450:	058ab783          	ld	a5,88(s5)
    80004454:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004458:	85ea                	mv	a1,s10
    8000445a:	ffffd097          	auipc	ra,0xffffd
    8000445e:	cc8080e7          	jalr	-824(ra) # 80001122 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004462:	0004851b          	sext.w	a0,s1
    80004466:	bbe1                	j	8000423e <exec+0x98>
    80004468:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000446c:	e0843583          	ld	a1,-504(s0)
    80004470:	855e                	mv	a0,s7
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	cb0080e7          	jalr	-848(ra) # 80001122 <proc_freepagetable>
  if(ip){
    8000447a:	da0498e3          	bnez	s1,8000422a <exec+0x84>
  return -1;
    8000447e:	557d                	li	a0,-1
    80004480:	bb7d                	j	8000423e <exec+0x98>
    80004482:	e1243423          	sd	s2,-504(s0)
    80004486:	b7dd                	j	8000446c <exec+0x2c6>
    80004488:	e1243423          	sd	s2,-504(s0)
    8000448c:	b7c5                	j	8000446c <exec+0x2c6>
    8000448e:	e1243423          	sd	s2,-504(s0)
    80004492:	bfe9                	j	8000446c <exec+0x2c6>
  sz = sz1;
    80004494:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004498:	4481                	li	s1,0
    8000449a:	bfc9                	j	8000446c <exec+0x2c6>
  sz = sz1;
    8000449c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a0:	4481                	li	s1,0
    800044a2:	b7e9                	j	8000446c <exec+0x2c6>
  sz = sz1;
    800044a4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a8:	4481                	li	s1,0
    800044aa:	b7c9                	j	8000446c <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044ac:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044b0:	2b05                	addiw	s6,s6,1
    800044b2:	0389899b          	addiw	s3,s3,56
    800044b6:	e8845783          	lhu	a5,-376(s0)
    800044ba:	e2fb5be3          	bge	s6,a5,800042f0 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044be:	2981                	sext.w	s3,s3
    800044c0:	03800713          	li	a4,56
    800044c4:	86ce                	mv	a3,s3
    800044c6:	e1840613          	addi	a2,s0,-488
    800044ca:	4581                	li	a1,0
    800044cc:	8526                	mv	a0,s1
    800044ce:	fffff097          	auipc	ra,0xfffff
    800044d2:	a8e080e7          	jalr	-1394(ra) # 80002f5c <readi>
    800044d6:	03800793          	li	a5,56
    800044da:	f8f517e3          	bne	a0,a5,80004468 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044de:	e1842783          	lw	a5,-488(s0)
    800044e2:	4705                	li	a4,1
    800044e4:	fce796e3          	bne	a5,a4,800044b0 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044e8:	e4043603          	ld	a2,-448(s0)
    800044ec:	e3843783          	ld	a5,-456(s0)
    800044f0:	f8f669e3          	bltu	a2,a5,80004482 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044f4:	e2843783          	ld	a5,-472(s0)
    800044f8:	963e                	add	a2,a2,a5
    800044fa:	f8f667e3          	bltu	a2,a5,80004488 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044fe:	85ca                	mv	a1,s2
    80004500:	855e                	mv	a0,s7
    80004502:	ffffc097          	auipc	ra,0xffffc
    80004506:	52c080e7          	jalr	1324(ra) # 80000a2e <uvmalloc>
    8000450a:	e0a43423          	sd	a0,-504(s0)
    8000450e:	d141                	beqz	a0,8000448e <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004510:	e2843d03          	ld	s10,-472(s0)
    80004514:	df043783          	ld	a5,-528(s0)
    80004518:	00fd77b3          	and	a5,s10,a5
    8000451c:	fba1                	bnez	a5,8000446c <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000451e:	e2042d83          	lw	s11,-480(s0)
    80004522:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004526:	f80c03e3          	beqz	s8,800044ac <exec+0x306>
    8000452a:	8a62                	mv	s4,s8
    8000452c:	4901                	li	s2,0
    8000452e:	b345                	j	800042ce <exec+0x128>

0000000080004530 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004530:	7179                	addi	sp,sp,-48
    80004532:	f406                	sd	ra,40(sp)
    80004534:	f022                	sd	s0,32(sp)
    80004536:	ec26                	sd	s1,24(sp)
    80004538:	e84a                	sd	s2,16(sp)
    8000453a:	1800                	addi	s0,sp,48
    8000453c:	892e                	mv	s2,a1
    8000453e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004540:	fdc40593          	addi	a1,s0,-36
    80004544:	ffffe097          	auipc	ra,0xffffe
    80004548:	bf2080e7          	jalr	-1038(ra) # 80002136 <argint>
    8000454c:	04054063          	bltz	a0,8000458c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004550:	fdc42703          	lw	a4,-36(s0)
    80004554:	47bd                	li	a5,15
    80004556:	02e7ed63          	bltu	a5,a4,80004590 <argfd+0x60>
    8000455a:	ffffd097          	auipc	ra,0xffffd
    8000455e:	a68080e7          	jalr	-1432(ra) # 80000fc2 <myproc>
    80004562:	fdc42703          	lw	a4,-36(s0)
    80004566:	01a70793          	addi	a5,a4,26
    8000456a:	078e                	slli	a5,a5,0x3
    8000456c:	953e                	add	a0,a0,a5
    8000456e:	611c                	ld	a5,0(a0)
    80004570:	c395                	beqz	a5,80004594 <argfd+0x64>
    return -1;
  if(pfd)
    80004572:	00090463          	beqz	s2,8000457a <argfd+0x4a>
    *pfd = fd;
    80004576:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000457a:	4501                	li	a0,0
  if(pf)
    8000457c:	c091                	beqz	s1,80004580 <argfd+0x50>
    *pf = f;
    8000457e:	e09c                	sd	a5,0(s1)
}
    80004580:	70a2                	ld	ra,40(sp)
    80004582:	7402                	ld	s0,32(sp)
    80004584:	64e2                	ld	s1,24(sp)
    80004586:	6942                	ld	s2,16(sp)
    80004588:	6145                	addi	sp,sp,48
    8000458a:	8082                	ret
    return -1;
    8000458c:	557d                	li	a0,-1
    8000458e:	bfcd                	j	80004580 <argfd+0x50>
    return -1;
    80004590:	557d                	li	a0,-1
    80004592:	b7fd                	j	80004580 <argfd+0x50>
    80004594:	557d                	li	a0,-1
    80004596:	b7ed                	j	80004580 <argfd+0x50>

0000000080004598 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004598:	1101                	addi	sp,sp,-32
    8000459a:	ec06                	sd	ra,24(sp)
    8000459c:	e822                	sd	s0,16(sp)
    8000459e:	e426                	sd	s1,8(sp)
    800045a0:	1000                	addi	s0,sp,32
    800045a2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045a4:	ffffd097          	auipc	ra,0xffffd
    800045a8:	a1e080e7          	jalr	-1506(ra) # 80000fc2 <myproc>
    800045ac:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045ae:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdb8e90>
    800045b2:	4501                	li	a0,0
    800045b4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045b6:	6398                	ld	a4,0(a5)
    800045b8:	cb19                	beqz	a4,800045ce <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045ba:	2505                	addiw	a0,a0,1
    800045bc:	07a1                	addi	a5,a5,8
    800045be:	fed51ce3          	bne	a0,a3,800045b6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045c2:	557d                	li	a0,-1
}
    800045c4:	60e2                	ld	ra,24(sp)
    800045c6:	6442                	ld	s0,16(sp)
    800045c8:	64a2                	ld	s1,8(sp)
    800045ca:	6105                	addi	sp,sp,32
    800045cc:	8082                	ret
      p->ofile[fd] = f;
    800045ce:	01a50793          	addi	a5,a0,26
    800045d2:	078e                	slli	a5,a5,0x3
    800045d4:	963e                	add	a2,a2,a5
    800045d6:	e204                	sd	s1,0(a2)
      return fd;
    800045d8:	b7f5                	j	800045c4 <fdalloc+0x2c>

00000000800045da <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045da:	715d                	addi	sp,sp,-80
    800045dc:	e486                	sd	ra,72(sp)
    800045de:	e0a2                	sd	s0,64(sp)
    800045e0:	fc26                	sd	s1,56(sp)
    800045e2:	f84a                	sd	s2,48(sp)
    800045e4:	f44e                	sd	s3,40(sp)
    800045e6:	f052                	sd	s4,32(sp)
    800045e8:	ec56                	sd	s5,24(sp)
    800045ea:	0880                	addi	s0,sp,80
    800045ec:	89ae                	mv	s3,a1
    800045ee:	8ab2                	mv	s5,a2
    800045f0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045f2:	fb040593          	addi	a1,s0,-80
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	e86080e7          	jalr	-378(ra) # 8000347c <nameiparent>
    800045fe:	892a                	mv	s2,a0
    80004600:	12050f63          	beqz	a0,8000473e <create+0x164>
    return 0;

  ilock(dp);
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	6a4080e7          	jalr	1700(ra) # 80002ca8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000460c:	4601                	li	a2,0
    8000460e:	fb040593          	addi	a1,s0,-80
    80004612:	854a                	mv	a0,s2
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	b78080e7          	jalr	-1160(ra) # 8000318c <dirlookup>
    8000461c:	84aa                	mv	s1,a0
    8000461e:	c921                	beqz	a0,8000466e <create+0x94>
    iunlockput(dp);
    80004620:	854a                	mv	a0,s2
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	8e8080e7          	jalr	-1816(ra) # 80002f0a <iunlockput>
    ilock(ip);
    8000462a:	8526                	mv	a0,s1
    8000462c:	ffffe097          	auipc	ra,0xffffe
    80004630:	67c080e7          	jalr	1660(ra) # 80002ca8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004634:	2981                	sext.w	s3,s3
    80004636:	4789                	li	a5,2
    80004638:	02f99463          	bne	s3,a5,80004660 <create+0x86>
    8000463c:	0444d783          	lhu	a5,68(s1)
    80004640:	37f9                	addiw	a5,a5,-2
    80004642:	17c2                	slli	a5,a5,0x30
    80004644:	93c1                	srli	a5,a5,0x30
    80004646:	4705                	li	a4,1
    80004648:	00f76c63          	bltu	a4,a5,80004660 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000464c:	8526                	mv	a0,s1
    8000464e:	60a6                	ld	ra,72(sp)
    80004650:	6406                	ld	s0,64(sp)
    80004652:	74e2                	ld	s1,56(sp)
    80004654:	7942                	ld	s2,48(sp)
    80004656:	79a2                	ld	s3,40(sp)
    80004658:	7a02                	ld	s4,32(sp)
    8000465a:	6ae2                	ld	s5,24(sp)
    8000465c:	6161                	addi	sp,sp,80
    8000465e:	8082                	ret
    iunlockput(ip);
    80004660:	8526                	mv	a0,s1
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	8a8080e7          	jalr	-1880(ra) # 80002f0a <iunlockput>
    return 0;
    8000466a:	4481                	li	s1,0
    8000466c:	b7c5                	j	8000464c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000466e:	85ce                	mv	a1,s3
    80004670:	00092503          	lw	a0,0(s2)
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	49c080e7          	jalr	1180(ra) # 80002b10 <ialloc>
    8000467c:	84aa                	mv	s1,a0
    8000467e:	c529                	beqz	a0,800046c8 <create+0xee>
  ilock(ip);
    80004680:	ffffe097          	auipc	ra,0xffffe
    80004684:	628080e7          	jalr	1576(ra) # 80002ca8 <ilock>
  ip->major = major;
    80004688:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000468c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004690:	4785                	li	a5,1
    80004692:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004696:	8526                	mv	a0,s1
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	546080e7          	jalr	1350(ra) # 80002bde <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046a0:	2981                	sext.w	s3,s3
    800046a2:	4785                	li	a5,1
    800046a4:	02f98a63          	beq	s3,a5,800046d8 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046a8:	40d0                	lw	a2,4(s1)
    800046aa:	fb040593          	addi	a1,s0,-80
    800046ae:	854a                	mv	a0,s2
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	cec080e7          	jalr	-788(ra) # 8000339c <dirlink>
    800046b8:	06054b63          	bltz	a0,8000472e <create+0x154>
  iunlockput(dp);
    800046bc:	854a                	mv	a0,s2
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	84c080e7          	jalr	-1972(ra) # 80002f0a <iunlockput>
  return ip;
    800046c6:	b759                	j	8000464c <create+0x72>
    panic("create: ialloc");
    800046c8:	00004517          	auipc	a0,0x4
    800046cc:	fa050513          	addi	a0,a0,-96 # 80008668 <syscalls+0x2a0>
    800046d0:	00001097          	auipc	ra,0x1
    800046d4:	688080e7          	jalr	1672(ra) # 80005d58 <panic>
    dp->nlink++;  // for ".."
    800046d8:	04a95783          	lhu	a5,74(s2)
    800046dc:	2785                	addiw	a5,a5,1
    800046de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046e2:	854a                	mv	a0,s2
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	4fa080e7          	jalr	1274(ra) # 80002bde <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ec:	40d0                	lw	a2,4(s1)
    800046ee:	00004597          	auipc	a1,0x4
    800046f2:	f8a58593          	addi	a1,a1,-118 # 80008678 <syscalls+0x2b0>
    800046f6:	8526                	mv	a0,s1
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	ca4080e7          	jalr	-860(ra) # 8000339c <dirlink>
    80004700:	00054f63          	bltz	a0,8000471e <create+0x144>
    80004704:	00492603          	lw	a2,4(s2)
    80004708:	00004597          	auipc	a1,0x4
    8000470c:	f7858593          	addi	a1,a1,-136 # 80008680 <syscalls+0x2b8>
    80004710:	8526                	mv	a0,s1
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	c8a080e7          	jalr	-886(ra) # 8000339c <dirlink>
    8000471a:	f80557e3          	bgez	a0,800046a8 <create+0xce>
      panic("create dots");
    8000471e:	00004517          	auipc	a0,0x4
    80004722:	f6a50513          	addi	a0,a0,-150 # 80008688 <syscalls+0x2c0>
    80004726:	00001097          	auipc	ra,0x1
    8000472a:	632080e7          	jalr	1586(ra) # 80005d58 <panic>
    panic("create: dirlink");
    8000472e:	00004517          	auipc	a0,0x4
    80004732:	f6a50513          	addi	a0,a0,-150 # 80008698 <syscalls+0x2d0>
    80004736:	00001097          	auipc	ra,0x1
    8000473a:	622080e7          	jalr	1570(ra) # 80005d58 <panic>
    return 0;
    8000473e:	84aa                	mv	s1,a0
    80004740:	b731                	j	8000464c <create+0x72>

0000000080004742 <sys_dup>:
{
    80004742:	7179                	addi	sp,sp,-48
    80004744:	f406                	sd	ra,40(sp)
    80004746:	f022                	sd	s0,32(sp)
    80004748:	ec26                	sd	s1,24(sp)
    8000474a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000474c:	fd840613          	addi	a2,s0,-40
    80004750:	4581                	li	a1,0
    80004752:	4501                	li	a0,0
    80004754:	00000097          	auipc	ra,0x0
    80004758:	ddc080e7          	jalr	-548(ra) # 80004530 <argfd>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000475e:	02054363          	bltz	a0,80004784 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004762:	fd843503          	ld	a0,-40(s0)
    80004766:	00000097          	auipc	ra,0x0
    8000476a:	e32080e7          	jalr	-462(ra) # 80004598 <fdalloc>
    8000476e:	84aa                	mv	s1,a0
    return -1;
    80004770:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004772:	00054963          	bltz	a0,80004784 <sys_dup+0x42>
  filedup(f);
    80004776:	fd843503          	ld	a0,-40(s0)
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	37a080e7          	jalr	890(ra) # 80003af4 <filedup>
  return fd;
    80004782:	87a6                	mv	a5,s1
}
    80004784:	853e                	mv	a0,a5
    80004786:	70a2                	ld	ra,40(sp)
    80004788:	7402                	ld	s0,32(sp)
    8000478a:	64e2                	ld	s1,24(sp)
    8000478c:	6145                	addi	sp,sp,48
    8000478e:	8082                	ret

0000000080004790 <sys_read>:
{
    80004790:	7179                	addi	sp,sp,-48
    80004792:	f406                	sd	ra,40(sp)
    80004794:	f022                	sd	s0,32(sp)
    80004796:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004798:	fe840613          	addi	a2,s0,-24
    8000479c:	4581                	li	a1,0
    8000479e:	4501                	li	a0,0
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	d90080e7          	jalr	-624(ra) # 80004530 <argfd>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047aa:	04054163          	bltz	a0,800047ec <sys_read+0x5c>
    800047ae:	fe440593          	addi	a1,s0,-28
    800047b2:	4509                	li	a0,2
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	982080e7          	jalr	-1662(ra) # 80002136 <argint>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047be:	02054763          	bltz	a0,800047ec <sys_read+0x5c>
    800047c2:	fd840593          	addi	a1,s0,-40
    800047c6:	4505                	li	a0,1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	990080e7          	jalr	-1648(ra) # 80002158 <argaddr>
    return -1;
    800047d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d2:	00054d63          	bltz	a0,800047ec <sys_read+0x5c>
  return fileread(f, p, n);
    800047d6:	fe442603          	lw	a2,-28(s0)
    800047da:	fd843583          	ld	a1,-40(s0)
    800047de:	fe843503          	ld	a0,-24(s0)
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	49e080e7          	jalr	1182(ra) # 80003c80 <fileread>
    800047ea:	87aa                	mv	a5,a0
}
    800047ec:	853e                	mv	a0,a5
    800047ee:	70a2                	ld	ra,40(sp)
    800047f0:	7402                	ld	s0,32(sp)
    800047f2:	6145                	addi	sp,sp,48
    800047f4:	8082                	ret

00000000800047f6 <sys_write>:
{
    800047f6:	7179                	addi	sp,sp,-48
    800047f8:	f406                	sd	ra,40(sp)
    800047fa:	f022                	sd	s0,32(sp)
    800047fc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fe:	fe840613          	addi	a2,s0,-24
    80004802:	4581                	li	a1,0
    80004804:	4501                	li	a0,0
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	d2a080e7          	jalr	-726(ra) # 80004530 <argfd>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004810:	04054163          	bltz	a0,80004852 <sys_write+0x5c>
    80004814:	fe440593          	addi	a1,s0,-28
    80004818:	4509                	li	a0,2
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	91c080e7          	jalr	-1764(ra) # 80002136 <argint>
    return -1;
    80004822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004824:	02054763          	bltz	a0,80004852 <sys_write+0x5c>
    80004828:	fd840593          	addi	a1,s0,-40
    8000482c:	4505                	li	a0,1
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	92a080e7          	jalr	-1750(ra) # 80002158 <argaddr>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004838:	00054d63          	bltz	a0,80004852 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000483c:	fe442603          	lw	a2,-28(s0)
    80004840:	fd843583          	ld	a1,-40(s0)
    80004844:	fe843503          	ld	a0,-24(s0)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	4fa080e7          	jalr	1274(ra) # 80003d42 <filewrite>
    80004850:	87aa                	mv	a5,a0
}
    80004852:	853e                	mv	a0,a5
    80004854:	70a2                	ld	ra,40(sp)
    80004856:	7402                	ld	s0,32(sp)
    80004858:	6145                	addi	sp,sp,48
    8000485a:	8082                	ret

000000008000485c <sys_close>:
{
    8000485c:	1101                	addi	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004864:	fe040613          	addi	a2,s0,-32
    80004868:	fec40593          	addi	a1,s0,-20
    8000486c:	4501                	li	a0,0
    8000486e:	00000097          	auipc	ra,0x0
    80004872:	cc2080e7          	jalr	-830(ra) # 80004530 <argfd>
    return -1;
    80004876:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004878:	02054463          	bltz	a0,800048a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	746080e7          	jalr	1862(ra) # 80000fc2 <myproc>
    80004884:	fec42783          	lw	a5,-20(s0)
    80004888:	07e9                	addi	a5,a5,26
    8000488a:	078e                	slli	a5,a5,0x3
    8000488c:	97aa                	add	a5,a5,a0
    8000488e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004892:	fe043503          	ld	a0,-32(s0)
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	2b0080e7          	jalr	688(ra) # 80003b46 <fileclose>
  return 0;
    8000489e:	4781                	li	a5,0
}
    800048a0:	853e                	mv	a0,a5
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	6105                	addi	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <sys_fstat>:
{
    800048aa:	1101                	addi	sp,sp,-32
    800048ac:	ec06                	sd	ra,24(sp)
    800048ae:	e822                	sd	s0,16(sp)
    800048b0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048b2:	fe840613          	addi	a2,s0,-24
    800048b6:	4581                	li	a1,0
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	c76080e7          	jalr	-906(ra) # 80004530 <argfd>
    return -1;
    800048c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c4:	02054563          	bltz	a0,800048ee <sys_fstat+0x44>
    800048c8:	fe040593          	addi	a1,s0,-32
    800048cc:	4505                	li	a0,1
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	88a080e7          	jalr	-1910(ra) # 80002158 <argaddr>
    return -1;
    800048d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048d8:	00054b63          	bltz	a0,800048ee <sys_fstat+0x44>
  return filestat(f, st);
    800048dc:	fe043583          	ld	a1,-32(s0)
    800048e0:	fe843503          	ld	a0,-24(s0)
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	32a080e7          	jalr	810(ra) # 80003c0e <filestat>
    800048ec:	87aa                	mv	a5,a0
}
    800048ee:	853e                	mv	a0,a5
    800048f0:	60e2                	ld	ra,24(sp)
    800048f2:	6442                	ld	s0,16(sp)
    800048f4:	6105                	addi	sp,sp,32
    800048f6:	8082                	ret

00000000800048f8 <sys_link>:
{
    800048f8:	7169                	addi	sp,sp,-304
    800048fa:	f606                	sd	ra,296(sp)
    800048fc:	f222                	sd	s0,288(sp)
    800048fe:	ee26                	sd	s1,280(sp)
    80004900:	ea4a                	sd	s2,272(sp)
    80004902:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004904:	08000613          	li	a2,128
    80004908:	ed040593          	addi	a1,s0,-304
    8000490c:	4501                	li	a0,0
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	86c080e7          	jalr	-1940(ra) # 8000217a <argstr>
    return -1;
    80004916:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004918:	10054e63          	bltz	a0,80004a34 <sys_link+0x13c>
    8000491c:	08000613          	li	a2,128
    80004920:	f5040593          	addi	a1,s0,-176
    80004924:	4505                	li	a0,1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	854080e7          	jalr	-1964(ra) # 8000217a <argstr>
    return -1;
    8000492e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004930:	10054263          	bltz	a0,80004a34 <sys_link+0x13c>
  begin_op();
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	d46080e7          	jalr	-698(ra) # 8000367a <begin_op>
  if((ip = namei(old)) == 0){
    8000493c:	ed040513          	addi	a0,s0,-304
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	b1e080e7          	jalr	-1250(ra) # 8000345e <namei>
    80004948:	84aa                	mv	s1,a0
    8000494a:	c551                	beqz	a0,800049d6 <sys_link+0xde>
  ilock(ip);
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	35c080e7          	jalr	860(ra) # 80002ca8 <ilock>
  if(ip->type == T_DIR){
    80004954:	04449703          	lh	a4,68(s1)
    80004958:	4785                	li	a5,1
    8000495a:	08f70463          	beq	a4,a5,800049e2 <sys_link+0xea>
  ip->nlink++;
    8000495e:	04a4d783          	lhu	a5,74(s1)
    80004962:	2785                	addiw	a5,a5,1
    80004964:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	274080e7          	jalr	628(ra) # 80002bde <iupdate>
  iunlock(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	3f6080e7          	jalr	1014(ra) # 80002d6a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000497c:	fd040593          	addi	a1,s0,-48
    80004980:	f5040513          	addi	a0,s0,-176
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	af8080e7          	jalr	-1288(ra) # 8000347c <nameiparent>
    8000498c:	892a                	mv	s2,a0
    8000498e:	c935                	beqz	a0,80004a02 <sys_link+0x10a>
  ilock(dp);
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	318080e7          	jalr	792(ra) # 80002ca8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004998:	00092703          	lw	a4,0(s2)
    8000499c:	409c                	lw	a5,0(s1)
    8000499e:	04f71d63          	bne	a4,a5,800049f8 <sys_link+0x100>
    800049a2:	40d0                	lw	a2,4(s1)
    800049a4:	fd040593          	addi	a1,s0,-48
    800049a8:	854a                	mv	a0,s2
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	9f2080e7          	jalr	-1550(ra) # 8000339c <dirlink>
    800049b2:	04054363          	bltz	a0,800049f8 <sys_link+0x100>
  iunlockput(dp);
    800049b6:	854a                	mv	a0,s2
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	552080e7          	jalr	1362(ra) # 80002f0a <iunlockput>
  iput(ip);
    800049c0:	8526                	mv	a0,s1
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	4a0080e7          	jalr	1184(ra) # 80002e62 <iput>
  end_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	d30080e7          	jalr	-720(ra) # 800036fa <end_op>
  return 0;
    800049d2:	4781                	li	a5,0
    800049d4:	a085                	j	80004a34 <sys_link+0x13c>
    end_op();
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	d24080e7          	jalr	-732(ra) # 800036fa <end_op>
    return -1;
    800049de:	57fd                	li	a5,-1
    800049e0:	a891                	j	80004a34 <sys_link+0x13c>
    iunlockput(ip);
    800049e2:	8526                	mv	a0,s1
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	526080e7          	jalr	1318(ra) # 80002f0a <iunlockput>
    end_op();
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	d0e080e7          	jalr	-754(ra) # 800036fa <end_op>
    return -1;
    800049f4:	57fd                	li	a5,-1
    800049f6:	a83d                	j	80004a34 <sys_link+0x13c>
    iunlockput(dp);
    800049f8:	854a                	mv	a0,s2
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	510080e7          	jalr	1296(ra) # 80002f0a <iunlockput>
  ilock(ip);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	2a4080e7          	jalr	676(ra) # 80002ca8 <ilock>
  ip->nlink--;
    80004a0c:	04a4d783          	lhu	a5,74(s1)
    80004a10:	37fd                	addiw	a5,a5,-1
    80004a12:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	1c6080e7          	jalr	454(ra) # 80002bde <iupdate>
  iunlockput(ip);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	4e8080e7          	jalr	1256(ra) # 80002f0a <iunlockput>
  end_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	cd0080e7          	jalr	-816(ra) # 800036fa <end_op>
  return -1;
    80004a32:	57fd                	li	a5,-1
}
    80004a34:	853e                	mv	a0,a5
    80004a36:	70b2                	ld	ra,296(sp)
    80004a38:	7412                	ld	s0,288(sp)
    80004a3a:	64f2                	ld	s1,280(sp)
    80004a3c:	6952                	ld	s2,272(sp)
    80004a3e:	6155                	addi	sp,sp,304
    80004a40:	8082                	ret

0000000080004a42 <sys_unlink>:
{
    80004a42:	7151                	addi	sp,sp,-240
    80004a44:	f586                	sd	ra,232(sp)
    80004a46:	f1a2                	sd	s0,224(sp)
    80004a48:	eda6                	sd	s1,216(sp)
    80004a4a:	e9ca                	sd	s2,208(sp)
    80004a4c:	e5ce                	sd	s3,200(sp)
    80004a4e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a50:	08000613          	li	a2,128
    80004a54:	f3040593          	addi	a1,s0,-208
    80004a58:	4501                	li	a0,0
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	720080e7          	jalr	1824(ra) # 8000217a <argstr>
    80004a62:	18054163          	bltz	a0,80004be4 <sys_unlink+0x1a2>
  begin_op();
    80004a66:	fffff097          	auipc	ra,0xfffff
    80004a6a:	c14080e7          	jalr	-1004(ra) # 8000367a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a6e:	fb040593          	addi	a1,s0,-80
    80004a72:	f3040513          	addi	a0,s0,-208
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	a06080e7          	jalr	-1530(ra) # 8000347c <nameiparent>
    80004a7e:	84aa                	mv	s1,a0
    80004a80:	c979                	beqz	a0,80004b56 <sys_unlink+0x114>
  ilock(dp);
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	226080e7          	jalr	550(ra) # 80002ca8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a8a:	00004597          	auipc	a1,0x4
    80004a8e:	bee58593          	addi	a1,a1,-1042 # 80008678 <syscalls+0x2b0>
    80004a92:	fb040513          	addi	a0,s0,-80
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	6dc080e7          	jalr	1756(ra) # 80003172 <namecmp>
    80004a9e:	14050a63          	beqz	a0,80004bf2 <sys_unlink+0x1b0>
    80004aa2:	00004597          	auipc	a1,0x4
    80004aa6:	bde58593          	addi	a1,a1,-1058 # 80008680 <syscalls+0x2b8>
    80004aaa:	fb040513          	addi	a0,s0,-80
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	6c4080e7          	jalr	1732(ra) # 80003172 <namecmp>
    80004ab6:	12050e63          	beqz	a0,80004bf2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aba:	f2c40613          	addi	a2,s0,-212
    80004abe:	fb040593          	addi	a1,s0,-80
    80004ac2:	8526                	mv	a0,s1
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	6c8080e7          	jalr	1736(ra) # 8000318c <dirlookup>
    80004acc:	892a                	mv	s2,a0
    80004ace:	12050263          	beqz	a0,80004bf2 <sys_unlink+0x1b0>
  ilock(ip);
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	1d6080e7          	jalr	470(ra) # 80002ca8 <ilock>
  if(ip->nlink < 1)
    80004ada:	04a91783          	lh	a5,74(s2)
    80004ade:	08f05263          	blez	a5,80004b62 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ae2:	04491703          	lh	a4,68(s2)
    80004ae6:	4785                	li	a5,1
    80004ae8:	08f70563          	beq	a4,a5,80004b72 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004aec:	4641                	li	a2,16
    80004aee:	4581                	li	a1,0
    80004af0:	fc040513          	addi	a0,s0,-64
    80004af4:	ffffb097          	auipc	ra,0xffffb
    80004af8:	7f8080e7          	jalr	2040(ra) # 800002ec <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afc:	4741                	li	a4,16
    80004afe:	f2c42683          	lw	a3,-212(s0)
    80004b02:	fc040613          	addi	a2,s0,-64
    80004b06:	4581                	li	a1,0
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	54a080e7          	jalr	1354(ra) # 80003054 <writei>
    80004b12:	47c1                	li	a5,16
    80004b14:	0af51563          	bne	a0,a5,80004bbe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b18:	04491703          	lh	a4,68(s2)
    80004b1c:	4785                	li	a5,1
    80004b1e:	0af70863          	beq	a4,a5,80004bce <sys_unlink+0x18c>
  iunlockput(dp);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	3e6080e7          	jalr	998(ra) # 80002f0a <iunlockput>
  ip->nlink--;
    80004b2c:	04a95783          	lhu	a5,74(s2)
    80004b30:	37fd                	addiw	a5,a5,-1
    80004b32:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b36:	854a                	mv	a0,s2
    80004b38:	ffffe097          	auipc	ra,0xffffe
    80004b3c:	0a6080e7          	jalr	166(ra) # 80002bde <iupdate>
  iunlockput(ip);
    80004b40:	854a                	mv	a0,s2
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	3c8080e7          	jalr	968(ra) # 80002f0a <iunlockput>
  end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	bb0080e7          	jalr	-1104(ra) # 800036fa <end_op>
  return 0;
    80004b52:	4501                	li	a0,0
    80004b54:	a84d                	j	80004c06 <sys_unlink+0x1c4>
    end_op();
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	ba4080e7          	jalr	-1116(ra) # 800036fa <end_op>
    return -1;
    80004b5e:	557d                	li	a0,-1
    80004b60:	a05d                	j	80004c06 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b62:	00004517          	auipc	a0,0x4
    80004b66:	b4650513          	addi	a0,a0,-1210 # 800086a8 <syscalls+0x2e0>
    80004b6a:	00001097          	auipc	ra,0x1
    80004b6e:	1ee080e7          	jalr	494(ra) # 80005d58 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b72:	04c92703          	lw	a4,76(s2)
    80004b76:	02000793          	li	a5,32
    80004b7a:	f6e7f9e3          	bgeu	a5,a4,80004aec <sys_unlink+0xaa>
    80004b7e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b82:	4741                	li	a4,16
    80004b84:	86ce                	mv	a3,s3
    80004b86:	f1840613          	addi	a2,s0,-232
    80004b8a:	4581                	li	a1,0
    80004b8c:	854a                	mv	a0,s2
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	3ce080e7          	jalr	974(ra) # 80002f5c <readi>
    80004b96:	47c1                	li	a5,16
    80004b98:	00f51b63          	bne	a0,a5,80004bae <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b9c:	f1845783          	lhu	a5,-232(s0)
    80004ba0:	e7a1                	bnez	a5,80004be8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ba2:	29c1                	addiw	s3,s3,16
    80004ba4:	04c92783          	lw	a5,76(s2)
    80004ba8:	fcf9ede3          	bltu	s3,a5,80004b82 <sys_unlink+0x140>
    80004bac:	b781                	j	80004aec <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bae:	00004517          	auipc	a0,0x4
    80004bb2:	b1250513          	addi	a0,a0,-1262 # 800086c0 <syscalls+0x2f8>
    80004bb6:	00001097          	auipc	ra,0x1
    80004bba:	1a2080e7          	jalr	418(ra) # 80005d58 <panic>
    panic("unlink: writei");
    80004bbe:	00004517          	auipc	a0,0x4
    80004bc2:	b1a50513          	addi	a0,a0,-1254 # 800086d8 <syscalls+0x310>
    80004bc6:	00001097          	auipc	ra,0x1
    80004bca:	192080e7          	jalr	402(ra) # 80005d58 <panic>
    dp->nlink--;
    80004bce:	04a4d783          	lhu	a5,74(s1)
    80004bd2:	37fd                	addiw	a5,a5,-1
    80004bd4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bd8:	8526                	mv	a0,s1
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	004080e7          	jalr	4(ra) # 80002bde <iupdate>
    80004be2:	b781                	j	80004b22 <sys_unlink+0xe0>
    return -1;
    80004be4:	557d                	li	a0,-1
    80004be6:	a005                	j	80004c06 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004be8:	854a                	mv	a0,s2
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	320080e7          	jalr	800(ra) # 80002f0a <iunlockput>
  iunlockput(dp);
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	316080e7          	jalr	790(ra) # 80002f0a <iunlockput>
  end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	afe080e7          	jalr	-1282(ra) # 800036fa <end_op>
  return -1;
    80004c04:	557d                	li	a0,-1
}
    80004c06:	70ae                	ld	ra,232(sp)
    80004c08:	740e                	ld	s0,224(sp)
    80004c0a:	64ee                	ld	s1,216(sp)
    80004c0c:	694e                	ld	s2,208(sp)
    80004c0e:	69ae                	ld	s3,200(sp)
    80004c10:	616d                	addi	sp,sp,240
    80004c12:	8082                	ret

0000000080004c14 <sys_open>:

uint64
sys_open(void)
{
    80004c14:	7131                	addi	sp,sp,-192
    80004c16:	fd06                	sd	ra,184(sp)
    80004c18:	f922                	sd	s0,176(sp)
    80004c1a:	f526                	sd	s1,168(sp)
    80004c1c:	f14a                	sd	s2,160(sp)
    80004c1e:	ed4e                	sd	s3,152(sp)
    80004c20:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c22:	08000613          	li	a2,128
    80004c26:	f5040593          	addi	a1,s0,-176
    80004c2a:	4501                	li	a0,0
    80004c2c:	ffffd097          	auipc	ra,0xffffd
    80004c30:	54e080e7          	jalr	1358(ra) # 8000217a <argstr>
    return -1;
    80004c34:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c36:	0c054163          	bltz	a0,80004cf8 <sys_open+0xe4>
    80004c3a:	f4c40593          	addi	a1,s0,-180
    80004c3e:	4505                	li	a0,1
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	4f6080e7          	jalr	1270(ra) # 80002136 <argint>
    80004c48:	0a054863          	bltz	a0,80004cf8 <sys_open+0xe4>

  begin_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	a2e080e7          	jalr	-1490(ra) # 8000367a <begin_op>

  if(omode & O_CREATE){
    80004c54:	f4c42783          	lw	a5,-180(s0)
    80004c58:	2007f793          	andi	a5,a5,512
    80004c5c:	cbdd                	beqz	a5,80004d12 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c5e:	4681                	li	a3,0
    80004c60:	4601                	li	a2,0
    80004c62:	4589                	li	a1,2
    80004c64:	f5040513          	addi	a0,s0,-176
    80004c68:	00000097          	auipc	ra,0x0
    80004c6c:	972080e7          	jalr	-1678(ra) # 800045da <create>
    80004c70:	892a                	mv	s2,a0
    if(ip == 0){
    80004c72:	c959                	beqz	a0,80004d08 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c74:	04491703          	lh	a4,68(s2)
    80004c78:	478d                	li	a5,3
    80004c7a:	00f71763          	bne	a4,a5,80004c88 <sys_open+0x74>
    80004c7e:	04695703          	lhu	a4,70(s2)
    80004c82:	47a5                	li	a5,9
    80004c84:	0ce7ec63          	bltu	a5,a4,80004d5c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	e02080e7          	jalr	-510(ra) # 80003a8a <filealloc>
    80004c90:	89aa                	mv	s3,a0
    80004c92:	10050263          	beqz	a0,80004d96 <sys_open+0x182>
    80004c96:	00000097          	auipc	ra,0x0
    80004c9a:	902080e7          	jalr	-1790(ra) # 80004598 <fdalloc>
    80004c9e:	84aa                	mv	s1,a0
    80004ca0:	0e054663          	bltz	a0,80004d8c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ca4:	04491703          	lh	a4,68(s2)
    80004ca8:	478d                	li	a5,3
    80004caa:	0cf70463          	beq	a4,a5,80004d72 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cae:	4789                	li	a5,2
    80004cb0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cb4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cb8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cbc:	f4c42783          	lw	a5,-180(s0)
    80004cc0:	0017c713          	xori	a4,a5,1
    80004cc4:	8b05                	andi	a4,a4,1
    80004cc6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cca:	0037f713          	andi	a4,a5,3
    80004cce:	00e03733          	snez	a4,a4
    80004cd2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cd6:	4007f793          	andi	a5,a5,1024
    80004cda:	c791                	beqz	a5,80004ce6 <sys_open+0xd2>
    80004cdc:	04491703          	lh	a4,68(s2)
    80004ce0:	4789                	li	a5,2
    80004ce2:	08f70f63          	beq	a4,a5,80004d80 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ce6:	854a                	mv	a0,s2
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	082080e7          	jalr	130(ra) # 80002d6a <iunlock>
  end_op();
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	a0a080e7          	jalr	-1526(ra) # 800036fa <end_op>

  return fd;
}
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	70ea                	ld	ra,184(sp)
    80004cfc:	744a                	ld	s0,176(sp)
    80004cfe:	74aa                	ld	s1,168(sp)
    80004d00:	790a                	ld	s2,160(sp)
    80004d02:	69ea                	ld	s3,152(sp)
    80004d04:	6129                	addi	sp,sp,192
    80004d06:	8082                	ret
      end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	9f2080e7          	jalr	-1550(ra) # 800036fa <end_op>
      return -1;
    80004d10:	b7e5                	j	80004cf8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d12:	f5040513          	addi	a0,s0,-176
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	748080e7          	jalr	1864(ra) # 8000345e <namei>
    80004d1e:	892a                	mv	s2,a0
    80004d20:	c905                	beqz	a0,80004d50 <sys_open+0x13c>
    ilock(ip);
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	f86080e7          	jalr	-122(ra) # 80002ca8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d2a:	04491703          	lh	a4,68(s2)
    80004d2e:	4785                	li	a5,1
    80004d30:	f4f712e3          	bne	a4,a5,80004c74 <sys_open+0x60>
    80004d34:	f4c42783          	lw	a5,-180(s0)
    80004d38:	dba1                	beqz	a5,80004c88 <sys_open+0x74>
      iunlockput(ip);
    80004d3a:	854a                	mv	a0,s2
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	1ce080e7          	jalr	462(ra) # 80002f0a <iunlockput>
      end_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	9b6080e7          	jalr	-1610(ra) # 800036fa <end_op>
      return -1;
    80004d4c:	54fd                	li	s1,-1
    80004d4e:	b76d                	j	80004cf8 <sys_open+0xe4>
      end_op();
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	9aa080e7          	jalr	-1622(ra) # 800036fa <end_op>
      return -1;
    80004d58:	54fd                	li	s1,-1
    80004d5a:	bf79                	j	80004cf8 <sys_open+0xe4>
    iunlockput(ip);
    80004d5c:	854a                	mv	a0,s2
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	1ac080e7          	jalr	428(ra) # 80002f0a <iunlockput>
    end_op();
    80004d66:	fffff097          	auipc	ra,0xfffff
    80004d6a:	994080e7          	jalr	-1644(ra) # 800036fa <end_op>
    return -1;
    80004d6e:	54fd                	li	s1,-1
    80004d70:	b761                	j	80004cf8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d72:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d76:	04691783          	lh	a5,70(s2)
    80004d7a:	02f99223          	sh	a5,36(s3)
    80004d7e:	bf2d                	j	80004cb8 <sys_open+0xa4>
    itrunc(ip);
    80004d80:	854a                	mv	a0,s2
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	034080e7          	jalr	52(ra) # 80002db6 <itrunc>
    80004d8a:	bfb1                	j	80004ce6 <sys_open+0xd2>
      fileclose(f);
    80004d8c:	854e                	mv	a0,s3
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	db8080e7          	jalr	-584(ra) # 80003b46 <fileclose>
    iunlockput(ip);
    80004d96:	854a                	mv	a0,s2
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	172080e7          	jalr	370(ra) # 80002f0a <iunlockput>
    end_op();
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	95a080e7          	jalr	-1702(ra) # 800036fa <end_op>
    return -1;
    80004da8:	54fd                	li	s1,-1
    80004daa:	b7b9                	j	80004cf8 <sys_open+0xe4>

0000000080004dac <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dac:	7175                	addi	sp,sp,-144
    80004dae:	e506                	sd	ra,136(sp)
    80004db0:	e122                	sd	s0,128(sp)
    80004db2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	8c6080e7          	jalr	-1850(ra) # 8000367a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f7040593          	addi	a1,s0,-144
    80004dc4:	4501                	li	a0,0
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	3b4080e7          	jalr	948(ra) # 8000217a <argstr>
    80004dce:	02054963          	bltz	a0,80004e00 <sys_mkdir+0x54>
    80004dd2:	4681                	li	a3,0
    80004dd4:	4601                	li	a2,0
    80004dd6:	4585                	li	a1,1
    80004dd8:	f7040513          	addi	a0,s0,-144
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	7fe080e7          	jalr	2046(ra) # 800045da <create>
    80004de4:	cd11                	beqz	a0,80004e00 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	124080e7          	jalr	292(ra) # 80002f0a <iunlockput>
  end_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	90c080e7          	jalr	-1780(ra) # 800036fa <end_op>
  return 0;
    80004df6:	4501                	li	a0,0
}
    80004df8:	60aa                	ld	ra,136(sp)
    80004dfa:	640a                	ld	s0,128(sp)
    80004dfc:	6149                	addi	sp,sp,144
    80004dfe:	8082                	ret
    end_op();
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	8fa080e7          	jalr	-1798(ra) # 800036fa <end_op>
    return -1;
    80004e08:	557d                	li	a0,-1
    80004e0a:	b7fd                	j	80004df8 <sys_mkdir+0x4c>

0000000080004e0c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e0c:	7135                	addi	sp,sp,-160
    80004e0e:	ed06                	sd	ra,152(sp)
    80004e10:	e922                	sd	s0,144(sp)
    80004e12:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	866080e7          	jalr	-1946(ra) # 8000367a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e1c:	08000613          	li	a2,128
    80004e20:	f7040593          	addi	a1,s0,-144
    80004e24:	4501                	li	a0,0
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	354080e7          	jalr	852(ra) # 8000217a <argstr>
    80004e2e:	04054a63          	bltz	a0,80004e82 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e32:	f6c40593          	addi	a1,s0,-148
    80004e36:	4505                	li	a0,1
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	2fe080e7          	jalr	766(ra) # 80002136 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e40:	04054163          	bltz	a0,80004e82 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e44:	f6840593          	addi	a1,s0,-152
    80004e48:	4509                	li	a0,2
    80004e4a:	ffffd097          	auipc	ra,0xffffd
    80004e4e:	2ec080e7          	jalr	748(ra) # 80002136 <argint>
     argint(1, &major) < 0 ||
    80004e52:	02054863          	bltz	a0,80004e82 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e56:	f6841683          	lh	a3,-152(s0)
    80004e5a:	f6c41603          	lh	a2,-148(s0)
    80004e5e:	458d                	li	a1,3
    80004e60:	f7040513          	addi	a0,s0,-144
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	776080e7          	jalr	1910(ra) # 800045da <create>
     argint(2, &minor) < 0 ||
    80004e6c:	c919                	beqz	a0,80004e82 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	09c080e7          	jalr	156(ra) # 80002f0a <iunlockput>
  end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	884080e7          	jalr	-1916(ra) # 800036fa <end_op>
  return 0;
    80004e7e:	4501                	li	a0,0
    80004e80:	a031                	j	80004e8c <sys_mknod+0x80>
    end_op();
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	878080e7          	jalr	-1928(ra) # 800036fa <end_op>
    return -1;
    80004e8a:	557d                	li	a0,-1
}
    80004e8c:	60ea                	ld	ra,152(sp)
    80004e8e:	644a                	ld	s0,144(sp)
    80004e90:	610d                	addi	sp,sp,160
    80004e92:	8082                	ret

0000000080004e94 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e94:	7135                	addi	sp,sp,-160
    80004e96:	ed06                	sd	ra,152(sp)
    80004e98:	e922                	sd	s0,144(sp)
    80004e9a:	e526                	sd	s1,136(sp)
    80004e9c:	e14a                	sd	s2,128(sp)
    80004e9e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ea0:	ffffc097          	auipc	ra,0xffffc
    80004ea4:	122080e7          	jalr	290(ra) # 80000fc2 <myproc>
    80004ea8:	892a                	mv	s2,a0
  
  begin_op();
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	7d0080e7          	jalr	2000(ra) # 8000367a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eb2:	08000613          	li	a2,128
    80004eb6:	f6040593          	addi	a1,s0,-160
    80004eba:	4501                	li	a0,0
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	2be080e7          	jalr	702(ra) # 8000217a <argstr>
    80004ec4:	04054b63          	bltz	a0,80004f1a <sys_chdir+0x86>
    80004ec8:	f6040513          	addi	a0,s0,-160
    80004ecc:	ffffe097          	auipc	ra,0xffffe
    80004ed0:	592080e7          	jalr	1426(ra) # 8000345e <namei>
    80004ed4:	84aa                	mv	s1,a0
    80004ed6:	c131                	beqz	a0,80004f1a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	dd0080e7          	jalr	-560(ra) # 80002ca8 <ilock>
  if(ip->type != T_DIR){
    80004ee0:	04449703          	lh	a4,68(s1)
    80004ee4:	4785                	li	a5,1
    80004ee6:	04f71063          	bne	a4,a5,80004f26 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eea:	8526                	mv	a0,s1
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	e7e080e7          	jalr	-386(ra) # 80002d6a <iunlock>
  iput(p->cwd);
    80004ef4:	15093503          	ld	a0,336(s2)
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	f6a080e7          	jalr	-150(ra) # 80002e62 <iput>
  end_op();
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	7fa080e7          	jalr	2042(ra) # 800036fa <end_op>
  p->cwd = ip;
    80004f08:	14993823          	sd	s1,336(s2)
  return 0;
    80004f0c:	4501                	li	a0,0
}
    80004f0e:	60ea                	ld	ra,152(sp)
    80004f10:	644a                	ld	s0,144(sp)
    80004f12:	64aa                	ld	s1,136(sp)
    80004f14:	690a                	ld	s2,128(sp)
    80004f16:	610d                	addi	sp,sp,160
    80004f18:	8082                	ret
    end_op();
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	7e0080e7          	jalr	2016(ra) # 800036fa <end_op>
    return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	b7ed                	j	80004f0e <sys_chdir+0x7a>
    iunlockput(ip);
    80004f26:	8526                	mv	a0,s1
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	fe2080e7          	jalr	-30(ra) # 80002f0a <iunlockput>
    end_op();
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	7ca080e7          	jalr	1994(ra) # 800036fa <end_op>
    return -1;
    80004f38:	557d                	li	a0,-1
    80004f3a:	bfd1                	j	80004f0e <sys_chdir+0x7a>

0000000080004f3c <sys_exec>:

uint64
sys_exec(void)
{
    80004f3c:	7145                	addi	sp,sp,-464
    80004f3e:	e786                	sd	ra,456(sp)
    80004f40:	e3a2                	sd	s0,448(sp)
    80004f42:	ff26                	sd	s1,440(sp)
    80004f44:	fb4a                	sd	s2,432(sp)
    80004f46:	f74e                	sd	s3,424(sp)
    80004f48:	f352                	sd	s4,416(sp)
    80004f4a:	ef56                	sd	s5,408(sp)
    80004f4c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f4e:	08000613          	li	a2,128
    80004f52:	f4040593          	addi	a1,s0,-192
    80004f56:	4501                	li	a0,0
    80004f58:	ffffd097          	auipc	ra,0xffffd
    80004f5c:	222080e7          	jalr	546(ra) # 8000217a <argstr>
    return -1;
    80004f60:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f62:	0c054a63          	bltz	a0,80005036 <sys_exec+0xfa>
    80004f66:	e3840593          	addi	a1,s0,-456
    80004f6a:	4505                	li	a0,1
    80004f6c:	ffffd097          	auipc	ra,0xffffd
    80004f70:	1ec080e7          	jalr	492(ra) # 80002158 <argaddr>
    80004f74:	0c054163          	bltz	a0,80005036 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f78:	10000613          	li	a2,256
    80004f7c:	4581                	li	a1,0
    80004f7e:	e4040513          	addi	a0,s0,-448
    80004f82:	ffffb097          	auipc	ra,0xffffb
    80004f86:	36a080e7          	jalr	874(ra) # 800002ec <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f8a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f8e:	89a6                	mv	s3,s1
    80004f90:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f92:	02000a13          	li	s4,32
    80004f96:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f9a:	00391513          	slli	a0,s2,0x3
    80004f9e:	e3040593          	addi	a1,s0,-464
    80004fa2:	e3843783          	ld	a5,-456(s0)
    80004fa6:	953e                	add	a0,a0,a5
    80004fa8:	ffffd097          	auipc	ra,0xffffd
    80004fac:	0f4080e7          	jalr	244(ra) # 8000209c <fetchaddr>
    80004fb0:	02054a63          	bltz	a0,80004fe4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fb4:	e3043783          	ld	a5,-464(s0)
    80004fb8:	c3b9                	beqz	a5,80004ffe <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fba:	ffffb097          	auipc	ra,0xffffb
    80004fbe:	2b8080e7          	jalr	696(ra) # 80000272 <kalloc>
    80004fc2:	85aa                	mv	a1,a0
    80004fc4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fc8:	cd11                	beqz	a0,80004fe4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fca:	6605                	lui	a2,0x1
    80004fcc:	e3043503          	ld	a0,-464(s0)
    80004fd0:	ffffd097          	auipc	ra,0xffffd
    80004fd4:	11e080e7          	jalr	286(ra) # 800020ee <fetchstr>
    80004fd8:	00054663          	bltz	a0,80004fe4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fdc:	0905                	addi	s2,s2,1
    80004fde:	09a1                	addi	s3,s3,8
    80004fe0:	fb491be3          	bne	s2,s4,80004f96 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe4:	10048913          	addi	s2,s1,256
    80004fe8:	6088                	ld	a0,0(s1)
    80004fea:	c529                	beqz	a0,80005034 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fec:	ffffb097          	auipc	ra,0xffffb
    80004ff0:	10e080e7          	jalr	270(ra) # 800000fa <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff4:	04a1                	addi	s1,s1,8
    80004ff6:	ff2499e3          	bne	s1,s2,80004fe8 <sys_exec+0xac>
  return -1;
    80004ffa:	597d                	li	s2,-1
    80004ffc:	a82d                	j	80005036 <sys_exec+0xfa>
      argv[i] = 0;
    80004ffe:	0a8e                	slli	s5,s5,0x3
    80005000:	fc040793          	addi	a5,s0,-64
    80005004:	9abe                	add	s5,s5,a5
    80005006:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000500a:	e4040593          	addi	a1,s0,-448
    8000500e:	f4040513          	addi	a0,s0,-192
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	194080e7          	jalr	404(ra) # 800041a6 <exec>
    8000501a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501c:	10048993          	addi	s3,s1,256
    80005020:	6088                	ld	a0,0(s1)
    80005022:	c911                	beqz	a0,80005036 <sys_exec+0xfa>
    kfree(argv[i]);
    80005024:	ffffb097          	auipc	ra,0xffffb
    80005028:	0d6080e7          	jalr	214(ra) # 800000fa <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000502c:	04a1                	addi	s1,s1,8
    8000502e:	ff3499e3          	bne	s1,s3,80005020 <sys_exec+0xe4>
    80005032:	a011                	j	80005036 <sys_exec+0xfa>
  return -1;
    80005034:	597d                	li	s2,-1
}
    80005036:	854a                	mv	a0,s2
    80005038:	60be                	ld	ra,456(sp)
    8000503a:	641e                	ld	s0,448(sp)
    8000503c:	74fa                	ld	s1,440(sp)
    8000503e:	795a                	ld	s2,432(sp)
    80005040:	79ba                	ld	s3,424(sp)
    80005042:	7a1a                	ld	s4,416(sp)
    80005044:	6afa                	ld	s5,408(sp)
    80005046:	6179                	addi	sp,sp,464
    80005048:	8082                	ret

000000008000504a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000504a:	7139                	addi	sp,sp,-64
    8000504c:	fc06                	sd	ra,56(sp)
    8000504e:	f822                	sd	s0,48(sp)
    80005050:	f426                	sd	s1,40(sp)
    80005052:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005054:	ffffc097          	auipc	ra,0xffffc
    80005058:	f6e080e7          	jalr	-146(ra) # 80000fc2 <myproc>
    8000505c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000505e:	fd840593          	addi	a1,s0,-40
    80005062:	4501                	li	a0,0
    80005064:	ffffd097          	auipc	ra,0xffffd
    80005068:	0f4080e7          	jalr	244(ra) # 80002158 <argaddr>
    return -1;
    8000506c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000506e:	0e054063          	bltz	a0,8000514e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005072:	fc840593          	addi	a1,s0,-56
    80005076:	fd040513          	addi	a0,s0,-48
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	dfc080e7          	jalr	-516(ra) # 80003e76 <pipealloc>
    return -1;
    80005082:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005084:	0c054563          	bltz	a0,8000514e <sys_pipe+0x104>
  fd0 = -1;
    80005088:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000508c:	fd043503          	ld	a0,-48(s0)
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	508080e7          	jalr	1288(ra) # 80004598 <fdalloc>
    80005098:	fca42223          	sw	a0,-60(s0)
    8000509c:	08054c63          	bltz	a0,80005134 <sys_pipe+0xea>
    800050a0:	fc843503          	ld	a0,-56(s0)
    800050a4:	fffff097          	auipc	ra,0xfffff
    800050a8:	4f4080e7          	jalr	1268(ra) # 80004598 <fdalloc>
    800050ac:	fca42023          	sw	a0,-64(s0)
    800050b0:	06054863          	bltz	a0,80005120 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050b4:	4691                	li	a3,4
    800050b6:	fc440613          	addi	a2,s0,-60
    800050ba:	fd843583          	ld	a1,-40(s0)
    800050be:	68a8                	ld	a0,80(s1)
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	bb0080e7          	jalr	-1104(ra) # 80000c70 <copyout>
    800050c8:	02054063          	bltz	a0,800050e8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050cc:	4691                	li	a3,4
    800050ce:	fc040613          	addi	a2,s0,-64
    800050d2:	fd843583          	ld	a1,-40(s0)
    800050d6:	0591                	addi	a1,a1,4
    800050d8:	68a8                	ld	a0,80(s1)
    800050da:	ffffc097          	auipc	ra,0xffffc
    800050de:	b96080e7          	jalr	-1130(ra) # 80000c70 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050e2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050e4:	06055563          	bgez	a0,8000514e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050e8:	fc442783          	lw	a5,-60(s0)
    800050ec:	07e9                	addi	a5,a5,26
    800050ee:	078e                	slli	a5,a5,0x3
    800050f0:	97a6                	add	a5,a5,s1
    800050f2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050f6:	fc042503          	lw	a0,-64(s0)
    800050fa:	0569                	addi	a0,a0,26
    800050fc:	050e                	slli	a0,a0,0x3
    800050fe:	9526                	add	a0,a0,s1
    80005100:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005104:	fd043503          	ld	a0,-48(s0)
    80005108:	fffff097          	auipc	ra,0xfffff
    8000510c:	a3e080e7          	jalr	-1474(ra) # 80003b46 <fileclose>
    fileclose(wf);
    80005110:	fc843503          	ld	a0,-56(s0)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	a32080e7          	jalr	-1486(ra) # 80003b46 <fileclose>
    return -1;
    8000511c:	57fd                	li	a5,-1
    8000511e:	a805                	j	8000514e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005120:	fc442783          	lw	a5,-60(s0)
    80005124:	0007c863          	bltz	a5,80005134 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005128:	01a78513          	addi	a0,a5,26
    8000512c:	050e                	slli	a0,a0,0x3
    8000512e:	9526                	add	a0,a0,s1
    80005130:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005134:	fd043503          	ld	a0,-48(s0)
    80005138:	fffff097          	auipc	ra,0xfffff
    8000513c:	a0e080e7          	jalr	-1522(ra) # 80003b46 <fileclose>
    fileclose(wf);
    80005140:	fc843503          	ld	a0,-56(s0)
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	a02080e7          	jalr	-1534(ra) # 80003b46 <fileclose>
    return -1;
    8000514c:	57fd                	li	a5,-1
}
    8000514e:	853e                	mv	a0,a5
    80005150:	70e2                	ld	ra,56(sp)
    80005152:	7442                	ld	s0,48(sp)
    80005154:	74a2                	ld	s1,40(sp)
    80005156:	6121                	addi	sp,sp,64
    80005158:	8082                	ret
    8000515a:	0000                	unimp
    8000515c:	0000                	unimp
	...

0000000080005160 <kernelvec>:
    80005160:	7111                	addi	sp,sp,-256
    80005162:	e006                	sd	ra,0(sp)
    80005164:	e40a                	sd	sp,8(sp)
    80005166:	e80e                	sd	gp,16(sp)
    80005168:	ec12                	sd	tp,24(sp)
    8000516a:	f016                	sd	t0,32(sp)
    8000516c:	f41a                	sd	t1,40(sp)
    8000516e:	f81e                	sd	t2,48(sp)
    80005170:	fc22                	sd	s0,56(sp)
    80005172:	e0a6                	sd	s1,64(sp)
    80005174:	e4aa                	sd	a0,72(sp)
    80005176:	e8ae                	sd	a1,80(sp)
    80005178:	ecb2                	sd	a2,88(sp)
    8000517a:	f0b6                	sd	a3,96(sp)
    8000517c:	f4ba                	sd	a4,104(sp)
    8000517e:	f8be                	sd	a5,112(sp)
    80005180:	fcc2                	sd	a6,120(sp)
    80005182:	e146                	sd	a7,128(sp)
    80005184:	e54a                	sd	s2,136(sp)
    80005186:	e94e                	sd	s3,144(sp)
    80005188:	ed52                	sd	s4,152(sp)
    8000518a:	f156                	sd	s5,160(sp)
    8000518c:	f55a                	sd	s6,168(sp)
    8000518e:	f95e                	sd	s7,176(sp)
    80005190:	fd62                	sd	s8,184(sp)
    80005192:	e1e6                	sd	s9,192(sp)
    80005194:	e5ea                	sd	s10,200(sp)
    80005196:	e9ee                	sd	s11,208(sp)
    80005198:	edf2                	sd	t3,216(sp)
    8000519a:	f1f6                	sd	t4,224(sp)
    8000519c:	f5fa                	sd	t5,232(sp)
    8000519e:	f9fe                	sd	t6,240(sp)
    800051a0:	c0dfc0ef          	jal	ra,80001dac <kerneltrap>
    800051a4:	6082                	ld	ra,0(sp)
    800051a6:	6122                	ld	sp,8(sp)
    800051a8:	61c2                	ld	gp,16(sp)
    800051aa:	7282                	ld	t0,32(sp)
    800051ac:	7322                	ld	t1,40(sp)
    800051ae:	73c2                	ld	t2,48(sp)
    800051b0:	7462                	ld	s0,56(sp)
    800051b2:	6486                	ld	s1,64(sp)
    800051b4:	6526                	ld	a0,72(sp)
    800051b6:	65c6                	ld	a1,80(sp)
    800051b8:	6666                	ld	a2,88(sp)
    800051ba:	7686                	ld	a3,96(sp)
    800051bc:	7726                	ld	a4,104(sp)
    800051be:	77c6                	ld	a5,112(sp)
    800051c0:	7866                	ld	a6,120(sp)
    800051c2:	688a                	ld	a7,128(sp)
    800051c4:	692a                	ld	s2,136(sp)
    800051c6:	69ca                	ld	s3,144(sp)
    800051c8:	6a6a                	ld	s4,152(sp)
    800051ca:	7a8a                	ld	s5,160(sp)
    800051cc:	7b2a                	ld	s6,168(sp)
    800051ce:	7bca                	ld	s7,176(sp)
    800051d0:	7c6a                	ld	s8,184(sp)
    800051d2:	6c8e                	ld	s9,192(sp)
    800051d4:	6d2e                	ld	s10,200(sp)
    800051d6:	6dce                	ld	s11,208(sp)
    800051d8:	6e6e                	ld	t3,216(sp)
    800051da:	7e8e                	ld	t4,224(sp)
    800051dc:	7f2e                	ld	t5,232(sp)
    800051de:	7fce                	ld	t6,240(sp)
    800051e0:	6111                	addi	sp,sp,256
    800051e2:	10200073          	sret
    800051e6:	00000013          	nop
    800051ea:	00000013          	nop
    800051ee:	0001                	nop

00000000800051f0 <timervec>:
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	e10c                	sd	a1,0(a0)
    800051f6:	e510                	sd	a2,8(a0)
    800051f8:	e914                	sd	a3,16(a0)
    800051fa:	6d0c                	ld	a1,24(a0)
    800051fc:	7110                	ld	a2,32(a0)
    800051fe:	6194                	ld	a3,0(a1)
    80005200:	96b2                	add	a3,a3,a2
    80005202:	e194                	sd	a3,0(a1)
    80005204:	4589                	li	a1,2
    80005206:	14459073          	csrw	sip,a1
    8000520a:	6914                	ld	a3,16(a0)
    8000520c:	6510                	ld	a2,8(a0)
    8000520e:	610c                	ld	a1,0(a0)
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	30200073          	mret
	...

000000008000521a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000521a:	1141                	addi	sp,sp,-16
    8000521c:	e422                	sd	s0,8(sp)
    8000521e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005220:	0c0007b7          	lui	a5,0xc000
    80005224:	4705                	li	a4,1
    80005226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005228:	c3d8                	sw	a4,4(a5)
}
    8000522a:	6422                	ld	s0,8(sp)
    8000522c:	0141                	addi	sp,sp,16
    8000522e:	8082                	ret

0000000080005230 <plicinithart>:

void
plicinithart(void)
{
    80005230:	1141                	addi	sp,sp,-16
    80005232:	e406                	sd	ra,8(sp)
    80005234:	e022                	sd	s0,0(sp)
    80005236:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	d5e080e7          	jalr	-674(ra) # 80000f96 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005240:	0085171b          	slliw	a4,a0,0x8
    80005244:	0c0027b7          	lui	a5,0xc002
    80005248:	97ba                	add	a5,a5,a4
    8000524a:	40200713          	li	a4,1026
    8000524e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005252:	00d5151b          	slliw	a0,a0,0xd
    80005256:	0c2017b7          	lui	a5,0xc201
    8000525a:	953e                	add	a0,a0,a5
    8000525c:	00052023          	sw	zero,0(a0)
}
    80005260:	60a2                	ld	ra,8(sp)
    80005262:	6402                	ld	s0,0(sp)
    80005264:	0141                	addi	sp,sp,16
    80005266:	8082                	ret

0000000080005268 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005268:	1141                	addi	sp,sp,-16
    8000526a:	e406                	sd	ra,8(sp)
    8000526c:	e022                	sd	s0,0(sp)
    8000526e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	d26080e7          	jalr	-730(ra) # 80000f96 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005278:	00d5179b          	slliw	a5,a0,0xd
    8000527c:	0c201537          	lui	a0,0xc201
    80005280:	953e                	add	a0,a0,a5
  return irq;
}
    80005282:	4148                	lw	a0,4(a0)
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret

000000008000528c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000528c:	1101                	addi	sp,sp,-32
    8000528e:	ec06                	sd	ra,24(sp)
    80005290:	e822                	sd	s0,16(sp)
    80005292:	e426                	sd	s1,8(sp)
    80005294:	1000                	addi	s0,sp,32
    80005296:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	cfe080e7          	jalr	-770(ra) # 80000f96 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052a0:	00d5151b          	slliw	a0,a0,0xd
    800052a4:	0c2017b7          	lui	a5,0xc201
    800052a8:	97aa                	add	a5,a5,a0
    800052aa:	c3c4                	sw	s1,4(a5)
}
    800052ac:	60e2                	ld	ra,24(sp)
    800052ae:	6442                	ld	s0,16(sp)
    800052b0:	64a2                	ld	s1,8(sp)
    800052b2:	6105                	addi	sp,sp,32
    800052b4:	8082                	ret

00000000800052b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052b6:	1141                	addi	sp,sp,-16
    800052b8:	e406                	sd	ra,8(sp)
    800052ba:	e022                	sd	s0,0(sp)
    800052bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052be:	479d                	li	a5,7
    800052c0:	06a7c963          	blt	a5,a0,80005332 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052c4:	00236797          	auipc	a5,0x236
    800052c8:	d3c78793          	addi	a5,a5,-708 # 8023b000 <disk>
    800052cc:	00a78733          	add	a4,a5,a0
    800052d0:	6789                	lui	a5,0x2
    800052d2:	97ba                	add	a5,a5,a4
    800052d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052d8:	e7ad                	bnez	a5,80005342 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052da:	00451793          	slli	a5,a0,0x4
    800052de:	00238717          	auipc	a4,0x238
    800052e2:	d2270713          	addi	a4,a4,-734 # 8023d000 <disk+0x2000>
    800052e6:	6314                	ld	a3,0(a4)
    800052e8:	96be                	add	a3,a3,a5
    800052ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052ee:	6314                	ld	a3,0(a4)
    800052f0:	96be                	add	a3,a3,a5
    800052f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052f6:	6314                	ld	a3,0(a4)
    800052f8:	96be                	add	a3,a3,a5
    800052fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052fe:	6318                	ld	a4,0(a4)
    80005300:	97ba                	add	a5,a5,a4
    80005302:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005306:	00236797          	auipc	a5,0x236
    8000530a:	cfa78793          	addi	a5,a5,-774 # 8023b000 <disk>
    8000530e:	97aa                	add	a5,a5,a0
    80005310:	6509                	lui	a0,0x2
    80005312:	953e                	add	a0,a0,a5
    80005314:	4785                	li	a5,1
    80005316:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000531a:	00238517          	auipc	a0,0x238
    8000531e:	cfe50513          	addi	a0,a0,-770 # 8023d018 <disk+0x2018>
    80005322:	ffffc097          	auipc	ra,0xffffc
    80005326:	4e8080e7          	jalr	1256(ra) # 8000180a <wakeup>
}
    8000532a:	60a2                	ld	ra,8(sp)
    8000532c:	6402                	ld	s0,0(sp)
    8000532e:	0141                	addi	sp,sp,16
    80005330:	8082                	ret
    panic("free_desc 1");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	3b650513          	addi	a0,a0,950 # 800086e8 <syscalls+0x320>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	a1e080e7          	jalr	-1506(ra) # 80005d58 <panic>
    panic("free_desc 2");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	3b650513          	addi	a0,a0,950 # 800086f8 <syscalls+0x330>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	a0e080e7          	jalr	-1522(ra) # 80005d58 <panic>

0000000080005352 <virtio_disk_init>:
{
    80005352:	1101                	addi	sp,sp,-32
    80005354:	ec06                	sd	ra,24(sp)
    80005356:	e822                	sd	s0,16(sp)
    80005358:	e426                	sd	s1,8(sp)
    8000535a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000535c:	00003597          	auipc	a1,0x3
    80005360:	3ac58593          	addi	a1,a1,940 # 80008708 <syscalls+0x340>
    80005364:	00238517          	auipc	a0,0x238
    80005368:	dc450513          	addi	a0,a0,-572 # 8023d128 <disk+0x2128>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	ea6080e7          	jalr	-346(ra) # 80006212 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	4398                	lw	a4,0(a5)
    8000537a:	2701                	sext.w	a4,a4
    8000537c:	747277b7          	lui	a5,0x74727
    80005380:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005384:	0ef71163          	bne	a4,a5,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005388:	100017b7          	lui	a5,0x10001
    8000538c:	43dc                	lw	a5,4(a5)
    8000538e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005390:	4705                	li	a4,1
    80005392:	0ce79a63          	bne	a5,a4,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005396:	100017b7          	lui	a5,0x10001
    8000539a:	479c                	lw	a5,8(a5)
    8000539c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000539e:	4709                	li	a4,2
    800053a0:	0ce79363          	bne	a5,a4,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	47d8                	lw	a4,12(a5)
    800053aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ac:	554d47b7          	lui	a5,0x554d4
    800053b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053b4:	0af71963          	bne	a4,a5,80005466 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	4705                	li	a4,1
    800053be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c0:	470d                	li	a4,3
    800053c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053c6:	c7ffe737          	lui	a4,0xc7ffe
    800053ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    800053ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053d0:	2701                	sext.w	a4,a4
    800053d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d4:	472d                	li	a4,11
    800053d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d8:	473d                	li	a4,15
    800053da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053dc:	6705                	lui	a4,0x1
    800053de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053e4:	5bdc                	lw	a5,52(a5)
    800053e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053e8:	c7d9                	beqz	a5,80005476 <virtio_disk_init+0x124>
  if(max < NUM)
    800053ea:	471d                	li	a4,7
    800053ec:	08f77d63          	bgeu	a4,a5,80005486 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053f0:	100014b7          	lui	s1,0x10001
    800053f4:	47a1                	li	a5,8
    800053f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053f8:	6609                	lui	a2,0x2
    800053fa:	4581                	li	a1,0
    800053fc:	00236517          	auipc	a0,0x236
    80005400:	c0450513          	addi	a0,a0,-1020 # 8023b000 <disk>
    80005404:	ffffb097          	auipc	ra,0xffffb
    80005408:	ee8080e7          	jalr	-280(ra) # 800002ec <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000540c:	00236717          	auipc	a4,0x236
    80005410:	bf470713          	addi	a4,a4,-1036 # 8023b000 <disk>
    80005414:	00c75793          	srli	a5,a4,0xc
    80005418:	2781                	sext.w	a5,a5
    8000541a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000541c:	00238797          	auipc	a5,0x238
    80005420:	be478793          	addi	a5,a5,-1052 # 8023d000 <disk+0x2000>
    80005424:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005426:	00236717          	auipc	a4,0x236
    8000542a:	c5a70713          	addi	a4,a4,-934 # 8023b080 <disk+0x80>
    8000542e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005430:	00237717          	auipc	a4,0x237
    80005434:	bd070713          	addi	a4,a4,-1072 # 8023c000 <disk+0x1000>
    80005438:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000543a:	4705                	li	a4,1
    8000543c:	00e78c23          	sb	a4,24(a5)
    80005440:	00e78ca3          	sb	a4,25(a5)
    80005444:	00e78d23          	sb	a4,26(a5)
    80005448:	00e78da3          	sb	a4,27(a5)
    8000544c:	00e78e23          	sb	a4,28(a5)
    80005450:	00e78ea3          	sb	a4,29(a5)
    80005454:	00e78f23          	sb	a4,30(a5)
    80005458:	00e78fa3          	sb	a4,31(a5)
}
    8000545c:	60e2                	ld	ra,24(sp)
    8000545e:	6442                	ld	s0,16(sp)
    80005460:	64a2                	ld	s1,8(sp)
    80005462:	6105                	addi	sp,sp,32
    80005464:	8082                	ret
    panic("could not find virtio disk");
    80005466:	00003517          	auipc	a0,0x3
    8000546a:	2b250513          	addi	a0,a0,690 # 80008718 <syscalls+0x350>
    8000546e:	00001097          	auipc	ra,0x1
    80005472:	8ea080e7          	jalr	-1814(ra) # 80005d58 <panic>
    panic("virtio disk has no queue 0");
    80005476:	00003517          	auipc	a0,0x3
    8000547a:	2c250513          	addi	a0,a0,706 # 80008738 <syscalls+0x370>
    8000547e:	00001097          	auipc	ra,0x1
    80005482:	8da080e7          	jalr	-1830(ra) # 80005d58 <panic>
    panic("virtio disk max queue too short");
    80005486:	00003517          	auipc	a0,0x3
    8000548a:	2d250513          	addi	a0,a0,722 # 80008758 <syscalls+0x390>
    8000548e:	00001097          	auipc	ra,0x1
    80005492:	8ca080e7          	jalr	-1846(ra) # 80005d58 <panic>

0000000080005496 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005496:	7159                	addi	sp,sp,-112
    80005498:	f486                	sd	ra,104(sp)
    8000549a:	f0a2                	sd	s0,96(sp)
    8000549c:	eca6                	sd	s1,88(sp)
    8000549e:	e8ca                	sd	s2,80(sp)
    800054a0:	e4ce                	sd	s3,72(sp)
    800054a2:	e0d2                	sd	s4,64(sp)
    800054a4:	fc56                	sd	s5,56(sp)
    800054a6:	f85a                	sd	s6,48(sp)
    800054a8:	f45e                	sd	s7,40(sp)
    800054aa:	f062                	sd	s8,32(sp)
    800054ac:	ec66                	sd	s9,24(sp)
    800054ae:	e86a                	sd	s10,16(sp)
    800054b0:	1880                	addi	s0,sp,112
    800054b2:	892a                	mv	s2,a0
    800054b4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054b6:	00c52c83          	lw	s9,12(a0)
    800054ba:	001c9c9b          	slliw	s9,s9,0x1
    800054be:	1c82                	slli	s9,s9,0x20
    800054c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054c4:	00238517          	auipc	a0,0x238
    800054c8:	c6450513          	addi	a0,a0,-924 # 8023d128 <disk+0x2128>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	dd6080e7          	jalr	-554(ra) # 800062a2 <acquire>
  for(int i = 0; i < 3; i++){
    800054d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054d6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054d8:	00236b97          	auipc	s7,0x236
    800054dc:	b28b8b93          	addi	s7,s7,-1240 # 8023b000 <disk>
    800054e0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054e4:	8a4e                	mv	s4,s3
    800054e6:	a051                	j	8000556a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054e8:	00fb86b3          	add	a3,s7,a5
    800054ec:	96da                	add	a3,a3,s6
    800054ee:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054f2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054f4:	0207c563          	bltz	a5,8000551e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054f8:	2485                	addiw	s1,s1,1
    800054fa:	0711                	addi	a4,a4,4
    800054fc:	25548063          	beq	s1,s5,8000573c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005500:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005502:	00238697          	auipc	a3,0x238
    80005506:	b1668693          	addi	a3,a3,-1258 # 8023d018 <disk+0x2018>
    8000550a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000550c:	0006c583          	lbu	a1,0(a3)
    80005510:	fde1                	bnez	a1,800054e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005512:	2785                	addiw	a5,a5,1
    80005514:	0685                	addi	a3,a3,1
    80005516:	ff879be3          	bne	a5,s8,8000550c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000551a:	57fd                	li	a5,-1
    8000551c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000551e:	02905a63          	blez	s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005522:	f9042503          	lw	a0,-112(s0)
    80005526:	00000097          	auipc	ra,0x0
    8000552a:	d90080e7          	jalr	-624(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000552e:	4785                	li	a5,1
    80005530:	0297d163          	bge	a5,s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005534:	f9442503          	lw	a0,-108(s0)
    80005538:	00000097          	auipc	ra,0x0
    8000553c:	d7e080e7          	jalr	-642(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005540:	4789                	li	a5,2
    80005542:	0097d863          	bge	a5,s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005546:	f9842503          	lw	a0,-104(s0)
    8000554a:	00000097          	auipc	ra,0x0
    8000554e:	d6c080e7          	jalr	-660(ra) # 800052b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005552:	00238597          	auipc	a1,0x238
    80005556:	bd658593          	addi	a1,a1,-1066 # 8023d128 <disk+0x2128>
    8000555a:	00238517          	auipc	a0,0x238
    8000555e:	abe50513          	addi	a0,a0,-1346 # 8023d018 <disk+0x2018>
    80005562:	ffffc097          	auipc	ra,0xffffc
    80005566:	11c080e7          	jalr	284(ra) # 8000167e <sleep>
  for(int i = 0; i < 3; i++){
    8000556a:	f9040713          	addi	a4,s0,-112
    8000556e:	84ce                	mv	s1,s3
    80005570:	bf41                	j	80005500 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005572:	20058713          	addi	a4,a1,512
    80005576:	00471693          	slli	a3,a4,0x4
    8000557a:	00236717          	auipc	a4,0x236
    8000557e:	a8670713          	addi	a4,a4,-1402 # 8023b000 <disk>
    80005582:	9736                	add	a4,a4,a3
    80005584:	4685                	li	a3,1
    80005586:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000558a:	20058713          	addi	a4,a1,512
    8000558e:	00471693          	slli	a3,a4,0x4
    80005592:	00236717          	auipc	a4,0x236
    80005596:	a6e70713          	addi	a4,a4,-1426 # 8023b000 <disk>
    8000559a:	9736                	add	a4,a4,a3
    8000559c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055a0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055a4:	7679                	lui	a2,0xffffe
    800055a6:	963e                	add	a2,a2,a5
    800055a8:	00238697          	auipc	a3,0x238
    800055ac:	a5868693          	addi	a3,a3,-1448 # 8023d000 <disk+0x2000>
    800055b0:	6298                	ld	a4,0(a3)
    800055b2:	9732                	add	a4,a4,a2
    800055b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055b6:	6298                	ld	a4,0(a3)
    800055b8:	9732                	add	a4,a4,a2
    800055ba:	4541                	li	a0,16
    800055bc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055be:	6298                	ld	a4,0(a3)
    800055c0:	9732                	add	a4,a4,a2
    800055c2:	4505                	li	a0,1
    800055c4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055c8:	f9442703          	lw	a4,-108(s0)
    800055cc:	6288                	ld	a0,0(a3)
    800055ce:	962a                	add	a2,a2,a0
    800055d0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055d4:	0712                	slli	a4,a4,0x4
    800055d6:	6290                	ld	a2,0(a3)
    800055d8:	963a                	add	a2,a2,a4
    800055da:	05890513          	addi	a0,s2,88
    800055de:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055e0:	6294                	ld	a3,0(a3)
    800055e2:	96ba                	add	a3,a3,a4
    800055e4:	40000613          	li	a2,1024
    800055e8:	c690                	sw	a2,8(a3)
  if(write)
    800055ea:	140d0063          	beqz	s10,8000572a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ee:	00238697          	auipc	a3,0x238
    800055f2:	a126b683          	ld	a3,-1518(a3) # 8023d000 <disk+0x2000>
    800055f6:	96ba                	add	a3,a3,a4
    800055f8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055fc:	00236817          	auipc	a6,0x236
    80005600:	a0480813          	addi	a6,a6,-1532 # 8023b000 <disk>
    80005604:	00238517          	auipc	a0,0x238
    80005608:	9fc50513          	addi	a0,a0,-1540 # 8023d000 <disk+0x2000>
    8000560c:	6114                	ld	a3,0(a0)
    8000560e:	96ba                	add	a3,a3,a4
    80005610:	00c6d603          	lhu	a2,12(a3)
    80005614:	00166613          	ori	a2,a2,1
    80005618:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000561c:	f9842683          	lw	a3,-104(s0)
    80005620:	6110                	ld	a2,0(a0)
    80005622:	9732                	add	a4,a4,a2
    80005624:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005628:	20058613          	addi	a2,a1,512
    8000562c:	0612                	slli	a2,a2,0x4
    8000562e:	9642                	add	a2,a2,a6
    80005630:	577d                	li	a4,-1
    80005632:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005636:	00469713          	slli	a4,a3,0x4
    8000563a:	6114                	ld	a3,0(a0)
    8000563c:	96ba                	add	a3,a3,a4
    8000563e:	03078793          	addi	a5,a5,48
    80005642:	97c2                	add	a5,a5,a6
    80005644:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005646:	611c                	ld	a5,0(a0)
    80005648:	97ba                	add	a5,a5,a4
    8000564a:	4685                	li	a3,1
    8000564c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000564e:	611c                	ld	a5,0(a0)
    80005650:	97ba                	add	a5,a5,a4
    80005652:	4809                	li	a6,2
    80005654:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005658:	611c                	ld	a5,0(a0)
    8000565a:	973e                	add	a4,a4,a5
    8000565c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005660:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005664:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005668:	6518                	ld	a4,8(a0)
    8000566a:	00275783          	lhu	a5,2(a4)
    8000566e:	8b9d                	andi	a5,a5,7
    80005670:	0786                	slli	a5,a5,0x1
    80005672:	97ba                	add	a5,a5,a4
    80005674:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005678:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000567c:	6518                	ld	a4,8(a0)
    8000567e:	00275783          	lhu	a5,2(a4)
    80005682:	2785                	addiw	a5,a5,1
    80005684:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005688:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000568c:	100017b7          	lui	a5,0x10001
    80005690:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005694:	00492703          	lw	a4,4(s2)
    80005698:	4785                	li	a5,1
    8000569a:	02f71163          	bne	a4,a5,800056bc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000569e:	00238997          	auipc	s3,0x238
    800056a2:	a8a98993          	addi	s3,s3,-1398 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    800056a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056a8:	85ce                	mv	a1,s3
    800056aa:	854a                	mv	a0,s2
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	fd2080e7          	jalr	-46(ra) # 8000167e <sleep>
  while(b->disk == 1) {
    800056b4:	00492783          	lw	a5,4(s2)
    800056b8:	fe9788e3          	beq	a5,s1,800056a8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056bc:	f9042903          	lw	s2,-112(s0)
    800056c0:	20090793          	addi	a5,s2,512
    800056c4:	00479713          	slli	a4,a5,0x4
    800056c8:	00236797          	auipc	a5,0x236
    800056cc:	93878793          	addi	a5,a5,-1736 # 8023b000 <disk>
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056d6:	00238997          	auipc	s3,0x238
    800056da:	92a98993          	addi	s3,s3,-1750 # 8023d000 <disk+0x2000>
    800056de:	00491713          	slli	a4,s2,0x4
    800056e2:	0009b783          	ld	a5,0(s3)
    800056e6:	97ba                	add	a5,a5,a4
    800056e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ec:	854a                	mv	a0,s2
    800056ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056f2:	00000097          	auipc	ra,0x0
    800056f6:	bc4080e7          	jalr	-1084(ra) # 800052b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056fa:	8885                	andi	s1,s1,1
    800056fc:	f0ed                	bnez	s1,800056de <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056fe:	00238517          	auipc	a0,0x238
    80005702:	a2a50513          	addi	a0,a0,-1494 # 8023d128 <disk+0x2128>
    80005706:	00001097          	auipc	ra,0x1
    8000570a:	c50080e7          	jalr	-944(ra) # 80006356 <release>
}
    8000570e:	70a6                	ld	ra,104(sp)
    80005710:	7406                	ld	s0,96(sp)
    80005712:	64e6                	ld	s1,88(sp)
    80005714:	6946                	ld	s2,80(sp)
    80005716:	69a6                	ld	s3,72(sp)
    80005718:	6a06                	ld	s4,64(sp)
    8000571a:	7ae2                	ld	s5,56(sp)
    8000571c:	7b42                	ld	s6,48(sp)
    8000571e:	7ba2                	ld	s7,40(sp)
    80005720:	7c02                	ld	s8,32(sp)
    80005722:	6ce2                	ld	s9,24(sp)
    80005724:	6d42                	ld	s10,16(sp)
    80005726:	6165                	addi	sp,sp,112
    80005728:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000572a:	00238697          	auipc	a3,0x238
    8000572e:	8d66b683          	ld	a3,-1834(a3) # 8023d000 <disk+0x2000>
    80005732:	96ba                	add	a3,a3,a4
    80005734:	4609                	li	a2,2
    80005736:	00c69623          	sh	a2,12(a3)
    8000573a:	b5c9                	j	800055fc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000573c:	f9042583          	lw	a1,-112(s0)
    80005740:	20058793          	addi	a5,a1,512
    80005744:	0792                	slli	a5,a5,0x4
    80005746:	00236517          	auipc	a0,0x236
    8000574a:	96250513          	addi	a0,a0,-1694 # 8023b0a8 <disk+0xa8>
    8000574e:	953e                	add	a0,a0,a5
  if(write)
    80005750:	e20d11e3          	bnez	s10,80005572 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005754:	20058713          	addi	a4,a1,512
    80005758:	00471693          	slli	a3,a4,0x4
    8000575c:	00236717          	auipc	a4,0x236
    80005760:	8a470713          	addi	a4,a4,-1884 # 8023b000 <disk>
    80005764:	9736                	add	a4,a4,a3
    80005766:	0a072423          	sw	zero,168(a4)
    8000576a:	b505                	j	8000558a <virtio_disk_rw+0xf4>

000000008000576c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000576c:	1101                	addi	sp,sp,-32
    8000576e:	ec06                	sd	ra,24(sp)
    80005770:	e822                	sd	s0,16(sp)
    80005772:	e426                	sd	s1,8(sp)
    80005774:	e04a                	sd	s2,0(sp)
    80005776:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005778:	00238517          	auipc	a0,0x238
    8000577c:	9b050513          	addi	a0,a0,-1616 # 8023d128 <disk+0x2128>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	b22080e7          	jalr	-1246(ra) # 800062a2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005788:	10001737          	lui	a4,0x10001
    8000578c:	533c                	lw	a5,96(a4)
    8000578e:	8b8d                	andi	a5,a5,3
    80005790:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005792:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005796:	00238797          	auipc	a5,0x238
    8000579a:	86a78793          	addi	a5,a5,-1942 # 8023d000 <disk+0x2000>
    8000579e:	6b94                	ld	a3,16(a5)
    800057a0:	0207d703          	lhu	a4,32(a5)
    800057a4:	0026d783          	lhu	a5,2(a3)
    800057a8:	06f70163          	beq	a4,a5,8000580a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ac:	00236917          	auipc	s2,0x236
    800057b0:	85490913          	addi	s2,s2,-1964 # 8023b000 <disk>
    800057b4:	00238497          	auipc	s1,0x238
    800057b8:	84c48493          	addi	s1,s1,-1972 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    800057bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c0:	6898                	ld	a4,16(s1)
    800057c2:	0204d783          	lhu	a5,32(s1)
    800057c6:	8b9d                	andi	a5,a5,7
    800057c8:	078e                	slli	a5,a5,0x3
    800057ca:	97ba                	add	a5,a5,a4
    800057cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ce:	20078713          	addi	a4,a5,512
    800057d2:	0712                	slli	a4,a4,0x4
    800057d4:	974a                	add	a4,a4,s2
    800057d6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057da:	e731                	bnez	a4,80005826 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057dc:	20078793          	addi	a5,a5,512
    800057e0:	0792                	slli	a5,a5,0x4
    800057e2:	97ca                	add	a5,a5,s2
    800057e4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ea:	ffffc097          	auipc	ra,0xffffc
    800057ee:	020080e7          	jalr	32(ra) # 8000180a <wakeup>

    disk.used_idx += 1;
    800057f2:	0204d783          	lhu	a5,32(s1)
    800057f6:	2785                	addiw	a5,a5,1
    800057f8:	17c2                	slli	a5,a5,0x30
    800057fa:	93c1                	srli	a5,a5,0x30
    800057fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005800:	6898                	ld	a4,16(s1)
    80005802:	00275703          	lhu	a4,2(a4)
    80005806:	faf71be3          	bne	a4,a5,800057bc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000580a:	00238517          	auipc	a0,0x238
    8000580e:	91e50513          	addi	a0,a0,-1762 # 8023d128 <disk+0x2128>
    80005812:	00001097          	auipc	ra,0x1
    80005816:	b44080e7          	jalr	-1212(ra) # 80006356 <release>
}
    8000581a:	60e2                	ld	ra,24(sp)
    8000581c:	6442                	ld	s0,16(sp)
    8000581e:	64a2                	ld	s1,8(sp)
    80005820:	6902                	ld	s2,0(sp)
    80005822:	6105                	addi	sp,sp,32
    80005824:	8082                	ret
      panic("virtio_disk_intr status");
    80005826:	00003517          	auipc	a0,0x3
    8000582a:	f5250513          	addi	a0,a0,-174 # 80008778 <syscalls+0x3b0>
    8000582e:	00000097          	auipc	ra,0x0
    80005832:	52a080e7          	jalr	1322(ra) # 80005d58 <panic>

0000000080005836 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005836:	1141                	addi	sp,sp,-16
    80005838:	e422                	sd	s0,8(sp)
    8000583a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000583c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005840:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005844:	0037979b          	slliw	a5,a5,0x3
    80005848:	02004737          	lui	a4,0x2004
    8000584c:	97ba                	add	a5,a5,a4
    8000584e:	0200c737          	lui	a4,0x200c
    80005852:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005856:	000f4637          	lui	a2,0xf4
    8000585a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000585e:	95b2                	add	a1,a1,a2
    80005860:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005862:	00269713          	slli	a4,a3,0x2
    80005866:	9736                	add	a4,a4,a3
    80005868:	00371693          	slli	a3,a4,0x3
    8000586c:	00238717          	auipc	a4,0x238
    80005870:	79470713          	addi	a4,a4,1940 # 8023e000 <timer_scratch>
    80005874:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005876:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005878:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000587a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000587e:	00000797          	auipc	a5,0x0
    80005882:	97278793          	addi	a5,a5,-1678 # 800051f0 <timervec>
    80005886:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000588a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000588e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005892:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005896:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000589a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000589e:	30479073          	csrw	mie,a5
}
    800058a2:	6422                	ld	s0,8(sp)
    800058a4:	0141                	addi	sp,sp,16
    800058a6:	8082                	ret

00000000800058a8 <start>:
{
    800058a8:	1141                	addi	sp,sp,-16
    800058aa:	e406                	sd	ra,8(sp)
    800058ac:	e022                	sd	s0,0(sp)
    800058ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058b4:	7779                	lui	a4,0xffffe
    800058b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    800058ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058bc:	6705                	lui	a4,0x1
    800058be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058c2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058c4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058c8:	ffffb797          	auipc	a5,0xffffb
    800058cc:	bd278793          	addi	a5,a5,-1070 # 8000049a <main>
    800058d0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058d4:	4781                	li	a5,0
    800058d6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058da:	67c1                	lui	a5,0x10
    800058dc:	17fd                	addi	a5,a5,-1
    800058de:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058e2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ea:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ee:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058f2:	57fd                	li	a5,-1
    800058f4:	83a9                	srli	a5,a5,0xa
    800058f6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058fa:	47bd                	li	a5,15
    800058fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005900:	00000097          	auipc	ra,0x0
    80005904:	f36080e7          	jalr	-202(ra) # 80005836 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005908:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000590c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000590e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005910:	30200073          	mret
}
    80005914:	60a2                	ld	ra,8(sp)
    80005916:	6402                	ld	s0,0(sp)
    80005918:	0141                	addi	sp,sp,16
    8000591a:	8082                	ret

000000008000591c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000591c:	715d                	addi	sp,sp,-80
    8000591e:	e486                	sd	ra,72(sp)
    80005920:	e0a2                	sd	s0,64(sp)
    80005922:	fc26                	sd	s1,56(sp)
    80005924:	f84a                	sd	s2,48(sp)
    80005926:	f44e                	sd	s3,40(sp)
    80005928:	f052                	sd	s4,32(sp)
    8000592a:	ec56                	sd	s5,24(sp)
    8000592c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000592e:	04c05663          	blez	a2,8000597a <consolewrite+0x5e>
    80005932:	8a2a                	mv	s4,a0
    80005934:	84ae                	mv	s1,a1
    80005936:	89b2                	mv	s3,a2
    80005938:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000593a:	5afd                	li	s5,-1
    8000593c:	4685                	li	a3,1
    8000593e:	8626                	mv	a2,s1
    80005940:	85d2                	mv	a1,s4
    80005942:	fbf40513          	addi	a0,s0,-65
    80005946:	ffffc097          	auipc	ra,0xffffc
    8000594a:	132080e7          	jalr	306(ra) # 80001a78 <either_copyin>
    8000594e:	01550c63          	beq	a0,s5,80005966 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005952:	fbf44503          	lbu	a0,-65(s0)
    80005956:	00000097          	auipc	ra,0x0
    8000595a:	78e080e7          	jalr	1934(ra) # 800060e4 <uartputc>
  for(i = 0; i < n; i++){
    8000595e:	2905                	addiw	s2,s2,1
    80005960:	0485                	addi	s1,s1,1
    80005962:	fd299de3          	bne	s3,s2,8000593c <consolewrite+0x20>
  }

  return i;
}
    80005966:	854a                	mv	a0,s2
    80005968:	60a6                	ld	ra,72(sp)
    8000596a:	6406                	ld	s0,64(sp)
    8000596c:	74e2                	ld	s1,56(sp)
    8000596e:	7942                	ld	s2,48(sp)
    80005970:	79a2                	ld	s3,40(sp)
    80005972:	7a02                	ld	s4,32(sp)
    80005974:	6ae2                	ld	s5,24(sp)
    80005976:	6161                	addi	sp,sp,80
    80005978:	8082                	ret
  for(i = 0; i < n; i++){
    8000597a:	4901                	li	s2,0
    8000597c:	b7ed                	j	80005966 <consolewrite+0x4a>

000000008000597e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000597e:	7119                	addi	sp,sp,-128
    80005980:	fc86                	sd	ra,120(sp)
    80005982:	f8a2                	sd	s0,112(sp)
    80005984:	f4a6                	sd	s1,104(sp)
    80005986:	f0ca                	sd	s2,96(sp)
    80005988:	ecce                	sd	s3,88(sp)
    8000598a:	e8d2                	sd	s4,80(sp)
    8000598c:	e4d6                	sd	s5,72(sp)
    8000598e:	e0da                	sd	s6,64(sp)
    80005990:	fc5e                	sd	s7,56(sp)
    80005992:	f862                	sd	s8,48(sp)
    80005994:	f466                	sd	s9,40(sp)
    80005996:	f06a                	sd	s10,32(sp)
    80005998:	ec6e                	sd	s11,24(sp)
    8000599a:	0100                	addi	s0,sp,128
    8000599c:	8b2a                	mv	s6,a0
    8000599e:	8aae                	mv	s5,a1
    800059a0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059a2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059a6:	00240517          	auipc	a0,0x240
    800059aa:	79a50513          	addi	a0,a0,1946 # 80246140 <cons>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	8f4080e7          	jalr	-1804(ra) # 800062a2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059b6:	00240497          	auipc	s1,0x240
    800059ba:	78a48493          	addi	s1,s1,1930 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059be:	89a6                	mv	s3,s1
    800059c0:	00241917          	auipc	s2,0x241
    800059c4:	81890913          	addi	s2,s2,-2024 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059c8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ca:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059cc:	4da9                	li	s11,10
  while(n > 0){
    800059ce:	07405863          	blez	s4,80005a3e <consoleread+0xc0>
    while(cons.r == cons.w){
    800059d2:	0984a783          	lw	a5,152(s1)
    800059d6:	09c4a703          	lw	a4,156(s1)
    800059da:	02f71463          	bne	a4,a5,80005a02 <consoleread+0x84>
      if(myproc()->killed){
    800059de:	ffffb097          	auipc	ra,0xffffb
    800059e2:	5e4080e7          	jalr	1508(ra) # 80000fc2 <myproc>
    800059e6:	551c                	lw	a5,40(a0)
    800059e8:	e7b5                	bnez	a5,80005a54 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059ea:	85ce                	mv	a1,s3
    800059ec:	854a                	mv	a0,s2
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	c90080e7          	jalr	-880(ra) # 8000167e <sleep>
    while(cons.r == cons.w){
    800059f6:	0984a783          	lw	a5,152(s1)
    800059fa:	09c4a703          	lw	a4,156(s1)
    800059fe:	fef700e3          	beq	a4,a5,800059de <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a02:	0017871b          	addiw	a4,a5,1
    80005a06:	08e4ac23          	sw	a4,152(s1)
    80005a0a:	07f7f713          	andi	a4,a5,127
    80005a0e:	9726                	add	a4,a4,s1
    80005a10:	01874703          	lbu	a4,24(a4)
    80005a14:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a18:	079c0663          	beq	s8,s9,80005a84 <consoleread+0x106>
    cbuf = c;
    80005a1c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a20:	4685                	li	a3,1
    80005a22:	f8f40613          	addi	a2,s0,-113
    80005a26:	85d6                	mv	a1,s5
    80005a28:	855a                	mv	a0,s6
    80005a2a:	ffffc097          	auipc	ra,0xffffc
    80005a2e:	ff8080e7          	jalr	-8(ra) # 80001a22 <either_copyout>
    80005a32:	01a50663          	beq	a0,s10,80005a3e <consoleread+0xc0>
    dst++;
    80005a36:	0a85                	addi	s5,s5,1
    --n;
    80005a38:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a3a:	f9bc1ae3          	bne	s8,s11,800059ce <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a3e:	00240517          	auipc	a0,0x240
    80005a42:	70250513          	addi	a0,a0,1794 # 80246140 <cons>
    80005a46:	00001097          	auipc	ra,0x1
    80005a4a:	910080e7          	jalr	-1776(ra) # 80006356 <release>

  return target - n;
    80005a4e:	414b853b          	subw	a0,s7,s4
    80005a52:	a811                	j	80005a66 <consoleread+0xe8>
        release(&cons.lock);
    80005a54:	00240517          	auipc	a0,0x240
    80005a58:	6ec50513          	addi	a0,a0,1772 # 80246140 <cons>
    80005a5c:	00001097          	auipc	ra,0x1
    80005a60:	8fa080e7          	jalr	-1798(ra) # 80006356 <release>
        return -1;
    80005a64:	557d                	li	a0,-1
}
    80005a66:	70e6                	ld	ra,120(sp)
    80005a68:	7446                	ld	s0,112(sp)
    80005a6a:	74a6                	ld	s1,104(sp)
    80005a6c:	7906                	ld	s2,96(sp)
    80005a6e:	69e6                	ld	s3,88(sp)
    80005a70:	6a46                	ld	s4,80(sp)
    80005a72:	6aa6                	ld	s5,72(sp)
    80005a74:	6b06                	ld	s6,64(sp)
    80005a76:	7be2                	ld	s7,56(sp)
    80005a78:	7c42                	ld	s8,48(sp)
    80005a7a:	7ca2                	ld	s9,40(sp)
    80005a7c:	7d02                	ld	s10,32(sp)
    80005a7e:	6de2                	ld	s11,24(sp)
    80005a80:	6109                	addi	sp,sp,128
    80005a82:	8082                	ret
      if(n < target){
    80005a84:	000a071b          	sext.w	a4,s4
    80005a88:	fb777be3          	bgeu	a4,s7,80005a3e <consoleread+0xc0>
        cons.r--;
    80005a8c:	00240717          	auipc	a4,0x240
    80005a90:	74f72623          	sw	a5,1868(a4) # 802461d8 <cons+0x98>
    80005a94:	b76d                	j	80005a3e <consoleread+0xc0>

0000000080005a96 <consputc>:
{
    80005a96:	1141                	addi	sp,sp,-16
    80005a98:	e406                	sd	ra,8(sp)
    80005a9a:	e022                	sd	s0,0(sp)
    80005a9c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a9e:	10000793          	li	a5,256
    80005aa2:	00f50a63          	beq	a0,a5,80005ab6 <consputc+0x20>
    uartputc_sync(c);
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	564080e7          	jalr	1380(ra) # 8000600a <uartputc_sync>
}
    80005aae:	60a2                	ld	ra,8(sp)
    80005ab0:	6402                	ld	s0,0(sp)
    80005ab2:	0141                	addi	sp,sp,16
    80005ab4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ab6:	4521                	li	a0,8
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	552080e7          	jalr	1362(ra) # 8000600a <uartputc_sync>
    80005ac0:	02000513          	li	a0,32
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	546080e7          	jalr	1350(ra) # 8000600a <uartputc_sync>
    80005acc:	4521                	li	a0,8
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	53c080e7          	jalr	1340(ra) # 8000600a <uartputc_sync>
    80005ad6:	bfe1                	j	80005aae <consputc+0x18>

0000000080005ad8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ad8:	1101                	addi	sp,sp,-32
    80005ada:	ec06                	sd	ra,24(sp)
    80005adc:	e822                	sd	s0,16(sp)
    80005ade:	e426                	sd	s1,8(sp)
    80005ae0:	e04a                	sd	s2,0(sp)
    80005ae2:	1000                	addi	s0,sp,32
    80005ae4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ae6:	00240517          	auipc	a0,0x240
    80005aea:	65a50513          	addi	a0,a0,1626 # 80246140 <cons>
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	7b4080e7          	jalr	1972(ra) # 800062a2 <acquire>

  switch(c){
    80005af6:	47d5                	li	a5,21
    80005af8:	0af48663          	beq	s1,a5,80005ba4 <consoleintr+0xcc>
    80005afc:	0297ca63          	blt	a5,s1,80005b30 <consoleintr+0x58>
    80005b00:	47a1                	li	a5,8
    80005b02:	0ef48763          	beq	s1,a5,80005bf0 <consoleintr+0x118>
    80005b06:	47c1                	li	a5,16
    80005b08:	10f49a63          	bne	s1,a5,80005c1c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b0c:	ffffc097          	auipc	ra,0xffffc
    80005b10:	fc2080e7          	jalr	-62(ra) # 80001ace <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b14:	00240517          	auipc	a0,0x240
    80005b18:	62c50513          	addi	a0,a0,1580 # 80246140 <cons>
    80005b1c:	00001097          	auipc	ra,0x1
    80005b20:	83a080e7          	jalr	-1990(ra) # 80006356 <release>
}
    80005b24:	60e2                	ld	ra,24(sp)
    80005b26:	6442                	ld	s0,16(sp)
    80005b28:	64a2                	ld	s1,8(sp)
    80005b2a:	6902                	ld	s2,0(sp)
    80005b2c:	6105                	addi	sp,sp,32
    80005b2e:	8082                	ret
  switch(c){
    80005b30:	07f00793          	li	a5,127
    80005b34:	0af48e63          	beq	s1,a5,80005bf0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b38:	00240717          	auipc	a4,0x240
    80005b3c:	60870713          	addi	a4,a4,1544 # 80246140 <cons>
    80005b40:	0a072783          	lw	a5,160(a4)
    80005b44:	09872703          	lw	a4,152(a4)
    80005b48:	9f99                	subw	a5,a5,a4
    80005b4a:	07f00713          	li	a4,127
    80005b4e:	fcf763e3          	bltu	a4,a5,80005b14 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b52:	47b5                	li	a5,13
    80005b54:	0cf48763          	beq	s1,a5,80005c22 <consoleintr+0x14a>
      consputc(c);
    80005b58:	8526                	mv	a0,s1
    80005b5a:	00000097          	auipc	ra,0x0
    80005b5e:	f3c080e7          	jalr	-196(ra) # 80005a96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b62:	00240797          	auipc	a5,0x240
    80005b66:	5de78793          	addi	a5,a5,1502 # 80246140 <cons>
    80005b6a:	0a07a703          	lw	a4,160(a5)
    80005b6e:	0017069b          	addiw	a3,a4,1
    80005b72:	0006861b          	sext.w	a2,a3
    80005b76:	0ad7a023          	sw	a3,160(a5)
    80005b7a:	07f77713          	andi	a4,a4,127
    80005b7e:	97ba                	add	a5,a5,a4
    80005b80:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b84:	47a9                	li	a5,10
    80005b86:	0cf48563          	beq	s1,a5,80005c50 <consoleintr+0x178>
    80005b8a:	4791                	li	a5,4
    80005b8c:	0cf48263          	beq	s1,a5,80005c50 <consoleintr+0x178>
    80005b90:	00240797          	auipc	a5,0x240
    80005b94:	6487a783          	lw	a5,1608(a5) # 802461d8 <cons+0x98>
    80005b98:	0807879b          	addiw	a5,a5,128
    80005b9c:	f6f61ce3          	bne	a2,a5,80005b14 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ba0:	863e                	mv	a2,a5
    80005ba2:	a07d                	j	80005c50 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ba4:	00240717          	auipc	a4,0x240
    80005ba8:	59c70713          	addi	a4,a4,1436 # 80246140 <cons>
    80005bac:	0a072783          	lw	a5,160(a4)
    80005bb0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bb4:	00240497          	auipc	s1,0x240
    80005bb8:	58c48493          	addi	s1,s1,1420 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005bbc:	4929                	li	s2,10
    80005bbe:	f4f70be3          	beq	a4,a5,80005b14 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bc2:	37fd                	addiw	a5,a5,-1
    80005bc4:	07f7f713          	andi	a4,a5,127
    80005bc8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bca:	01874703          	lbu	a4,24(a4)
    80005bce:	f52703e3          	beq	a4,s2,80005b14 <consoleintr+0x3c>
      cons.e--;
    80005bd2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bd6:	10000513          	li	a0,256
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	ebc080e7          	jalr	-324(ra) # 80005a96 <consputc>
    while(cons.e != cons.w &&
    80005be2:	0a04a783          	lw	a5,160(s1)
    80005be6:	09c4a703          	lw	a4,156(s1)
    80005bea:	fcf71ce3          	bne	a4,a5,80005bc2 <consoleintr+0xea>
    80005bee:	b71d                	j	80005b14 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bf0:	00240717          	auipc	a4,0x240
    80005bf4:	55070713          	addi	a4,a4,1360 # 80246140 <cons>
    80005bf8:	0a072783          	lw	a5,160(a4)
    80005bfc:	09c72703          	lw	a4,156(a4)
    80005c00:	f0f70ae3          	beq	a4,a5,80005b14 <consoleintr+0x3c>
      cons.e--;
    80005c04:	37fd                	addiw	a5,a5,-1
    80005c06:	00240717          	auipc	a4,0x240
    80005c0a:	5cf72d23          	sw	a5,1498(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c0e:	10000513          	li	a0,256
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	e84080e7          	jalr	-380(ra) # 80005a96 <consputc>
    80005c1a:	bded                	j	80005b14 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c1c:	ee048ce3          	beqz	s1,80005b14 <consoleintr+0x3c>
    80005c20:	bf21                	j	80005b38 <consoleintr+0x60>
      consputc(c);
    80005c22:	4529                	li	a0,10
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	e72080e7          	jalr	-398(ra) # 80005a96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c2c:	00240797          	auipc	a5,0x240
    80005c30:	51478793          	addi	a5,a5,1300 # 80246140 <cons>
    80005c34:	0a07a703          	lw	a4,160(a5)
    80005c38:	0017069b          	addiw	a3,a4,1
    80005c3c:	0006861b          	sext.w	a2,a3
    80005c40:	0ad7a023          	sw	a3,160(a5)
    80005c44:	07f77713          	andi	a4,a4,127
    80005c48:	97ba                	add	a5,a5,a4
    80005c4a:	4729                	li	a4,10
    80005c4c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c50:	00240797          	auipc	a5,0x240
    80005c54:	58c7a623          	sw	a2,1420(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c58:	00240517          	auipc	a0,0x240
    80005c5c:	58050513          	addi	a0,a0,1408 # 802461d8 <cons+0x98>
    80005c60:	ffffc097          	auipc	ra,0xffffc
    80005c64:	baa080e7          	jalr	-1110(ra) # 8000180a <wakeup>
    80005c68:	b575                	j	80005b14 <consoleintr+0x3c>

0000000080005c6a <consoleinit>:

void
consoleinit(void)
{
    80005c6a:	1141                	addi	sp,sp,-16
    80005c6c:	e406                	sd	ra,8(sp)
    80005c6e:	e022                	sd	s0,0(sp)
    80005c70:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c72:	00003597          	auipc	a1,0x3
    80005c76:	b1e58593          	addi	a1,a1,-1250 # 80008790 <syscalls+0x3c8>
    80005c7a:	00240517          	auipc	a0,0x240
    80005c7e:	4c650513          	addi	a0,a0,1222 # 80246140 <cons>
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	590080e7          	jalr	1424(ra) # 80006212 <initlock>

  uartinit();
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	330080e7          	jalr	816(ra) # 80005fba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c92:	00233797          	auipc	a5,0x233
    80005c96:	43678793          	addi	a5,a5,1078 # 802390c8 <devsw>
    80005c9a:	00000717          	auipc	a4,0x0
    80005c9e:	ce470713          	addi	a4,a4,-796 # 8000597e <consoleread>
    80005ca2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ca4:	00000717          	auipc	a4,0x0
    80005ca8:	c7870713          	addi	a4,a4,-904 # 8000591c <consolewrite>
    80005cac:	ef98                	sd	a4,24(a5)
}
    80005cae:	60a2                	ld	ra,8(sp)
    80005cb0:	6402                	ld	s0,0(sp)
    80005cb2:	0141                	addi	sp,sp,16
    80005cb4:	8082                	ret

0000000080005cb6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cb6:	7179                	addi	sp,sp,-48
    80005cb8:	f406                	sd	ra,40(sp)
    80005cba:	f022                	sd	s0,32(sp)
    80005cbc:	ec26                	sd	s1,24(sp)
    80005cbe:	e84a                	sd	s2,16(sp)
    80005cc0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cc2:	c219                	beqz	a2,80005cc8 <printint+0x12>
    80005cc4:	08054663          	bltz	a0,80005d50 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cc8:	2501                	sext.w	a0,a0
    80005cca:	4881                	li	a7,0
    80005ccc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cd0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cd2:	2581                	sext.w	a1,a1
    80005cd4:	00003617          	auipc	a2,0x3
    80005cd8:	aec60613          	addi	a2,a2,-1300 # 800087c0 <digits>
    80005cdc:	883a                	mv	a6,a4
    80005cde:	2705                	addiw	a4,a4,1
    80005ce0:	02b577bb          	remuw	a5,a0,a1
    80005ce4:	1782                	slli	a5,a5,0x20
    80005ce6:	9381                	srli	a5,a5,0x20
    80005ce8:	97b2                	add	a5,a5,a2
    80005cea:	0007c783          	lbu	a5,0(a5)
    80005cee:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cf2:	0005079b          	sext.w	a5,a0
    80005cf6:	02b5553b          	divuw	a0,a0,a1
    80005cfa:	0685                	addi	a3,a3,1
    80005cfc:	feb7f0e3          	bgeu	a5,a1,80005cdc <printint+0x26>

  if(sign)
    80005d00:	00088b63          	beqz	a7,80005d16 <printint+0x60>
    buf[i++] = '-';
    80005d04:	fe040793          	addi	a5,s0,-32
    80005d08:	973e                	add	a4,a4,a5
    80005d0a:	02d00793          	li	a5,45
    80005d0e:	fef70823          	sb	a5,-16(a4)
    80005d12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d16:	02e05763          	blez	a4,80005d44 <printint+0x8e>
    80005d1a:	fd040793          	addi	a5,s0,-48
    80005d1e:	00e784b3          	add	s1,a5,a4
    80005d22:	fff78913          	addi	s2,a5,-1
    80005d26:	993a                	add	s2,s2,a4
    80005d28:	377d                	addiw	a4,a4,-1
    80005d2a:	1702                	slli	a4,a4,0x20
    80005d2c:	9301                	srli	a4,a4,0x20
    80005d2e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d32:	fff4c503          	lbu	a0,-1(s1)
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	d60080e7          	jalr	-672(ra) # 80005a96 <consputc>
  while(--i >= 0)
    80005d3e:	14fd                	addi	s1,s1,-1
    80005d40:	ff2499e3          	bne	s1,s2,80005d32 <printint+0x7c>
}
    80005d44:	70a2                	ld	ra,40(sp)
    80005d46:	7402                	ld	s0,32(sp)
    80005d48:	64e2                	ld	s1,24(sp)
    80005d4a:	6942                	ld	s2,16(sp)
    80005d4c:	6145                	addi	sp,sp,48
    80005d4e:	8082                	ret
    x = -xx;
    80005d50:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d54:	4885                	li	a7,1
    x = -xx;
    80005d56:	bf9d                	j	80005ccc <printint+0x16>

0000000080005d58 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d58:	1101                	addi	sp,sp,-32
    80005d5a:	ec06                	sd	ra,24(sp)
    80005d5c:	e822                	sd	s0,16(sp)
    80005d5e:	e426                	sd	s1,8(sp)
    80005d60:	1000                	addi	s0,sp,32
    80005d62:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d64:	00240797          	auipc	a5,0x240
    80005d68:	4807ae23          	sw	zero,1180(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005d6c:	00003517          	auipc	a0,0x3
    80005d70:	a2c50513          	addi	a0,a0,-1492 # 80008798 <syscalls+0x3d0>
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	02e080e7          	jalr	46(ra) # 80005da2 <printf>
  printf(s);
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	024080e7          	jalr	36(ra) # 80005da2 <printf>
  printf("\n");
    80005d86:	00002517          	auipc	a0,0x2
    80005d8a:	2c250513          	addi	a0,a0,706 # 80008048 <etext+0x48>
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	014080e7          	jalr	20(ra) # 80005da2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d96:	4785                	li	a5,1
    80005d98:	00003717          	auipc	a4,0x3
    80005d9c:	28f72223          	sw	a5,644(a4) # 8000901c <panicked>
  for(;;)
    80005da0:	a001                	j	80005da0 <panic+0x48>

0000000080005da2 <printf>:
{
    80005da2:	7131                	addi	sp,sp,-192
    80005da4:	fc86                	sd	ra,120(sp)
    80005da6:	f8a2                	sd	s0,112(sp)
    80005da8:	f4a6                	sd	s1,104(sp)
    80005daa:	f0ca                	sd	s2,96(sp)
    80005dac:	ecce                	sd	s3,88(sp)
    80005dae:	e8d2                	sd	s4,80(sp)
    80005db0:	e4d6                	sd	s5,72(sp)
    80005db2:	e0da                	sd	s6,64(sp)
    80005db4:	fc5e                	sd	s7,56(sp)
    80005db6:	f862                	sd	s8,48(sp)
    80005db8:	f466                	sd	s9,40(sp)
    80005dba:	f06a                	sd	s10,32(sp)
    80005dbc:	ec6e                	sd	s11,24(sp)
    80005dbe:	0100                	addi	s0,sp,128
    80005dc0:	8a2a                	mv	s4,a0
    80005dc2:	e40c                	sd	a1,8(s0)
    80005dc4:	e810                	sd	a2,16(s0)
    80005dc6:	ec14                	sd	a3,24(s0)
    80005dc8:	f018                	sd	a4,32(s0)
    80005dca:	f41c                	sd	a5,40(s0)
    80005dcc:	03043823          	sd	a6,48(s0)
    80005dd0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dd4:	00240d97          	auipc	s11,0x240
    80005dd8:	42cdad83          	lw	s11,1068(s11) # 80246200 <pr+0x18>
  if(locking)
    80005ddc:	020d9b63          	bnez	s11,80005e12 <printf+0x70>
  if (fmt == 0)
    80005de0:	040a0263          	beqz	s4,80005e24 <printf+0x82>
  va_start(ap, fmt);
    80005de4:	00840793          	addi	a5,s0,8
    80005de8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dec:	000a4503          	lbu	a0,0(s4)
    80005df0:	16050263          	beqz	a0,80005f54 <printf+0x1b2>
    80005df4:	4481                	li	s1,0
    if(c != '%'){
    80005df6:	02500a93          	li	s5,37
    switch(c){
    80005dfa:	07000b13          	li	s6,112
  consputc('x');
    80005dfe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e00:	00003b97          	auipc	s7,0x3
    80005e04:	9c0b8b93          	addi	s7,s7,-1600 # 800087c0 <digits>
    switch(c){
    80005e08:	07300c93          	li	s9,115
    80005e0c:	06400c13          	li	s8,100
    80005e10:	a82d                	j	80005e4a <printf+0xa8>
    acquire(&pr.lock);
    80005e12:	00240517          	auipc	a0,0x240
    80005e16:	3d650513          	addi	a0,a0,982 # 802461e8 <pr>
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	488080e7          	jalr	1160(ra) # 800062a2 <acquire>
    80005e22:	bf7d                	j	80005de0 <printf+0x3e>
    panic("null fmt");
    80005e24:	00003517          	auipc	a0,0x3
    80005e28:	98450513          	addi	a0,a0,-1660 # 800087a8 <syscalls+0x3e0>
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	f2c080e7          	jalr	-212(ra) # 80005d58 <panic>
      consputc(c);
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	c62080e7          	jalr	-926(ra) # 80005a96 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e3c:	2485                	addiw	s1,s1,1
    80005e3e:	009a07b3          	add	a5,s4,s1
    80005e42:	0007c503          	lbu	a0,0(a5)
    80005e46:	10050763          	beqz	a0,80005f54 <printf+0x1b2>
    if(c != '%'){
    80005e4a:	ff5515e3          	bne	a0,s5,80005e34 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e4e:	2485                	addiw	s1,s1,1
    80005e50:	009a07b3          	add	a5,s4,s1
    80005e54:	0007c783          	lbu	a5,0(a5)
    80005e58:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e5c:	cfe5                	beqz	a5,80005f54 <printf+0x1b2>
    switch(c){
    80005e5e:	05678a63          	beq	a5,s6,80005eb2 <printf+0x110>
    80005e62:	02fb7663          	bgeu	s6,a5,80005e8e <printf+0xec>
    80005e66:	09978963          	beq	a5,s9,80005ef8 <printf+0x156>
    80005e6a:	07800713          	li	a4,120
    80005e6e:	0ce79863          	bne	a5,a4,80005f3e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e72:	f8843783          	ld	a5,-120(s0)
    80005e76:	00878713          	addi	a4,a5,8
    80005e7a:	f8e43423          	sd	a4,-120(s0)
    80005e7e:	4605                	li	a2,1
    80005e80:	85ea                	mv	a1,s10
    80005e82:	4388                	lw	a0,0(a5)
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	e32080e7          	jalr	-462(ra) # 80005cb6 <printint>
      break;
    80005e8c:	bf45                	j	80005e3c <printf+0x9a>
    switch(c){
    80005e8e:	0b578263          	beq	a5,s5,80005f32 <printf+0x190>
    80005e92:	0b879663          	bne	a5,s8,80005f3e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e96:	f8843783          	ld	a5,-120(s0)
    80005e9a:	00878713          	addi	a4,a5,8
    80005e9e:	f8e43423          	sd	a4,-120(s0)
    80005ea2:	4605                	li	a2,1
    80005ea4:	45a9                	li	a1,10
    80005ea6:	4388                	lw	a0,0(a5)
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	e0e080e7          	jalr	-498(ra) # 80005cb6 <printint>
      break;
    80005eb0:	b771                	j	80005e3c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eb2:	f8843783          	ld	a5,-120(s0)
    80005eb6:	00878713          	addi	a4,a5,8
    80005eba:	f8e43423          	sd	a4,-120(s0)
    80005ebe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ec2:	03000513          	li	a0,48
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	bd0080e7          	jalr	-1072(ra) # 80005a96 <consputc>
  consputc('x');
    80005ece:	07800513          	li	a0,120
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	bc4080e7          	jalr	-1084(ra) # 80005a96 <consputc>
    80005eda:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005edc:	03c9d793          	srli	a5,s3,0x3c
    80005ee0:	97de                	add	a5,a5,s7
    80005ee2:	0007c503          	lbu	a0,0(a5)
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	bb0080e7          	jalr	-1104(ra) # 80005a96 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eee:	0992                	slli	s3,s3,0x4
    80005ef0:	397d                	addiw	s2,s2,-1
    80005ef2:	fe0915e3          	bnez	s2,80005edc <printf+0x13a>
    80005ef6:	b799                	j	80005e3c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ef8:	f8843783          	ld	a5,-120(s0)
    80005efc:	00878713          	addi	a4,a5,8
    80005f00:	f8e43423          	sd	a4,-120(s0)
    80005f04:	0007b903          	ld	s2,0(a5)
    80005f08:	00090e63          	beqz	s2,80005f24 <printf+0x182>
      for(; *s; s++)
    80005f0c:	00094503          	lbu	a0,0(s2)
    80005f10:	d515                	beqz	a0,80005e3c <printf+0x9a>
        consputc(*s);
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	b84080e7          	jalr	-1148(ra) # 80005a96 <consputc>
      for(; *s; s++)
    80005f1a:	0905                	addi	s2,s2,1
    80005f1c:	00094503          	lbu	a0,0(s2)
    80005f20:	f96d                	bnez	a0,80005f12 <printf+0x170>
    80005f22:	bf29                	j	80005e3c <printf+0x9a>
        s = "(null)";
    80005f24:	00003917          	auipc	s2,0x3
    80005f28:	87c90913          	addi	s2,s2,-1924 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80005f2c:	02800513          	li	a0,40
    80005f30:	b7cd                	j	80005f12 <printf+0x170>
      consputc('%');
    80005f32:	8556                	mv	a0,s5
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b62080e7          	jalr	-1182(ra) # 80005a96 <consputc>
      break;
    80005f3c:	b701                	j	80005e3c <printf+0x9a>
      consputc('%');
    80005f3e:	8556                	mv	a0,s5
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	b56080e7          	jalr	-1194(ra) # 80005a96 <consputc>
      consputc(c);
    80005f48:	854a                	mv	a0,s2
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	b4c080e7          	jalr	-1204(ra) # 80005a96 <consputc>
      break;
    80005f52:	b5ed                	j	80005e3c <printf+0x9a>
  if(locking)
    80005f54:	020d9163          	bnez	s11,80005f76 <printf+0x1d4>
}
    80005f58:	70e6                	ld	ra,120(sp)
    80005f5a:	7446                	ld	s0,112(sp)
    80005f5c:	74a6                	ld	s1,104(sp)
    80005f5e:	7906                	ld	s2,96(sp)
    80005f60:	69e6                	ld	s3,88(sp)
    80005f62:	6a46                	ld	s4,80(sp)
    80005f64:	6aa6                	ld	s5,72(sp)
    80005f66:	6b06                	ld	s6,64(sp)
    80005f68:	7be2                	ld	s7,56(sp)
    80005f6a:	7c42                	ld	s8,48(sp)
    80005f6c:	7ca2                	ld	s9,40(sp)
    80005f6e:	7d02                	ld	s10,32(sp)
    80005f70:	6de2                	ld	s11,24(sp)
    80005f72:	6129                	addi	sp,sp,192
    80005f74:	8082                	ret
    release(&pr.lock);
    80005f76:	00240517          	auipc	a0,0x240
    80005f7a:	27250513          	addi	a0,a0,626 # 802461e8 <pr>
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	3d8080e7          	jalr	984(ra) # 80006356 <release>
}
    80005f86:	bfc9                	j	80005f58 <printf+0x1b6>

0000000080005f88 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f88:	1101                	addi	sp,sp,-32
    80005f8a:	ec06                	sd	ra,24(sp)
    80005f8c:	e822                	sd	s0,16(sp)
    80005f8e:	e426                	sd	s1,8(sp)
    80005f90:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f92:	00240497          	auipc	s1,0x240
    80005f96:	25648493          	addi	s1,s1,598 # 802461e8 <pr>
    80005f9a:	00003597          	auipc	a1,0x3
    80005f9e:	81e58593          	addi	a1,a1,-2018 # 800087b8 <syscalls+0x3f0>
    80005fa2:	8526                	mv	a0,s1
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	26e080e7          	jalr	622(ra) # 80006212 <initlock>
  pr.locking = 1;
    80005fac:	4785                	li	a5,1
    80005fae:	cc9c                	sw	a5,24(s1)
}
    80005fb0:	60e2                	ld	ra,24(sp)
    80005fb2:	6442                	ld	s0,16(sp)
    80005fb4:	64a2                	ld	s1,8(sp)
    80005fb6:	6105                	addi	sp,sp,32
    80005fb8:	8082                	ret

0000000080005fba <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fba:	1141                	addi	sp,sp,-16
    80005fbc:	e406                	sd	ra,8(sp)
    80005fbe:	e022                	sd	s0,0(sp)
    80005fc0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fc2:	100007b7          	lui	a5,0x10000
    80005fc6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fca:	f8000713          	li	a4,-128
    80005fce:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fd2:	470d                	li	a4,3
    80005fd4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fd8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fdc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fe0:	469d                	li	a3,7
    80005fe2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fe6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fea:	00002597          	auipc	a1,0x2
    80005fee:	7ee58593          	addi	a1,a1,2030 # 800087d8 <digits+0x18>
    80005ff2:	00240517          	auipc	a0,0x240
    80005ff6:	21650513          	addi	a0,a0,534 # 80246208 <uart_tx_lock>
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	218080e7          	jalr	536(ra) # 80006212 <initlock>
}
    80006002:	60a2                	ld	ra,8(sp)
    80006004:	6402                	ld	s0,0(sp)
    80006006:	0141                	addi	sp,sp,16
    80006008:	8082                	ret

000000008000600a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000600a:	1101                	addi	sp,sp,-32
    8000600c:	ec06                	sd	ra,24(sp)
    8000600e:	e822                	sd	s0,16(sp)
    80006010:	e426                	sd	s1,8(sp)
    80006012:	1000                	addi	s0,sp,32
    80006014:	84aa                	mv	s1,a0
  push_off();
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	240080e7          	jalr	576(ra) # 80006256 <push_off>

  if(panicked){
    8000601e:	00003797          	auipc	a5,0x3
    80006022:	ffe7a783          	lw	a5,-2(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006026:	10000737          	lui	a4,0x10000
  if(panicked){
    8000602a:	c391                	beqz	a5,8000602e <uartputc_sync+0x24>
    for(;;)
    8000602c:	a001                	j	8000602c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000602e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006032:	0ff7f793          	andi	a5,a5,255
    80006036:	0207f793          	andi	a5,a5,32
    8000603a:	dbf5                	beqz	a5,8000602e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000603c:	0ff4f793          	andi	a5,s1,255
    80006040:	10000737          	lui	a4,0x10000
    80006044:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	2ae080e7          	jalr	686(ra) # 800062f6 <pop_off>
}
    80006050:	60e2                	ld	ra,24(sp)
    80006052:	6442                	ld	s0,16(sp)
    80006054:	64a2                	ld	s1,8(sp)
    80006056:	6105                	addi	sp,sp,32
    80006058:	8082                	ret

000000008000605a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fc673703          	ld	a4,-58(a4) # 80009020 <uart_tx_r>
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fc67b783          	ld	a5,-58(a5) # 80009028 <uart_tx_w>
    8000606a:	06e78c63          	beq	a5,a4,800060e2 <uartstart+0x88>
{
    8000606e:	7139                	addi	sp,sp,-64
    80006070:	fc06                	sd	ra,56(sp)
    80006072:	f822                	sd	s0,48(sp)
    80006074:	f426                	sd	s1,40(sp)
    80006076:	f04a                	sd	s2,32(sp)
    80006078:	ec4e                	sd	s3,24(sp)
    8000607a:	e852                	sd	s4,16(sp)
    8000607c:	e456                	sd	s5,8(sp)
    8000607e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006080:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006084:	00240a17          	auipc	s4,0x240
    80006088:	184a0a13          	addi	s4,s4,388 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    8000608c:	00003497          	auipc	s1,0x3
    80006090:	f9448493          	addi	s1,s1,-108 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006094:	00003997          	auipc	s3,0x3
    80006098:	f9498993          	addi	s3,s3,-108 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000609c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060a0:	0ff7f793          	andi	a5,a5,255
    800060a4:	0207f793          	andi	a5,a5,32
    800060a8:	c785                	beqz	a5,800060d0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060aa:	01f77793          	andi	a5,a4,31
    800060ae:	97d2                	add	a5,a5,s4
    800060b0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060b4:	0705                	addi	a4,a4,1
    800060b6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060b8:	8526                	mv	a0,s1
    800060ba:	ffffb097          	auipc	ra,0xffffb
    800060be:	750080e7          	jalr	1872(ra) # 8000180a <wakeup>
    
    WriteReg(THR, c);
    800060c2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060c6:	6098                	ld	a4,0(s1)
    800060c8:	0009b783          	ld	a5,0(s3)
    800060cc:	fce798e3          	bne	a5,a4,8000609c <uartstart+0x42>
  }
}
    800060d0:	70e2                	ld	ra,56(sp)
    800060d2:	7442                	ld	s0,48(sp)
    800060d4:	74a2                	ld	s1,40(sp)
    800060d6:	7902                	ld	s2,32(sp)
    800060d8:	69e2                	ld	s3,24(sp)
    800060da:	6a42                	ld	s4,16(sp)
    800060dc:	6aa2                	ld	s5,8(sp)
    800060de:	6121                	addi	sp,sp,64
    800060e0:	8082                	ret
    800060e2:	8082                	ret

00000000800060e4 <uartputc>:
{
    800060e4:	7179                	addi	sp,sp,-48
    800060e6:	f406                	sd	ra,40(sp)
    800060e8:	f022                	sd	s0,32(sp)
    800060ea:	ec26                	sd	s1,24(sp)
    800060ec:	e84a                	sd	s2,16(sp)
    800060ee:	e44e                	sd	s3,8(sp)
    800060f0:	e052                	sd	s4,0(sp)
    800060f2:	1800                	addi	s0,sp,48
    800060f4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060f6:	00240517          	auipc	a0,0x240
    800060fa:	11250513          	addi	a0,a0,274 # 80246208 <uart_tx_lock>
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	1a4080e7          	jalr	420(ra) # 800062a2 <acquire>
  if(panicked){
    80006106:	00003797          	auipc	a5,0x3
    8000610a:	f167a783          	lw	a5,-234(a5) # 8000901c <panicked>
    8000610e:	c391                	beqz	a5,80006112 <uartputc+0x2e>
    for(;;)
    80006110:	a001                	j	80006110 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006112:	00003797          	auipc	a5,0x3
    80006116:	f167b783          	ld	a5,-234(a5) # 80009028 <uart_tx_w>
    8000611a:	00003717          	auipc	a4,0x3
    8000611e:	f0673703          	ld	a4,-250(a4) # 80009020 <uart_tx_r>
    80006122:	02070713          	addi	a4,a4,32
    80006126:	02f71b63          	bne	a4,a5,8000615c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000612a:	00240a17          	auipc	s4,0x240
    8000612e:	0dea0a13          	addi	s4,s4,222 # 80246208 <uart_tx_lock>
    80006132:	00003497          	auipc	s1,0x3
    80006136:	eee48493          	addi	s1,s1,-274 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613a:	00003917          	auipc	s2,0x3
    8000613e:	eee90913          	addi	s2,s2,-274 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006142:	85d2                	mv	a1,s4
    80006144:	8526                	mv	a0,s1
    80006146:	ffffb097          	auipc	ra,0xffffb
    8000614a:	538080e7          	jalr	1336(ra) # 8000167e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000614e:	00093783          	ld	a5,0(s2)
    80006152:	6098                	ld	a4,0(s1)
    80006154:	02070713          	addi	a4,a4,32
    80006158:	fef705e3          	beq	a4,a5,80006142 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000615c:	00240497          	auipc	s1,0x240
    80006160:	0ac48493          	addi	s1,s1,172 # 80246208 <uart_tx_lock>
    80006164:	01f7f713          	andi	a4,a5,31
    80006168:	9726                	add	a4,a4,s1
    8000616a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000616e:	0785                	addi	a5,a5,1
    80006170:	00003717          	auipc	a4,0x3
    80006174:	eaf73c23          	sd	a5,-328(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	ee2080e7          	jalr	-286(ra) # 8000605a <uartstart>
      release(&uart_tx_lock);
    80006180:	8526                	mv	a0,s1
    80006182:	00000097          	auipc	ra,0x0
    80006186:	1d4080e7          	jalr	468(ra) # 80006356 <release>
}
    8000618a:	70a2                	ld	ra,40(sp)
    8000618c:	7402                	ld	s0,32(sp)
    8000618e:	64e2                	ld	s1,24(sp)
    80006190:	6942                	ld	s2,16(sp)
    80006192:	69a2                	ld	s3,8(sp)
    80006194:	6a02                	ld	s4,0(sp)
    80006196:	6145                	addi	sp,sp,48
    80006198:	8082                	ret

000000008000619a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000619a:	1141                	addi	sp,sp,-16
    8000619c:	e422                	sd	s0,8(sp)
    8000619e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061a0:	100007b7          	lui	a5,0x10000
    800061a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061a8:	8b85                	andi	a5,a5,1
    800061aa:	cb91                	beqz	a5,800061be <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061ac:	100007b7          	lui	a5,0x10000
    800061b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061b4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061b8:	6422                	ld	s0,8(sp)
    800061ba:	0141                	addi	sp,sp,16
    800061bc:	8082                	ret
    return -1;
    800061be:	557d                	li	a0,-1
    800061c0:	bfe5                	j	800061b8 <uartgetc+0x1e>

00000000800061c2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061c2:	1101                	addi	sp,sp,-32
    800061c4:	ec06                	sd	ra,24(sp)
    800061c6:	e822                	sd	s0,16(sp)
    800061c8:	e426                	sd	s1,8(sp)
    800061ca:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061cc:	54fd                	li	s1,-1
    int c = uartgetc();
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	fcc080e7          	jalr	-52(ra) # 8000619a <uartgetc>
    if(c == -1)
    800061d6:	00950763          	beq	a0,s1,800061e4 <uartintr+0x22>
      break;
    consoleintr(c);
    800061da:	00000097          	auipc	ra,0x0
    800061de:	8fe080e7          	jalr	-1794(ra) # 80005ad8 <consoleintr>
  while(1){
    800061e2:	b7f5                	j	800061ce <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061e4:	00240497          	auipc	s1,0x240
    800061e8:	02448493          	addi	s1,s1,36 # 80246208 <uart_tx_lock>
    800061ec:	8526                	mv	a0,s1
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	0b4080e7          	jalr	180(ra) # 800062a2 <acquire>
  uartstart();
    800061f6:	00000097          	auipc	ra,0x0
    800061fa:	e64080e7          	jalr	-412(ra) # 8000605a <uartstart>
  release(&uart_tx_lock);
    800061fe:	8526                	mv	a0,s1
    80006200:	00000097          	auipc	ra,0x0
    80006204:	156080e7          	jalr	342(ra) # 80006356 <release>
}
    80006208:	60e2                	ld	ra,24(sp)
    8000620a:	6442                	ld	s0,16(sp)
    8000620c:	64a2                	ld	s1,8(sp)
    8000620e:	6105                	addi	sp,sp,32
    80006210:	8082                	ret

0000000080006212 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006212:	1141                	addi	sp,sp,-16
    80006214:	e422                	sd	s0,8(sp)
    80006216:	0800                	addi	s0,sp,16
  lk->name = name;
    80006218:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000621a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000621e:	00053823          	sd	zero,16(a0)
}
    80006222:	6422                	ld	s0,8(sp)
    80006224:	0141                	addi	sp,sp,16
    80006226:	8082                	ret

0000000080006228 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006228:	411c                	lw	a5,0(a0)
    8000622a:	e399                	bnez	a5,80006230 <holding+0x8>
    8000622c:	4501                	li	a0,0
  return r;
}
    8000622e:	8082                	ret
{
    80006230:	1101                	addi	sp,sp,-32
    80006232:	ec06                	sd	ra,24(sp)
    80006234:	e822                	sd	s0,16(sp)
    80006236:	e426                	sd	s1,8(sp)
    80006238:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000623a:	6904                	ld	s1,16(a0)
    8000623c:	ffffb097          	auipc	ra,0xffffb
    80006240:	d6a080e7          	jalr	-662(ra) # 80000fa6 <mycpu>
    80006244:	40a48533          	sub	a0,s1,a0
    80006248:	00153513          	seqz	a0,a0
}
    8000624c:	60e2                	ld	ra,24(sp)
    8000624e:	6442                	ld	s0,16(sp)
    80006250:	64a2                	ld	s1,8(sp)
    80006252:	6105                	addi	sp,sp,32
    80006254:	8082                	ret

0000000080006256 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006256:	1101                	addi	sp,sp,-32
    80006258:	ec06                	sd	ra,24(sp)
    8000625a:	e822                	sd	s0,16(sp)
    8000625c:	e426                	sd	s1,8(sp)
    8000625e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006260:	100024f3          	csrr	s1,sstatus
    80006264:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006268:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	d38080e7          	jalr	-712(ra) # 80000fa6 <mycpu>
    80006276:	5d3c                	lw	a5,120(a0)
    80006278:	cf89                	beqz	a5,80006292 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	d2c080e7          	jalr	-724(ra) # 80000fa6 <mycpu>
    80006282:	5d3c                	lw	a5,120(a0)
    80006284:	2785                	addiw	a5,a5,1
    80006286:	dd3c                	sw	a5,120(a0)
}
    80006288:	60e2                	ld	ra,24(sp)
    8000628a:	6442                	ld	s0,16(sp)
    8000628c:	64a2                	ld	s1,8(sp)
    8000628e:	6105                	addi	sp,sp,32
    80006290:	8082                	ret
    mycpu()->intena = old;
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	d14080e7          	jalr	-748(ra) # 80000fa6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000629a:	8085                	srli	s1,s1,0x1
    8000629c:	8885                	andi	s1,s1,1
    8000629e:	dd64                	sw	s1,124(a0)
    800062a0:	bfe9                	j	8000627a <push_off+0x24>

00000000800062a2 <acquire>:
{
    800062a2:	1101                	addi	sp,sp,-32
    800062a4:	ec06                	sd	ra,24(sp)
    800062a6:	e822                	sd	s0,16(sp)
    800062a8:	e426                	sd	s1,8(sp)
    800062aa:	1000                	addi	s0,sp,32
    800062ac:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	fa8080e7          	jalr	-88(ra) # 80006256 <push_off>
  if(holding(lk))
    800062b6:	8526                	mv	a0,s1
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	f70080e7          	jalr	-144(ra) # 80006228 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062c0:	4705                	li	a4,1
  if(holding(lk))
    800062c2:	e115                	bnez	a0,800062e6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062c4:	87ba                	mv	a5,a4
    800062c6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062ca:	2781                	sext.w	a5,a5
    800062cc:	ffe5                	bnez	a5,800062c4 <acquire+0x22>
  __sync_synchronize();
    800062ce:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062d2:	ffffb097          	auipc	ra,0xffffb
    800062d6:	cd4080e7          	jalr	-812(ra) # 80000fa6 <mycpu>
    800062da:	e888                	sd	a0,16(s1)
}
    800062dc:	60e2                	ld	ra,24(sp)
    800062de:	6442                	ld	s0,16(sp)
    800062e0:	64a2                	ld	s1,8(sp)
    800062e2:	6105                	addi	sp,sp,32
    800062e4:	8082                	ret
    panic("acquire");
    800062e6:	00002517          	auipc	a0,0x2
    800062ea:	4fa50513          	addi	a0,a0,1274 # 800087e0 <digits+0x20>
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	a6a080e7          	jalr	-1430(ra) # 80005d58 <panic>

00000000800062f6 <pop_off>:

void
pop_off(void)
{
    800062f6:	1141                	addi	sp,sp,-16
    800062f8:	e406                	sd	ra,8(sp)
    800062fa:	e022                	sd	s0,0(sp)
    800062fc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062fe:	ffffb097          	auipc	ra,0xffffb
    80006302:	ca8080e7          	jalr	-856(ra) # 80000fa6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006306:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000630a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000630c:	e78d                	bnez	a5,80006336 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000630e:	5d3c                	lw	a5,120(a0)
    80006310:	02f05b63          	blez	a5,80006346 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006314:	37fd                	addiw	a5,a5,-1
    80006316:	0007871b          	sext.w	a4,a5
    8000631a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000631c:	eb09                	bnez	a4,8000632e <pop_off+0x38>
    8000631e:	5d7c                	lw	a5,124(a0)
    80006320:	c799                	beqz	a5,8000632e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006322:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006326:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000632a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000632e:	60a2                	ld	ra,8(sp)
    80006330:	6402                	ld	s0,0(sp)
    80006332:	0141                	addi	sp,sp,16
    80006334:	8082                	ret
    panic("pop_off - interruptible");
    80006336:	00002517          	auipc	a0,0x2
    8000633a:	4b250513          	addi	a0,a0,1202 # 800087e8 <digits+0x28>
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	a1a080e7          	jalr	-1510(ra) # 80005d58 <panic>
    panic("pop_off");
    80006346:	00002517          	auipc	a0,0x2
    8000634a:	4ba50513          	addi	a0,a0,1210 # 80008800 <digits+0x40>
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	a0a080e7          	jalr	-1526(ra) # 80005d58 <panic>

0000000080006356 <release>:
{
    80006356:	1101                	addi	sp,sp,-32
    80006358:	ec06                	sd	ra,24(sp)
    8000635a:	e822                	sd	s0,16(sp)
    8000635c:	e426                	sd	s1,8(sp)
    8000635e:	1000                	addi	s0,sp,32
    80006360:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006362:	00000097          	auipc	ra,0x0
    80006366:	ec6080e7          	jalr	-314(ra) # 80006228 <holding>
    8000636a:	c115                	beqz	a0,8000638e <release+0x38>
  lk->cpu = 0;
    8000636c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006370:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006374:	0f50000f          	fence	iorw,ow
    80006378:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	f7a080e7          	jalr	-134(ra) # 800062f6 <pop_off>
}
    80006384:	60e2                	ld	ra,24(sp)
    80006386:	6442                	ld	s0,16(sp)
    80006388:	64a2                	ld	s1,8(sp)
    8000638a:	6105                	addi	sp,sp,32
    8000638c:	8082                	ret
    panic("release");
    8000638e:	00002517          	auipc	a0,0x2
    80006392:	47a50513          	addi	a0,a0,1146 # 80008808 <digits+0x48>
    80006396:	00000097          	auipc	ra,0x0
    8000639a:	9c2080e7          	jalr	-1598(ra) # 80005d58 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
