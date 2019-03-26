
kernel/system:     file format elf32-i386


Disassembly of section .text:

00100000 <_start>:

.globl _start

.text
_start:
	movw	$0x1234,0x472			# warm boot
  100000:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  100007:	34 12 

	# Setup kernel stack
	movl $0, %ebp
  100009:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl $(bootstacktop), %esp
  10000e:	bc 20 b3 10 00       	mov    $0x10b320,%esp


	call kernel_main
  100013:	e8 04 00 00 00       	call   10001c <kernel_main>

00100018 <die>:
die:
	jmp die
  100018:	eb fe                	jmp    100018 <die>
	...

0010001c <kernel_main>:
#include <kernel/trap.h>
#include <kernel/picirq.h>

extern void init_video(void);
void kernel_main(void)
{
  10001c:	83 ec 0c             	sub    $0xc,%esp




	init_video();
  10001f:	e8 53 04 00 00       	call   100477 <init_video>

	pic_init();
  100024:	e8 3f 00 00 00       	call   100068 <pic_init>
	/* TODO: You should uncomment them
	*/

	kbd_init();
  100029:	e8 08 02 00 00       	call   100236 <kbd_init>
	timer_init();
  10002e:	e8 14 09 00 00       	call   100947 <timer_init>
	trap_init();
  100033:	e8 7b 06 00 00       	call   1006b3 <trap_init>

	//enable interrupt之後，就開始怪怪的

	/* Enable interrupt */
	__asm __volatile("sti");
  100038:	fb                   	sti    

	shell();
}
  100039:	83 c4 0c             	add    $0xc,%esp
	//enable interrupt之後，就開始怪怪的

	/* Enable interrupt */
	__asm __volatile("sti");

	shell();
  10003c:	e9 c9 07 00 00       	jmp    10080a <shell>
  100041:	00 00                	add    %al,(%eax)
	...

00100044 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
  100044:	8b 54 24 04          	mov    0x4(%esp),%edx
	int i;
	irq_mask_8259A = mask;
	if (!didinit)
  100048:	80 3d 20 b3 10 00 00 	cmpb   $0x0,0x10b320
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
  10004f:	89 d0                	mov    %edx,%eax
	int i;
	irq_mask_8259A = mask;
  100051:	66 89 15 00 30 10 00 	mov    %dx,0x103000
	if (!didinit)
  100058:	74 0d                	je     100067 <irq_setmask_8259A+0x23>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  10005a:	ba 21 00 00 00       	mov    $0x21,%edx
  10005f:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
  100060:	66 c1 e8 08          	shr    $0x8,%ax
  100064:	b2 a1                	mov    $0xa1,%dl
  100066:	ee                   	out    %al,(%dx)
  100067:	c3                   	ret    

00100068 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
  100068:	57                   	push   %edi
  100069:	b9 21 00 00 00       	mov    $0x21,%ecx
  10006e:	56                   	push   %esi
  10006f:	b0 ff                	mov    $0xff,%al
  100071:	53                   	push   %ebx
  100072:	89 ca                	mov    %ecx,%edx
  100074:	ee                   	out    %al,(%dx)
  100075:	be a1 00 00 00       	mov    $0xa1,%esi
  10007a:	89 f2                	mov    %esi,%edx
  10007c:	ee                   	out    %al,(%dx)
  10007d:	bf 11 00 00 00       	mov    $0x11,%edi
  100082:	bb 20 00 00 00       	mov    $0x20,%ebx
  100087:	89 f8                	mov    %edi,%eax
  100089:	89 da                	mov    %ebx,%edx
  10008b:	ee                   	out    %al,(%dx)
  10008c:	b0 20                	mov    $0x20,%al
  10008e:	89 ca                	mov    %ecx,%edx
  100090:	ee                   	out    %al,(%dx)
  100091:	b0 04                	mov    $0x4,%al
  100093:	ee                   	out    %al,(%dx)
  100094:	b0 03                	mov    $0x3,%al
  100096:	ee                   	out    %al,(%dx)
  100097:	b1 a0                	mov    $0xa0,%cl
  100099:	89 f8                	mov    %edi,%eax
  10009b:	89 ca                	mov    %ecx,%edx
  10009d:	ee                   	out    %al,(%dx)
  10009e:	b0 28                	mov    $0x28,%al
  1000a0:	89 f2                	mov    %esi,%edx
  1000a2:	ee                   	out    %al,(%dx)
  1000a3:	b0 02                	mov    $0x2,%al
  1000a5:	ee                   	out    %al,(%dx)
  1000a6:	b0 01                	mov    $0x1,%al
  1000a8:	ee                   	out    %al,(%dx)
  1000a9:	bf 68 00 00 00       	mov    $0x68,%edi
  1000ae:	89 da                	mov    %ebx,%edx
  1000b0:	89 f8                	mov    %edi,%eax
  1000b2:	ee                   	out    %al,(%dx)
  1000b3:	be 0a 00 00 00       	mov    $0xa,%esi
  1000b8:	89 f0                	mov    %esi,%eax
  1000ba:	ee                   	out    %al,(%dx)
  1000bb:	89 f8                	mov    %edi,%eax
  1000bd:	89 ca                	mov    %ecx,%edx
  1000bf:	ee                   	out    %al,(%dx)
  1000c0:	89 f0                	mov    %esi,%eax
  1000c2:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
  1000c3:	66 a1 00 30 10 00    	mov    0x103000,%ax

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
  1000c9:	c6 05 20 b3 10 00 01 	movb   $0x1,0x10b320
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
  1000d0:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  1000d4:	74 0a                	je     1000e0 <pic_init+0x78>
		irq_setmask_8259A(irq_mask_8259A);
  1000d6:	0f b7 c0             	movzwl %ax,%eax
  1000d9:	50                   	push   %eax
  1000da:	e8 65 ff ff ff       	call   100044 <irq_setmask_8259A>
  1000df:	58                   	pop    %eax
}
  1000e0:	5b                   	pop    %ebx
  1000e1:	5e                   	pop    %esi
  1000e2:	5f                   	pop    %edi
  1000e3:	c3                   	ret    

001000e4 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  1000e4:	53                   	push   %ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  1000e5:	ba 64 00 00 00       	mov    $0x64,%edx
  1000ea:	83 ec 08             	sub    $0x8,%esp
  1000ed:	ec                   	in     (%dx),%al
  1000ee:	88 c2                	mov    %al,%dl
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
  1000f0:	83 c8 ff             	or     $0xffffffff,%eax
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  1000f3:	80 e2 01             	and    $0x1,%dl
  1000f6:	0f 84 d2 00 00 00    	je     1001ce <kbd_proc_data+0xea>
  1000fc:	ba 60 00 00 00       	mov    $0x60,%edx
  100101:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
  100102:	3c e0                	cmp    $0xe0,%al
  100104:	88 c1                	mov    %al,%cl
  100106:	75 09                	jne    100111 <kbd_proc_data+0x2d>
		// E0 escape character
		shift |= E0ESC;
  100108:	83 0d 2c b5 10 00 40 	orl    $0x40,0x10b52c
  10010f:	eb 2d                	jmp    10013e <kbd_proc_data+0x5a>
		return 0;
	} else if (data & 0x80) {
  100111:	84 c0                	test   %al,%al
  100113:	8b 15 2c b5 10 00    	mov    0x10b52c,%edx
  100119:	79 2a                	jns    100145 <kbd_proc_data+0x61>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
  10011b:	88 c1                	mov    %al,%cl
  10011d:	83 e1 7f             	and    $0x7f,%ecx
  100120:	f6 c2 40             	test   $0x40,%dl
  100123:	0f 45 c8             	cmovne %eax,%ecx
		shift &= ~(shiftcode[data] | E0ESC);
  100126:	0f b6 c9             	movzbl %cl,%ecx
  100129:	8a 81 2c 17 10 00    	mov    0x10172c(%ecx),%al
  10012f:	83 c8 40             	or     $0x40,%eax
  100132:	0f b6 c0             	movzbl %al,%eax
  100135:	f7 d0                	not    %eax
  100137:	21 d0                	and    %edx,%eax
  100139:	a3 2c b5 10 00       	mov    %eax,0x10b52c
		return 0;
  10013e:	31 c0                	xor    %eax,%eax
  100140:	e9 89 00 00 00       	jmp    1001ce <kbd_proc_data+0xea>
	} else if (shift & E0ESC) {
  100145:	f6 c2 40             	test   $0x40,%dl
  100148:	74 0c                	je     100156 <kbd_proc_data+0x72>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
  10014a:	83 e2 bf             	and    $0xffffffbf,%edx
		data = (shift & E0ESC ? data : data & 0x7F);
		shift &= ~(shiftcode[data] | E0ESC);
		return 0;
	} else if (shift & E0ESC) {
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
  10014d:	83 c9 80             	or     $0xffffff80,%ecx
		shift &= ~E0ESC;
  100150:	89 15 2c b5 10 00    	mov    %edx,0x10b52c
	}

	shift |= shiftcode[data];
  100156:	0f b6 c9             	movzbl %cl,%ecx
	shift ^= togglecode[data];
  100159:	0f b6 81 2c 18 10 00 	movzbl 0x10182c(%ecx),%eax
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
  100160:	0f b6 91 2c 17 10 00 	movzbl 0x10172c(%ecx),%edx
  100167:	0b 15 2c b5 10 00    	or     0x10b52c,%edx
	shift ^= togglecode[data];
  10016d:	31 c2                	xor    %eax,%edx

	c = charcode[shift & (CTL | SHIFT)][data];
  10016f:	89 d0                	mov    %edx,%eax
  100171:	83 e0 03             	and    $0x3,%eax
	if (shift & CAPSLOCK) {
  100174:	f6 c2 08             	test   $0x8,%dl
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];

	c = charcode[shift & (CTL | SHIFT)][data];
  100177:	8b 04 85 2c 19 10 00 	mov    0x10192c(,%eax,4),%eax
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];
  10017e:	89 15 2c b5 10 00    	mov    %edx,0x10b52c

	c = charcode[shift & (CTL | SHIFT)][data];
  100184:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
	if (shift & CAPSLOCK) {
  100188:	74 19                	je     1001a3 <kbd_proc_data+0xbf>
		if ('a' <= c && c <= 'z')
  10018a:	8d 48 9f             	lea    -0x61(%eax),%ecx
  10018d:	83 f9 19             	cmp    $0x19,%ecx
  100190:	77 05                	ja     100197 <kbd_proc_data+0xb3>
			c += 'A' - 'a';
  100192:	83 e8 20             	sub    $0x20,%eax
  100195:	eb 0c                	jmp    1001a3 <kbd_proc_data+0xbf>
		else if ('A' <= c && c <= 'Z')
  100197:	8d 58 bf             	lea    -0x41(%eax),%ebx
			c += 'a' - 'A';
  10019a:	8d 48 20             	lea    0x20(%eax),%ecx
  10019d:	83 fb 19             	cmp    $0x19,%ebx
  1001a0:	0f 46 c1             	cmovbe %ecx,%eax
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1001a3:	3d e9 00 00 00       	cmp    $0xe9,%eax
  1001a8:	75 24                	jne    1001ce <kbd_proc_data+0xea>
  1001aa:	f7 d2                	not    %edx
  1001ac:	80 e2 06             	and    $0x6,%dl
  1001af:	75 1d                	jne    1001ce <kbd_proc_data+0xea>
		cprintf("Rebooting!\n");
  1001b1:	83 ec 0c             	sub    $0xc,%esp
  1001b4:	68 20 17 10 00       	push   $0x101720
  1001b9:	e8 c8 05 00 00       	call   100786 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1001be:	ba 92 00 00 00       	mov    $0x92,%edx
  1001c3:	b0 03                	mov    $0x3,%al
  1001c5:	ee                   	out    %al,(%dx)
  1001c6:	b8 e9 00 00 00       	mov    $0xe9,%eax
  1001cb:	83 c4 10             	add    $0x10,%esp
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
  1001ce:	83 c4 08             	add    $0x8,%esp
  1001d1:	5b                   	pop    %ebx
  1001d2:	c3                   	ret    

001001d3 <cons_getc>:
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	//kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001d3:	8b 15 24 b5 10 00    	mov    0x10b524,%edx
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
  1001d9:	31 c0                	xor    %eax,%eax
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	//kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001db:	3b 15 28 b5 10 00    	cmp    0x10b528,%edx
  1001e1:	74 1b                	je     1001fe <cons_getc+0x2b>
		c = cons.buf[cons.rpos++];
  1001e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  1001e6:	0f b6 82 24 b3 10 00 	movzbl 0x10b324(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
  1001ed:	31 d2                	xor    %edx,%edx
  1001ef:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  1001f5:	0f 45 d1             	cmovne %ecx,%edx
  1001f8:	89 15 24 b5 10 00    	mov    %edx,0x10b524
		return c;
	}
	return 0;
}
  1001fe:	c3                   	ret    

001001ff <kbd_intr>:
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(void)
{
  1001ff:	53                   	push   %ebx
	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
  100200:	31 db                	xor    %ebx,%ebx
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(void)
{
  100202:	83 ec 08             	sub    $0x8,%esp
  100205:	eb 20                	jmp    100227 <kbd_intr+0x28>
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
  100207:	85 c0                	test   %eax,%eax
  100209:	74 1c                	je     100227 <kbd_intr+0x28>
			continue;
		cons.buf[cons.wpos++] = c;
  10020b:	8b 15 28 b5 10 00    	mov    0x10b528,%edx
  100211:	88 82 24 b3 10 00    	mov    %al,0x10b324(%edx)
  100217:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
  10021a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10021f:	0f 44 c3             	cmove  %ebx,%eax
  100222:	a3 28 b5 10 00       	mov    %eax,0x10b528
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
  100227:	e8 b8 fe ff ff       	call   1000e4 <kbd_proc_data>
  10022c:	83 f8 ff             	cmp    $0xffffffff,%eax
  10022f:	75 d6                	jne    100207 <kbd_intr+0x8>
 */
void
kbd_intr(void)
{
	cons_intr(kbd_proc_data);
}
  100231:	83 c4 08             	add    $0x8,%esp
  100234:	5b                   	pop    %ebx
  100235:	c3                   	ret    

00100236 <kbd_init>:

void kbd_init(void)
{
  100236:	83 ec 0c             	sub    $0xc,%esp
	// Drain the kbd buffer so that Bochs generates interrupts.
	cons.rpos = 0;
  100239:	c7 05 24 b5 10 00 00 	movl   $0x0,0x10b524
  100240:	00 00 00 
	cons.wpos = 0;
  100243:	c7 05 28 b5 10 00 00 	movl   $0x0,0x10b528
  10024a:	00 00 00 
	kbd_intr();
  10024d:	e8 ad ff ff ff       	call   1001ff <kbd_intr>
        //IRQ_KBD = 1
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
  100252:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  100259:	83 ec 0c             	sub    $0xc,%esp
  10025c:	25 fd ff 00 00       	and    $0xfffd,%eax
  100261:	50                   	push   %eax
  100262:	e8 dd fd ff ff       	call   100044 <irq_setmask_8259A>
}
  100267:	83 c4 1c             	add    $0x1c,%esp
  10026a:	c3                   	ret    

0010026b <getc>:
/* high-level console I/O */
int getc(void)
{
	int c;

	while ((c = cons_getc()) == 0)
  10026b:	e8 63 ff ff ff       	call   1001d3 <cons_getc>
  100270:	85 c0                	test   %eax,%eax
  100272:	74 f7                	je     10026b <getc>
		/* do nothing */;
	return c;
}
  100274:	c3                   	ret    
  100275:	00 00                	add    %al,(%eax)
	...

00100278 <scroll>:
int attrib = 0x0F;
int csr_x = 0, csr_y = 0;

/* Scrolls the screen */
void scroll(void)
{
  100278:	56                   	push   %esi
  100279:	53                   	push   %ebx
  10027a:	83 ec 04             	sub    $0x4,%esp
    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
  10027d:	8b 1d 34 b5 10 00    	mov    0x10b534,%ebx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
  100283:	8b 35 04 33 10 00    	mov    0x103304,%esi

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
  100289:	83 fb 18             	cmp    $0x18,%ebx
  10028c:	7e 58                	jle    1002e6 <scroll+0x6e>
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
  10028e:	83 eb 18             	sub    $0x18,%ebx
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  100291:	a1 40 b9 10 00       	mov    0x10b940,%eax
  100296:	0f b7 db             	movzwl %bx,%ebx
  100299:	52                   	push   %edx
  10029a:	69 d3 60 ff ff ff    	imul   $0xffffff60,%ebx,%edx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
  1002a0:	c1 e6 08             	shl    $0x8,%esi
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002a3:	0f b7 f6             	movzwl %si,%esi
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  1002a6:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  1002ac:	52                   	push   %edx
  1002ad:	69 d3 a0 00 00 00    	imul   $0xa0,%ebx,%edx

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002b3:	6b db b0             	imul   $0xffffffb0,%ebx,%ebx
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  1002b6:	8d 14 10             	lea    (%eax,%edx,1),%edx
  1002b9:	52                   	push   %edx
  1002ba:	50                   	push   %eax
  1002bb:	e8 69 10 00 00       	call   101329 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002c0:	83 c4 0c             	add    $0xc,%esp
  1002c3:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
  1002ca:	03 05 40 b9 10 00    	add    0x10b940,%eax
  1002d0:	6a 50                	push   $0x50
  1002d2:	56                   	push   %esi
  1002d3:	50                   	push   %eax
  1002d4:	e8 76 0f 00 00       	call   10124f <memset>
        csr_y = 25 - 1;
  1002d9:	83 c4 10             	add    $0x10,%esp
  1002dc:	c7 05 34 b5 10 00 18 	movl   $0x18,0x10b534
  1002e3:	00 00 00 
    }
}
  1002e6:	83 c4 04             	add    $0x4,%esp
  1002e9:	5b                   	pop    %ebx
  1002ea:	5e                   	pop    %esi
  1002eb:	c3                   	ret    

001002ec <move_csr>:
    unsigned short temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = csr_y * 80 + csr_x;
  1002ec:	66 6b 0d 34 b5 10 00 	imul   $0x50,0x10b534,%cx
  1002f3:	50 
  1002f4:	ba d4 03 00 00       	mov    $0x3d4,%edx
  1002f9:	03 0d 30 b5 10 00    	add    0x10b530,%ecx
  1002ff:	b0 0e                	mov    $0xe,%al
  100301:	ee                   	out    %al,(%dx)
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outb(0x3D4, 14);
    outb(0x3D5, temp >> 8);
  100302:	89 c8                	mov    %ecx,%eax
  100304:	b2 d5                	mov    $0xd5,%dl
  100306:	66 c1 e8 08          	shr    $0x8,%ax
  10030a:	ee                   	out    %al,(%dx)
  10030b:	b0 0f                	mov    $0xf,%al
  10030d:	b2 d4                	mov    $0xd4,%dl
  10030f:	ee                   	out    %al,(%dx)
  100310:	b2 d5                	mov    $0xd5,%dl
  100312:	88 c8                	mov    %cl,%al
  100314:	ee                   	out    %al,(%dx)
    outb(0x3D4, 15);
    outb(0x3D5, temp);
}
  100315:	c3                   	ret    

00100316 <cls>:

/* Clears the screen */
void cls()
{
  100316:	56                   	push   %esi
  100317:	53                   	push   %ebx
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
  100318:	31 db                	xor    %ebx,%ebx
    outb(0x3D5, temp);
}

/* Clears the screen */
void cls()
{
  10031a:	83 ec 04             	sub    $0x4,%esp
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
  10031d:	8b 35 04 33 10 00    	mov    0x103304,%esi
  100323:	c1 e6 08             	shl    $0x8,%esi

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
        memset (textmemptr + i * 80, blank, 80);
  100326:	0f b7 f6             	movzwl %si,%esi
  100329:	a1 40 b9 10 00       	mov    0x10b940,%eax
  10032e:	51                   	push   %ecx
  10032f:	6a 50                	push   $0x50
  100331:	56                   	push   %esi
  100332:	01 d8                	add    %ebx,%eax
  100334:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  10033a:	50                   	push   %eax
  10033b:	e8 0f 0f 00 00       	call   10124f <memset>
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
  100340:	83 c4 10             	add    $0x10,%esp
  100343:	81 fb a0 0f 00 00    	cmp    $0xfa0,%ebx
  100349:	75 de                	jne    100329 <cls+0x13>
        memset (textmemptr + i * 80, blank, 80);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
  10034b:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  100352:	00 00 00 
    csr_y = 0;
  100355:	c7 05 34 b5 10 00 00 	movl   $0x0,0x10b534
  10035c:	00 00 00 
    move_csr();
}
  10035f:	83 c4 04             	add    $0x4,%esp
  100362:	5b                   	pop    %ebx
  100363:	5e                   	pop    %esi

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
    csr_y = 0;
    move_csr();
  100364:	e9 83 ff ff ff       	jmp    1002ec <move_csr>

00100369 <putch>:
}

/* Puts a single character on the screen */
void putch(unsigned char c)
{
  100369:	53                   	push   %ebx
  10036a:	83 ec 08             	sub    $0x8,%esp
    unsigned short *where;
    unsigned short att = attrib << 8;
  10036d:	8b 0d 04 33 10 00    	mov    0x103304,%ecx
    move_csr();
}

/* Puts a single character on the screen */
void putch(unsigned char c)
{
  100373:	8a 44 24 10          	mov    0x10(%esp),%al
    unsigned short *where;
    unsigned short att = attrib << 8;
  100377:	c1 e1 08             	shl    $0x8,%ecx

    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
  10037a:	3c 08                	cmp    $0x8,%al
  10037c:	75 21                	jne    10039f <putch+0x36>
    {
        if(csr_x != 0) {
  10037e:	a1 30 b5 10 00       	mov    0x10b530,%eax
  100383:	85 c0                	test   %eax,%eax
  100385:	74 7d                	je     100404 <putch+0x9b>
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
  100387:	6b 15 34 b5 10 00 50 	imul   $0x50,0x10b534,%edx
  10038e:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
          *where = 0x0 | att;	/* Character AND attributes: color */
  100392:	8b 15 40 b9 10 00    	mov    0x10b940,%edx
          csr_x--;
  100398:	48                   	dec    %eax
    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
    {
        if(csr_x != 0) {
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
          *where = 0x0 | att;	/* Character AND attributes: color */
  100399:	66 89 0c 5a          	mov    %cx,(%edx,%ebx,2)
  10039d:	eb 0f                	jmp    1003ae <putch+0x45>
          csr_x--;
        }
    }
    /* Handles a tab by incrementing the cursor's x, but only
    *  to a point that will make it divisible by 8 */
    else if(c == 0x09)
  10039f:	3c 09                	cmp    $0x9,%al
  1003a1:	75 12                	jne    1003b5 <putch+0x4c>
    {
        csr_x = (csr_x + 8) & ~(8 - 1);
  1003a3:	a1 30 b5 10 00       	mov    0x10b530,%eax
  1003a8:	83 c0 08             	add    $0x8,%eax
  1003ab:	83 e0 f8             	and    $0xfffffff8,%eax
  1003ae:	a3 30 b5 10 00       	mov    %eax,0x10b530
  1003b3:	eb 4f                	jmp    100404 <putch+0x9b>
    }
    /* Handles a 'Carriage Return', which simply brings the
    *  cursor back to the margin */
    else if(c == '\r')
  1003b5:	3c 0d                	cmp    $0xd,%al
  1003b7:	75 0c                	jne    1003c5 <putch+0x5c>
    {
        csr_x = 0;
  1003b9:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  1003c0:	00 00 00 
  1003c3:	eb 3f                	jmp    100404 <putch+0x9b>
    }
    /* We handle our newlines the way DOS and the BIOS do: we
    *  treat it as if a 'CR' was also there, so we bring the
    *  cursor to the margin and we increment the 'y' value */
    else if(c == '\n')
  1003c5:	3c 0a                	cmp    $0xa,%al
  1003c7:	75 12                	jne    1003db <putch+0x72>
    {
        csr_x = 0;
  1003c9:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  1003d0:	00 00 00 
        csr_y++;
  1003d3:	ff 05 34 b5 10 00    	incl   0x10b534
  1003d9:	eb 29                	jmp    100404 <putch+0x9b>
    }
    /* Any character greater than and including a space, is a
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
  1003db:	3c 1f                	cmp    $0x1f,%al
  1003dd:	76 25                	jbe    100404 <putch+0x9b>
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003df:	8b 15 30 b5 10 00    	mov    0x10b530,%edx
        *where = c | att;	/* Character AND attributes: color */
  1003e5:	0f b6 c0             	movzbl %al,%eax
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003e8:	6b 1d 34 b5 10 00 50 	imul   $0x50,0x10b534,%ebx
        *where = c | att;	/* Character AND attributes: color */
  1003ef:	09 c8                	or     %ecx,%eax
  1003f1:	8b 0d 40 b9 10 00    	mov    0x10b940,%ecx
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003f7:	01 d3                	add    %edx,%ebx
        *where = c | att;	/* Character AND attributes: color */
        csr_x++;
  1003f9:	42                   	inc    %edx
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
        *where = c | att;	/* Character AND attributes: color */
  1003fa:	66 89 04 59          	mov    %ax,(%ecx,%ebx,2)
        csr_x++;
  1003fe:	89 15 30 b5 10 00    	mov    %edx,0x10b530
    }

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
  100404:	83 3d 30 b5 10 00 4f 	cmpl   $0x4f,0x10b530
  10040b:	7e 10                	jle    10041d <putch+0xb4>
    {
        csr_x = 0;
        csr_y++;
  10040d:	ff 05 34 b5 10 00    	incl   0x10b534

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
    {
        csr_x = 0;
  100413:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  10041a:	00 00 00 
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
  10041d:	e8 56 fe ff ff       	call   100278 <scroll>
    move_csr();
}
  100422:	83 c4 08             	add    $0x8,%esp
  100425:	5b                   	pop    %ebx
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
  100426:	e9 c1 fe ff ff       	jmp    1002ec <move_csr>

0010042b <puts>:
}

/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
  10042b:	56                   	push   %esi
  10042c:	53                   	push   %ebx
    int i;

    for (i = 0; i < strlen(text); i++)
  10042d:	31 db                	xor    %ebx,%ebx
    move_csr();
}

/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
  10042f:	83 ec 04             	sub    $0x4,%esp
  100432:	8b 74 24 10          	mov    0x10(%esp),%esi
    int i;

    for (i = 0; i < strlen(text); i++)
  100436:	eb 11                	jmp    100449 <puts+0x1e>
    {
        putch(text[i]);
  100438:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
  10043c:	83 ec 0c             	sub    $0xc,%esp
/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen(text); i++)
  10043f:	43                   	inc    %ebx
    {
        putch(text[i]);
  100440:	50                   	push   %eax
  100441:	e8 23 ff ff ff       	call   100369 <putch>
/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen(text); i++)
  100446:	83 c4 10             	add    $0x10,%esp
  100449:	83 ec 0c             	sub    $0xc,%esp
  10044c:	56                   	push   %esi
  10044d:	e8 2e 0c 00 00       	call   101080 <strlen>
  100452:	83 c4 10             	add    $0x10,%esp
  100455:	39 c3                	cmp    %eax,%ebx
  100457:	7c df                	jl     100438 <puts+0xd>
    {
        putch(text[i]);
    }
}
  100459:	83 c4 04             	add    $0x4,%esp
  10045c:	5b                   	pop    %ebx
  10045d:	5e                   	pop    %esi
  10045e:	c3                   	ret    

0010045f <settextcolor>:
void settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    /* Lab3: Use this function */
    /* Top 4 bit are the background, bottom 4 bytes
    *  are the foreground color */
    attrib = (backcolor << 4) | (forecolor & 0x0F);
  10045f:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
  100464:	0f b6 54 24 04       	movzbl 0x4(%esp),%edx
  100469:	c1 e0 04             	shl    $0x4,%eax
  10046c:	83 e2 0f             	and    $0xf,%edx
  10046f:	09 d0                	or     %edx,%eax
  100471:	a3 04 33 10 00       	mov    %eax,0x103304
}
  100476:	c3                   	ret    

00100477 <init_video>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
  100477:	83 ec 0c             	sub    $0xc,%esp
    textmemptr = (unsigned short *)0xB8000;
  10047a:	c7 05 40 b9 10 00 00 	movl   $0xb8000,0x10b940
  100481:	80 0b 00 
    cls();
}
  100484:	83 c4 0c             	add    $0xc,%esp

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
    textmemptr = (unsigned short *)0xB8000;
    cls();
  100487:	e9 8a fe ff ff       	jmp    100316 <cls>

0010048c <print_regs>:
}

/* For debugging */
void
print_regs(struct PushRegs *regs)
{
  10048c:	53                   	push   %ebx
  10048d:	83 ec 10             	sub    $0x10,%esp
  100490:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
  100494:	ff 33                	pushl  (%ebx)
  100496:	68 3c 19 10 00       	push   $0x10193c
  10049b:	e8 e6 02 00 00       	call   100786 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
  1004a0:	58                   	pop    %eax
  1004a1:	5a                   	pop    %edx
  1004a2:	ff 73 04             	pushl  0x4(%ebx)
  1004a5:	68 4b 19 10 00       	push   $0x10194b
  1004aa:	e8 d7 02 00 00       	call   100786 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  1004af:	5a                   	pop    %edx
  1004b0:	59                   	pop    %ecx
  1004b1:	ff 73 08             	pushl  0x8(%ebx)
  1004b4:	68 5a 19 10 00       	push   $0x10195a
  1004b9:	e8 c8 02 00 00       	call   100786 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1004be:	59                   	pop    %ecx
  1004bf:	58                   	pop    %eax
  1004c0:	ff 73 0c             	pushl  0xc(%ebx)
  1004c3:	68 69 19 10 00       	push   $0x101969
  1004c8:	e8 b9 02 00 00       	call   100786 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1004cd:	58                   	pop    %eax
  1004ce:	5a                   	pop    %edx
  1004cf:	ff 73 10             	pushl  0x10(%ebx)
  1004d2:	68 78 19 10 00       	push   $0x101978
  1004d7:	e8 aa 02 00 00       	call   100786 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
  1004dc:	5a                   	pop    %edx
  1004dd:	59                   	pop    %ecx
  1004de:	ff 73 14             	pushl  0x14(%ebx)
  1004e1:	68 87 19 10 00       	push   $0x101987
  1004e6:	e8 9b 02 00 00       	call   100786 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  1004eb:	59                   	pop    %ecx
  1004ec:	58                   	pop    %eax
  1004ed:	ff 73 18             	pushl  0x18(%ebx)
  1004f0:	68 96 19 10 00       	push   $0x101996
  1004f5:	e8 8c 02 00 00       	call   100786 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
  1004fa:	58                   	pop    %eax
  1004fb:	5a                   	pop    %edx
  1004fc:	ff 73 1c             	pushl  0x1c(%ebx)
  1004ff:	68 a5 19 10 00       	push   $0x1019a5
  100504:	e8 7d 02 00 00       	call   100786 <cprintf>
}
  100509:	83 c4 18             	add    $0x18,%esp
  10050c:	5b                   	pop    %ebx
  10050d:	c3                   	ret    

0010050e <print_trapframe>:
}

/* For debugging */
void
print_trapframe(struct Trapframe *tf)
{
  10050e:	56                   	push   %esi
  10050f:	53                   	push   %ebx
  100510:	83 ec 10             	sub    $0x10,%esp
  100513:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
	cprintf("TRAP frame at %p \n");
  100517:	68 09 1a 10 00       	push   $0x101a09
  10051c:	e8 65 02 00 00       	call   100786 <cprintf>
	print_regs(&tf->tf_regs);
  100521:	89 1c 24             	mov    %ebx,(%esp)
  100524:	e8 63 ff ff ff       	call   10048c <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
  100529:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
  10052d:	5a                   	pop    %edx
  10052e:	59                   	pop    %ecx
  10052f:	50                   	push   %eax
  100530:	68 1c 1a 10 00       	push   $0x101a1c
  100535:	e8 4c 02 00 00       	call   100786 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10053a:	5e                   	pop    %esi
  10053b:	58                   	pop    %eax
  10053c:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
  100540:	50                   	push   %eax
  100541:	68 2f 1a 10 00       	push   $0x101a2f
  100546:	e8 3b 02 00 00       	call   100786 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10054b:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
  10054e:	83 c4 10             	add    $0x10,%esp
  100551:	83 f8 13             	cmp    $0x13,%eax
  100554:	77 09                	ja     10055f <print_trapframe+0x51>
		return excnames[trapno];
  100556:	8b 14 85 44 1c 10 00 	mov    0x101c44(,%eax,4),%edx
  10055d:	eb 1d                	jmp    10057c <print_trapframe+0x6e>
	if (trapno == T_SYSCALL)
  10055f:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
  100562:	ba b4 19 10 00       	mov    $0x1019b4,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
  100567:	74 13                	je     10057c <print_trapframe+0x6e>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  100569:	8d 48 e0             	lea    -0x20(%eax),%ecx
		return "Hardware Interrupt";
  10056c:	ba c0 19 10 00       	mov    $0x1019c0,%edx
  100571:	83 f9 0f             	cmp    $0xf,%ecx
  100574:	b9 d3 19 10 00       	mov    $0x1019d3,%ecx
  100579:	0f 47 d1             	cmova  %ecx,%edx
{
	cprintf("TRAP frame at %p \n");
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10057c:	51                   	push   %ecx
  10057d:	52                   	push   %edx
  10057e:	50                   	push   %eax
  10057f:	68 42 1a 10 00       	push   $0x101a42
  100584:	e8 fd 01 00 00       	call   100786 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  100589:	83 c4 10             	add    $0x10,%esp
  10058c:	3b 1d 38 b5 10 00    	cmp    0x10b538,%ebx
  100592:	75 19                	jne    1005ad <print_trapframe+0x9f>
  100594:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
  100598:	75 13                	jne    1005ad <print_trapframe+0x9f>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
  10059a:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
  10059d:	52                   	push   %edx
  10059e:	52                   	push   %edx
  10059f:	50                   	push   %eax
  1005a0:	68 54 1a 10 00       	push   $0x101a54
  1005a5:	e8 dc 01 00 00       	call   100786 <cprintf>
  1005aa:	83 c4 10             	add    $0x10,%esp
	cprintf("  err  0x%08x", tf->tf_err);
  1005ad:	56                   	push   %esi
  1005ae:	56                   	push   %esi
  1005af:	ff 73 2c             	pushl  0x2c(%ebx)
  1005b2:	68 63 1a 10 00       	push   $0x101a63
  1005b7:	e8 ca 01 00 00       	call   100786 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
  1005bc:	83 c4 10             	add    $0x10,%esp
  1005bf:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
  1005c3:	75 43                	jne    100608 <print_trapframe+0xfa>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
  1005c5:	8b 73 2c             	mov    0x2c(%ebx),%esi
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
  1005c8:	b8 ed 19 10 00       	mov    $0x1019ed,%eax
  1005cd:	b9 e2 19 10 00       	mov    $0x1019e2,%ecx
  1005d2:	ba f9 19 10 00       	mov    $0x1019f9,%edx
  1005d7:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1005dd:	0f 44 c8             	cmove  %eax,%ecx
  1005e0:	f7 c6 02 00 00 00    	test   $0x2,%esi
  1005e6:	b8 ff 19 10 00       	mov    $0x1019ff,%eax
  1005eb:	0f 44 d0             	cmove  %eax,%edx
  1005ee:	83 e6 04             	and    $0x4,%esi
  1005f1:	51                   	push   %ecx
  1005f2:	b8 04 1a 10 00       	mov    $0x101a04,%eax
  1005f7:	be de 1c 10 00       	mov    $0x101cde,%esi
  1005fc:	52                   	push   %edx
  1005fd:	0f 44 c6             	cmove  %esi,%eax
  100600:	50                   	push   %eax
  100601:	68 71 1a 10 00       	push   $0x101a71
  100606:	eb 08                	jmp    100610 <print_trapframe+0x102>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
  100608:	83 ec 0c             	sub    $0xc,%esp
  10060b:	68 1a 1a 10 00       	push   $0x101a1a
  100610:	e8 71 01 00 00       	call   100786 <cprintf>
  100615:	5a                   	pop    %edx
  100616:	59                   	pop    %ecx
	cprintf("  eip  0x%08x\n", tf->tf_eip);
  100617:	ff 73 30             	pushl  0x30(%ebx)
  10061a:	68 80 1a 10 00       	push   $0x101a80
  10061f:	e8 62 01 00 00       	call   100786 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
  100624:	5e                   	pop    %esi
  100625:	58                   	pop    %eax
  100626:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  10062a:	50                   	push   %eax
  10062b:	68 8f 1a 10 00       	push   $0x101a8f
  100630:	e8 51 01 00 00       	call   100786 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
  100635:	5a                   	pop    %edx
  100636:	59                   	pop    %ecx
  100637:	ff 73 38             	pushl  0x38(%ebx)
  10063a:	68 a2 1a 10 00       	push   $0x101aa2
  10063f:	e8 42 01 00 00       	call   100786 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
  100644:	83 c4 10             	add    $0x10,%esp
  100647:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  10064b:	74 23                	je     100670 <print_trapframe+0x162>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
  10064d:	50                   	push   %eax
  10064e:	50                   	push   %eax
  10064f:	ff 73 3c             	pushl  0x3c(%ebx)
  100652:	68 b1 1a 10 00       	push   $0x101ab1
  100657:	e8 2a 01 00 00       	call   100786 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10065c:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
  100660:	59                   	pop    %ecx
  100661:	5e                   	pop    %esi
  100662:	50                   	push   %eax
  100663:	68 c0 1a 10 00       	push   $0x101ac0
  100668:	e8 19 01 00 00       	call   100786 <cprintf>
  10066d:	83 c4 10             	add    $0x10,%esp
	}
}
  100670:	83 c4 04             	add    $0x4,%esp
  100673:	5b                   	pop    %ebx
  100674:	5e                   	pop    %esi
  100675:	c3                   	ret    

00100676 <default_trap_handler>:

/* 
 * Note: This is the called for every interrupt.
 */
void default_trap_handler(struct Trapframe *tf)
{
  100676:	83 ec 0c             	sub    $0xc,%esp
  100679:	8b 44 24 10          	mov    0x10(%esp),%eax
  	 *       The interrupt number is defined in inc/trap.h
  	 *
   	 *       We prepared the keyboard handler and timer handler for you
   	 *       already. Please reference in kernel/kbd.c and kernel/timer.c
   	 */
	if(tf->tf_trapno==IRQ_OFFSET+IRQ_TIMER){
  10067d:	8b 50 28             	mov    0x28(%eax),%edx
 */
void default_trap_handler(struct Trapframe *tf)
{
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
  100680:	a3 38 b5 10 00       	mov    %eax,0x10b538
  	 *       The interrupt number is defined in inc/trap.h
  	 *
   	 *       We prepared the keyboard handler and timer handler for you
   	 *       already. Please reference in kernel/kbd.c and kernel/timer.c
   	 */
	if(tf->tf_trapno==IRQ_OFFSET+IRQ_TIMER){
  100685:	83 fa 20             	cmp    $0x20,%edx
  100688:	75 08                	jne    100692 <default_trap_handler+0x1c>
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

}
  10068a:	83 c4 0c             	add    $0xc,%esp
   	 *       We prepared the keyboard handler and timer handler for you
   	 *       already. Please reference in kernel/kbd.c and kernel/timer.c
   	 */
	if(tf->tf_trapno==IRQ_OFFSET+IRQ_TIMER){
		//cprintf("timer!\n");
		timer_handler();
  10068d:	e9 a8 02 00 00       	jmp    10093a <timer_handler>
		//for(;;);
		return;
	}else if(tf->tf_trapno==IRQ_OFFSET+IRQ_KBD){
  100692:	83 fa 21             	cmp    $0x21,%edx
  100695:	75 10                	jne    1006a7 <default_trap_handler+0x31>
		cprintf("--------------keyboard!-------------\n");
  100697:	c7 44 24 10 d3 1a 10 	movl   $0x101ad3,0x10(%esp)
  10069e:	00 
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

}
  10069f:	83 c4 0c             	add    $0xc,%esp
		//cprintf("timer!\n");
		timer_handler();
		//for(;;);
		return;
	}else if(tf->tf_trapno==IRQ_OFFSET+IRQ_KBD){
		cprintf("--------------keyboard!-------------\n");
  1006a2:	e9 df 00 00 00       	jmp    100786 <cprintf>
		return;
		//for(;;);
	}

	// Unexpected trap: The user process or the kernel has a bug.	
	print_trapframe(tf);
  1006a7:	89 44 24 10          	mov    %eax,0x10(%esp)
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

}
  1006ab:	83 c4 0c             	add    $0xc,%esp
		return;
		//for(;;);
	}

	// Unexpected trap: The user process or the kernel has a bug.	
	print_trapframe(tf);
  1006ae:	e9 5b fe ff ff       	jmp    10050e <print_trapframe>

001006b3 <trap_init>:

}


void trap_init()
{
  1006b3:	83 ec 18             	sub    $0x18,%esp
   *       There is a data structure called Pseudodesc in mmu.h which might
   *       come in handy for you when filling up the argument of "lidt"
   */
   //SETGATE(gate, istrap, sel, off, dpl)
   //SETGATE()
  cprintf("hihi\n");
  1006b6:	68 f9 1a 10 00       	push   $0x101af9
  1006bb:	e8 c6 00 00 00       	call   100786 <cprintf>

  /* Keyboard interrupt setup */
  SETGATE(idt[0x21], 0,  0x8, keyboard, 0);
  1006c0:	b8 3e 07 10 00       	mov    $0x10073e,%eax
  1006c5:	66 a3 54 ba 10 00    	mov    %ax,0x10ba54
  1006cb:	c1 e8 10             	shr    $0x10,%eax
  1006ce:	66 a3 5a ba 10 00    	mov    %ax,0x10ba5a
  /* Timer Trap setup */
  SETGATE(idt[0x20], 0,  0x8, timer, 0);
  1006d4:	b8 38 07 10 00       	mov    $0x100738,%eax
  1006d9:	66 a3 4c ba 10 00    	mov    %ax,0x10ba4c
  1006df:	c1 e8 10             	shr    $0x10,%eax
  1006e2:	66 a3 52 ba 10 00    	mov    %ax,0x10ba52
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
  1006e8:	b8 44 b9 10 00       	mov    $0x10b944,%eax
   //SETGATE(gate, istrap, sel, off, dpl)
   //SETGATE()
  cprintf("hihi\n");

  /* Keyboard interrupt setup */
  SETGATE(idt[0x21], 0,  0x8, keyboard, 0);
  1006ed:	66 c7 05 56 ba 10 00 	movw   $0x8,0x10ba56
  1006f4:	08 00 
  1006f6:	c6 05 58 ba 10 00 00 	movb   $0x0,0x10ba58
  1006fd:	c6 05 59 ba 10 00 8e 	movb   $0x8e,0x10ba59
  /* Timer Trap setup */
  SETGATE(idt[0x20], 0,  0x8, timer, 0);
  100704:	66 c7 05 4e ba 10 00 	movw   $0x8,0x10ba4e
  10070b:	08 00 
  10070d:	c6 05 50 ba 10 00 00 	movb   $0x0,0x10ba50
  100714:	c6 05 51 ba 10 00 8e 	movb   $0x8e,0x10ba51
  /* Load IDT */
  idt_pd.pd_lim = 256*8-1;
  10071b:	66 c7 05 44 b9 10 00 	movw   $0x7ff,0x10b944
  100722:	ff 07 
  idt_pd.pd_base= idt;
  100724:	c7 05 46 b9 10 00 4c 	movl   $0x10b94c,0x10b946
  10072b:	b9 10 00 
  10072e:	0f 01 18             	lidtl  (%eax)

  lidt(&idt_pd);

}
  100731:	83 c4 1c             	add    $0x1c,%esp
  100734:	c3                   	ret    
  100735:	00 00                	add    %al,(%eax)
	...

00100738 <timer>:
 *       The Trap number are declared in inc/trap.h which might come in handy
 *       when declaring interface for ISRs.
 */
	#第一個參數意思應該是function名稱
	#第二個參數意思應該是....
	TRAPHANDLER_NOEC(timer, 0x20) 
  100738:	6a 00                	push   $0x0
  10073a:	6a 20                	push   $0x20
  10073c:	eb 06                	jmp    100744 <_alltraps>

0010073e <keyboard>:
	TRAPHANDLER_NOEC(keyboard, 0x21) 
  10073e:	6a 00                	push   $0x0
  100740:	6a 21                	push   $0x21
  100742:	eb 00                	jmp    100744 <_alltraps>

00100744 <_alltraps>:
   *       occurs. Thus, you do not have to push those registers.
   *       Please reference lab3.docx for what registers are pushed by
   *       CPU.
   */

	push %ds
  100744:	1e                   	push   %ds
	push %es
  100745:	06                   	push   %es
	push %eax
  100746:	50                   	push   %eax
	push %ecx
  100747:	51                   	push   %ecx
	push %edx
  100748:	52                   	push   %edx
	push %ebx
  100749:	53                   	push   %ebx
	push $0  #useless
  10074a:	6a 00                	push   $0x0
	push %ebp
  10074c:	55                   	push   %ebp
	push %esi
  10074d:	56                   	push   %esi
	push %edi
  10074e:	57                   	push   %edi
	pushl %esp # Pass a pointer which points to the Trapframe as an argument to default_trap_handler()
  10074f:	54                   	push   %esp
	call default_trap_handler
  100750:	e8 21 ff ff ff       	call   100676 <default_trap_handler>

	add $8, %esp # Cleans up the pushed error code and pushed ISR number
  100755:	83 c4 08             	add    $0x8,%esp
	add $0x2c, %esp #0x4*11
  100758:	83 c4 2c             	add    $0x2c,%esp
	iret # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!
  10075b:	cf                   	iret   

0010075c <vcprintf>:
#include <inc/stdio.h>


int
vcprintf(const char *fmt, va_list ap)
{
  10075c:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
  10075f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100766:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
  100767:	ff 74 24 24          	pushl  0x24(%esp)
  10076b:	ff 74 24 24          	pushl  0x24(%esp)
  10076f:	8d 44 24 14          	lea    0x14(%esp),%eax
  100773:	50                   	push   %eax
  100774:	68 69 03 10 00       	push   $0x100369
  100779:	e8 61 03 00 00       	call   100adf <vprintfmt>
	return cnt;
}
  10077e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  100782:	83 c4 2c             	add    $0x2c,%esp
  100785:	c3                   	ret    

00100786 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  100786:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  100789:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vcprintf(fmt, ap);
  10078d:	52                   	push   %edx
  10078e:	52                   	push   %edx
  10078f:	50                   	push   %eax
  100790:	ff 74 24 1c          	pushl  0x1c(%esp)
  100794:	e8 c3 ff ff ff       	call   10075c <vcprintf>
	va_end(ap);

	return cnt;
}
  100799:	83 c4 1c             	add    $0x1c,%esp
  10079c:	c3                   	ret    
  10079d:	00 00                	add    %al,(%eax)
	...

001007a0 <mon_kerninfo>:
   *       provide you with those information.
   *       Use PROVIDE inside linker script and calculate the
   *       offset.
   */
	return 0;
}
  1007a0:	31 c0                	xor    %eax,%eax
  1007a2:	c3                   	ret    

001007a3 <mon_help>:
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))


int mon_help(int argc, char **argv)
{
  1007a3:	83 ec 10             	sub    $0x10,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  1007a6:	68 94 1c 10 00       	push   $0x101c94
  1007ab:	68 b2 1c 10 00       	push   $0x101cb2
  1007b0:	68 b7 1c 10 00       	push   $0x101cb7
  1007b5:	e8 cc ff ff ff       	call   100786 <cprintf>
  1007ba:	83 c4 0c             	add    $0xc,%esp
  1007bd:	68 c0 1c 10 00       	push   $0x101cc0
  1007c2:	68 e5 1c 10 00       	push   $0x101ce5
  1007c7:	68 b7 1c 10 00       	push   $0x101cb7
  1007cc:	e8 b5 ff ff ff       	call   100786 <cprintf>
  1007d1:	83 c4 0c             	add    $0xc,%esp
  1007d4:	68 ee 1c 10 00       	push   $0x101cee
  1007d9:	68 02 1d 10 00       	push   $0x101d02
  1007de:	68 b7 1c 10 00       	push   $0x101cb7
  1007e3:	e8 9e ff ff ff       	call   100786 <cprintf>
	return 0;
}
  1007e8:	31 c0                	xor    %eax,%eax
  1007ea:	83 c4 1c             	add    $0x1c,%esp
  1007ed:	c3                   	ret    

001007ee <print_tick>:
   *       offset.
   */
	return 0;
}
int print_tick(int argc, char **argv)
{
  1007ee:	83 ec 0c             	sub    $0xc,%esp
	cprintf("Now tick = %d\n", get_tick());
  1007f1:	e8 4b 01 00 00       	call   100941 <get_tick>
  1007f6:	c7 44 24 10 0d 1d 10 	movl   $0x101d0d,0x10(%esp)
  1007fd:	00 
  1007fe:	89 44 24 14          	mov    %eax,0x14(%esp)
}
  100802:	83 c4 0c             	add    $0xc,%esp
   */
	return 0;
}
int print_tick(int argc, char **argv)
{
	cprintf("Now tick = %d\n", get_tick());
  100805:	e9 7c ff ff ff       	jmp    100786 <cprintf>

0010080a <shell>:
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}
void shell()
{
  10080a:	55                   	push   %ebp
  10080b:	57                   	push   %edi
  10080c:	56                   	push   %esi
  10080d:	53                   	push   %ebx
  10080e:	83 ec 58             	sub    $0x58,%esp
	char *buf;
	cprintf("Welcome to the OSDI course!\n");
  100811:	68 1c 1d 10 00       	push   $0x101d1c
  100816:	e8 6b ff ff ff       	call   100786 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
  10081b:	c7 04 24 39 1d 10 00 	movl   $0x101d39,(%esp)
  100822:	e8 5f ff ff ff       	call   100786 <cprintf>
  100827:	83 c4 10             	add    $0x10,%esp
	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
  10082a:	89 e5                	mov    %esp,%ebp
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  10082c:	83 ec 0c             	sub    $0xc,%esp
  10082f:	68 5e 1d 10 00       	push   $0x101d5e
  100834:	e8 97 07 00 00       	call   100fd0 <readline>
		if (buf != NULL)
  100839:	83 c4 10             	add    $0x10,%esp
  10083c:	85 c0                	test   %eax,%eax
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  10083e:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
  100840:	74 ea                	je     10082c <shell+0x22>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
  100842:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  100849:	31 f6                	xor    %esi,%esi
  10084b:	eb 04                	jmp    100851 <shell+0x47>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
  10084d:	c6 03 00             	movb   $0x0,(%ebx)
  100850:	43                   	inc    %ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  100851:	8a 03                	mov    (%ebx),%al
  100853:	84 c0                	test   %al,%al
  100855:	74 17                	je     10086e <shell+0x64>
  100857:	52                   	push   %edx
  100858:	0f be c0             	movsbl %al,%eax
  10085b:	52                   	push   %edx
  10085c:	50                   	push   %eax
  10085d:	68 65 1d 10 00       	push   $0x101d65
  100862:	e8 8a 09 00 00       	call   1011f1 <strchr>
  100867:	83 c4 10             	add    $0x10,%esp
  10086a:	85 c0                	test   %eax,%eax
  10086c:	75 df                	jne    10084d <shell+0x43>
			*buf++ = 0;
		if (*buf == 0)
  10086e:	80 3b 00             	cmpb   $0x0,(%ebx)
  100871:	74 36                	je     1008a9 <shell+0x9f>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  100873:	83 fe 0f             	cmp    $0xf,%esi
  100876:	75 0b                	jne    100883 <shell+0x79>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  100878:	50                   	push   %eax
  100879:	50                   	push   %eax
  10087a:	6a 10                	push   $0x10
  10087c:	68 6a 1d 10 00       	push   $0x101d6a
  100881:	eb 7d                	jmp    100900 <shell+0xf6>
			return 0;
		}
		argv[argc++] = buf;
  100883:	89 1c b4             	mov    %ebx,(%esp,%esi,4)
  100886:	46                   	inc    %esi
  100887:	eb 01                	jmp    10088a <shell+0x80>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
  100889:	43                   	inc    %ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  10088a:	8a 03                	mov    (%ebx),%al
  10088c:	84 c0                	test   %al,%al
  10088e:	74 c1                	je     100851 <shell+0x47>
  100890:	57                   	push   %edi
  100891:	0f be c0             	movsbl %al,%eax
  100894:	57                   	push   %edi
  100895:	50                   	push   %eax
  100896:	68 65 1d 10 00       	push   $0x101d65
  10089b:	e8 51 09 00 00       	call   1011f1 <strchr>
  1008a0:	83 c4 10             	add    $0x10,%esp
  1008a3:	85 c0                	test   %eax,%eax
  1008a5:	74 e2                	je     100889 <shell+0x7f>
  1008a7:	eb a8                	jmp    100851 <shell+0x47>
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
  1008a9:	85 f6                	test   %esi,%esi
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  1008ab:	c7 04 b4 00 00 00 00 	movl   $0x0,(%esp,%esi,4)

	// Lookup and invoke the command
	if (argc == 0)
  1008b2:	0f 84 74 ff ff ff    	je     10082c <shell+0x22>
  1008b8:	bf a0 1d 10 00       	mov    $0x101da0,%edi
  1008bd:	31 db                	xor    %ebx,%ebx
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
  1008bf:	51                   	push   %ecx
  1008c0:	51                   	push   %ecx
  1008c1:	ff 37                	pushl  (%edi)
  1008c3:	83 c7 0c             	add    $0xc,%edi
  1008c6:	ff 74 24 0c          	pushl  0xc(%esp)
  1008ca:	e8 ab 08 00 00       	call   10117a <strcmp>
  1008cf:	83 c4 10             	add    $0x10,%esp
  1008d2:	85 c0                	test   %eax,%eax
  1008d4:	75 19                	jne    1008ef <shell+0xe5>
			return commands[i].func(argc, argv);
  1008d6:	6b db 0c             	imul   $0xc,%ebx,%ebx
  1008d9:	52                   	push   %edx
  1008da:	52                   	push   %edx
  1008db:	55                   	push   %ebp
  1008dc:	56                   	push   %esi
  1008dd:	ff 93 a8 1d 10 00    	call   *0x101da8(%ebx)
	while(1)
	{
		buf = readline("OSDI> ");
		if (buf != NULL)
		{
			if (runcmd(buf) < 0)
  1008e3:	83 c4 10             	add    $0x10,%esp
  1008e6:	85 c0                	test   %eax,%eax
  1008e8:	78 23                	js     10090d <shell+0x103>
  1008ea:	e9 3d ff ff ff       	jmp    10082c <shell+0x22>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  1008ef:	43                   	inc    %ebx
  1008f0:	83 fb 03             	cmp    $0x3,%ebx
  1008f3:	75 ca                	jne    1008bf <shell+0xb5>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  1008f5:	50                   	push   %eax
  1008f6:	50                   	push   %eax
  1008f7:	ff 74 24 08          	pushl  0x8(%esp)
  1008fb:	68 87 1d 10 00       	push   $0x101d87
  100900:	e8 81 fe ff ff       	call   100786 <cprintf>
  100905:	83 c4 10             	add    $0x10,%esp
  100908:	e9 1f ff ff ff       	jmp    10082c <shell+0x22>
		{
			if (runcmd(buf) < 0)
				break;
		}
	}
}
  10090d:	83 c4 4c             	add    $0x4c,%esp
  100910:	5b                   	pop    %ebx
  100911:	5e                   	pop    %esi
  100912:	5f                   	pop    %edi
  100913:	5d                   	pop    %ebp
  100914:	c3                   	ret    
  100915:	00 00                	add    %al,(%eax)
	...

00100918 <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
    int divisor = 1193180 / hz;       /* Calculate our divisor */
  100918:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
  10091d:	89 c8                	mov    %ecx,%eax
  10091f:	99                   	cltd   
  100920:	f7 7c 24 04          	idivl  0x4(%esp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100924:	ba 43 00 00 00       	mov    $0x43,%edx
  100929:	89 c1                	mov    %eax,%ecx
  10092b:	b0 36                	mov    $0x36,%al
  10092d:	ee                   	out    %al,(%dx)
  10092e:	b2 40                	mov    $0x40,%dl
  100930:	88 c8                	mov    %cl,%al
  100932:	ee                   	out    %al,(%dx)
    outb(0x43, 0x36);             /* Set our command byte 0x36 */
    outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
    outb(0x40, divisor >> 8);     /* Set high byte of divisor */
  100933:	89 c8                	mov    %ecx,%eax
  100935:	c1 f8 08             	sar    $0x8,%eax
  100938:	ee                   	out    %al,(%dx)
}
  100939:	c3                   	ret    

0010093a <timer_handler>:
/* 
 * Timer interrupt handler
 */
void timer_handler()
{
	jiffies++;
  10093a:	ff 05 3c b5 10 00    	incl   0x10b53c
}
  100940:	c3                   	ret    

00100941 <get_tick>:

unsigned long get_tick()
{
	return jiffies;
}
  100941:	a1 3c b5 10 00       	mov    0x10b53c,%eax
  100946:	c3                   	ret    

00100947 <timer_init>:
void timer_init()
{
  100947:	83 ec 0c             	sub    $0xc,%esp
	set_timer(TIME_HZ);
  10094a:	6a 64                	push   $0x64
  10094c:	e8 c7 ff ff ff       	call   100918 <set_timer>

	/* Enable interrupt */
        //IRQ_TIMER = 0
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_TIMER));
  100951:	50                   	push   %eax
  100952:	50                   	push   %eax
  100953:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  10095a:	25 fe ff 00 00       	and    $0xfffe,%eax
  10095f:	50                   	push   %eax
  100960:	e8 df f6 ff ff       	call   100044 <irq_setmask_8259A>
}
  100965:	83 c4 1c             	add    $0x1c,%esp
  100968:	c3                   	ret    
  100969:	00 00                	add    %al,(%eax)
  10096b:	00 00                	add    %al,(%eax)
  10096d:	00 00                	add    %al,(%eax)
	...

00100970 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  100970:	55                   	push   %ebp
  100971:	57                   	push   %edi
  100972:	56                   	push   %esi
  100973:	53                   	push   %ebx
  100974:	83 ec 3c             	sub    $0x3c,%esp
  100977:	89 c5                	mov    %eax,%ebp
  100979:	89 d6                	mov    %edx,%esi
  10097b:	8b 44 24 50          	mov    0x50(%esp),%eax
  10097f:	89 44 24 24          	mov    %eax,0x24(%esp)
  100983:	8b 54 24 54          	mov    0x54(%esp),%edx
  100987:	89 54 24 20          	mov    %edx,0x20(%esp)
  10098b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
  10098f:	8b 7c 24 60          	mov    0x60(%esp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  100993:	b8 00 00 00 00       	mov    $0x0,%eax
  100998:	39 d0                	cmp    %edx,%eax
  10099a:	72 13                	jb     1009af <printnum+0x3f>
  10099c:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  1009a0:	39 4c 24 58          	cmp    %ecx,0x58(%esp)
  1009a4:	76 09                	jbe    1009af <printnum+0x3f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  1009a6:	83 eb 01             	sub    $0x1,%ebx
  1009a9:	85 db                	test   %ebx,%ebx
  1009ab:	7f 63                	jg     100a10 <printnum+0xa0>
  1009ad:	eb 71                	jmp    100a20 <printnum+0xb0>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  1009af:	89 7c 24 10          	mov    %edi,0x10(%esp)
  1009b3:	83 eb 01             	sub    $0x1,%ebx
  1009b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1009ba:	8b 5c 24 58          	mov    0x58(%esp),%ebx
  1009be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1009c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  1009c6:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1009ca:	89 44 24 28          	mov    %eax,0x28(%esp)
  1009ce:	89 54 24 2c          	mov    %edx,0x2c(%esp)
  1009d2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1009d9:	00 
  1009da:	8b 54 24 24          	mov    0x24(%esp),%edx
  1009de:	89 14 24             	mov    %edx,(%esp)
  1009e1:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  1009e5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1009e9:	e8 d2 0a 00 00       	call   1014c0 <__udivdi3>
  1009ee:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  1009f2:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
  1009f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1009fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1009fe:	89 04 24             	mov    %eax,(%esp)
  100a01:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a05:	89 f2                	mov    %esi,%edx
  100a07:	89 e8                	mov    %ebp,%eax
  100a09:	e8 62 ff ff ff       	call   100970 <printnum>
  100a0e:	eb 10                	jmp    100a20 <printnum+0xb0>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  100a10:	89 74 24 04          	mov    %esi,0x4(%esp)
  100a14:	89 3c 24             	mov    %edi,(%esp)
  100a17:	ff d5                	call   *%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  100a19:	83 eb 01             	sub    $0x1,%ebx
  100a1c:	85 db                	test   %ebx,%ebx
  100a1e:	7f f0                	jg     100a10 <printnum+0xa0>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  100a20:	89 74 24 04          	mov    %esi,0x4(%esp)
  100a24:	8b 74 24 04          	mov    0x4(%esp),%esi
  100a28:	8b 44 24 58          	mov    0x58(%esp),%eax
  100a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a30:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100a37:	00 
  100a38:	8b 54 24 24          	mov    0x24(%esp),%edx
  100a3c:	89 14 24             	mov    %edx,(%esp)
  100a3f:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  100a43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100a47:	e8 84 0b 00 00       	call   1015d0 <__umoddi3>
  100a4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100a50:	0f be 80 c4 1d 10 00 	movsbl 0x101dc4(%eax),%eax
  100a57:	89 04 24             	mov    %eax,(%esp)
  100a5a:	ff d5                	call   *%ebp
}
  100a5c:	83 c4 3c             	add    $0x3c,%esp
  100a5f:	5b                   	pop    %ebx
  100a60:	5e                   	pop    %esi
  100a61:	5f                   	pop    %edi
  100a62:	5d                   	pop    %ebp
  100a63:	c3                   	ret    

00100a64 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100a64:	83 fa 01             	cmp    $0x1,%edx
  100a67:	7e 0d                	jle    100a76 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
  100a69:	8b 10                	mov    (%eax),%edx
  100a6b:	8d 4a 08             	lea    0x8(%edx),%ecx
  100a6e:	89 08                	mov    %ecx,(%eax)
  100a70:	8b 02                	mov    (%edx),%eax
  100a72:	8b 52 04             	mov    0x4(%edx),%edx
  100a75:	c3                   	ret    
	else if (lflag)
  100a76:	85 d2                	test   %edx,%edx
  100a78:	74 0f                	je     100a89 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  100a7a:	8b 10                	mov    (%eax),%edx
  100a7c:	8d 4a 04             	lea    0x4(%edx),%ecx
  100a7f:	89 08                	mov    %ecx,(%eax)
  100a81:	8b 02                	mov    (%edx),%eax
  100a83:	ba 00 00 00 00       	mov    $0x0,%edx
  100a88:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  100a89:	8b 10                	mov    (%eax),%edx
  100a8b:	8d 4a 04             	lea    0x4(%edx),%ecx
  100a8e:	89 08                	mov    %ecx,(%eax)
  100a90:	8b 02                	mov    (%edx),%eax
  100a92:	ba 00 00 00 00       	mov    $0x0,%edx
}
  100a97:	c3                   	ret    

00100a98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  100a98:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
  100a9c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  100aa0:	8b 10                	mov    (%eax),%edx
  100aa2:	3b 50 04             	cmp    0x4(%eax),%edx
  100aa5:	73 0b                	jae    100ab2 <sprintputch+0x1a>
		*b->buf++ = ch;
  100aa7:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  100aab:	88 0a                	mov    %cl,(%edx)
  100aad:	83 c2 01             	add    $0x1,%edx
  100ab0:	89 10                	mov    %edx,(%eax)
  100ab2:	f3 c3                	repz ret 

00100ab4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  100ab4:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;

	va_start(ap, fmt);
  100ab7:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  100abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100abf:	8b 44 24 28          	mov    0x28(%esp),%eax
  100ac3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ac7:	8b 44 24 24          	mov    0x24(%esp),%eax
  100acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100acf:	8b 44 24 20          	mov    0x20(%esp),%eax
  100ad3:	89 04 24             	mov    %eax,(%esp)
  100ad6:	e8 04 00 00 00       	call   100adf <vprintfmt>
	va_end(ap);
}
  100adb:	83 c4 1c             	add    $0x1c,%esp
  100ade:	c3                   	ret    

00100adf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  100adf:	55                   	push   %ebp
  100ae0:	57                   	push   %edi
  100ae1:	56                   	push   %esi
  100ae2:	53                   	push   %ebx
  100ae3:	83 ec 4c             	sub    $0x4c,%esp
  100ae6:	8b 6c 24 60          	mov    0x60(%esp),%ebp
  100aea:	8b 7c 24 64          	mov    0x64(%esp),%edi
  100aee:	8b 5c 24 68          	mov    0x68(%esp),%ebx
  100af2:	eb 11                	jmp    100b05 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  100af4:	85 c0                	test   %eax,%eax
  100af6:	0f 84 40 04 00 00    	je     100f3c <vprintfmt+0x45d>
				return;
			putch(ch, putdat);
  100afc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100b00:	89 04 24             	mov    %eax,(%esp)
  100b03:	ff d5                	call   *%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  100b05:	0f b6 03             	movzbl (%ebx),%eax
  100b08:	83 c3 01             	add    $0x1,%ebx
  100b0b:	83 f8 25             	cmp    $0x25,%eax
  100b0e:	75 e4                	jne    100af4 <vprintfmt+0x15>
  100b10:	c6 44 24 28 20       	movb   $0x20,0x28(%esp)
  100b15:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  100b1c:	00 
  100b1d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100b22:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%esp)
  100b29:	ff 
  100b2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  100b2f:	89 74 24 34          	mov    %esi,0x34(%esp)
  100b33:	eb 34                	jmp    100b69 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100b35:	8b 5c 24 24          	mov    0x24(%esp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  100b39:	c6 44 24 28 2d       	movb   $0x2d,0x28(%esp)
  100b3e:	eb 29                	jmp    100b69 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100b40:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  100b44:	c6 44 24 28 30       	movb   $0x30,0x28(%esp)
  100b49:	eb 1e                	jmp    100b69 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100b4b:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  100b4f:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100b56:	00 
  100b57:	eb 10                	jmp    100b69 <vprintfmt+0x8a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  100b59:	8b 44 24 34          	mov    0x34(%esp),%eax
  100b5d:	89 44 24 30          	mov    %eax,0x30(%esp)
  100b61:	c7 44 24 34 ff ff ff 	movl   $0xffffffff,0x34(%esp)
  100b68:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100b69:	0f b6 03             	movzbl (%ebx),%eax
  100b6c:	0f b6 d0             	movzbl %al,%edx
  100b6f:	8d 73 01             	lea    0x1(%ebx),%esi
  100b72:	89 74 24 24          	mov    %esi,0x24(%esp)
  100b76:	83 e8 23             	sub    $0x23,%eax
  100b79:	3c 55                	cmp    $0x55,%al
  100b7b:	0f 87 9c 03 00 00    	ja     100f1d <vprintfmt+0x43e>
  100b81:	0f b6 c0             	movzbl %al,%eax
  100b84:	ff 24 85 80 1e 10 00 	jmp    *0x101e80(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  100b8b:	83 ea 30             	sub    $0x30,%edx
  100b8e:	89 54 24 34          	mov    %edx,0x34(%esp)
				ch = *fmt;
  100b92:	8b 54 24 24          	mov    0x24(%esp),%edx
  100b96:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  100b99:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100b9c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  100ba0:	83 fa 09             	cmp    $0x9,%edx
  100ba3:	77 5b                	ja     100c00 <vprintfmt+0x121>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100ba5:	8b 74 24 34          	mov    0x34(%esp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  100ba9:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  100bac:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  100baf:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  100bb3:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  100bb6:	8d 50 d0             	lea    -0x30(%eax),%edx
  100bb9:	83 fa 09             	cmp    $0x9,%edx
  100bbc:	76 eb                	jbe    100ba9 <vprintfmt+0xca>
  100bbe:	89 74 24 34          	mov    %esi,0x34(%esp)
  100bc2:	eb 3c                	jmp    100c00 <vprintfmt+0x121>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  100bc4:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100bc8:	8d 50 04             	lea    0x4(%eax),%edx
  100bcb:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100bcf:	8b 00                	mov    (%eax),%eax
  100bd1:	89 44 24 34          	mov    %eax,0x34(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100bd5:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  100bd9:	eb 25                	jmp    100c00 <vprintfmt+0x121>

		case '.':
			if (width < 0)
  100bdb:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100be0:	0f 88 65 ff ff ff    	js     100b4b <vprintfmt+0x6c>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100be6:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100bea:	e9 7a ff ff ff       	jmp    100b69 <vprintfmt+0x8a>
  100bef:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  100bf3:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
  100bfa:	00 
			goto reswitch;
  100bfb:	e9 69 ff ff ff       	jmp    100b69 <vprintfmt+0x8a>

		process_precision:
			if (width < 0)
  100c00:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100c05:	0f 89 5e ff ff ff    	jns    100b69 <vprintfmt+0x8a>
  100c0b:	e9 49 ff ff ff       	jmp    100b59 <vprintfmt+0x7a>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  100c10:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c13:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100c17:	e9 4d ff ff ff       	jmp    100b69 <vprintfmt+0x8a>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  100c1c:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100c20:	8d 50 04             	lea    0x4(%eax),%edx
  100c23:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100c27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100c2b:	8b 00                	mov    (%eax),%eax
  100c2d:	89 04 24             	mov    %eax,(%esp)
  100c30:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c32:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  100c36:	e9 ca fe ff ff       	jmp    100b05 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  100c3b:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100c3f:	8d 50 04             	lea    0x4(%eax),%edx
  100c42:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100c46:	8b 00                	mov    (%eax),%eax
  100c48:	89 c2                	mov    %eax,%edx
  100c4a:	c1 fa 1f             	sar    $0x1f,%edx
  100c4d:	31 d0                	xor    %edx,%eax
  100c4f:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  100c51:	83 f8 08             	cmp    $0x8,%eax
  100c54:	7f 0b                	jg     100c61 <vprintfmt+0x182>
  100c56:	8b 14 85 e0 1f 10 00 	mov    0x101fe0(,%eax,4),%edx
  100c5d:	85 d2                	test   %edx,%edx
  100c5f:	75 21                	jne    100c82 <vprintfmt+0x1a3>
				printfmt(putch, putdat, "error %d", err);
  100c61:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100c65:	c7 44 24 08 dc 1d 10 	movl   $0x101ddc,0x8(%esp)
  100c6c:	00 
  100c6d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100c71:	89 2c 24             	mov    %ebp,(%esp)
  100c74:	e8 3b fe ff ff       	call   100ab4 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c79:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  100c7d:	e9 83 fe ff ff       	jmp    100b05 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  100c82:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100c86:	c7 44 24 08 e5 1d 10 	movl   $0x101de5,0x8(%esp)
  100c8d:	00 
  100c8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100c92:	89 2c 24             	mov    %ebp,(%esp)
  100c95:	e8 1a fe ff ff       	call   100ab4 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c9a:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100c9e:	e9 62 fe ff ff       	jmp    100b05 <vprintfmt+0x26>
  100ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  100ca7:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100cab:	8b 44 24 30          	mov    0x30(%esp),%eax
  100caf:	89 44 24 38          	mov    %eax,0x38(%esp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  100cb3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100cb7:	8d 50 04             	lea    0x4(%eax),%edx
  100cba:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100cbe:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  100cc0:	85 c0                	test   %eax,%eax
  100cc2:	ba d5 1d 10 00       	mov    $0x101dd5,%edx
  100cc7:	0f 45 d0             	cmovne %eax,%edx
  100cca:	89 54 24 34          	mov    %edx,0x34(%esp)
			if (width > 0 && padc != '-')
  100cce:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  100cd3:	7e 07                	jle    100cdc <vprintfmt+0x1fd>
  100cd5:	80 7c 24 28 2d       	cmpb   $0x2d,0x28(%esp)
  100cda:	75 14                	jne    100cf0 <vprintfmt+0x211>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100cdc:	8b 54 24 34          	mov    0x34(%esp),%edx
  100ce0:	0f be 02             	movsbl (%edx),%eax
  100ce3:	85 c0                	test   %eax,%eax
  100ce5:	0f 85 ac 00 00 00    	jne    100d97 <vprintfmt+0x2b8>
  100ceb:	e9 97 00 00 00       	jmp    100d87 <vprintfmt+0x2a8>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100cf0:	89 74 24 04          	mov    %esi,0x4(%esp)
  100cf4:	8b 44 24 34          	mov    0x34(%esp),%eax
  100cf8:	89 04 24             	mov    %eax,(%esp)
  100cfb:	e8 99 03 00 00       	call   101099 <strnlen>
  100d00:	8b 54 24 38          	mov    0x38(%esp),%edx
  100d04:	29 c2                	sub    %eax,%edx
  100d06:	89 54 24 30          	mov    %edx,0x30(%esp)
  100d0a:	85 d2                	test   %edx,%edx
  100d0c:	7e ce                	jle    100cdc <vprintfmt+0x1fd>
					putch(padc, putdat);
  100d0e:	0f be 44 24 28       	movsbl 0x28(%esp),%eax
  100d13:	89 74 24 38          	mov    %esi,0x38(%esp)
  100d17:	89 5c 24 3c          	mov    %ebx,0x3c(%esp)
  100d1b:	89 d3                	mov    %edx,%ebx
  100d1d:	89 c6                	mov    %eax,%esi
  100d1f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d23:	89 34 24             	mov    %esi,(%esp)
  100d26:	ff d5                	call   *%ebp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100d28:	83 eb 01             	sub    $0x1,%ebx
  100d2b:	85 db                	test   %ebx,%ebx
  100d2d:	7f f0                	jg     100d1f <vprintfmt+0x240>
  100d2f:	8b 74 24 38          	mov    0x38(%esp),%esi
  100d33:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
  100d37:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100d3e:	00 
  100d3f:	eb 9b                	jmp    100cdc <vprintfmt+0x1fd>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  100d41:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100d46:	74 19                	je     100d61 <vprintfmt+0x282>
  100d48:	8d 50 e0             	lea    -0x20(%eax),%edx
  100d4b:	83 fa 5e             	cmp    $0x5e,%edx
  100d4e:	76 11                	jbe    100d61 <vprintfmt+0x282>
					putch('?', putdat);
  100d50:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d54:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  100d5b:	ff 54 24 28          	call   *0x28(%esp)
  100d5f:	eb 0b                	jmp    100d6c <vprintfmt+0x28d>
				else
					putch(ch, putdat);
  100d61:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d65:	89 04 24             	mov    %eax,(%esp)
  100d68:	ff 54 24 28          	call   *0x28(%esp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100d6c:	83 ed 01             	sub    $0x1,%ebp
  100d6f:	0f be 03             	movsbl (%ebx),%eax
  100d72:	85 c0                	test   %eax,%eax
  100d74:	74 05                	je     100d7b <vprintfmt+0x29c>
  100d76:	83 c3 01             	add    $0x1,%ebx
  100d79:	eb 31                	jmp    100dac <vprintfmt+0x2cd>
  100d7b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
  100d7f:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  100d83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100d87:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100d8c:	7f 35                	jg     100dc3 <vprintfmt+0x2e4>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100d8e:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100d92:	e9 6e fd ff ff       	jmp    100b05 <vprintfmt+0x26>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100d97:	8b 54 24 34          	mov    0x34(%esp),%edx
  100d9b:	83 c2 01             	add    $0x1,%edx
  100d9e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
  100da2:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  100da6:	89 5c 24 38          	mov    %ebx,0x38(%esp)
  100daa:	89 d3                	mov    %edx,%ebx
  100dac:	85 f6                	test   %esi,%esi
  100dae:	78 91                	js     100d41 <vprintfmt+0x262>
  100db0:	83 ee 01             	sub    $0x1,%esi
  100db3:	79 8c                	jns    100d41 <vprintfmt+0x262>
  100db5:	89 6c 24 30          	mov    %ebp,0x30(%esp)
  100db9:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  100dbd:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  100dc1:	eb c4                	jmp    100d87 <vprintfmt+0x2a8>
  100dc3:	89 de                	mov    %ebx,%esi
  100dc5:	8b 5c 24 30          	mov    0x30(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  100dc9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100dcd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100dd4:	ff d5                	call   *%ebp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100dd6:	83 eb 01             	sub    $0x1,%ebx
  100dd9:	85 db                	test   %ebx,%ebx
  100ddb:	7f ec                	jg     100dc9 <vprintfmt+0x2ea>
  100ddd:	89 f3                	mov    %esi,%ebx
  100ddf:	e9 21 fd ff ff       	jmp    100b05 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100de4:	83 f9 01             	cmp    $0x1,%ecx
  100de7:	7e 12                	jle    100dfb <vprintfmt+0x31c>
		return va_arg(*ap, long long);
  100de9:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100ded:	8d 50 08             	lea    0x8(%eax),%edx
  100df0:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100df4:	8b 18                	mov    (%eax),%ebx
  100df6:	8b 70 04             	mov    0x4(%eax),%esi
  100df9:	eb 2a                	jmp    100e25 <vprintfmt+0x346>
	else if (lflag)
  100dfb:	85 c9                	test   %ecx,%ecx
  100dfd:	74 14                	je     100e13 <vprintfmt+0x334>
		return va_arg(*ap, long);
  100dff:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100e03:	8d 50 04             	lea    0x4(%eax),%edx
  100e06:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100e0a:	8b 18                	mov    (%eax),%ebx
  100e0c:	89 de                	mov    %ebx,%esi
  100e0e:	c1 fe 1f             	sar    $0x1f,%esi
  100e11:	eb 12                	jmp    100e25 <vprintfmt+0x346>
	else
		return va_arg(*ap, int);
  100e13:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100e17:	8d 50 04             	lea    0x4(%eax),%edx
  100e1a:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100e1e:	8b 18                	mov    (%eax),%ebx
  100e20:	89 de                	mov    %ebx,%esi
  100e22:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  100e25:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  100e2a:	85 f6                	test   %esi,%esi
  100e2c:	0f 89 ab 00 00 00    	jns    100edd <vprintfmt+0x3fe>
				putch('-', putdat);
  100e32:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e36:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  100e3d:	ff d5                	call   *%ebp
				num = -(long long) num;
  100e3f:	f7 db                	neg    %ebx
  100e41:	83 d6 00             	adc    $0x0,%esi
  100e44:	f7 de                	neg    %esi
			}
			base = 10;
  100e46:	b8 0a 00 00 00       	mov    $0xa,%eax
  100e4b:	e9 8d 00 00 00       	jmp    100edd <vprintfmt+0x3fe>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  100e50:	89 ca                	mov    %ecx,%edx
  100e52:	8d 44 24 6c          	lea    0x6c(%esp),%eax
  100e56:	e8 09 fc ff ff       	call   100a64 <getuint>
  100e5b:	89 c3                	mov    %eax,%ebx
  100e5d:	89 d6                	mov    %edx,%esi
			base = 10;
  100e5f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  100e64:	eb 77                	jmp    100edd <vprintfmt+0x3fe>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  100e66:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e6a:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100e71:	ff d5                	call   *%ebp
			putch('X', putdat);
  100e73:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e77:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100e7e:	ff d5                	call   *%ebp
			putch('X', putdat);
  100e80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e84:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100e8b:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100e8d:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
  100e91:	e9 6f fc ff ff       	jmp    100b05 <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
  100e96:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e9a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  100ea1:	ff d5                	call   *%ebp
			putch('x', putdat);
  100ea3:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ea7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  100eae:	ff d5                	call   *%ebp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  100eb0:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100eb4:	8d 50 04             	lea    0x4(%eax),%edx
  100eb7:	89 54 24 6c          	mov    %edx,0x6c(%esp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  100ebb:	8b 18                	mov    (%eax),%ebx
  100ebd:	be 00 00 00 00       	mov    $0x0,%esi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  100ec2:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  100ec7:	eb 14                	jmp    100edd <vprintfmt+0x3fe>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  100ec9:	89 ca                	mov    %ecx,%edx
  100ecb:	8d 44 24 6c          	lea    0x6c(%esp),%eax
  100ecf:	e8 90 fb ff ff       	call   100a64 <getuint>
  100ed4:	89 c3                	mov    %eax,%ebx
  100ed6:	89 d6                	mov    %edx,%esi
			base = 16;
  100ed8:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  100edd:	0f be 54 24 28       	movsbl 0x28(%esp),%edx
  100ee2:	89 54 24 10          	mov    %edx,0x10(%esp)
  100ee6:	8b 54 24 30          	mov    0x30(%esp),%edx
  100eea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100eee:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ef2:	89 1c 24             	mov    %ebx,(%esp)
  100ef5:	89 74 24 04          	mov    %esi,0x4(%esp)
  100ef9:	89 fa                	mov    %edi,%edx
  100efb:	89 e8                	mov    %ebp,%eax
  100efd:	e8 6e fa ff ff       	call   100970 <printnum>
			break;
  100f02:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100f06:	e9 fa fb ff ff       	jmp    100b05 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  100f0b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f0f:	89 14 24             	mov    %edx,(%esp)
  100f12:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100f14:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  100f18:	e9 e8 fb ff ff       	jmp    100b05 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  100f1d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f21:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  100f28:	ff d5                	call   *%ebp
			for (fmt--; fmt[-1] != '%'; fmt--)
  100f2a:	eb 02                	jmp    100f2e <vprintfmt+0x44f>
  100f2c:	89 c3                	mov    %eax,%ebx
  100f2e:	8d 43 ff             	lea    -0x1(%ebx),%eax
  100f31:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  100f35:	75 f5                	jne    100f2c <vprintfmt+0x44d>
  100f37:	e9 c9 fb ff ff       	jmp    100b05 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  100f3c:	83 c4 4c             	add    $0x4c,%esp
  100f3f:	5b                   	pop    %ebx
  100f40:	5e                   	pop    %esi
  100f41:	5f                   	pop    %edi
  100f42:	5d                   	pop    %ebp
  100f43:	c3                   	ret    

00100f44 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  100f44:	83 ec 2c             	sub    $0x2c,%esp
  100f47:	8b 44 24 30          	mov    0x30(%esp),%eax
  100f4b:	8b 54 24 34          	mov    0x34(%esp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  100f4f:	89 44 24 14          	mov    %eax,0x14(%esp)
  100f53:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  100f57:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  100f5b:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  100f62:	00 

	if (buf == NULL || n < 1)
  100f63:	85 c0                	test   %eax,%eax
  100f65:	74 35                	je     100f9c <vsnprintf+0x58>
  100f67:	85 d2                	test   %edx,%edx
  100f69:	7e 31                	jle    100f9c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  100f6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  100f6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100f73:	8b 44 24 38          	mov    0x38(%esp),%eax
  100f77:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f7b:	8d 44 24 14          	lea    0x14(%esp),%eax
  100f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f83:	c7 04 24 98 0a 10 00 	movl   $0x100a98,(%esp)
  100f8a:	e8 50 fb ff ff       	call   100adf <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  100f8f:	8b 44 24 14          	mov    0x14(%esp),%eax
  100f93:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  100f96:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  100f9a:	eb 05                	jmp    100fa1 <vsnprintf+0x5d>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  100f9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  100fa1:	83 c4 2c             	add    $0x2c,%esp
  100fa4:	c3                   	ret    

00100fa5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  100fa5:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  100fa8:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  100fac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100fb0:	8b 44 24 28          	mov    0x28(%esp),%eax
  100fb4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100fb8:	8b 44 24 24          	mov    0x24(%esp),%eax
  100fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100fc0:	8b 44 24 20          	mov    0x20(%esp),%eax
  100fc4:	89 04 24             	mov    %eax,(%esp)
  100fc7:	e8 78 ff ff ff       	call   100f44 <vsnprintf>
	va_end(ap);

	return rc;
}
  100fcc:	83 c4 1c             	add    $0x1c,%esp
  100fcf:	c3                   	ret    

00100fd0 <readline>:

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  100fd0:	56                   	push   %esi
  100fd1:	53                   	push   %ebx
  100fd2:	83 ec 14             	sub    $0x14,%esp
  100fd5:	8b 44 24 20          	mov    0x20(%esp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  100fd9:	85 c0                	test   %eax,%eax
  100fdb:	74 10                	je     100fed <readline+0x1d>
		cprintf("%s", prompt);
  100fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100fe1:	c7 04 24 e5 1d 10 00 	movl   $0x101de5,(%esp)
  100fe8:	e8 99 f7 ff ff       	call   100786 <cprintf>

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  100fed:	be 00 00 00 00       	mov    $0x0,%esi
	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
	while (1) {
		c = getc();
  100ff2:	e8 74 f2 ff ff       	call   10026b <getc>
  100ff7:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  100ff9:	85 c0                	test   %eax,%eax
  100ffb:	79 17                	jns    101014 <readline+0x44>
			cprintf("read error: %e\n", c);
  100ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101001:	c7 04 24 04 20 10 00 	movl   $0x102004,(%esp)
  101008:	e8 79 f7 ff ff       	call   100786 <cprintf>
			return NULL;
  10100d:	b8 00 00 00 00       	mov    $0x0,%eax
  101012:	eb 64                	jmp    101078 <readline+0xa8>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  101014:	83 f8 08             	cmp    $0x8,%eax
  101017:	74 05                	je     10101e <readline+0x4e>
  101019:	83 f8 7f             	cmp    $0x7f,%eax
  10101c:	75 15                	jne    101033 <readline+0x63>
  10101e:	85 f6                	test   %esi,%esi
  101020:	7e 11                	jle    101033 <readline+0x63>
			putch('\b');
  101022:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101029:	e8 3b f3 ff ff       	call   100369 <putch>
			i--;
  10102e:	83 ee 01             	sub    $0x1,%esi
  101031:	eb bf                	jmp    100ff2 <readline+0x22>
		} else if (c >= ' ' && i < BUFLEN-1) {
  101033:	83 fb 1f             	cmp    $0x1f,%ebx
  101036:	7e 1e                	jle    101056 <readline+0x86>
  101038:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  10103e:	7f 16                	jg     101056 <readline+0x86>
			putch(c);
  101040:	0f b6 c3             	movzbl %bl,%eax
  101043:	89 04 24             	mov    %eax,(%esp)
  101046:	e8 1e f3 ff ff       	call   100369 <putch>
			buf[i++] = c;
  10104b:	88 9e 40 b5 10 00    	mov    %bl,0x10b540(%esi)
  101051:	83 c6 01             	add    $0x1,%esi
  101054:	eb 9c                	jmp    100ff2 <readline+0x22>
		} else if (c == '\n' || c == '\r') {
  101056:	83 fb 0a             	cmp    $0xa,%ebx
  101059:	74 05                	je     101060 <readline+0x90>
  10105b:	83 fb 0d             	cmp    $0xd,%ebx
  10105e:	75 92                	jne    100ff2 <readline+0x22>
			putch('\n');
  101060:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  101067:	e8 fd f2 ff ff       	call   100369 <putch>
			buf[i] = 0;
  10106c:	c6 86 40 b5 10 00 00 	movb   $0x0,0x10b540(%esi)
			return buf;
  101073:	b8 40 b5 10 00       	mov    $0x10b540,%eax
		}
	}
}
  101078:	83 c4 14             	add    $0x14,%esp
  10107b:	5b                   	pop    %ebx
  10107c:	5e                   	pop    %esi
  10107d:	c3                   	ret    
	...

00101080 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  101080:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  101084:	b8 00 00 00 00       	mov    $0x0,%eax
  101089:	80 3a 00             	cmpb   $0x0,(%edx)
  10108c:	74 09                	je     101097 <strlen+0x17>
		n++;
  10108e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  101091:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  101095:	75 f7                	jne    10108e <strlen+0xe>
		n++;
	return n;
}
  101097:	f3 c3                	repz ret 

00101099 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  101099:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10109d:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  1010a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1010a6:	85 d2                	test   %edx,%edx
  1010a8:	74 12                	je     1010bc <strnlen+0x23>
  1010aa:	80 39 00             	cmpb   $0x0,(%ecx)
  1010ad:	74 0d                	je     1010bc <strnlen+0x23>
		n++;
  1010af:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  1010b2:	39 d0                	cmp    %edx,%eax
  1010b4:	74 06                	je     1010bc <strnlen+0x23>
  1010b6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  1010ba:	75 f3                	jne    1010af <strnlen+0x16>
		n++;
	return n;
}
  1010bc:	f3 c3                	repz ret 

001010be <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  1010be:	53                   	push   %ebx
  1010bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  1010c3:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  1010c7:	ba 00 00 00 00       	mov    $0x0,%edx
  1010cc:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  1010d0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1010d3:	83 c2 01             	add    $0x1,%edx
  1010d6:	84 c9                	test   %cl,%cl
  1010d8:	75 f2                	jne    1010cc <strcpy+0xe>
		/* do nothing */;
	return ret;
}
  1010da:	5b                   	pop    %ebx
  1010db:	c3                   	ret    

001010dc <strcat>:

char *
strcat(char *dst, const char *src)
{
  1010dc:	53                   	push   %ebx
  1010dd:	83 ec 08             	sub    $0x8,%esp
  1010e0:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int len = strlen(dst);
  1010e4:	89 1c 24             	mov    %ebx,(%esp)
  1010e7:	e8 94 ff ff ff       	call   101080 <strlen>
	strcpy(dst + len, src);
  1010ec:	8b 54 24 14          	mov    0x14(%esp),%edx
  1010f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1010f4:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  1010f7:	89 04 24             	mov    %eax,(%esp)
  1010fa:	e8 bf ff ff ff       	call   1010be <strcpy>
	return dst;
}
  1010ff:	89 d8                	mov    %ebx,%eax
  101101:	83 c4 08             	add    $0x8,%esp
  101104:	5b                   	pop    %ebx
  101105:	c3                   	ret    

00101106 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  101106:	56                   	push   %esi
  101107:	53                   	push   %ebx
  101108:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10110c:	8b 54 24 10          	mov    0x10(%esp),%edx
  101110:	8b 74 24 14          	mov    0x14(%esp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  101114:	85 f6                	test   %esi,%esi
  101116:	74 18                	je     101130 <strncpy+0x2a>
  101118:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  10111d:	0f b6 1a             	movzbl (%edx),%ebx
  101120:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  101123:	80 3a 01             	cmpb   $0x1,(%edx)
  101126:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  101129:	83 c1 01             	add    $0x1,%ecx
  10112c:	39 ce                	cmp    %ecx,%esi
  10112e:	77 ed                	ja     10111d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  101130:	5b                   	pop    %ebx
  101131:	5e                   	pop    %esi
  101132:	c3                   	ret    

00101133 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  101133:	57                   	push   %edi
  101134:	56                   	push   %esi
  101135:	53                   	push   %ebx
  101136:	8b 7c 24 10          	mov    0x10(%esp),%edi
  10113a:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  10113e:	8b 74 24 18          	mov    0x18(%esp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  101142:	89 f8                	mov    %edi,%eax
  101144:	85 f6                	test   %esi,%esi
  101146:	74 2c                	je     101174 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  101148:	83 fe 01             	cmp    $0x1,%esi
  10114b:	74 24                	je     101171 <strlcpy+0x3e>
  10114d:	0f b6 0b             	movzbl (%ebx),%ecx
  101150:	84 c9                	test   %cl,%cl
  101152:	74 1d                	je     101171 <strlcpy+0x3e>
  101154:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  101159:	83 ee 02             	sub    $0x2,%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  10115c:	88 08                	mov    %cl,(%eax)
  10115e:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  101161:	39 f2                	cmp    %esi,%edx
  101163:	74 0c                	je     101171 <strlcpy+0x3e>
  101165:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
  10116a:	83 c2 01             	add    $0x1,%edx
  10116d:	84 c9                	test   %cl,%cl
  10116f:	75 eb                	jne    10115c <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  101171:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  101174:	29 f8                	sub    %edi,%eax
}
  101176:	5b                   	pop    %ebx
  101177:	5e                   	pop    %esi
  101178:	5f                   	pop    %edi
  101179:	c3                   	ret    

0010117a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  10117a:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10117e:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
  101182:	0f b6 01             	movzbl (%ecx),%eax
  101185:	84 c0                	test   %al,%al
  101187:	74 15                	je     10119e <strcmp+0x24>
  101189:	3a 02                	cmp    (%edx),%al
  10118b:	75 11                	jne    10119e <strcmp+0x24>
		p++, q++;
  10118d:	83 c1 01             	add    $0x1,%ecx
  101190:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  101193:	0f b6 01             	movzbl (%ecx),%eax
  101196:	84 c0                	test   %al,%al
  101198:	74 04                	je     10119e <strcmp+0x24>
  10119a:	3a 02                	cmp    (%edx),%al
  10119c:	74 ef                	je     10118d <strcmp+0x13>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  10119e:	0f b6 c0             	movzbl %al,%eax
  1011a1:	0f b6 12             	movzbl (%edx),%edx
  1011a4:	29 d0                	sub    %edx,%eax
}
  1011a6:	c3                   	ret    

001011a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  1011a7:	53                   	push   %ebx
  1011a8:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1011ac:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  1011b0:	8b 54 24 10          	mov    0x10(%esp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  1011b4:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  1011b9:	85 d2                	test   %edx,%edx
  1011bb:	74 28                	je     1011e5 <strncmp+0x3e>
  1011bd:	0f b6 01             	movzbl (%ecx),%eax
  1011c0:	84 c0                	test   %al,%al
  1011c2:	74 23                	je     1011e7 <strncmp+0x40>
  1011c4:	3a 03                	cmp    (%ebx),%al
  1011c6:	75 1f                	jne    1011e7 <strncmp+0x40>
  1011c8:	83 ea 01             	sub    $0x1,%edx
  1011cb:	74 13                	je     1011e0 <strncmp+0x39>
		n--, p++, q++;
  1011cd:	83 c1 01             	add    $0x1,%ecx
  1011d0:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  1011d3:	0f b6 01             	movzbl (%ecx),%eax
  1011d6:	84 c0                	test   %al,%al
  1011d8:	74 0d                	je     1011e7 <strncmp+0x40>
  1011da:	3a 03                	cmp    (%ebx),%al
  1011dc:	74 ea                	je     1011c8 <strncmp+0x21>
  1011de:	eb 07                	jmp    1011e7 <strncmp+0x40>
		n--, p++, q++;
	if (n == 0)
		return 0;
  1011e0:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  1011e5:	5b                   	pop    %ebx
  1011e6:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  1011e7:	0f b6 01             	movzbl (%ecx),%eax
  1011ea:	0f b6 13             	movzbl (%ebx),%edx
  1011ed:	29 d0                	sub    %edx,%eax
  1011ef:	eb f4                	jmp    1011e5 <strncmp+0x3e>

001011f1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  1011f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  1011f5:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
  1011fa:	0f b6 10             	movzbl (%eax),%edx
  1011fd:	84 d2                	test   %dl,%dl
  1011ff:	74 21                	je     101222 <strchr+0x31>
		if (*s == c)
  101201:	38 ca                	cmp    %cl,%dl
  101203:	75 0d                	jne    101212 <strchr+0x21>
  101205:	f3 c3                	repz ret 
  101207:	38 ca                	cmp    %cl,%dl
  101209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101210:	74 15                	je     101227 <strchr+0x36>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  101212:	83 c0 01             	add    $0x1,%eax
  101215:	0f b6 10             	movzbl (%eax),%edx
  101218:	84 d2                	test   %dl,%dl
  10121a:	75 eb                	jne    101207 <strchr+0x16>
		if (*s == c)
			return (char *) s;
	return 0;
  10121c:	b8 00 00 00 00       	mov    $0x0,%eax
  101221:	c3                   	ret    
  101222:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101227:	f3 c3                	repz ret 

00101229 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  101229:	8b 44 24 04          	mov    0x4(%esp),%eax
  10122d:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
  101232:	0f b6 10             	movzbl (%eax),%edx
  101235:	84 d2                	test   %dl,%dl
  101237:	74 14                	je     10124d <strfind+0x24>
		if (*s == c)
  101239:	38 ca                	cmp    %cl,%dl
  10123b:	75 06                	jne    101243 <strfind+0x1a>
  10123d:	f3 c3                	repz ret 
  10123f:	38 ca                	cmp    %cl,%dl
  101241:	74 0a                	je     10124d <strfind+0x24>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  101243:	83 c0 01             	add    $0x1,%eax
  101246:	0f b6 10             	movzbl (%eax),%edx
  101249:	84 d2                	test   %dl,%dl
  10124b:	75 f2                	jne    10123f <strfind+0x16>
		if (*s == c)
			break;
	return (char *) s;
}
  10124d:	f3 c3                	repz ret 

0010124f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  10124f:	83 ec 0c             	sub    $0xc,%esp
  101252:	89 1c 24             	mov    %ebx,(%esp)
  101255:	89 74 24 04          	mov    %esi,0x4(%esp)
  101259:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10125d:	8b 7c 24 10          	mov    0x10(%esp),%edi
  101261:	8b 44 24 14          	mov    0x14(%esp),%eax
  101265:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	char *p;

	if (n == 0)
  101269:	85 c9                	test   %ecx,%ecx
  10126b:	74 30                	je     10129d <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  10126d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101273:	75 25                	jne    10129a <memset+0x4b>
  101275:	f6 c1 03             	test   $0x3,%cl
  101278:	75 20                	jne    10129a <memset+0x4b>
		c &= 0xFF;
  10127a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  10127d:	89 d3                	mov    %edx,%ebx
  10127f:	c1 e3 08             	shl    $0x8,%ebx
  101282:	89 d6                	mov    %edx,%esi
  101284:	c1 e6 18             	shl    $0x18,%esi
  101287:	89 d0                	mov    %edx,%eax
  101289:	c1 e0 10             	shl    $0x10,%eax
  10128c:	09 f0                	or     %esi,%eax
  10128e:	09 d0                	or     %edx,%eax
  101290:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  101292:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  101295:	fc                   	cld    
  101296:	f3 ab                	rep stos %eax,%es:(%edi)
  101298:	eb 03                	jmp    10129d <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  10129a:	fc                   	cld    
  10129b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  10129d:	89 f8                	mov    %edi,%eax
  10129f:	8b 1c 24             	mov    (%esp),%ebx
  1012a2:	8b 74 24 04          	mov    0x4(%esp),%esi
  1012a6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  1012aa:	83 c4 0c             	add    $0xc,%esp
  1012ad:	c3                   	ret    

001012ae <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  1012ae:	83 ec 08             	sub    $0x8,%esp
  1012b1:	89 34 24             	mov    %esi,(%esp)
  1012b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1012b8:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1012bc:	8b 74 24 10          	mov    0x10(%esp),%esi
  1012c0:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  1012c4:	39 c6                	cmp    %eax,%esi
  1012c6:	73 36                	jae    1012fe <memmove+0x50>
  1012c8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  1012cb:	39 d0                	cmp    %edx,%eax
  1012cd:	73 2f                	jae    1012fe <memmove+0x50>
		s += n;
		d += n;
  1012cf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  1012d2:	f6 c2 03             	test   $0x3,%dl
  1012d5:	75 1b                	jne    1012f2 <memmove+0x44>
  1012d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  1012dd:	75 13                	jne    1012f2 <memmove+0x44>
  1012df:	f6 c1 03             	test   $0x3,%cl
  1012e2:	75 0e                	jne    1012f2 <memmove+0x44>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  1012e4:	83 ef 04             	sub    $0x4,%edi
  1012e7:	8d 72 fc             	lea    -0x4(%edx),%esi
  1012ea:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  1012ed:	fd                   	std    
  1012ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1012f0:	eb 09                	jmp    1012fb <memmove+0x4d>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  1012f2:	83 ef 01             	sub    $0x1,%edi
  1012f5:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  1012f8:	fd                   	std    
  1012f9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  1012fb:	fc                   	cld    
  1012fc:	eb 20                	jmp    10131e <memmove+0x70>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  1012fe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  101304:	75 13                	jne    101319 <memmove+0x6b>
  101306:	a8 03                	test   $0x3,%al
  101308:	75 0f                	jne    101319 <memmove+0x6b>
  10130a:	f6 c1 03             	test   $0x3,%cl
  10130d:	75 0a                	jne    101319 <memmove+0x6b>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  10130f:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  101312:	89 c7                	mov    %eax,%edi
  101314:	fc                   	cld    
  101315:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101317:	eb 05                	jmp    10131e <memmove+0x70>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  101319:	89 c7                	mov    %eax,%edi
  10131b:	fc                   	cld    
  10131c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  10131e:	8b 34 24             	mov    (%esp),%esi
  101321:	8b 7c 24 04          	mov    0x4(%esp),%edi
  101325:	83 c4 08             	add    $0x8,%esp
  101328:	c3                   	ret    

00101329 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  101329:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  10132c:	8b 44 24 18          	mov    0x18(%esp),%eax
  101330:	89 44 24 08          	mov    %eax,0x8(%esp)
  101334:	8b 44 24 14          	mov    0x14(%esp),%eax
  101338:	89 44 24 04          	mov    %eax,0x4(%esp)
  10133c:	8b 44 24 10          	mov    0x10(%esp),%eax
  101340:	89 04 24             	mov    %eax,(%esp)
  101343:	e8 66 ff ff ff       	call   1012ae <memmove>
}
  101348:	83 c4 0c             	add    $0xc,%esp
  10134b:	c3                   	ret    

0010134c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  10134c:	57                   	push   %edi
  10134d:	56                   	push   %esi
  10134e:	53                   	push   %ebx
  10134f:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  101353:	8b 74 24 14          	mov    0x14(%esp),%esi
  101357:	8b 7c 24 18          	mov    0x18(%esp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  10135b:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  101360:	85 ff                	test   %edi,%edi
  101362:	74 38                	je     10139c <memcmp+0x50>
		if (*s1 != *s2)
  101364:	0f b6 03             	movzbl (%ebx),%eax
  101367:	0f b6 0e             	movzbl (%esi),%ecx
  10136a:	38 c8                	cmp    %cl,%al
  10136c:	74 1d                	je     10138b <memcmp+0x3f>
  10136e:	eb 11                	jmp    101381 <memcmp+0x35>
  101370:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  101375:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  10137a:	83 c2 01             	add    $0x1,%edx
  10137d:	38 c8                	cmp    %cl,%al
  10137f:	74 12                	je     101393 <memcmp+0x47>
			return (int) *s1 - (int) *s2;
  101381:	0f b6 c0             	movzbl %al,%eax
  101384:	0f b6 c9             	movzbl %cl,%ecx
  101387:	29 c8                	sub    %ecx,%eax
  101389:	eb 11                	jmp    10139c <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  10138b:	83 ef 01             	sub    $0x1,%edi
  10138e:	ba 00 00 00 00       	mov    $0x0,%edx
  101393:	39 fa                	cmp    %edi,%edx
  101395:	75 d9                	jne    101370 <memcmp+0x24>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  101397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10139c:	5b                   	pop    %ebx
  10139d:	5e                   	pop    %esi
  10139e:	5f                   	pop    %edi
  10139f:	c3                   	ret    

001013a0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  1013a0:	8b 44 24 04          	mov    0x4(%esp),%eax
	const void *ends = (const char *) s + n;
  1013a4:	89 c2                	mov    %eax,%edx
  1013a6:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
  1013aa:	39 d0                	cmp    %edx,%eax
  1013ac:	73 16                	jae    1013c4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  1013ae:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
  1013b3:	38 08                	cmp    %cl,(%eax)
  1013b5:	75 06                	jne    1013bd <memfind+0x1d>
  1013b7:	f3 c3                	repz ret 
  1013b9:	38 08                	cmp    %cl,(%eax)
  1013bb:	74 07                	je     1013c4 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  1013bd:	83 c0 01             	add    $0x1,%eax
  1013c0:	39 c2                	cmp    %eax,%edx
  1013c2:	77 f5                	ja     1013b9 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  1013c4:	f3 c3                	repz ret 

001013c6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  1013c6:	55                   	push   %ebp
  1013c7:	57                   	push   %edi
  1013c8:	56                   	push   %esi
  1013c9:	53                   	push   %ebx
  1013ca:	8b 54 24 14          	mov    0x14(%esp),%edx
  1013ce:	8b 74 24 18          	mov    0x18(%esp),%esi
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  1013d2:	0f b6 02             	movzbl (%edx),%eax
  1013d5:	3c 20                	cmp    $0x20,%al
  1013d7:	74 04                	je     1013dd <strtol+0x17>
  1013d9:	3c 09                	cmp    $0x9,%al
  1013db:	75 0e                	jne    1013eb <strtol+0x25>
		s++;
  1013dd:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  1013e0:	0f b6 02             	movzbl (%edx),%eax
  1013e3:	3c 20                	cmp    $0x20,%al
  1013e5:	74 f6                	je     1013dd <strtol+0x17>
  1013e7:	3c 09                	cmp    $0x9,%al
  1013e9:	74 f2                	je     1013dd <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  1013eb:	3c 2b                	cmp    $0x2b,%al
  1013ed:	75 0a                	jne    1013f9 <strtol+0x33>
		s++;
  1013ef:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  1013f2:	bf 00 00 00 00       	mov    $0x0,%edi
  1013f7:	eb 10                	jmp    101409 <strtol+0x43>
  1013f9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  1013fe:	3c 2d                	cmp    $0x2d,%al
  101400:	75 07                	jne    101409 <strtol+0x43>
		s++, neg = 1;
  101402:	83 c2 01             	add    $0x1,%edx
  101405:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  101409:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  10140e:	0f 94 c0             	sete   %al
  101411:	74 07                	je     10141a <strtol+0x54>
  101413:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
  101418:	75 18                	jne    101432 <strtol+0x6c>
  10141a:	80 3a 30             	cmpb   $0x30,(%edx)
  10141d:	75 13                	jne    101432 <strtol+0x6c>
  10141f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  101423:	75 0d                	jne    101432 <strtol+0x6c>
		s += 2, base = 16;
  101425:	83 c2 02             	add    $0x2,%edx
  101428:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  10142f:	00 
  101430:	eb 1c                	jmp    10144e <strtol+0x88>
	else if (base == 0 && s[0] == '0')
  101432:	84 c0                	test   %al,%al
  101434:	74 18                	je     10144e <strtol+0x88>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  101436:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
  10143d:	00 
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  10143e:	80 3a 30             	cmpb   $0x30,(%edx)
  101441:	75 0b                	jne    10144e <strtol+0x88>
		s++, base = 8;
  101443:	83 c2 01             	add    $0x1,%edx
  101446:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
  10144d:	00 
	else if (base == 0)
		base = 10;
  10144e:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  101453:	0f b6 0a             	movzbl (%edx),%ecx
  101456:	8d 69 d0             	lea    -0x30(%ecx),%ebp
  101459:	89 eb                	mov    %ebp,%ebx
  10145b:	80 fb 09             	cmp    $0x9,%bl
  10145e:	77 08                	ja     101468 <strtol+0xa2>
			dig = *s - '0';
  101460:	0f be c9             	movsbl %cl,%ecx
  101463:	83 e9 30             	sub    $0x30,%ecx
  101466:	eb 22                	jmp    10148a <strtol+0xc4>
		else if (*s >= 'a' && *s <= 'z')
  101468:	8d 69 9f             	lea    -0x61(%ecx),%ebp
  10146b:	89 eb                	mov    %ebp,%ebx
  10146d:	80 fb 19             	cmp    $0x19,%bl
  101470:	77 08                	ja     10147a <strtol+0xb4>
			dig = *s - 'a' + 10;
  101472:	0f be c9             	movsbl %cl,%ecx
  101475:	83 e9 57             	sub    $0x57,%ecx
  101478:	eb 10                	jmp    10148a <strtol+0xc4>
		else if (*s >= 'A' && *s <= 'Z')
  10147a:	8d 69 bf             	lea    -0x41(%ecx),%ebp
  10147d:	89 eb                	mov    %ebp,%ebx
  10147f:	80 fb 19             	cmp    $0x19,%bl
  101482:	77 19                	ja     10149d <strtol+0xd7>
			dig = *s - 'A' + 10;
  101484:	0f be c9             	movsbl %cl,%ecx
  101487:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  10148a:	3b 4c 24 1c          	cmp    0x1c(%esp),%ecx
  10148e:	7d 11                	jge    1014a1 <strtol+0xdb>
			break;
		s++, val = (val * base) + dig;
  101490:	83 c2 01             	add    $0x1,%edx
  101493:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
  101498:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  10149b:	eb b6                	jmp    101453 <strtol+0x8d>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  10149d:	89 c1                	mov    %eax,%ecx
  10149f:	eb 02                	jmp    1014a3 <strtol+0xdd>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  1014a1:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  1014a3:	85 f6                	test   %esi,%esi
  1014a5:	74 02                	je     1014a9 <strtol+0xe3>
		*endptr = (char *) s;
  1014a7:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  1014a9:	89 ca                	mov    %ecx,%edx
  1014ab:	f7 da                	neg    %edx
  1014ad:	85 ff                	test   %edi,%edi
  1014af:	0f 45 c2             	cmovne %edx,%eax
}
  1014b2:	5b                   	pop    %ebx
  1014b3:	5e                   	pop    %esi
  1014b4:	5f                   	pop    %edi
  1014b5:	5d                   	pop    %ebp
  1014b6:	c3                   	ret    
	...

001014c0 <__udivdi3>:
  1014c0:	55                   	push   %ebp
  1014c1:	89 e5                	mov    %esp,%ebp
  1014c3:	57                   	push   %edi
  1014c4:	56                   	push   %esi
  1014c5:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  1014c9:	8b 45 14             	mov    0x14(%ebp),%eax
  1014cc:	8b 75 08             	mov    0x8(%ebp),%esi
  1014cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1014d2:	85 c0                	test   %eax,%eax
  1014d4:	89 75 e8             	mov    %esi,-0x18(%ebp)
  1014d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1014da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  1014dd:	75 39                	jne    101518 <__udivdi3+0x58>
  1014df:	39 f9                	cmp    %edi,%ecx
  1014e1:	77 65                	ja     101548 <__udivdi3+0x88>
  1014e3:	85 c9                	test   %ecx,%ecx
  1014e5:	75 0b                	jne    1014f2 <__udivdi3+0x32>
  1014e7:	b8 01 00 00 00       	mov    $0x1,%eax
  1014ec:	31 d2                	xor    %edx,%edx
  1014ee:	f7 f1                	div    %ecx
  1014f0:	89 c1                	mov    %eax,%ecx
  1014f2:	89 f8                	mov    %edi,%eax
  1014f4:	31 d2                	xor    %edx,%edx
  1014f6:	f7 f1                	div    %ecx
  1014f8:	89 c7                	mov    %eax,%edi
  1014fa:	89 f0                	mov    %esi,%eax
  1014fc:	f7 f1                	div    %ecx
  1014fe:	89 fa                	mov    %edi,%edx
  101500:	89 c6                	mov    %eax,%esi
  101502:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101505:	89 55 f4             	mov    %edx,-0xc(%ebp)
  101508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10150b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10150e:	8d 64 24 20          	lea    0x20(%esp),%esp
  101512:	5e                   	pop    %esi
  101513:	5f                   	pop    %edi
  101514:	5d                   	pop    %ebp
  101515:	c3                   	ret    
  101516:	66 90                	xchg   %ax,%ax
  101518:	31 d2                	xor    %edx,%edx
  10151a:	31 f6                	xor    %esi,%esi
  10151c:	39 f8                	cmp    %edi,%eax
  10151e:	77 e2                	ja     101502 <__udivdi3+0x42>
  101520:	0f bd d0             	bsr    %eax,%edx
  101523:	83 f2 1f             	xor    $0x1f,%edx
  101526:	89 55 ec             	mov    %edx,-0x14(%ebp)
  101529:	75 2d                	jne    101558 <__udivdi3+0x98>
  10152b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10152e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  101531:	76 06                	jbe    101539 <__udivdi3+0x79>
  101533:	39 f8                	cmp    %edi,%eax
  101535:	89 f2                	mov    %esi,%edx
  101537:	73 c9                	jae    101502 <__udivdi3+0x42>
  101539:	31 d2                	xor    %edx,%edx
  10153b:	be 01 00 00 00       	mov    $0x1,%esi
  101540:	eb c0                	jmp    101502 <__udivdi3+0x42>
  101542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101548:	89 f0                	mov    %esi,%eax
  10154a:	89 fa                	mov    %edi,%edx
  10154c:	f7 f1                	div    %ecx
  10154e:	31 d2                	xor    %edx,%edx
  101550:	89 c6                	mov    %eax,%esi
  101552:	eb ae                	jmp    101502 <__udivdi3+0x42>
  101554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101558:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10155c:	89 c2                	mov    %eax,%edx
  10155e:	b8 20 00 00 00       	mov    $0x20,%eax
  101563:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101566:	d3 e2                	shl    %cl,%edx
  101568:	89 c1                	mov    %eax,%ecx
  10156a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10156d:	d3 ee                	shr    %cl,%esi
  10156f:	09 d6                	or     %edx,%esi
  101571:	89 fa                	mov    %edi,%edx
  101573:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101577:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  10157a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10157d:	d3 e6                	shl    %cl,%esi
  10157f:	89 c1                	mov    %eax,%ecx
  101581:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101584:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101587:	d3 ea                	shr    %cl,%edx
  101589:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10158d:	d3 e7                	shl    %cl,%edi
  10158f:	89 c1                	mov    %eax,%ecx
  101591:	d3 ee                	shr    %cl,%esi
  101593:	09 fe                	or     %edi,%esi
  101595:	89 f0                	mov    %esi,%eax
  101597:	f7 75 e4             	divl   -0x1c(%ebp)
  10159a:	89 d7                	mov    %edx,%edi
  10159c:	89 c6                	mov    %eax,%esi
  10159e:	f7 65 f0             	mull   -0x10(%ebp)
  1015a1:	39 d7                	cmp    %edx,%edi
  1015a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1015a6:	72 12                	jb     1015ba <__udivdi3+0xfa>
  1015a8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  1015ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015af:	d3 e2                	shl    %cl,%edx
  1015b1:	39 c2                	cmp    %eax,%edx
  1015b3:	73 08                	jae    1015bd <__udivdi3+0xfd>
  1015b5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  1015b8:	75 03                	jne    1015bd <__udivdi3+0xfd>
  1015ba:	8d 76 ff             	lea    -0x1(%esi),%esi
  1015bd:	31 d2                	xor    %edx,%edx
  1015bf:	e9 3e ff ff ff       	jmp    101502 <__udivdi3+0x42>
	...

001015d0 <__umoddi3>:
  1015d0:	55                   	push   %ebp
  1015d1:	89 e5                	mov    %esp,%ebp
  1015d3:	57                   	push   %edi
  1015d4:	56                   	push   %esi
  1015d5:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  1015d9:	8b 7d 14             	mov    0x14(%ebp),%edi
  1015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1015e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  1015e5:	85 ff                	test   %edi,%edi
  1015e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1015ea:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  1015ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1015f0:	89 f2                	mov    %esi,%edx
  1015f2:	75 14                	jne    101608 <__umoddi3+0x38>
  1015f4:	39 f1                	cmp    %esi,%ecx
  1015f6:	76 40                	jbe    101638 <__umoddi3+0x68>
  1015f8:	f7 f1                	div    %ecx
  1015fa:	89 d0                	mov    %edx,%eax
  1015fc:	31 d2                	xor    %edx,%edx
  1015fe:	8d 64 24 20          	lea    0x20(%esp),%esp
  101602:	5e                   	pop    %esi
  101603:	5f                   	pop    %edi
  101604:	5d                   	pop    %ebp
  101605:	c3                   	ret    
  101606:	66 90                	xchg   %ax,%ax
  101608:	39 f7                	cmp    %esi,%edi
  10160a:	77 4c                	ja     101658 <__umoddi3+0x88>
  10160c:	0f bd c7             	bsr    %edi,%eax
  10160f:	83 f0 1f             	xor    $0x1f,%eax
  101612:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101615:	75 51                	jne    101668 <__umoddi3+0x98>
  101617:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  10161a:	0f 87 e8 00 00 00    	ja     101708 <__umoddi3+0x138>
  101620:	89 f2                	mov    %esi,%edx
  101622:	8b 75 f0             	mov    -0x10(%ebp),%esi
  101625:	29 ce                	sub    %ecx,%esi
  101627:	19 fa                	sbb    %edi,%edx
  101629:	89 75 f0             	mov    %esi,-0x10(%ebp)
  10162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10162f:	8d 64 24 20          	lea    0x20(%esp),%esp
  101633:	5e                   	pop    %esi
  101634:	5f                   	pop    %edi
  101635:	5d                   	pop    %ebp
  101636:	c3                   	ret    
  101637:	90                   	nop
  101638:	85 c9                	test   %ecx,%ecx
  10163a:	75 0b                	jne    101647 <__umoddi3+0x77>
  10163c:	b8 01 00 00 00       	mov    $0x1,%eax
  101641:	31 d2                	xor    %edx,%edx
  101643:	f7 f1                	div    %ecx
  101645:	89 c1                	mov    %eax,%ecx
  101647:	89 f0                	mov    %esi,%eax
  101649:	31 d2                	xor    %edx,%edx
  10164b:	f7 f1                	div    %ecx
  10164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101650:	f7 f1                	div    %ecx
  101652:	eb a6                	jmp    1015fa <__umoddi3+0x2a>
  101654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101658:	89 f2                	mov    %esi,%edx
  10165a:	8d 64 24 20          	lea    0x20(%esp),%esp
  10165e:	5e                   	pop    %esi
  10165f:	5f                   	pop    %edi
  101660:	5d                   	pop    %ebp
  101661:	c3                   	ret    
  101662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101668:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10166c:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  101673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101676:	29 45 f0             	sub    %eax,-0x10(%ebp)
  101679:	d3 e7                	shl    %cl,%edi
  10167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10167e:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101682:	89 f2                	mov    %esi,%edx
  101684:	d3 e8                	shr    %cl,%eax
  101686:	09 f8                	or     %edi,%eax
  101688:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10168c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101692:	d3 e0                	shl    %cl,%eax
  101694:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101698:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10169b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10169e:	d3 ea                	shr    %cl,%edx
  1016a0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  1016a4:	d3 e6                	shl    %cl,%esi
  1016a6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  1016aa:	d3 e8                	shr    %cl,%eax
  1016ac:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  1016b0:	09 f0                	or     %esi,%eax
  1016b2:	8b 75 e8             	mov    -0x18(%ebp),%esi
  1016b5:	d3 e6                	shl    %cl,%esi
  1016b7:	f7 75 e4             	divl   -0x1c(%ebp)
  1016ba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  1016bd:	89 d6                	mov    %edx,%esi
  1016bf:	f7 65 f4             	mull   -0xc(%ebp)
  1016c2:	89 d7                	mov    %edx,%edi
  1016c4:	89 c2                	mov    %eax,%edx
  1016c6:	39 fe                	cmp    %edi,%esi
  1016c8:	89 f9                	mov    %edi,%ecx
  1016ca:	72 30                	jb     1016fc <__umoddi3+0x12c>
  1016cc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1016cf:	72 27                	jb     1016f8 <__umoddi3+0x128>
  1016d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1016d4:	29 d0                	sub    %edx,%eax
  1016d6:	19 ce                	sbb    %ecx,%esi
  1016d8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  1016dc:	89 f2                	mov    %esi,%edx
  1016de:	d3 e8                	shr    %cl,%eax
  1016e0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  1016e4:	d3 e2                	shl    %cl,%edx
  1016e6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  1016ea:	09 d0                	or     %edx,%eax
  1016ec:	89 f2                	mov    %esi,%edx
  1016ee:	d3 ea                	shr    %cl,%edx
  1016f0:	8d 64 24 20          	lea    0x20(%esp),%esp
  1016f4:	5e                   	pop    %esi
  1016f5:	5f                   	pop    %edi
  1016f6:	5d                   	pop    %ebp
  1016f7:	c3                   	ret    
  1016f8:	39 fe                	cmp    %edi,%esi
  1016fa:	75 d5                	jne    1016d1 <__umoddi3+0x101>
  1016fc:	89 f9                	mov    %edi,%ecx
  1016fe:	89 c2                	mov    %eax,%edx
  101700:	2b 55 f4             	sub    -0xc(%ebp),%edx
  101703:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  101706:	eb c9                	jmp    1016d1 <__umoddi3+0x101>
  101708:	39 f7                	cmp    %esi,%edi
  10170a:	0f 82 10 ff ff ff    	jb     101620 <__umoddi3+0x50>
  101710:	e9 17 ff ff ff       	jmp    10162c <__umoddi3+0x5c>
