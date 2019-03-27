
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
  10002e:	e8 c8 09 00 00       	call   1009fb <timer_init>
	trap_init();
  100033:	e8 73 06 00 00       	call   1006ab <trap_init>

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
  10003c:	e9 7d 08 00 00       	jmp    1008be <shell>
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
  100129:	8a 81 0c 1b 10 00    	mov    0x101b0c(%ecx),%al
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
  100159:	0f b6 81 0c 1c 10 00 	movzbl 0x101c0c(%ecx),%eax
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
  100160:	0f b6 91 0c 1b 10 00 	movzbl 0x101b0c(%ecx),%edx
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
  100177:	8b 04 85 0c 1d 10 00 	mov    0x101d0c(,%eax,4),%eax
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
  1001b4:	68 00 1b 10 00       	push   $0x101b00
  1001b9:	e8 b8 05 00 00       	call   100776 <cprintf>
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
	// (e.g., when called from the kernel monitor).
	//kbd_intr();

        //cprintf("cons_getc cons.rpos:%d  cons.wpos:%d\n",cons.rpos,cons.wpos);
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
	// (e.g., when called from the kernel monitor).
	//kbd_intr();

        //cprintf("cons_getc cons.rpos:%d  cons.wpos:%d\n",cons.rpos,cons.wpos);
	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001db:	3b 15 28 b5 10 00    	cmp    0x10b528,%edx
  1001e1:	74 1b                	je     1001fe <cons_getc+0x2b>
		//cprintf("\n\ncons_getc return 0\n\n");
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
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
		//cprintf("\ninput:%d\n",c);
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
		//cprintf("\ninput:%d\n",c);
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
kbd_intr(void)
{
	cons_intr(kbd_proc_data);

        //cprintf("cons.rpos:%d  cons.wpos:%d\n",cons.rpos,cons.wpos);
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
		//cprintf("g");
		/* do nothing */
	        //for(;;);
	//}
	do{
		c=cons_getc();
  10026b:	e8 63 ff ff ff       	call   1001d3 <cons_getc>
	}while(c==0 /*|| c>1000000 || c==-1*/);	
  100270:	85 c0                	test   %eax,%eax
  100272:	74 f7                	je     10026b <getc>


	//cprintf("\n\ngetc : %d\n\n",c);
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
  1002bb:	e8 78 13 00 00       	call   101638 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002c0:	83 c4 0c             	add    $0xc,%esp
  1002c3:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
  1002ca:	03 05 40 b9 10 00    	add    0x10b940,%eax
  1002d0:	6a 50                	push   $0x50
  1002d2:	56                   	push   %esi
  1002d3:	50                   	push   %eax
  1002d4:	e8 ee 11 00 00       	call   1014c7 <memset>
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
  10033b:	e8 87 11 00 00       	call   1014c7 <memset>
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
  10044d:	e8 f2 0d 00 00       	call   101244 <strlen>
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
  100496:	68 1c 1d 10 00       	push   $0x101d1c
  10049b:	e8 d6 02 00 00       	call   100776 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
  1004a0:	58                   	pop    %eax
  1004a1:	5a                   	pop    %edx
  1004a2:	ff 73 04             	pushl  0x4(%ebx)
  1004a5:	68 2b 1d 10 00       	push   $0x101d2b
  1004aa:	e8 c7 02 00 00       	call   100776 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  1004af:	5a                   	pop    %edx
  1004b0:	59                   	pop    %ecx
  1004b1:	ff 73 08             	pushl  0x8(%ebx)
  1004b4:	68 3a 1d 10 00       	push   $0x101d3a
  1004b9:	e8 b8 02 00 00       	call   100776 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1004be:	59                   	pop    %ecx
  1004bf:	58                   	pop    %eax
  1004c0:	ff 73 0c             	pushl  0xc(%ebx)
  1004c3:	68 49 1d 10 00       	push   $0x101d49
  1004c8:	e8 a9 02 00 00       	call   100776 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1004cd:	58                   	pop    %eax
  1004ce:	5a                   	pop    %edx
  1004cf:	ff 73 10             	pushl  0x10(%ebx)
  1004d2:	68 58 1d 10 00       	push   $0x101d58
  1004d7:	e8 9a 02 00 00       	call   100776 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
  1004dc:	5a                   	pop    %edx
  1004dd:	59                   	pop    %ecx
  1004de:	ff 73 14             	pushl  0x14(%ebx)
  1004e1:	68 67 1d 10 00       	push   $0x101d67
  1004e6:	e8 8b 02 00 00       	call   100776 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  1004eb:	59                   	pop    %ecx
  1004ec:	58                   	pop    %eax
  1004ed:	ff 73 18             	pushl  0x18(%ebx)
  1004f0:	68 76 1d 10 00       	push   $0x101d76
  1004f5:	e8 7c 02 00 00       	call   100776 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
  1004fa:	58                   	pop    %eax
  1004fb:	5a                   	pop    %edx
  1004fc:	ff 73 1c             	pushl  0x1c(%ebx)
  1004ff:	68 85 1d 10 00       	push   $0x101d85
  100504:	e8 6d 02 00 00       	call   100776 <cprintf>
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
  100517:	68 e9 1d 10 00       	push   $0x101de9
  10051c:	e8 55 02 00 00       	call   100776 <cprintf>
	print_regs(&tf->tf_regs);
  100521:	89 1c 24             	mov    %ebx,(%esp)
  100524:	e8 63 ff ff ff       	call   10048c <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
  100529:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
  10052d:	5a                   	pop    %edx
  10052e:	59                   	pop    %ecx
  10052f:	50                   	push   %eax
  100530:	68 fc 1d 10 00       	push   $0x101dfc
  100535:	e8 3c 02 00 00       	call   100776 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10053a:	5e                   	pop    %esi
  10053b:	58                   	pop    %eax
  10053c:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
  100540:	50                   	push   %eax
  100541:	68 0f 1e 10 00       	push   $0x101e0f
  100546:	e8 2b 02 00 00       	call   100776 <cprintf>
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
  100556:	8b 14 85 f8 1f 10 00 	mov    0x101ff8(,%eax,4),%edx
  10055d:	eb 1d                	jmp    10057c <print_trapframe+0x6e>
	if (trapno == T_SYSCALL)
  10055f:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
  100562:	ba 94 1d 10 00       	mov    $0x101d94,%edx
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
  10056c:	ba a0 1d 10 00       	mov    $0x101da0,%edx
  100571:	83 f9 0f             	cmp    $0xf,%ecx
  100574:	b9 b3 1d 10 00       	mov    $0x101db3,%ecx
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
  10057f:	68 22 1e 10 00       	push   $0x101e22
  100584:	e8 ed 01 00 00       	call   100776 <cprintf>
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
  1005a0:	68 34 1e 10 00       	push   $0x101e34
  1005a5:	e8 cc 01 00 00       	call   100776 <cprintf>
  1005aa:	83 c4 10             	add    $0x10,%esp
	cprintf("  err  0x%08x", tf->tf_err);
  1005ad:	56                   	push   %esi
  1005ae:	56                   	push   %esi
  1005af:	ff 73 2c             	pushl  0x2c(%ebx)
  1005b2:	68 43 1e 10 00       	push   $0x101e43
  1005b7:	e8 ba 01 00 00       	call   100776 <cprintf>
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
  1005c8:	b8 cd 1d 10 00       	mov    $0x101dcd,%eax
  1005cd:	b9 c2 1d 10 00       	mov    $0x101dc2,%ecx
  1005d2:	ba d9 1d 10 00       	mov    $0x101dd9,%edx
  1005d7:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1005dd:	0f 44 c8             	cmove  %eax,%ecx
  1005e0:	f7 c6 02 00 00 00    	test   $0x2,%esi
  1005e6:	b8 df 1d 10 00       	mov    $0x101ddf,%eax
  1005eb:	0f 44 d0             	cmove  %eax,%edx
  1005ee:	83 e6 04             	and    $0x4,%esi
  1005f1:	51                   	push   %ecx
  1005f2:	b8 e4 1d 10 00       	mov    $0x101de4,%eax
  1005f7:	be 06 21 10 00       	mov    $0x102106,%esi
  1005fc:	52                   	push   %edx
  1005fd:	0f 44 c6             	cmove  %esi,%eax
  100600:	50                   	push   %eax
  100601:	68 51 1e 10 00       	push   $0x101e51
  100606:	eb 08                	jmp    100610 <print_trapframe+0x102>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
  100608:	83 ec 0c             	sub    $0xc,%esp
  10060b:	68 fa 1d 10 00       	push   $0x101dfa
  100610:	e8 61 01 00 00       	call   100776 <cprintf>
  100615:	5a                   	pop    %edx
  100616:	59                   	pop    %ecx
	cprintf("  eip  0x%08x\n", tf->tf_eip);
  100617:	ff 73 30             	pushl  0x30(%ebx)
  10061a:	68 60 1e 10 00       	push   $0x101e60
  10061f:	e8 52 01 00 00       	call   100776 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
  100624:	5e                   	pop    %esi
  100625:	58                   	pop    %eax
  100626:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  10062a:	50                   	push   %eax
  10062b:	68 6f 1e 10 00       	push   $0x101e6f
  100630:	e8 41 01 00 00       	call   100776 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
  100635:	5a                   	pop    %edx
  100636:	59                   	pop    %ecx
  100637:	ff 73 38             	pushl  0x38(%ebx)
  10063a:	68 82 1e 10 00       	push   $0x101e82
  10063f:	e8 32 01 00 00       	call   100776 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
  100644:	83 c4 10             	add    $0x10,%esp
  100647:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  10064b:	74 23                	je     100670 <print_trapframe+0x162>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
  10064d:	50                   	push   %eax
  10064e:	50                   	push   %eax
  10064f:	ff 73 3c             	pushl  0x3c(%ebx)
  100652:	68 91 1e 10 00       	push   $0x101e91
  100657:	e8 1a 01 00 00       	call   100776 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10065c:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
  100660:	59                   	pop    %ecx
  100661:	5e                   	pop    %esi
  100662:	50                   	push   %eax
  100663:	68 a0 1e 10 00       	push   $0x101ea0
  100668:	e8 09 01 00 00       	call   100776 <cprintf>
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
  10068d:	e9 5c 03 00 00       	jmp    1009ee <timer_handler>
		//print_trapframe(tf);
		//for(;;);
		return;
	}else if(tf->tf_trapno==IRQ_OFFSET+IRQ_KBD){
  100692:	83 fa 21             	cmp    $0x21,%edx
  100695:	75 08                	jne    10069f <default_trap_handler+0x29>
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

}
  100697:	83 c4 0c             	add    $0xc,%esp
		//for(;;);
		return;
	}else if(tf->tf_trapno==IRQ_OFFSET+IRQ_KBD){
		//cprintf("--------------keyboard!-------------\n");
		//print_trapframe(tf);
		kbd_intr();
  10069a:	e9 60 fb ff ff       	jmp    1001ff <kbd_intr>
		//for(;;);
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.	
	print_trapframe(tf);
  10069f:	89 44 24 10          	mov    %eax,0x10(%esp)
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

}
  1006a3:	83 c4 0c             	add    $0xc,%esp
		//for(;;);
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.	
	print_trapframe(tf);
  1006a6:	e9 63 fe ff ff       	jmp    10050e <print_trapframe>

001006ab <trap_init>:
   *       come in handy for you when filling up the argument of "lidt"
   */
   //SETGATE(gate, istrap, sel, off, dpl)
   //SETGATE()
  /* Keyboard interrupt setup */
  SETGATE(idt[0x21], 0,  0x8, keyboard, 3);
  1006ab:	b8 26 07 10 00       	mov    $0x100726,%eax
  1006b0:	66 a3 54 ba 10 00    	mov    %ax,0x10ba54
  1006b6:	c1 e8 10             	shr    $0x10,%eax
  1006b9:	66 a3 5a ba 10 00    	mov    %ax,0x10ba5a
  /* Timer Trap setup */
  SETGATE(idt[0x20], 0,  0x8, timer, 3);
  1006bf:	b8 20 07 10 00       	mov    $0x100720,%eax
  1006c4:	66 a3 4c ba 10 00    	mov    %ax,0x10ba4c
  1006ca:	c1 e8 10             	shr    $0x10,%eax
  1006cd:	66 a3 52 ba 10 00    	mov    %ax,0x10ba52
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
  1006d3:	b8 44 b9 10 00       	mov    $0x10b944,%eax
   *       come in handy for you when filling up the argument of "lidt"
   */
   //SETGATE(gate, istrap, sel, off, dpl)
   //SETGATE()
  /* Keyboard interrupt setup */
  SETGATE(idt[0x21], 0,  0x8, keyboard, 3);
  1006d8:	66 c7 05 56 ba 10 00 	movw   $0x8,0x10ba56
  1006df:	08 00 
  1006e1:	c6 05 58 ba 10 00 00 	movb   $0x0,0x10ba58
  1006e8:	c6 05 59 ba 10 00 ee 	movb   $0xee,0x10ba59
  /* Timer Trap setup */
  SETGATE(idt[0x20], 0,  0x8, timer, 3);
  1006ef:	66 c7 05 4e ba 10 00 	movw   $0x8,0x10ba4e
  1006f6:	08 00 
  1006f8:	c6 05 50 ba 10 00 00 	movb   $0x0,0x10ba50
  1006ff:	c6 05 51 ba 10 00 ee 	movb   $0xee,0x10ba51
  /* Load IDT */
  idt_pd.pd_lim = 256*8-1;
  100706:	66 c7 05 44 b9 10 00 	movw   $0x7ff,0x10b944
  10070d:	ff 07 
  idt_pd.pd_base= idt;
  10070f:	c7 05 46 b9 10 00 4c 	movl   $0x10b94c,0x10b946
  100716:	b9 10 00 
  100719:	0f 01 18             	lidtl  (%eax)

  lidt(&idt_pd);

}
  10071c:	c3                   	ret    
  10071d:	00 00                	add    %al,(%eax)
	...

00100720 <timer>:
 *       The Trap number are declared in inc/trap.h which might come in handy
 *       when declaring interface for ISRs.
 */
	#第一個參數意思應該是function名稱
	#第二個參數意思應該是....
	TRAPHANDLER_NOEC(timer, 0x20) 
  100720:	6a 00                	push   $0x0
  100722:	6a 20                	push   $0x20
  100724:	eb 06                	jmp    10072c <_alltraps>

00100726 <keyboard>:
	TRAPHANDLER_NOEC(keyboard, 0x21) 
  100726:	6a 00                	push   $0x0
  100728:	6a 21                	push   $0x21
  10072a:	eb 00                	jmp    10072c <_alltraps>

0010072c <_alltraps>:
   *       occurs. Thus, you do not have to push those registers.
   *       Please reference lab3.docx for what registers are pushed by
   *       CPU.
   */

	pushl %ds
  10072c:	1e                   	push   %ds
	pushl %es
  10072d:	06                   	push   %es
	pushl %eax
  10072e:	50                   	push   %eax
	pushl %ecx
  10072f:	51                   	push   %ecx
	pushl %edx
  100730:	52                   	push   %edx
	pushl %ebx
  100731:	53                   	push   %ebx
	pushl $0  #useless
  100732:	6a 00                	push   $0x0
	pushl %ebp
  100734:	55                   	push   %ebp
	pushl %esi
  100735:	56                   	push   %esi
	pushl %edi
  100736:	57                   	push   %edi

	pushl %esp # Pass a pointer which points to the Trapframe as an argument to default_trap_handler()
  100737:	54                   	push   %esp
	call default_trap_handler
  100738:	e8 39 ff ff ff       	call   100676 <default_trap_handler>

	
	pop %esp
  10073d:	5c                   	pop    %esp
	pop %edi
  10073e:	5f                   	pop    %edi
	pop %esi
  10073f:	5e                   	pop    %esi
	pop %ebp
  100740:	5d                   	pop    %ebp
	pop %eax #useless
  100741:	58                   	pop    %eax
	pop %ebx
  100742:	5b                   	pop    %ebx
	pop %edx
  100743:	5a                   	pop    %edx
	pop %ecx
  100744:	59                   	pop    %ecx
	pop %eax
  100745:	58                   	pop    %eax
	pop %es
  100746:	07                   	pop    %es
	pop %ds
  100747:	1f                   	pop    %ds
	add $8, %esp # Cleans up the pushed error code and pushed ISR number
  100748:	83 c4 08             	add    $0x8,%esp
	#add $0x28, %esp #0x4*11
	iret # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!
  10074b:	cf                   	iret   

0010074c <vcprintf>:
#include <inc/stdio.h>


int
vcprintf(const char *fmt, va_list ap)
{
  10074c:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
  10074f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100756:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
  100757:	ff 74 24 24          	pushl  0x24(%esp)
  10075b:	ff 74 24 24          	pushl  0x24(%esp)
  10075f:	8d 44 24 14          	lea    0x14(%esp),%eax
  100763:	50                   	push   %eax
  100764:	68 69 03 10 00       	push   $0x100369
  100769:	e8 4c 04 00 00       	call   100bba <vprintfmt>
	return cnt;
}
  10076e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  100772:	83 c4 2c             	add    $0x2c,%esp
  100775:	c3                   	ret    

00100776 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  100776:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  100779:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vcprintf(fmt, ap);
  10077d:	52                   	push   %edx
  10077e:	52                   	push   %edx
  10077f:	50                   	push   %eax
  100780:	ff 74 24 1c          	pushl  0x1c(%esp)
  100784:	e8 c3 ff ff ff       	call   10074c <vcprintf>
	va_end(ap);

	return cnt;
}
  100789:	83 c4 1c             	add    $0x1c,%esp
  10078c:	c3                   	ret    
  10078d:	00 00                	add    %al,(%eax)
	...

00100790 <mon_kerninfo>:
 	* NOTE: You can count only linker script (kernel/kern.ld) to
 	*       provide you with those information.
	*       Use PROVIDE inside linker script and calculate the
	*       offset.
	*/
	cprintf("kernel code base start=%p size = %d\n",&kernel_load_addr,(int)&etext-(int)&kernel_load_addr);
  100790:	b8 e5 1a 10 00       	mov    $0x101ae5,%eax
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int mon_kerninfo(int argc, char **argv)
{
  100795:	83 ec 10             	sub    $0x10,%esp
 	* NOTE: You can count only linker script (kernel/kern.ld) to
 	*       provide you with those information.
	*       Use PROVIDE inside linker script and calculate the
	*       offset.
	*/
	cprintf("kernel code base start=%p size = %d\n",&kernel_load_addr,(int)&etext-(int)&kernel_load_addr);
  100798:	2d 00 00 10 00       	sub    $0x100000,%eax
  10079d:	50                   	push   %eax
  10079e:	68 00 00 10 00       	push   $0x100000
  1007a3:	68 48 20 10 00       	push   $0x102048
  1007a8:	e8 c9 ff ff ff       	call   100776 <cprintf>
	cprintf("kernel data base start=%p size = %d\n",&beforedata,(int)&afterdata-(int)&beforedata);
  1007ad:	b8 08 33 10 00       	mov    $0x103308,%eax
  1007b2:	83 c4 0c             	add    $0xc,%esp
  1007b5:	2d 00 30 10 00       	sub    $0x103000,%eax
  1007ba:	50                   	push   %eax
  1007bb:	68 00 30 10 00       	push   $0x103000
  1007c0:	68 6d 20 10 00       	push   $0x10206d
  1007c5:	e8 ac ff ff ff       	call   100776 <cprintf>
	cprintf("kernel executable memory footprint: %dKB\n",((int)&end-(int)&kernel_load_addr)/1024);
  1007ca:	b9 00 04 00 00       	mov    $0x400,%ecx
  1007cf:	58                   	pop    %eax
  1007d0:	b8 4c c1 10 00       	mov    $0x10c14c,%eax
  1007d5:	2d 00 00 10 00       	sub    $0x100000,%eax
  1007da:	5a                   	pop    %edx
  1007db:	99                   	cltd   
  1007dc:	f7 f9                	idiv   %ecx
  1007de:	50                   	push   %eax
  1007df:	68 92 20 10 00       	push   $0x102092
  1007e4:	e8 8d ff ff ff       	call   100776 <cprintf>
	return 0;
}
  1007e9:	31 c0                	xor    %eax,%eax
  1007eb:	83 c4 1c             	add    $0x1c,%esp
  1007ee:	c3                   	ret    

001007ef <mon_help>:
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))


int mon_help(int argc, char **argv)
{
  1007ef:	83 ec 10             	sub    $0x10,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  1007f2:	68 bc 20 10 00       	push   $0x1020bc
  1007f7:	68 da 20 10 00       	push   $0x1020da
  1007fc:	68 df 20 10 00       	push   $0x1020df
  100801:	e8 70 ff ff ff       	call   100776 <cprintf>
  100806:	83 c4 0c             	add    $0xc,%esp
  100809:	68 e8 20 10 00       	push   $0x1020e8
  10080e:	68 0d 21 10 00       	push   $0x10210d
  100813:	68 df 20 10 00       	push   $0x1020df
  100818:	e8 59 ff ff ff       	call   100776 <cprintf>
  10081d:	83 c4 0c             	add    $0xc,%esp
  100820:	68 16 21 10 00       	push   $0x102116
  100825:	68 2a 21 10 00       	push   $0x10212a
  10082a:	68 df 20 10 00       	push   $0x1020df
  10082f:	e8 42 ff ff ff       	call   100776 <cprintf>
  100834:	83 c4 0c             	add    $0xc,%esp
  100837:	68 35 21 10 00       	push   $0x102135
  10083c:	68 58 21 10 00       	push   $0x102158
  100841:	68 df 20 10 00       	push   $0x1020df
  100846:	e8 2b ff ff ff       	call   100776 <cprintf>
	return 0;
}
  10084b:	31 c0                	xor    %eax,%eax
  10084d:	83 c4 1c             	add    $0x1c,%esp
  100850:	c3                   	ret    

00100851 <chgcolor>:
{
	cprintf("Now tick = %d\n", get_tick());
}

int chgcolor(int argc, char **argv)
{
  100851:	53                   	push   %ebx
  100852:	83 ec 08             	sub    $0x8,%esp
	if(argc==1){
  100855:	83 7c 24 10 01       	cmpl   $0x1,0x10(%esp)
{
	cprintf("Now tick = %d\n", get_tick());
}

int chgcolor(int argc, char **argv)
{
  10085a:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	if(argc==1){
  10085e:	75 11                	jne    100871 <chgcolor+0x20>
		cprintf("No input text color!\n");
  100860:	c7 44 24 10 61 21 10 	movl   $0x102161,0x10(%esp)
  100867:	00 
	}else{
		//int color = ;
		settextcolor(argv[1][0]-'0',0);
		cprintf("Change color %d!\n",argv[1][0]-'0');
	}
}
  100868:	83 c4 08             	add    $0x8,%esp
  10086b:	5b                   	pop    %ebx
}

int chgcolor(int argc, char **argv)
{
	if(argc==1){
		cprintf("No input text color!\n");
  10086c:	e9 05 ff ff ff       	jmp    100776 <cprintf>
	}else{
		//int color = ;
		settextcolor(argv[1][0]-'0',0);
  100871:	51                   	push   %ecx
  100872:	51                   	push   %ecx
  100873:	6a 00                	push   $0x0
  100875:	8b 43 04             	mov    0x4(%ebx),%eax
  100878:	0f be 00             	movsbl (%eax),%eax
  10087b:	83 e8 30             	sub    $0x30,%eax
  10087e:	50                   	push   %eax
  10087f:	e8 db fb ff ff       	call   10045f <settextcolor>
		cprintf("Change color %d!\n",argv[1][0]-'0');
  100884:	8b 43 04             	mov    0x4(%ebx),%eax
  100887:	0f be 00             	movsbl (%eax),%eax
  10088a:	c7 44 24 20 77 21 10 	movl   $0x102177,0x20(%esp)
  100891:	00 
  100892:	83 e8 30             	sub    $0x30,%eax
  100895:	89 44 24 24          	mov    %eax,0x24(%esp)
	}
}
  100899:	83 c4 18             	add    $0x18,%esp
  10089c:	5b                   	pop    %ebx
	if(argc==1){
		cprintf("No input text color!\n");
	}else{
		//int color = ;
		settextcolor(argv[1][0]-'0',0);
		cprintf("Change color %d!\n",argv[1][0]-'0');
  10089d:	e9 d4 fe ff ff       	jmp    100776 <cprintf>

001008a2 <print_tick>:
	cprintf("kernel data base start=%p size = %d\n",&beforedata,(int)&afterdata-(int)&beforedata);
	cprintf("kernel executable memory footprint: %dKB\n",((int)&end-(int)&kernel_load_addr)/1024);
	return 0;
}
int print_tick(int argc, char **argv)
{
  1008a2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("Now tick = %d\n", get_tick());
  1008a5:	e8 4b 01 00 00       	call   1009f5 <get_tick>
  1008aa:	c7 44 24 10 89 21 10 	movl   $0x102189,0x10(%esp)
  1008b1:	00 
  1008b2:	89 44 24 14          	mov    %eax,0x14(%esp)
}
  1008b6:	83 c4 0c             	add    $0xc,%esp
	cprintf("kernel executable memory footprint: %dKB\n",((int)&end-(int)&kernel_load_addr)/1024);
	return 0;
}
int print_tick(int argc, char **argv)
{
	cprintf("Now tick = %d\n", get_tick());
  1008b9:	e9 b8 fe ff ff       	jmp    100776 <cprintf>

001008be <shell>:
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}
void shell()
{
  1008be:	55                   	push   %ebp
  1008bf:	57                   	push   %edi
  1008c0:	56                   	push   %esi
  1008c1:	53                   	push   %ebx
  1008c2:	83 ec 58             	sub    $0x58,%esp
	char *buf;
	cprintf("Welcome to the OSDI course!\n");
  1008c5:	68 98 21 10 00       	push   $0x102198
  1008ca:	e8 a7 fe ff ff       	call   100776 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
  1008cf:	c7 04 24 b5 21 10 00 	movl   $0x1021b5,(%esp)
  1008d6:	e8 9b fe ff ff       	call   100776 <cprintf>
  1008db:	83 c4 10             	add    $0x10,%esp
	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
  1008de:	89 e5                	mov    %esp,%ebp
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  1008e0:	83 ec 0c             	sub    $0xc,%esp
  1008e3:	68 da 21 10 00       	push   $0x1021da
  1008e8:	e8 67 08 00 00       	call   101154 <readline>
		if (buf != NULL)
  1008ed:	83 c4 10             	add    $0x10,%esp
  1008f0:	85 c0                	test   %eax,%eax
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  1008f2:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
  1008f4:	74 ea                	je     1008e0 <shell+0x22>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
  1008f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  1008fd:	31 f6                	xor    %esi,%esi
  1008ff:	eb 04                	jmp    100905 <shell+0x47>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
  100901:	c6 03 00             	movb   $0x0,(%ebx)
  100904:	43                   	inc    %ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  100905:	8a 03                	mov    (%ebx),%al
  100907:	84 c0                	test   %al,%al
  100909:	74 17                	je     100922 <shell+0x64>
  10090b:	57                   	push   %edi
  10090c:	0f be c0             	movsbl %al,%eax
  10090f:	57                   	push   %edi
  100910:	50                   	push   %eax
  100911:	68 e1 21 10 00       	push   $0x1021e1
  100916:	e8 42 0b 00 00       	call   10145d <strchr>
  10091b:	83 c4 10             	add    $0x10,%esp
  10091e:	85 c0                	test   %eax,%eax
  100920:	75 df                	jne    100901 <shell+0x43>
			*buf++ = 0;
		if (*buf == 0)
  100922:	80 3b 00             	cmpb   $0x0,(%ebx)
  100925:	74 36                	je     10095d <shell+0x9f>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  100927:	83 fe 0f             	cmp    $0xf,%esi
  10092a:	75 0b                	jne    100937 <shell+0x79>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  10092c:	51                   	push   %ecx
  10092d:	51                   	push   %ecx
  10092e:	6a 10                	push   $0x10
  100930:	68 e6 21 10 00       	push   $0x1021e6
  100935:	eb 7d                	jmp    1009b4 <shell+0xf6>
			return 0;
		}
		argv[argc++] = buf;
  100937:	89 1c b4             	mov    %ebx,(%esp,%esi,4)
  10093a:	46                   	inc    %esi
  10093b:	eb 01                	jmp    10093e <shell+0x80>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
  10093d:	43                   	inc    %ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  10093e:	8a 03                	mov    (%ebx),%al
  100940:	84 c0                	test   %al,%al
  100942:	74 c1                	je     100905 <shell+0x47>
  100944:	52                   	push   %edx
  100945:	0f be c0             	movsbl %al,%eax
  100948:	52                   	push   %edx
  100949:	50                   	push   %eax
  10094a:	68 e1 21 10 00       	push   $0x1021e1
  10094f:	e8 09 0b 00 00       	call   10145d <strchr>
  100954:	83 c4 10             	add    $0x10,%esp
  100957:	85 c0                	test   %eax,%eax
  100959:	74 e2                	je     10093d <shell+0x7f>
  10095b:	eb a8                	jmp    100905 <shell+0x47>
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
  10095d:	85 f6                	test   %esi,%esi
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  10095f:	c7 04 b4 00 00 00 00 	movl   $0x0,(%esp,%esi,4)

	// Lookup and invoke the command
	if (argc == 0)
  100966:	0f 84 74 ff ff ff    	je     1008e0 <shell+0x22>
  10096c:	bf 1c 22 10 00       	mov    $0x10221c,%edi
  100971:	31 db                	xor    %ebx,%ebx
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
  100973:	50                   	push   %eax
  100974:	50                   	push   %eax
  100975:	ff 37                	pushl  (%edi)
  100977:	83 c7 0c             	add    $0xc,%edi
  10097a:	ff 74 24 0c          	pushl  0xc(%esp)
  10097e:	e8 38 0a 00 00       	call   1013bb <strcmp>
  100983:	83 c4 10             	add    $0x10,%esp
  100986:	85 c0                	test   %eax,%eax
  100988:	75 19                	jne    1009a3 <shell+0xe5>
			return commands[i].func(argc, argv);
  10098a:	6b db 0c             	imul   $0xc,%ebx,%ebx
  10098d:	57                   	push   %edi
  10098e:	57                   	push   %edi
  10098f:	55                   	push   %ebp
  100990:	56                   	push   %esi
  100991:	ff 93 24 22 10 00    	call   *0x102224(%ebx)
	while(1)
	{
		buf = readline("OSDI> ");
		if (buf != NULL)
		{
			if (runcmd(buf) < 0)
  100997:	83 c4 10             	add    $0x10,%esp
  10099a:	85 c0                	test   %eax,%eax
  10099c:	78 23                	js     1009c1 <shell+0x103>
  10099e:	e9 3d ff ff ff       	jmp    1008e0 <shell+0x22>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  1009a3:	43                   	inc    %ebx
  1009a4:	83 fb 04             	cmp    $0x4,%ebx
  1009a7:	75 ca                	jne    100973 <shell+0xb5>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  1009a9:	53                   	push   %ebx
  1009aa:	53                   	push   %ebx
  1009ab:	ff 74 24 08          	pushl  0x8(%esp)
  1009af:	68 03 22 10 00       	push   $0x102203
  1009b4:	e8 bd fd ff ff       	call   100776 <cprintf>
  1009b9:	83 c4 10             	add    $0x10,%esp
  1009bc:	e9 1f ff ff ff       	jmp    1008e0 <shell+0x22>
		{
			if (runcmd(buf) < 0)
				break;
		}
	}
}
  1009c1:	83 c4 4c             	add    $0x4c,%esp
  1009c4:	5b                   	pop    %ebx
  1009c5:	5e                   	pop    %esi
  1009c6:	5f                   	pop    %edi
  1009c7:	5d                   	pop    %ebp
  1009c8:	c3                   	ret    
  1009c9:	00 00                	add    %al,(%eax)
	...

001009cc <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
    int divisor = 1193180 / hz;       /* Calculate our divisor */
  1009cc:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
  1009d1:	89 c8                	mov    %ecx,%eax
  1009d3:	99                   	cltd   
  1009d4:	f7 7c 24 04          	idivl  0x4(%esp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1009d8:	ba 43 00 00 00       	mov    $0x43,%edx
  1009dd:	89 c1                	mov    %eax,%ecx
  1009df:	b0 36                	mov    $0x36,%al
  1009e1:	ee                   	out    %al,(%dx)
  1009e2:	b2 40                	mov    $0x40,%dl
  1009e4:	88 c8                	mov    %cl,%al
  1009e6:	ee                   	out    %al,(%dx)
    outb(0x43, 0x36);             /* Set our command byte 0x36 */
    outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
    outb(0x40, divisor >> 8);     /* Set high byte of divisor */
  1009e7:	89 c8                	mov    %ecx,%eax
  1009e9:	c1 f8 08             	sar    $0x8,%eax
  1009ec:	ee                   	out    %al,(%dx)
}
  1009ed:	c3                   	ret    

001009ee <timer_handler>:
/* 
 * Timer interrupt handler
 */
void timer_handler()
{
	jiffies++;
  1009ee:	ff 05 3c b5 10 00    	incl   0x10b53c
}
  1009f4:	c3                   	ret    

001009f5 <get_tick>:

unsigned long get_tick()
{
	return jiffies;
}
  1009f5:	a1 3c b5 10 00       	mov    0x10b53c,%eax
  1009fa:	c3                   	ret    

001009fb <timer_init>:
void timer_init()
{
  1009fb:	83 ec 0c             	sub    $0xc,%esp
	set_timer(TIME_HZ);
  1009fe:	6a 64                	push   $0x64
  100a00:	e8 c7 ff ff ff       	call   1009cc <set_timer>

	/* Enable interrupt */
        //IRQ_TIMER = 0
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_TIMER));
  100a05:	50                   	push   %eax
  100a06:	50                   	push   %eax
  100a07:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  100a0e:	25 fe ff 00 00       	and    $0xfffe,%eax
  100a13:	50                   	push   %eax
  100a14:	e8 2b f6 ff ff       	call   100044 <irq_setmask_8259A>
}
  100a19:	83 c4 1c             	add    $0x1c,%esp
  100a1c:	c3                   	ret    
  100a1d:	00 00                	add    %al,(%eax)
	...

00100a20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  100a20:	53                   	push   %ebx
  100a21:	83 ec 38             	sub    $0x38,%esp
  100a24:	8b 44 24 48          	mov    0x48(%esp),%eax
  100a28:	89 44 24 28          	mov    %eax,0x28(%esp)
  100a2c:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  100a30:	89 44 24 2c          	mov    %eax,0x2c(%esp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  100a34:	8b 44 24 50          	mov    0x50(%esp),%eax
  100a38:	ba 00 00 00 00       	mov    $0x0,%edx
  100a3d:	3b 54 24 2c          	cmp    0x2c(%esp),%edx
  100a41:	77 7f                	ja     100ac2 <printnum+0xa2>
  100a43:	3b 54 24 2c          	cmp    0x2c(%esp),%edx
  100a47:	72 06                	jb     100a4f <printnum+0x2f>
  100a49:	3b 44 24 28          	cmp    0x28(%esp),%eax
  100a4d:	77 73                	ja     100ac2 <printnum+0xa2>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  100a4f:	8b 44 24 54          	mov    0x54(%esp),%eax
  100a53:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100a56:	8b 44 24 50          	mov    0x50(%esp),%eax
  100a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  100a5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100a67:	8b 44 24 28          	mov    0x28(%esp),%eax
  100a6b:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  100a6f:	89 04 24             	mov    %eax,(%esp)
  100a72:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a76:	e8 15 0e 00 00       	call   101890 <__udivdi3>
  100a7b:	8b 4c 24 58          	mov    0x58(%esp),%ecx
  100a7f:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  100a83:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  100a87:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a8b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a93:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100a97:	8b 44 24 44          	mov    0x44(%esp),%eax
  100a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a9f:	8b 44 24 40          	mov    0x40(%esp),%eax
  100aa3:	89 04 24             	mov    %eax,(%esp)
  100aa6:	e8 75 ff ff ff       	call   100a20 <printnum>
  100aab:	eb 21                	jmp    100ace <printnum+0xae>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  100aad:	8b 44 24 44          	mov    0x44(%esp),%eax
  100ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab5:	8b 44 24 58          	mov    0x58(%esp),%eax
  100ab9:	89 04 24             	mov    %eax,(%esp)
  100abc:	8b 44 24 40          	mov    0x40(%esp),%eax
  100ac0:	ff d0                	call   *%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  100ac2:	83 6c 24 54 01       	subl   $0x1,0x54(%esp)
  100ac7:	83 7c 24 54 00       	cmpl   $0x0,0x54(%esp)
  100acc:	7f df                	jg     100aad <printnum+0x8d>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  100ace:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100ad2:	bb 00 00 00 00       	mov    $0x0,%ebx
  100ad7:	8b 44 24 28          	mov    0x28(%esp),%eax
  100adb:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  100adf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ae3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  100ae7:	89 04 24             	mov    %eax,(%esp)
  100aea:	89 54 24 04          	mov    %edx,0x4(%esp)
  100aee:	e8 ad 0e 00 00       	call   1019a0 <__umoddi3>
  100af3:	05 24 23 10 00       	add    $0x102324,%eax
  100af8:	0f b6 00             	movzbl (%eax),%eax
  100afb:	0f be c0             	movsbl %al,%eax
  100afe:	8b 54 24 44          	mov    0x44(%esp),%edx
  100b02:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b06:	89 04 24             	mov    %eax,(%esp)
  100b09:	8b 44 24 40          	mov    0x40(%esp),%eax
  100b0d:	ff d0                	call   *%eax
}
  100b0f:	83 c4 38             	add    $0x38,%esp
  100b12:	5b                   	pop    %ebx
  100b13:	c3                   	ret    

00100b14 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100b14:	83 7c 24 08 01       	cmpl   $0x1,0x8(%esp)
  100b19:	7e 16                	jle    100b31 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  100b1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  100b1f:	8b 00                	mov    (%eax),%eax
  100b21:	8d 48 08             	lea    0x8(%eax),%ecx
  100b24:	8b 54 24 04          	mov    0x4(%esp),%edx
  100b28:	89 0a                	mov    %ecx,(%edx)
  100b2a:	8b 50 04             	mov    0x4(%eax),%edx
  100b2d:	8b 00                	mov    (%eax),%eax
  100b2f:	eb 35                	jmp    100b66 <getuint+0x52>
	else if (lflag)
  100b31:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100b36:	74 18                	je     100b50 <getuint+0x3c>
		return va_arg(*ap, unsigned long);
  100b38:	8b 44 24 04          	mov    0x4(%esp),%eax
  100b3c:	8b 00                	mov    (%eax),%eax
  100b3e:	8d 48 04             	lea    0x4(%eax),%ecx
  100b41:	8b 54 24 04          	mov    0x4(%esp),%edx
  100b45:	89 0a                	mov    %ecx,(%edx)
  100b47:	8b 00                	mov    (%eax),%eax
  100b49:	ba 00 00 00 00       	mov    $0x0,%edx
  100b4e:	eb 16                	jmp    100b66 <getuint+0x52>
	else
		return va_arg(*ap, unsigned int);
  100b50:	8b 44 24 04          	mov    0x4(%esp),%eax
  100b54:	8b 00                	mov    (%eax),%eax
  100b56:	8d 48 04             	lea    0x4(%eax),%ecx
  100b59:	8b 54 24 04          	mov    0x4(%esp),%edx
  100b5d:	89 0a                	mov    %ecx,(%edx)
  100b5f:	8b 00                	mov    (%eax),%eax
  100b61:	ba 00 00 00 00       	mov    $0x0,%edx
}
  100b66:	c3                   	ret    

00100b67 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100b67:	83 7c 24 08 01       	cmpl   $0x1,0x8(%esp)
  100b6c:	7e 16                	jle    100b84 <getint+0x1d>
		return va_arg(*ap, long long);
  100b6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  100b72:	8b 00                	mov    (%eax),%eax
  100b74:	8d 48 08             	lea    0x8(%eax),%ecx
  100b77:	8b 54 24 04          	mov    0x4(%esp),%edx
  100b7b:	89 0a                	mov    %ecx,(%edx)
  100b7d:	8b 50 04             	mov    0x4(%eax),%edx
  100b80:	8b 00                	mov    (%eax),%eax
  100b82:	eb 35                	jmp    100bb9 <getint+0x52>
	else if (lflag)
  100b84:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100b89:	74 18                	je     100ba3 <getint+0x3c>
		return va_arg(*ap, long);
  100b8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  100b8f:	8b 00                	mov    (%eax),%eax
  100b91:	8d 48 04             	lea    0x4(%eax),%ecx
  100b94:	8b 54 24 04          	mov    0x4(%esp),%edx
  100b98:	89 0a                	mov    %ecx,(%edx)
  100b9a:	8b 00                	mov    (%eax),%eax
  100b9c:	89 c2                	mov    %eax,%edx
  100b9e:	c1 fa 1f             	sar    $0x1f,%edx
  100ba1:	eb 16                	jmp    100bb9 <getint+0x52>
	else
		return va_arg(*ap, int);
  100ba3:	8b 44 24 04          	mov    0x4(%esp),%eax
  100ba7:	8b 00                	mov    (%eax),%eax
  100ba9:	8d 48 04             	lea    0x4(%eax),%ecx
  100bac:	8b 54 24 04          	mov    0x4(%esp),%edx
  100bb0:	89 0a                	mov    %ecx,(%edx)
  100bb2:	8b 00                	mov    (%eax),%eax
  100bb4:	89 c2                	mov    %eax,%edx
  100bb6:	c1 fa 1f             	sar    $0x1f,%edx
}
  100bb9:	c3                   	ret    

00100bba <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  100bba:	56                   	push   %esi
  100bbb:	53                   	push   %ebx
  100bbc:	83 ec 44             	sub    $0x44,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  100bbf:	eb 19                	jmp    100bda <vprintfmt+0x20>
			if (ch == '\0')
  100bc1:	85 db                	test   %ebx,%ebx
  100bc3:	0f 84 73 04 00 00    	je     10103c <vprintfmt+0x482>
				return;
			putch(ch, putdat);
  100bc9:	8b 44 24 54          	mov    0x54(%esp),%eax
  100bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd1:	89 1c 24             	mov    %ebx,(%esp)
  100bd4:	8b 44 24 50          	mov    0x50(%esp),%eax
  100bd8:	ff d0                	call   *%eax
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  100bda:	8b 44 24 58          	mov    0x58(%esp),%eax
  100bde:	0f b6 00             	movzbl (%eax),%eax
  100be1:	0f b6 d8             	movzbl %al,%ebx
  100be4:	83 fb 25             	cmp    $0x25,%ebx
  100be7:	0f 95 c0             	setne  %al
  100bea:	83 44 24 58 01       	addl   $0x1,0x58(%esp)
  100bef:	84 c0                	test   %al,%al
  100bf1:	75 ce                	jne    100bc1 <vprintfmt+0x7>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  100bf3:	c6 44 24 23 20       	movb   $0x20,0x23(%esp)
		width = -1;
  100bf8:	c7 44 24 2c ff ff ff 	movl   $0xffffffff,0x2c(%esp)
  100bff:	ff 
		precision = -1;
  100c00:	c7 44 24 28 ff ff ff 	movl   $0xffffffff,0x28(%esp)
  100c07:	ff 
		lflag = 0;
  100c08:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100c0f:	00 
		altflag = 0;
  100c10:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
  100c17:	00 
  100c18:	eb 04                	jmp    100c1e <vprintfmt+0x64>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  100c1a:	90                   	nop
  100c1b:	eb 01                	jmp    100c1e <vprintfmt+0x64>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  100c1d:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c1e:	8b 44 24 58          	mov    0x58(%esp),%eax
  100c22:	0f b6 00             	movzbl (%eax),%eax
  100c25:	0f b6 d8             	movzbl %al,%ebx
  100c28:	89 d8                	mov    %ebx,%eax
  100c2a:	83 44 24 58 01       	addl   $0x1,0x58(%esp)
  100c2f:	83 e8 23             	sub    $0x23,%eax
  100c32:	83 f8 55             	cmp    $0x55,%eax
  100c35:	0f 87 cb 03 00 00    	ja     101006 <vprintfmt+0x44c>
  100c3b:	8b 04 85 48 23 10 00 	mov    0x102348(,%eax,4),%eax
  100c42:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  100c44:	c6 44 24 23 2d       	movb   $0x2d,0x23(%esp)
			goto reswitch;
  100c49:	eb d3                	jmp    100c1e <vprintfmt+0x64>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  100c4b:	c6 44 24 23 30       	movb   $0x30,0x23(%esp)
			goto reswitch;
  100c50:	eb cc                	jmp    100c1e <vprintfmt+0x64>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  100c52:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  100c59:	00 
				precision = precision * 10 + ch - '0';
  100c5a:	8b 54 24 28          	mov    0x28(%esp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	c1 e0 02             	shl    $0x2,%eax
  100c63:	01 d0                	add    %edx,%eax
  100c65:	01 c0                	add    %eax,%eax
  100c67:	01 d8                	add    %ebx,%eax
  100c69:	83 e8 30             	sub    $0x30,%eax
  100c6c:	89 44 24 28          	mov    %eax,0x28(%esp)
				ch = *fmt;
  100c70:	8b 44 24 58          	mov    0x58(%esp),%eax
  100c74:	0f b6 00             	movzbl (%eax),%eax
  100c77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  100c7a:	83 fb 2f             	cmp    $0x2f,%ebx
  100c7d:	7e 44                	jle    100cc3 <vprintfmt+0x109>
  100c7f:	83 fb 39             	cmp    $0x39,%ebx
  100c82:	7f 42                	jg     100cc6 <vprintfmt+0x10c>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  100c84:	83 44 24 58 01       	addl   $0x1,0x58(%esp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  100c89:	eb cf                	jmp    100c5a <vprintfmt+0xa0>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  100c8b:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  100c8f:	8d 50 04             	lea    0x4(%eax),%edx
  100c92:	89 54 24 5c          	mov    %edx,0x5c(%esp)
  100c96:	8b 00                	mov    (%eax),%eax
  100c98:	89 44 24 28          	mov    %eax,0x28(%esp)
			goto process_precision;
  100c9c:	eb 29                	jmp    100cc7 <vprintfmt+0x10d>

		case '.':
			if (width < 0)
  100c9e:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100ca3:	0f 89 71 ff ff ff    	jns    100c1a <vprintfmt+0x60>
				width = 0;
  100ca9:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  100cb0:	00 
			goto reswitch;
  100cb1:	e9 68 ff ff ff       	jmp    100c1e <vprintfmt+0x64>

		case '#':
			altflag = 1;
  100cb6:	c7 44 24 24 01 00 00 	movl   $0x1,0x24(%esp)
  100cbd:	00 
			goto reswitch;
  100cbe:	e9 5b ff ff ff       	jmp    100c1e <vprintfmt+0x64>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  100cc3:	90                   	nop
  100cc4:	eb 01                	jmp    100cc7 <vprintfmt+0x10d>
  100cc6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  100cc7:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100ccc:	0f 89 4b ff ff ff    	jns    100c1d <vprintfmt+0x63>
				width = precision, precision = -1;
  100cd2:	8b 44 24 28          	mov    0x28(%esp),%eax
  100cd6:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  100cda:	c7 44 24 28 ff ff ff 	movl   $0xffffffff,0x28(%esp)
  100ce1:	ff 
			goto reswitch;
  100ce2:	e9 37 ff ff ff       	jmp    100c1e <vprintfmt+0x64>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  100ce7:	83 44 24 30 01       	addl   $0x1,0x30(%esp)
			goto reswitch;
  100cec:	e9 2d ff ff ff       	jmp    100c1e <vprintfmt+0x64>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  100cf1:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  100cf5:	8d 50 04             	lea    0x4(%eax),%edx
  100cf8:	89 54 24 5c          	mov    %edx,0x5c(%esp)
  100cfc:	8b 00                	mov    (%eax),%eax
  100cfe:	8b 54 24 54          	mov    0x54(%esp),%edx
  100d02:	89 54 24 04          	mov    %edx,0x4(%esp)
  100d06:	89 04 24             	mov    %eax,(%esp)
  100d09:	8b 44 24 50          	mov    0x50(%esp),%eax
  100d0d:	ff d0                	call   *%eax
			break;
  100d0f:	e9 22 03 00 00       	jmp    101036 <vprintfmt+0x47c>

		// error message
		case 'e':
			err = va_arg(ap, int);
  100d14:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  100d18:	8d 50 04             	lea    0x4(%eax),%edx
  100d1b:	89 54 24 5c          	mov    %edx,0x5c(%esp)
  100d1f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  100d21:	85 db                	test   %ebx,%ebx
  100d23:	79 02                	jns    100d27 <vprintfmt+0x16d>
				err = -err;
  100d25:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  100d27:	83 fb 08             	cmp    $0x8,%ebx
  100d2a:	7f 0b                	jg     100d37 <vprintfmt+0x17d>
  100d2c:	8b 34 9d 00 23 10 00 	mov    0x102300(,%ebx,4),%esi
  100d33:	85 f6                	test   %esi,%esi
  100d35:	75 25                	jne    100d5c <vprintfmt+0x1a2>
				printfmt(putch, putdat, "error %d", err);
  100d37:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  100d3b:	c7 44 24 08 35 23 10 	movl   $0x102335,0x8(%esp)
  100d42:	00 
  100d43:	8b 44 24 54          	mov    0x54(%esp),%eax
  100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4b:	8b 44 24 50          	mov    0x50(%esp),%eax
  100d4f:	89 04 24             	mov    %eax,(%esp)
  100d52:	e8 ec 02 00 00       	call   101043 <printfmt>
			else
				printfmt(putch, putdat, "%s", p);
			break;
  100d57:	e9 da 02 00 00       	jmp    101036 <vprintfmt+0x47c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  100d5c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100d60:	c7 44 24 08 3e 23 10 	movl   $0x10233e,0x8(%esp)
  100d67:	00 
  100d68:	8b 44 24 54          	mov    0x54(%esp),%eax
  100d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d70:	8b 44 24 50          	mov    0x50(%esp),%eax
  100d74:	89 04 24             	mov    %eax,(%esp)
  100d77:	e8 c7 02 00 00       	call   101043 <printfmt>
			break;
  100d7c:	e9 b5 02 00 00       	jmp    101036 <vprintfmt+0x47c>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  100d81:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  100d85:	8d 50 04             	lea    0x4(%eax),%edx
  100d88:	89 54 24 5c          	mov    %edx,0x5c(%esp)
  100d8c:	8b 30                	mov    (%eax),%esi
  100d8e:	85 f6                	test   %esi,%esi
  100d90:	75 05                	jne    100d97 <vprintfmt+0x1dd>
				p = "(null)";
  100d92:	be 41 23 10 00       	mov    $0x102341,%esi
			if (width > 0 && padc != '-')
  100d97:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100d9c:	0f 8e 81 00 00 00    	jle    100e23 <vprintfmt+0x269>
  100da2:	80 7c 24 23 2d       	cmpb   $0x2d,0x23(%esp)
  100da7:	74 7d                	je     100e26 <vprintfmt+0x26c>
				for (width -= strnlen(p, precision); width > 0; width--)
  100da9:	8b 44 24 28          	mov    0x28(%esp),%eax
  100dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  100db1:	89 34 24             	mov    %esi,(%esp)
  100db4:	e8 b5 04 00 00       	call   10126e <strnlen>
  100db9:	29 44 24 2c          	sub    %eax,0x2c(%esp)
  100dbd:	eb 1b                	jmp    100dda <vprintfmt+0x220>
					putch(padc, putdat);
  100dbf:	0f be 44 24 23       	movsbl 0x23(%esp),%eax
  100dc4:	8b 54 24 54          	mov    0x54(%esp),%edx
  100dc8:	89 54 24 04          	mov    %edx,0x4(%esp)
  100dcc:	89 04 24             	mov    %eax,(%esp)
  100dcf:	8b 44 24 50          	mov    0x50(%esp),%eax
  100dd3:	ff d0                	call   *%eax
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100dd5:	83 6c 24 2c 01       	subl   $0x1,0x2c(%esp)
  100dda:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100ddf:	7f de                	jg     100dbf <vprintfmt+0x205>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100de1:	eb 44                	jmp    100e27 <vprintfmt+0x26d>
				if (altflag && (ch < ' ' || ch > '~'))
  100de3:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
  100de8:	74 21                	je     100e0b <vprintfmt+0x251>
  100dea:	83 fb 1f             	cmp    $0x1f,%ebx
  100ded:	7e 05                	jle    100df4 <vprintfmt+0x23a>
  100def:	83 fb 7e             	cmp    $0x7e,%ebx
  100df2:	7e 17                	jle    100e0b <vprintfmt+0x251>
					putch('?', putdat);
  100df4:	8b 44 24 54          	mov    0x54(%esp),%eax
  100df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100dfc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  100e03:	8b 44 24 50          	mov    0x50(%esp),%eax
  100e07:	ff d0                	call   *%eax
  100e09:	eb 11                	jmp    100e1c <vprintfmt+0x262>
				else
					putch(ch, putdat);
  100e0b:	8b 44 24 54          	mov    0x54(%esp),%eax
  100e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e13:	89 1c 24             	mov    %ebx,(%esp)
  100e16:	8b 44 24 50          	mov    0x50(%esp),%eax
  100e1a:	ff d0                	call   *%eax
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100e1c:	83 6c 24 2c 01       	subl   $0x1,0x2c(%esp)
  100e21:	eb 04                	jmp    100e27 <vprintfmt+0x26d>
  100e23:	90                   	nop
  100e24:	eb 01                	jmp    100e27 <vprintfmt+0x26d>
  100e26:	90                   	nop
  100e27:	0f b6 06             	movzbl (%esi),%eax
  100e2a:	0f be d8             	movsbl %al,%ebx
  100e2d:	85 db                	test   %ebx,%ebx
  100e2f:	0f 95 c0             	setne  %al
  100e32:	83 c6 01             	add    $0x1,%esi
  100e35:	84 c0                	test   %al,%al
  100e37:	74 2f                	je     100e68 <vprintfmt+0x2ae>
  100e39:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
  100e3e:	78 a3                	js     100de3 <vprintfmt+0x229>
  100e40:	83 6c 24 28 01       	subl   $0x1,0x28(%esp)
  100e45:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
  100e4a:	79 97                	jns    100de3 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100e4c:	eb 1a                	jmp    100e68 <vprintfmt+0x2ae>
				putch(' ', putdat);
  100e4e:	8b 44 24 54          	mov    0x54(%esp),%eax
  100e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e56:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100e5d:	8b 44 24 50          	mov    0x50(%esp),%eax
  100e61:	ff d0                	call   *%eax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100e63:	83 6c 24 2c 01       	subl   $0x1,0x2c(%esp)
  100e68:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100e6d:	7f df                	jg     100e4e <vprintfmt+0x294>
				putch(' ', putdat);
			break;
  100e6f:	e9 c2 01 00 00       	jmp    101036 <vprintfmt+0x47c>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  100e74:	8b 44 24 30          	mov    0x30(%esp),%eax
  100e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e7c:	8d 44 24 5c          	lea    0x5c(%esp),%eax
  100e80:	89 04 24             	mov    %eax,(%esp)
  100e83:	e8 df fc ff ff       	call   100b67 <getint>
  100e88:	89 44 24 38          	mov    %eax,0x38(%esp)
  100e8c:	89 54 24 3c          	mov    %edx,0x3c(%esp)
			if ((long long) num < 0) {
  100e90:	8b 44 24 38          	mov    0x38(%esp),%eax
  100e94:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  100e98:	85 d2                	test   %edx,%edx
  100e9a:	79 2c                	jns    100ec8 <vprintfmt+0x30e>
				putch('-', putdat);
  100e9c:	8b 44 24 54          	mov    0x54(%esp),%eax
  100ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ea4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  100eab:	8b 44 24 50          	mov    0x50(%esp),%eax
  100eaf:	ff d0                	call   *%eax
				num = -(long long) num;
  100eb1:	8b 44 24 38          	mov    0x38(%esp),%eax
  100eb5:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  100eb9:	f7 d8                	neg    %eax
  100ebb:	83 d2 00             	adc    $0x0,%edx
  100ebe:	f7 da                	neg    %edx
  100ec0:	89 44 24 38          	mov    %eax,0x38(%esp)
  100ec4:	89 54 24 3c          	mov    %edx,0x3c(%esp)
			}
			base = 10;
  100ec8:	c7 44 24 34 0a 00 00 	movl   $0xa,0x34(%esp)
  100ecf:	00 
			goto number;
  100ed0:	e9 df 00 00 00       	jmp    100fb4 <vprintfmt+0x3fa>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  100ed5:	8b 44 24 30          	mov    0x30(%esp),%eax
  100ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100edd:	8d 44 24 5c          	lea    0x5c(%esp),%eax
  100ee1:	89 04 24             	mov    %eax,(%esp)
  100ee4:	e8 2b fc ff ff       	call   100b14 <getuint>
  100ee9:	89 44 24 38          	mov    %eax,0x38(%esp)
  100eed:	89 54 24 3c          	mov    %edx,0x3c(%esp)
			base = 10;
  100ef1:	c7 44 24 34 0a 00 00 	movl   $0xa,0x34(%esp)
  100ef8:	00 
			goto number;
  100ef9:	e9 b6 00 00 00       	jmp    100fb4 <vprintfmt+0x3fa>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  100efe:	8b 44 24 54          	mov    0x54(%esp),%eax
  100f02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f06:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f0d:	8b 44 24 50          	mov    0x50(%esp),%eax
  100f11:	ff d0                	call   *%eax
			putch('X', putdat);
  100f13:	8b 44 24 54          	mov    0x54(%esp),%eax
  100f17:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f1b:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f22:	8b 44 24 50          	mov    0x50(%esp),%eax
  100f26:	ff d0                	call   *%eax
			putch('X', putdat);
  100f28:	8b 44 24 54          	mov    0x54(%esp),%eax
  100f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f30:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f37:	8b 44 24 50          	mov    0x50(%esp),%eax
  100f3b:	ff d0                	call   *%eax
			break;
  100f3d:	e9 f4 00 00 00       	jmp    101036 <vprintfmt+0x47c>

		// pointer
		case 'p':
			putch('0', putdat);
  100f42:	8b 44 24 54          	mov    0x54(%esp),%eax
  100f46:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f4a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  100f51:	8b 44 24 50          	mov    0x50(%esp),%eax
  100f55:	ff d0                	call   *%eax
			putch('x', putdat);
  100f57:	8b 44 24 54          	mov    0x54(%esp),%eax
  100f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f5f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  100f66:	8b 44 24 50          	mov    0x50(%esp),%eax
  100f6a:	ff d0                	call   *%eax
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  100f6c:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  100f70:	8d 50 04             	lea    0x4(%eax),%edx
  100f73:	89 54 24 5c          	mov    %edx,0x5c(%esp)
  100f77:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  100f79:	ba 00 00 00 00       	mov    $0x0,%edx
  100f7e:	89 44 24 38          	mov    %eax,0x38(%esp)
  100f82:	89 54 24 3c          	mov    %edx,0x3c(%esp)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  100f86:	c7 44 24 34 10 00 00 	movl   $0x10,0x34(%esp)
  100f8d:	00 
			goto number;
  100f8e:	eb 24                	jmp    100fb4 <vprintfmt+0x3fa>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  100f90:	8b 44 24 30          	mov    0x30(%esp),%eax
  100f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f98:	8d 44 24 5c          	lea    0x5c(%esp),%eax
  100f9c:	89 04 24             	mov    %eax,(%esp)
  100f9f:	e8 70 fb ff ff       	call   100b14 <getuint>
  100fa4:	89 44 24 38          	mov    %eax,0x38(%esp)
  100fa8:	89 54 24 3c          	mov    %edx,0x3c(%esp)
			base = 16;
  100fac:	c7 44 24 34 10 00 00 	movl   $0x10,0x34(%esp)
  100fb3:	00 
		number:
			printnum(putch, putdat, num, base, width, padc);
  100fb4:	0f be 54 24 23       	movsbl 0x23(%esp),%edx
  100fb9:	8b 44 24 34          	mov    0x34(%esp),%eax
  100fbd:	89 54 24 18          	mov    %edx,0x18(%esp)
  100fc1:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  100fc5:	89 54 24 14          	mov    %edx,0x14(%esp)
  100fc9:	89 44 24 10          	mov    %eax,0x10(%esp)
  100fcd:	8b 44 24 38          	mov    0x38(%esp),%eax
  100fd1:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  100fd5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100fd9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100fdd:	8b 44 24 54          	mov    0x54(%esp),%eax
  100fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100fe5:	8b 44 24 50          	mov    0x50(%esp),%eax
  100fe9:	89 04 24             	mov    %eax,(%esp)
  100fec:	e8 2f fa ff ff       	call   100a20 <printnum>
			break;
  100ff1:	eb 43                	jmp    101036 <vprintfmt+0x47c>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  100ff3:	8b 44 24 54          	mov    0x54(%esp),%eax
  100ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ffb:	89 1c 24             	mov    %ebx,(%esp)
  100ffe:	8b 44 24 50          	mov    0x50(%esp),%eax
  101002:	ff d0                	call   *%eax
			break;
  101004:	eb 30                	jmp    101036 <vprintfmt+0x47c>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  101006:	8b 44 24 54          	mov    0x54(%esp),%eax
  10100a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10100e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  101015:	8b 44 24 50          	mov    0x50(%esp),%eax
  101019:	ff d0                	call   *%eax
			for (fmt--; fmt[-1] != '%'; fmt--)
  10101b:	83 6c 24 58 01       	subl   $0x1,0x58(%esp)
  101020:	eb 05                	jmp    101027 <vprintfmt+0x46d>
  101022:	83 6c 24 58 01       	subl   $0x1,0x58(%esp)
  101027:	8b 44 24 58          	mov    0x58(%esp),%eax
  10102b:	83 e8 01             	sub    $0x1,%eax
  10102e:	0f b6 00             	movzbl (%eax),%eax
  101031:	3c 25                	cmp    $0x25,%al
  101033:	75 ed                	jne    101022 <vprintfmt+0x468>
				/* do nothing */;
			break;
  101035:	90                   	nop
		}
	}
  101036:	90                   	nop
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  101037:	e9 9e fb ff ff       	jmp    100bda <vprintfmt+0x20>
			if (ch == '\0')
				return;
  10103c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  10103d:	83 c4 44             	add    $0x44,%esp
  101040:	5b                   	pop    %ebx
  101041:	5e                   	pop    %esi
  101042:	c3                   	ret    

00101043 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  101043:	83 ec 2c             	sub    $0x2c,%esp
	va_list ap;

	va_start(ap, fmt);
  101046:	8d 44 24 3c          	lea    0x3c(%esp),%eax
  10104a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	vprintfmt(putch, putdat, fmt, ap);
  10104e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  101052:	89 44 24 0c          	mov    %eax,0xc(%esp)
  101056:	8b 44 24 38          	mov    0x38(%esp),%eax
  10105a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10105e:	8b 44 24 34          	mov    0x34(%esp),%eax
  101062:	89 44 24 04          	mov    %eax,0x4(%esp)
  101066:	8b 44 24 30          	mov    0x30(%esp),%eax
  10106a:	89 04 24             	mov    %eax,(%esp)
  10106d:	e8 48 fb ff ff       	call   100bba <vprintfmt>
	va_end(ap);
}
  101072:	83 c4 2c             	add    $0x2c,%esp
  101075:	c3                   	ret    

00101076 <sprintputch>:
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
	b->cnt++;
  101076:	8b 44 24 08          	mov    0x8(%esp),%eax
  10107a:	8b 40 08             	mov    0x8(%eax),%eax
  10107d:	8d 50 01             	lea    0x1(%eax),%edx
  101080:	8b 44 24 08          	mov    0x8(%esp),%eax
  101084:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  101087:	8b 44 24 08          	mov    0x8(%esp),%eax
  10108b:	8b 10                	mov    (%eax),%edx
  10108d:	8b 44 24 08          	mov    0x8(%esp),%eax
  101091:	8b 40 04             	mov    0x4(%eax),%eax
  101094:	39 c2                	cmp    %eax,%edx
  101096:	73 15                	jae    1010ad <sprintputch+0x37>
		*b->buf++ = ch;
  101098:	8b 44 24 08          	mov    0x8(%esp),%eax
  10109c:	8b 00                	mov    (%eax),%eax
  10109e:	8b 54 24 04          	mov    0x4(%esp),%edx
  1010a2:	88 10                	mov    %dl,(%eax)
  1010a4:	8d 50 01             	lea    0x1(%eax),%edx
  1010a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  1010ab:	89 10                	mov    %edx,(%eax)
}
  1010ad:	c3                   	ret    

001010ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  1010ae:	83 ec 2c             	sub    $0x2c,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  1010b1:	8b 44 24 34          	mov    0x34(%esp),%eax
  1010b5:	83 e8 01             	sub    $0x1,%eax
  1010b8:	03 44 24 30          	add    0x30(%esp),%eax
  1010bc:	8b 54 24 30          	mov    0x30(%esp),%edx
  1010c0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1010c4:	89 44 24 18          	mov    %eax,0x18(%esp)
  1010c8:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  1010cf:	00 

	if (buf == NULL || n < 1)
  1010d0:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  1010d5:	74 07                	je     1010de <vsnprintf+0x30>
  1010d7:	83 7c 24 34 00       	cmpl   $0x0,0x34(%esp)
  1010dc:	7f 07                	jg     1010e5 <vsnprintf+0x37>
		return -E_INVAL;
  1010de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1010e3:	eb 30                	jmp    101115 <vsnprintf+0x67>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  1010e5:	b8 76 10 10 00       	mov    $0x101076,%eax
  1010ea:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  1010ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1010f2:	8b 54 24 38          	mov    0x38(%esp),%edx
  1010f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  1010fa:	8d 54 24 14          	lea    0x14(%esp),%edx
  1010fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  101102:	89 04 24             	mov    %eax,(%esp)
  101105:	e8 b0 fa ff ff       	call   100bba <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  10110a:	8b 44 24 14          	mov    0x14(%esp),%eax
  10110e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  101111:	8b 44 24 1c          	mov    0x1c(%esp),%eax
}
  101115:	83 c4 2c             	add    $0x2c,%esp
  101118:	c3                   	ret    

00101119 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  101119:	83 ec 2c             	sub    $0x2c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  10111c:	8d 44 24 3c          	lea    0x3c(%esp),%eax
  101120:	89 44 24 18          	mov    %eax,0x18(%esp)
	rc = vsnprintf(buf, n, fmt, ap);
  101124:	8b 44 24 18          	mov    0x18(%esp),%eax
  101128:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10112c:	8b 44 24 38          	mov    0x38(%esp),%eax
  101130:	89 44 24 08          	mov    %eax,0x8(%esp)
  101134:	8b 44 24 34          	mov    0x34(%esp),%eax
  101138:	89 44 24 04          	mov    %eax,0x4(%esp)
  10113c:	8b 44 24 30          	mov    0x30(%esp),%eax
  101140:	89 04 24             	mov    %eax,(%esp)
  101143:	e8 66 ff ff ff       	call   1010ae <vsnprintf>
  101148:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	va_end(ap);

	return rc;
  10114c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
}
  101150:	83 c4 2c             	add    $0x2c,%esp
  101153:	c3                   	ret    

00101154 <readline>:

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  101154:	83 ec 2c             	sub    $0x2c,%esp
	int i, c, echoing;

	if (prompt != NULL)
  101157:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  10115c:	74 14                	je     101172 <readline+0x1e>
		cprintf("%s", prompt);
  10115e:	8b 44 24 30          	mov    0x30(%esp),%eax
  101162:	89 44 24 04          	mov    %eax,0x4(%esp)
  101166:	c7 04 24 a0 24 10 00 	movl   $0x1024a0,(%esp)
  10116d:	e8 04 f6 ff ff       	call   100776 <cprintf>

	i = 0;
  101172:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  101179:	00 
  10117a:	eb 01                	jmp    10117d <readline+0x29>
		} else if (c == '\n' || c == '\r') {
			putch('\n');
			buf[i] = 0;
			return buf;
		}
	}
  10117c:	90                   	nop
	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
	while (1) {
		c = getc();
  10117d:	e8 e9 f0 ff ff       	call   10026b <getc>
  101182:	89 44 24 18          	mov    %eax,0x18(%esp)
		if (c < 0) {
  101186:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  10118b:	79 1e                	jns    1011ab <readline+0x57>
			cprintf("read error: %e\n", c);
  10118d:	8b 44 24 18          	mov    0x18(%esp),%eax
  101191:	89 44 24 04          	mov    %eax,0x4(%esp)
  101195:	c7 04 24 a3 24 10 00 	movl   $0x1024a3,(%esp)
  10119c:	e8 d5 f5 ff ff       	call   100776 <cprintf>
			return NULL;
  1011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1011a6:	e9 95 00 00 00       	jmp    101240 <readline+0xec>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  1011ab:	83 7c 24 18 08       	cmpl   $0x8,0x18(%esp)
  1011b0:	74 07                	je     1011b9 <readline+0x65>
  1011b2:	83 7c 24 18 7f       	cmpl   $0x7f,0x18(%esp)
  1011b7:	75 1a                	jne    1011d3 <readline+0x7f>
  1011b9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  1011be:	7e 13                	jle    1011d3 <readline+0x7f>
			putch('\b');
  1011c0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1011c7:	e8 9d f1 ff ff       	call   100369 <putch>
			i--;
  1011cc:	83 6c 24 1c 01       	subl   $0x1,0x1c(%esp)
  1011d1:	eb 68                	jmp    10123b <readline+0xe7>
		} else if (c >= ' ' && i < BUFLEN-1) {
  1011d3:	83 7c 24 18 1f       	cmpl   $0x1f,0x18(%esp)
  1011d8:	7e 30                	jle    10120a <readline+0xb6>
  1011da:	81 7c 24 1c fe 03 00 	cmpl   $0x3fe,0x1c(%esp)
  1011e1:	00 
  1011e2:	7f 26                	jg     10120a <readline+0xb6>
			putch(c);
  1011e4:	8b 44 24 18          	mov    0x18(%esp),%eax
  1011e8:	0f b6 c0             	movzbl %al,%eax
  1011eb:	89 04 24             	mov    %eax,(%esp)
  1011ee:	e8 76 f1 ff ff       	call   100369 <putch>
			buf[i++] = c;
  1011f3:	8b 44 24 18          	mov    0x18(%esp),%eax
  1011f7:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  1011fb:	81 c2 40 b5 10 00    	add    $0x10b540,%edx
  101201:	88 02                	mov    %al,(%edx)
  101203:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  101208:	eb 31                	jmp    10123b <readline+0xe7>
		} else if (c == '\n' || c == '\r') {
  10120a:	83 7c 24 18 0a       	cmpl   $0xa,0x18(%esp)
  10120f:	74 0b                	je     10121c <readline+0xc8>
  101211:	83 7c 24 18 0d       	cmpl   $0xd,0x18(%esp)
  101216:	0f 85 60 ff ff ff    	jne    10117c <readline+0x28>
			putch('\n');
  10121c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  101223:	e8 41 f1 ff ff       	call   100369 <putch>
			buf[i] = 0;
  101228:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  10122c:	05 40 b5 10 00       	add    $0x10b540,%eax
  101231:	c6 00 00             	movb   $0x0,(%eax)
			return buf;
  101234:	b8 40 b5 10 00       	mov    $0x10b540,%eax
  101239:	eb 05                	jmp    101240 <readline+0xec>
		}
	}
  10123b:	e9 3d ff ff ff       	jmp    10117d <readline+0x29>
}
  101240:	83 c4 2c             	add    $0x2c,%esp
  101243:	c3                   	ret    

00101244 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  101244:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  101247:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10124e:	00 
  10124f:	eb 0a                	jmp    10125b <strlen+0x17>
		n++;
  101251:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  101256:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  10125b:	8b 44 24 14          	mov    0x14(%esp),%eax
  10125f:	0f b6 00             	movzbl (%eax),%eax
  101262:	84 c0                	test   %al,%al
  101264:	75 eb                	jne    101251 <strlen+0xd>
		n++;
	return n;
  101266:	8b 44 24 0c          	mov    0xc(%esp),%eax
}
  10126a:	83 c4 10             	add    $0x10,%esp
  10126d:	c3                   	ret    

0010126e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  10126e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101271:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  101278:	00 
  101279:	eb 0f                	jmp    10128a <strnlen+0x1c>
		n++;
  10127b:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101280:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  101285:	83 6c 24 18 01       	subl   $0x1,0x18(%esp)
  10128a:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  10128f:	74 0b                	je     10129c <strnlen+0x2e>
  101291:	8b 44 24 14          	mov    0x14(%esp),%eax
  101295:	0f b6 00             	movzbl (%eax),%eax
  101298:	84 c0                	test   %al,%al
  10129a:	75 df                	jne    10127b <strnlen+0xd>
		n++;
	return n;
  10129c:	8b 44 24 0c          	mov    0xc(%esp),%eax
}
  1012a0:	83 c4 10             	add    $0x10,%esp
  1012a3:	c3                   	ret    

001012a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  1012a4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  1012a7:	8b 44 24 14          	mov    0x14(%esp),%eax
  1012ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
	while ((*dst++ = *src++) != '\0')
  1012af:	90                   	nop
  1012b0:	8b 44 24 18          	mov    0x18(%esp),%eax
  1012b4:	0f b6 10             	movzbl (%eax),%edx
  1012b7:	8b 44 24 14          	mov    0x14(%esp),%eax
  1012bb:	88 10                	mov    %dl,(%eax)
  1012bd:	8b 44 24 14          	mov    0x14(%esp),%eax
  1012c1:	0f b6 00             	movzbl (%eax),%eax
  1012c4:	84 c0                	test   %al,%al
  1012c6:	0f 95 c0             	setne  %al
  1012c9:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  1012ce:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
  1012d3:	84 c0                	test   %al,%al
  1012d5:	75 d9                	jne    1012b0 <strcpy+0xc>
		/* do nothing */;
	return ret;
  1012d7:	8b 44 24 0c          	mov    0xc(%esp),%eax
}
  1012db:	83 c4 10             	add    $0x10,%esp
  1012de:	c3                   	ret    

001012df <strcat>:

char *
strcat(char *dst, const char *src)
{
  1012df:	83 ec 18             	sub    $0x18,%esp
	int len = strlen(dst);
  1012e2:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1012e6:	89 04 24             	mov    %eax,(%esp)
  1012e9:	e8 56 ff ff ff       	call   101244 <strlen>
  1012ee:	89 44 24 14          	mov    %eax,0x14(%esp)
	strcpy(dst + len, src);
  1012f2:	8b 44 24 14          	mov    0x14(%esp),%eax
  1012f6:	03 44 24 1c          	add    0x1c(%esp),%eax
  1012fa:	8b 54 24 20          	mov    0x20(%esp),%edx
  1012fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  101302:	89 04 24             	mov    %eax,(%esp)
  101305:	e8 9a ff ff ff       	call   1012a4 <strcpy>
	return dst;
  10130a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
}
  10130e:	83 c4 18             	add    $0x18,%esp
  101311:	c3                   	ret    

00101312 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  101312:	83 ec 10             	sub    $0x10,%esp
	size_t i;
	char *ret;

	ret = dst;
  101315:	8b 44 24 14          	mov    0x14(%esp),%eax
  101319:	89 44 24 08          	mov    %eax,0x8(%esp)
	for (i = 0; i < size; i++) {
  10131d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  101324:	00 
  101325:	eb 27                	jmp    10134e <strncpy+0x3c>
		*dst++ = *src;
  101327:	8b 44 24 18          	mov    0x18(%esp),%eax
  10132b:	0f b6 10             	movzbl (%eax),%edx
  10132e:	8b 44 24 14          	mov    0x14(%esp),%eax
  101332:	88 10                	mov    %dl,(%eax)
  101334:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  101339:	8b 44 24 18          	mov    0x18(%esp),%eax
  10133d:	0f b6 00             	movzbl (%eax),%eax
  101340:	84 c0                	test   %al,%al
  101342:	74 05                	je     101349 <strncpy+0x37>
			src++;
  101344:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  101349:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
  10134e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101352:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
  101356:	72 cf                	jb     101327 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  101358:	8b 44 24 08          	mov    0x8(%esp),%eax
}
  10135c:	83 c4 10             	add    $0x10,%esp
  10135f:	c3                   	ret    

00101360 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  101360:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  101363:	8b 44 24 14          	mov    0x14(%esp),%eax
  101367:	89 44 24 0c          	mov    %eax,0xc(%esp)
	if (size > 0) {
  10136b:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  101370:	74 37                	je     1013a9 <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  101372:	eb 17                	jmp    10138b <strlcpy+0x2b>
			*dst++ = *src++;
  101374:	8b 44 24 18          	mov    0x18(%esp),%eax
  101378:	0f b6 10             	movzbl (%eax),%edx
  10137b:	8b 44 24 14          	mov    0x14(%esp),%eax
  10137f:	88 10                	mov    %dl,(%eax)
  101381:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  101386:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  10138b:	83 6c 24 1c 01       	subl   $0x1,0x1c(%esp)
  101390:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  101395:	74 0b                	je     1013a2 <strlcpy+0x42>
  101397:	8b 44 24 18          	mov    0x18(%esp),%eax
  10139b:	0f b6 00             	movzbl (%eax),%eax
  10139e:	84 c0                	test   %al,%al
  1013a0:	75 d2                	jne    101374 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  1013a2:	8b 44 24 14          	mov    0x14(%esp),%eax
  1013a6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  1013a9:	8b 54 24 14          	mov    0x14(%esp),%edx
  1013ad:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1013b1:	89 d1                	mov    %edx,%ecx
  1013b3:	29 c1                	sub    %eax,%ecx
  1013b5:	89 c8                	mov    %ecx,%eax
}
  1013b7:	83 c4 10             	add    $0x10,%esp
  1013ba:	c3                   	ret    

001013bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  1013bb:	eb 0a                	jmp    1013c7 <strcmp+0xc>
		p++, q++;
  1013bd:	83 44 24 04 01       	addl   $0x1,0x4(%esp)
  1013c2:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  1013c7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1013cb:	0f b6 00             	movzbl (%eax),%eax
  1013ce:	84 c0                	test   %al,%al
  1013d0:	74 12                	je     1013e4 <strcmp+0x29>
  1013d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  1013d6:	0f b6 10             	movzbl (%eax),%edx
  1013d9:	8b 44 24 08          	mov    0x8(%esp),%eax
  1013dd:	0f b6 00             	movzbl (%eax),%eax
  1013e0:	38 c2                	cmp    %al,%dl
  1013e2:	74 d9                	je     1013bd <strcmp+0x2>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  1013e4:	8b 44 24 04          	mov    0x4(%esp),%eax
  1013e8:	0f b6 00             	movzbl (%eax),%eax
  1013eb:	0f b6 d0             	movzbl %al,%edx
  1013ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  1013f2:	0f b6 00             	movzbl (%eax),%eax
  1013f5:	0f b6 c0             	movzbl %al,%eax
  1013f8:	89 d1                	mov    %edx,%ecx
  1013fa:	29 c1                	sub    %eax,%ecx
  1013fc:	89 c8                	mov    %ecx,%eax
}
  1013fe:	c3                   	ret    

001013ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  1013ff:	eb 0f                	jmp    101410 <strncmp+0x11>
		n--, p++, q++;
  101401:	83 6c 24 0c 01       	subl   $0x1,0xc(%esp)
  101406:	83 44 24 04 01       	addl   $0x1,0x4(%esp)
  10140b:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  101410:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  101415:	74 1d                	je     101434 <strncmp+0x35>
  101417:	8b 44 24 04          	mov    0x4(%esp),%eax
  10141b:	0f b6 00             	movzbl (%eax),%eax
  10141e:	84 c0                	test   %al,%al
  101420:	74 12                	je     101434 <strncmp+0x35>
  101422:	8b 44 24 04          	mov    0x4(%esp),%eax
  101426:	0f b6 10             	movzbl (%eax),%edx
  101429:	8b 44 24 08          	mov    0x8(%esp),%eax
  10142d:	0f b6 00             	movzbl (%eax),%eax
  101430:	38 c2                	cmp    %al,%dl
  101432:	74 cd                	je     101401 <strncmp+0x2>
		n--, p++, q++;
	if (n == 0)
  101434:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  101439:	75 07                	jne    101442 <strncmp+0x43>
		return 0;
  10143b:	b8 00 00 00 00       	mov    $0x0,%eax
  101440:	eb 1a                	jmp    10145c <strncmp+0x5d>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  101442:	8b 44 24 04          	mov    0x4(%esp),%eax
  101446:	0f b6 00             	movzbl (%eax),%eax
  101449:	0f b6 d0             	movzbl %al,%edx
  10144c:	8b 44 24 08          	mov    0x8(%esp),%eax
  101450:	0f b6 00             	movzbl (%eax),%eax
  101453:	0f b6 c0             	movzbl %al,%eax
  101456:	89 d1                	mov    %edx,%ecx
  101458:	29 c1                	sub    %eax,%ecx
  10145a:	89 c8                	mov    %ecx,%eax
}
  10145c:	c3                   	ret    

0010145d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  10145d:	83 ec 04             	sub    $0x4,%esp
  101460:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101464:	88 04 24             	mov    %al,(%esp)
	for (; *s; s++)
  101467:	eb 17                	jmp    101480 <strchr+0x23>
		if (*s == c)
  101469:	8b 44 24 08          	mov    0x8(%esp),%eax
  10146d:	0f b6 00             	movzbl (%eax),%eax
  101470:	3a 04 24             	cmp    (%esp),%al
  101473:	75 06                	jne    10147b <strchr+0x1e>
			return (char *) s;
  101475:	8b 44 24 08          	mov    0x8(%esp),%eax
  101479:	eb 15                	jmp    101490 <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  10147b:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
  101480:	8b 44 24 08          	mov    0x8(%esp),%eax
  101484:	0f b6 00             	movzbl (%eax),%eax
  101487:	84 c0                	test   %al,%al
  101489:	75 de                	jne    101469 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  10148b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101490:	83 c4 04             	add    $0x4,%esp
  101493:	c3                   	ret    

00101494 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  101494:	83 ec 04             	sub    $0x4,%esp
  101497:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10149b:	88 04 24             	mov    %al,(%esp)
	for (; *s; s++)
  10149e:	eb 11                	jmp    1014b1 <strfind+0x1d>
		if (*s == c)
  1014a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  1014a4:	0f b6 00             	movzbl (%eax),%eax
  1014a7:	3a 04 24             	cmp    (%esp),%al
  1014aa:	74 12                	je     1014be <strfind+0x2a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  1014ac:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
  1014b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  1014b5:	0f b6 00             	movzbl (%eax),%eax
  1014b8:	84 c0                	test   %al,%al
  1014ba:	75 e4                	jne    1014a0 <strfind+0xc>
  1014bc:	eb 01                	jmp    1014bf <strfind+0x2b>
		if (*s == c)
			break;
  1014be:	90                   	nop
	return (char *) s;
  1014bf:	8b 44 24 08          	mov    0x8(%esp),%eax
}
  1014c3:	83 c4 04             	add    $0x4,%esp
  1014c6:	c3                   	ret    

001014c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  1014c7:	57                   	push   %edi
	char *p;

	if (n == 0)
  1014c8:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  1014cd:	75 06                	jne    1014d5 <memset+0xe>
		return v;
  1014cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  1014d3:	eb 6a                	jmp    10153f <memset+0x78>
	if ((int)v%4 == 0 && n%4 == 0) {
  1014d5:	8b 44 24 08          	mov    0x8(%esp),%eax
  1014d9:	83 e0 03             	and    $0x3,%eax
  1014dc:	85 c0                	test   %eax,%eax
  1014de:	75 4a                	jne    10152a <memset+0x63>
  1014e0:	8b 44 24 10          	mov    0x10(%esp),%eax
  1014e4:	83 e0 03             	and    $0x3,%eax
  1014e7:	85 c0                	test   %eax,%eax
  1014e9:	75 3f                	jne    10152a <memset+0x63>
		c &= 0xFF;
  1014eb:	81 64 24 0c ff 00 00 	andl   $0xff,0xc(%esp)
  1014f2:	00 
		c = (c<<24)|(c<<16)|(c<<8)|c;
  1014f3:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1014f7:	89 c2                	mov    %eax,%edx
  1014f9:	c1 e2 18             	shl    $0x18,%edx
  1014fc:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101500:	c1 e0 10             	shl    $0x10,%eax
  101503:	09 c2                	or     %eax,%edx
  101505:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101509:	c1 e0 08             	shl    $0x8,%eax
  10150c:	09 d0                	or     %edx,%eax
  10150e:	09 44 24 0c          	or     %eax,0xc(%esp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  101512:	8b 44 24 10          	mov    0x10(%esp),%eax
  101516:	89 c1                	mov    %eax,%ecx
  101518:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  10151b:	8b 54 24 08          	mov    0x8(%esp),%edx
  10151f:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101523:	89 d7                	mov    %edx,%edi
  101525:	fc                   	cld    
  101526:	f3 ab                	rep stos %eax,%es:(%edi)
  101528:	eb 11                	jmp    10153b <memset+0x74>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  10152a:	8b 54 24 08          	mov    0x8(%esp),%edx
  10152e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101532:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  101536:	89 d7                	mov    %edx,%edi
  101538:	fc                   	cld    
  101539:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  10153b:	8b 44 24 08          	mov    0x8(%esp),%eax
}
  10153f:	5f                   	pop    %edi
  101540:	c3                   	ret    

00101541 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  101541:	57                   	push   %edi
  101542:	56                   	push   %esi
  101543:	53                   	push   %ebx
  101544:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  101547:	8b 44 24 24          	mov    0x24(%esp),%eax
  10154b:	89 44 24 0c          	mov    %eax,0xc(%esp)
	d = dst;
  10154f:	8b 44 24 20          	mov    0x20(%esp),%eax
  101553:	89 44 24 08          	mov    %eax,0x8(%esp)
	if (s < d && s + n > d) {
  101557:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10155b:	3b 44 24 08          	cmp    0x8(%esp),%eax
  10155f:	73 7e                	jae    1015df <memmove+0x9e>
  101561:	8b 44 24 28          	mov    0x28(%esp),%eax
  101565:	8b 54 24 0c          	mov    0xc(%esp),%edx
  101569:	8d 04 02             	lea    (%edx,%eax,1),%eax
  10156c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  101570:	76 6d                	jbe    1015df <memmove+0x9e>
		s += n;
  101572:	8b 44 24 28          	mov    0x28(%esp),%eax
  101576:	01 44 24 0c          	add    %eax,0xc(%esp)
		d += n;
  10157a:	8b 44 24 28          	mov    0x28(%esp),%eax
  10157e:	01 44 24 08          	add    %eax,0x8(%esp)
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101582:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101586:	83 e0 03             	and    $0x3,%eax
  101589:	85 c0                	test   %eax,%eax
  10158b:	75 34                	jne    1015c1 <memmove+0x80>
  10158d:	8b 44 24 08          	mov    0x8(%esp),%eax
  101591:	83 e0 03             	and    $0x3,%eax
  101594:	85 c0                	test   %eax,%eax
  101596:	75 29                	jne    1015c1 <memmove+0x80>
  101598:	8b 44 24 28          	mov    0x28(%esp),%eax
  10159c:	83 e0 03             	and    $0x3,%eax
  10159f:	85 c0                	test   %eax,%eax
  1015a1:	75 1e                	jne    1015c1 <memmove+0x80>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  1015a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  1015a7:	83 e8 04             	sub    $0x4,%eax
  1015aa:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1015ae:	83 ea 04             	sub    $0x4,%edx
  1015b1:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  1015b5:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  1015b8:	89 c7                	mov    %eax,%edi
  1015ba:	89 d6                	mov    %edx,%esi
  1015bc:	fd                   	std    
  1015bd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1015bf:	eb 1b                	jmp    1015dc <memmove+0x9b>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  1015c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  1015c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1015c8:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1015cc:	8d 58 ff             	lea    -0x1(%eax),%ebx
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  1015cf:	8b 44 24 28          	mov    0x28(%esp),%eax
  1015d3:	89 d7                	mov    %edx,%edi
  1015d5:	89 de                	mov    %ebx,%esi
  1015d7:	89 c1                	mov    %eax,%ecx
  1015d9:	fd                   	std    
  1015da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  1015dc:	fc                   	cld    
  1015dd:	eb 4e                	jmp    10162d <memmove+0xec>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  1015df:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1015e3:	83 e0 03             	and    $0x3,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 30                	jne    10161a <memmove+0xd9>
  1015ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  1015ee:	83 e0 03             	and    $0x3,%eax
  1015f1:	85 c0                	test   %eax,%eax
  1015f3:	75 25                	jne    10161a <memmove+0xd9>
  1015f5:	8b 44 24 28          	mov    0x28(%esp),%eax
  1015f9:	83 e0 03             	and    $0x3,%eax
  1015fc:	85 c0                	test   %eax,%eax
  1015fe:	75 1a                	jne    10161a <memmove+0xd9>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  101600:	8b 44 24 28          	mov    0x28(%esp),%eax
  101604:	89 c1                	mov    %eax,%ecx
  101606:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  101609:	8b 44 24 08          	mov    0x8(%esp),%eax
  10160d:	8b 54 24 0c          	mov    0xc(%esp),%edx
  101611:	89 c7                	mov    %eax,%edi
  101613:	89 d6                	mov    %edx,%esi
  101615:	fc                   	cld    
  101616:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101618:	eb 13                	jmp    10162d <memmove+0xec>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  10161a:	8b 44 24 08          	mov    0x8(%esp),%eax
  10161e:	8b 54 24 0c          	mov    0xc(%esp),%edx
  101622:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  101626:	89 c7                	mov    %eax,%edi
  101628:	89 d6                	mov    %edx,%esi
  10162a:	fc                   	cld    
  10162b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  10162d:	8b 44 24 20          	mov    0x20(%esp),%eax
}
  101631:	83 c4 10             	add    $0x10,%esp
  101634:	5b                   	pop    %ebx
  101635:	5e                   	pop    %esi
  101636:	5f                   	pop    %edi
  101637:	c3                   	ret    

00101638 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  101638:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  10163b:	8b 44 24 18          	mov    0x18(%esp),%eax
  10163f:	89 44 24 08          	mov    %eax,0x8(%esp)
  101643:	8b 44 24 14          	mov    0x14(%esp),%eax
  101647:	89 44 24 04          	mov    %eax,0x4(%esp)
  10164b:	8b 44 24 10          	mov    0x10(%esp),%eax
  10164f:	89 04 24             	mov    %eax,(%esp)
  101652:	e8 ea fe ff ff       	call   101541 <memmove>
}
  101657:	83 c4 0c             	add    $0xc,%esp
  10165a:	c3                   	ret    

0010165b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  10165b:	83 ec 10             	sub    $0x10,%esp
	const uint8_t *s1 = (const uint8_t *) v1;
  10165e:	8b 44 24 14          	mov    0x14(%esp),%eax
  101662:	89 44 24 0c          	mov    %eax,0xc(%esp)
	const uint8_t *s2 = (const uint8_t *) v2;
  101666:	8b 44 24 18          	mov    0x18(%esp),%eax
  10166a:	89 44 24 08          	mov    %eax,0x8(%esp)

	while (n-- > 0) {
  10166e:	eb 38                	jmp    1016a8 <memcmp+0x4d>
		if (*s1 != *s2)
  101670:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101674:	0f b6 10             	movzbl (%eax),%edx
  101677:	8b 44 24 08          	mov    0x8(%esp),%eax
  10167b:	0f b6 00             	movzbl (%eax),%eax
  10167e:	38 c2                	cmp    %al,%dl
  101680:	74 1c                	je     10169e <memcmp+0x43>
			return (int) *s1 - (int) *s2;
  101682:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101686:	0f b6 00             	movzbl (%eax),%eax
  101689:	0f b6 d0             	movzbl %al,%edx
  10168c:	8b 44 24 08          	mov    0x8(%esp),%eax
  101690:	0f b6 00             	movzbl (%eax),%eax
  101693:	0f b6 c0             	movzbl %al,%eax
  101696:	89 d1                	mov    %edx,%ecx
  101698:	29 c1                	sub    %eax,%ecx
  10169a:	89 c8                	mov    %ecx,%eax
  10169c:	eb 20                	jmp    1016be <memcmp+0x63>
		s1++, s2++;
  10169e:	83 44 24 0c 01       	addl   $0x1,0xc(%esp)
  1016a3:	83 44 24 08 01       	addl   $0x1,0x8(%esp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  1016a8:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  1016ad:	0f 95 c0             	setne  %al
  1016b0:	83 6c 24 1c 01       	subl   $0x1,0x1c(%esp)
  1016b5:	84 c0                	test   %al,%al
  1016b7:	75 b7                	jne    101670 <memcmp+0x15>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  1016b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016be:	83 c4 10             	add    $0x10,%esp
  1016c1:	c3                   	ret    

001016c2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  1016c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  1016c5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1016c9:	8b 54 24 14          	mov    0x14(%esp),%edx
  1016cd:	8d 04 02             	lea    (%edx,%eax,1),%eax
  1016d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
	for (; s < ends; s++)
  1016d4:	eb 14                	jmp    1016ea <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  1016d6:	8b 44 24 14          	mov    0x14(%esp),%eax
  1016da:	0f b6 10             	movzbl (%eax),%edx
  1016dd:	8b 44 24 18          	mov    0x18(%esp),%eax
  1016e1:	38 c2                	cmp    %al,%dl
  1016e3:	74 11                	je     1016f6 <memfind+0x34>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  1016e5:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  1016ea:	8b 44 24 14          	mov    0x14(%esp),%eax
  1016ee:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  1016f2:	72 e2                	jb     1016d6 <memfind+0x14>
  1016f4:	eb 01                	jmp    1016f7 <memfind+0x35>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  1016f6:	90                   	nop
	return (void *) s;
  1016f7:	8b 44 24 14          	mov    0x14(%esp),%eax
}
  1016fb:	83 c4 10             	add    $0x10,%esp
  1016fe:	c3                   	ret    

001016ff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  1016ff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  101702:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  101709:	00 
	long val = 0;
  10170a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101711:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  101712:	eb 05                	jmp    101719 <strtol+0x1a>
		s++;
  101714:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  101719:	8b 44 24 14          	mov    0x14(%esp),%eax
  10171d:	0f b6 00             	movzbl (%eax),%eax
  101720:	3c 20                	cmp    $0x20,%al
  101722:	74 f0                	je     101714 <strtol+0x15>
  101724:	8b 44 24 14          	mov    0x14(%esp),%eax
  101728:	0f b6 00             	movzbl (%eax),%eax
  10172b:	3c 09                	cmp    $0x9,%al
  10172d:	74 e5                	je     101714 <strtol+0x15>
		s++;

	// plus/minus sign
	if (*s == '+')
  10172f:	8b 44 24 14          	mov    0x14(%esp),%eax
  101733:	0f b6 00             	movzbl (%eax),%eax
  101736:	3c 2b                	cmp    $0x2b,%al
  101738:	75 07                	jne    101741 <strtol+0x42>
		s++;
  10173a:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  10173f:	eb 18                	jmp    101759 <strtol+0x5a>
	else if (*s == '-')
  101741:	8b 44 24 14          	mov    0x14(%esp),%eax
  101745:	0f b6 00             	movzbl (%eax),%eax
  101748:	3c 2d                	cmp    $0x2d,%al
  10174a:	75 0d                	jne    101759 <strtol+0x5a>
		s++, neg = 1;
  10174c:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  101751:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  101758:	00 

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  101759:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  10175e:	74 07                	je     101767 <strtol+0x68>
  101760:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
  101765:	75 28                	jne    10178f <strtol+0x90>
  101767:	8b 44 24 14          	mov    0x14(%esp),%eax
  10176b:	0f b6 00             	movzbl (%eax),%eax
  10176e:	3c 30                	cmp    $0x30,%al
  101770:	75 1d                	jne    10178f <strtol+0x90>
  101772:	8b 44 24 14          	mov    0x14(%esp),%eax
  101776:	83 c0 01             	add    $0x1,%eax
  101779:	0f b6 00             	movzbl (%eax),%eax
  10177c:	3c 78                	cmp    $0x78,%al
  10177e:	75 0f                	jne    10178f <strtol+0x90>
		s += 2, base = 16;
  101780:	83 44 24 14 02       	addl   $0x2,0x14(%esp)
  101785:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  10178c:	00 
  10178d:	eb 30                	jmp    1017bf <strtol+0xc0>
	else if (base == 0 && s[0] == '0')
  10178f:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  101794:	75 1a                	jne    1017b0 <strtol+0xb1>
  101796:	8b 44 24 14          	mov    0x14(%esp),%eax
  10179a:	0f b6 00             	movzbl (%eax),%eax
  10179d:	3c 30                	cmp    $0x30,%al
  10179f:	75 0f                	jne    1017b0 <strtol+0xb1>
		s++, base = 8;
  1017a1:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  1017a6:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
  1017ad:	00 
  1017ae:	eb 0f                	jmp    1017bf <strtol+0xc0>
	else if (base == 0)
  1017b0:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  1017b5:	75 08                	jne    1017bf <strtol+0xc0>
		base = 10;
  1017b7:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
  1017be:	00 

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  1017bf:	8b 44 24 14          	mov    0x14(%esp),%eax
  1017c3:	0f b6 00             	movzbl (%eax),%eax
  1017c6:	3c 2f                	cmp    $0x2f,%al
  1017c8:	7e 1e                	jle    1017e8 <strtol+0xe9>
  1017ca:	8b 44 24 14          	mov    0x14(%esp),%eax
  1017ce:	0f b6 00             	movzbl (%eax),%eax
  1017d1:	3c 39                	cmp    $0x39,%al
  1017d3:	7f 13                	jg     1017e8 <strtol+0xe9>
			dig = *s - '0';
  1017d5:	8b 44 24 14          	mov    0x14(%esp),%eax
  1017d9:	0f b6 00             	movzbl (%eax),%eax
  1017dc:	0f be c0             	movsbl %al,%eax
  1017df:	83 e8 30             	sub    $0x30,%eax
  1017e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017e6:	eb 50                	jmp    101838 <strtol+0x139>
		else if (*s >= 'a' && *s <= 'z')
  1017e8:	8b 44 24 14          	mov    0x14(%esp),%eax
  1017ec:	0f b6 00             	movzbl (%eax),%eax
  1017ef:	3c 60                	cmp    $0x60,%al
  1017f1:	7e 1e                	jle    101811 <strtol+0x112>
  1017f3:	8b 44 24 14          	mov    0x14(%esp),%eax
  1017f7:	0f b6 00             	movzbl (%eax),%eax
  1017fa:	3c 7a                	cmp    $0x7a,%al
  1017fc:	7f 13                	jg     101811 <strtol+0x112>
			dig = *s - 'a' + 10;
  1017fe:	8b 44 24 14          	mov    0x14(%esp),%eax
  101802:	0f b6 00             	movzbl (%eax),%eax
  101805:	0f be c0             	movsbl %al,%eax
  101808:	83 e8 57             	sub    $0x57,%eax
  10180b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10180f:	eb 27                	jmp    101838 <strtol+0x139>
		else if (*s >= 'A' && *s <= 'Z')
  101811:	8b 44 24 14          	mov    0x14(%esp),%eax
  101815:	0f b6 00             	movzbl (%eax),%eax
  101818:	3c 40                	cmp    $0x40,%al
  10181a:	7e 42                	jle    10185e <strtol+0x15f>
  10181c:	8b 44 24 14          	mov    0x14(%esp),%eax
  101820:	0f b6 00             	movzbl (%eax),%eax
  101823:	3c 5a                	cmp    $0x5a,%al
  101825:	7f 37                	jg     10185e <strtol+0x15f>
			dig = *s - 'A' + 10;
  101827:	8b 44 24 14          	mov    0x14(%esp),%eax
  10182b:	0f b6 00             	movzbl (%eax),%eax
  10182e:	0f be c0             	movsbl %al,%eax
  101831:	83 e8 37             	sub    $0x37,%eax
  101834:	89 44 24 04          	mov    %eax,0x4(%esp)
		else
			break;
		if (dig >= base)
  101838:	8b 44 24 04          	mov    0x4(%esp),%eax
  10183c:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
  101840:	7d 1b                	jge    10185d <strtol+0x15e>
			break;
		s++, val = (val * base) + dig;
  101842:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
  101847:	8b 44 24 08          	mov    0x8(%esp),%eax
  10184b:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
  101850:	03 44 24 04          	add    0x4(%esp),%eax
  101854:	89 44 24 08          	mov    %eax,0x8(%esp)
		// we don't properly detect overflow!
	}
  101858:	e9 62 ff ff ff       	jmp    1017bf <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  10185d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  10185e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  101863:	74 0a                	je     10186f <strtol+0x170>
		*endptr = (char *) s;
  101865:	8b 44 24 18          	mov    0x18(%esp),%eax
  101869:	8b 54 24 14          	mov    0x14(%esp),%edx
  10186d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  10186f:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  101874:	74 08                	je     10187e <strtol+0x17f>
  101876:	8b 44 24 08          	mov    0x8(%esp),%eax
  10187a:	f7 d8                	neg    %eax
  10187c:	eb 04                	jmp    101882 <strtol+0x183>
  10187e:	8b 44 24 08          	mov    0x8(%esp),%eax
}
  101882:	83 c4 10             	add    $0x10,%esp
  101885:	c3                   	ret    
	...

00101890 <__udivdi3>:
  101890:	55                   	push   %ebp
  101891:	89 e5                	mov    %esp,%ebp
  101893:	57                   	push   %edi
  101894:	56                   	push   %esi
  101895:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  101899:	8b 45 14             	mov    0x14(%ebp),%eax
  10189c:	8b 75 08             	mov    0x8(%ebp),%esi
  10189f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1018a2:	85 c0                	test   %eax,%eax
  1018a4:	89 75 e8             	mov    %esi,-0x18(%ebp)
  1018a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1018aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  1018ad:	75 39                	jne    1018e8 <__udivdi3+0x58>
  1018af:	39 f9                	cmp    %edi,%ecx
  1018b1:	77 65                	ja     101918 <__udivdi3+0x88>
  1018b3:	85 c9                	test   %ecx,%ecx
  1018b5:	75 0b                	jne    1018c2 <__udivdi3+0x32>
  1018b7:	b8 01 00 00 00       	mov    $0x1,%eax
  1018bc:	31 d2                	xor    %edx,%edx
  1018be:	f7 f1                	div    %ecx
  1018c0:	89 c1                	mov    %eax,%ecx
  1018c2:	89 f8                	mov    %edi,%eax
  1018c4:	31 d2                	xor    %edx,%edx
  1018c6:	f7 f1                	div    %ecx
  1018c8:	89 c7                	mov    %eax,%edi
  1018ca:	89 f0                	mov    %esi,%eax
  1018cc:	f7 f1                	div    %ecx
  1018ce:	89 fa                	mov    %edi,%edx
  1018d0:	89 c6                	mov    %eax,%esi
  1018d2:	89 75 f0             	mov    %esi,-0x10(%ebp)
  1018d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1018db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1018de:	8d 64 24 20          	lea    0x20(%esp),%esp
  1018e2:	5e                   	pop    %esi
  1018e3:	5f                   	pop    %edi
  1018e4:	5d                   	pop    %ebp
  1018e5:	c3                   	ret    
  1018e6:	66 90                	xchg   %ax,%ax
  1018e8:	31 d2                	xor    %edx,%edx
  1018ea:	31 f6                	xor    %esi,%esi
  1018ec:	39 f8                	cmp    %edi,%eax
  1018ee:	77 e2                	ja     1018d2 <__udivdi3+0x42>
  1018f0:	0f bd d0             	bsr    %eax,%edx
  1018f3:	83 f2 1f             	xor    $0x1f,%edx
  1018f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1018f9:	75 2d                	jne    101928 <__udivdi3+0x98>
  1018fb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1018fe:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  101901:	76 06                	jbe    101909 <__udivdi3+0x79>
  101903:	39 f8                	cmp    %edi,%eax
  101905:	89 f2                	mov    %esi,%edx
  101907:	73 c9                	jae    1018d2 <__udivdi3+0x42>
  101909:	31 d2                	xor    %edx,%edx
  10190b:	be 01 00 00 00       	mov    $0x1,%esi
  101910:	eb c0                	jmp    1018d2 <__udivdi3+0x42>
  101912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101918:	89 f0                	mov    %esi,%eax
  10191a:	89 fa                	mov    %edi,%edx
  10191c:	f7 f1                	div    %ecx
  10191e:	31 d2                	xor    %edx,%edx
  101920:	89 c6                	mov    %eax,%esi
  101922:	eb ae                	jmp    1018d2 <__udivdi3+0x42>
  101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101928:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10192c:	89 c2                	mov    %eax,%edx
  10192e:	b8 20 00 00 00       	mov    $0x20,%eax
  101933:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101936:	d3 e2                	shl    %cl,%edx
  101938:	89 c1                	mov    %eax,%ecx
  10193a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10193d:	d3 ee                	shr    %cl,%esi
  10193f:	09 d6                	or     %edx,%esi
  101941:	89 fa                	mov    %edi,%edx
  101943:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101947:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  10194a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10194d:	d3 e6                	shl    %cl,%esi
  10194f:	89 c1                	mov    %eax,%ecx
  101951:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101954:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101957:	d3 ea                	shr    %cl,%edx
  101959:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10195d:	d3 e7                	shl    %cl,%edi
  10195f:	89 c1                	mov    %eax,%ecx
  101961:	d3 ee                	shr    %cl,%esi
  101963:	09 fe                	or     %edi,%esi
  101965:	89 f0                	mov    %esi,%eax
  101967:	f7 75 e4             	divl   -0x1c(%ebp)
  10196a:	89 d7                	mov    %edx,%edi
  10196c:	89 c6                	mov    %eax,%esi
  10196e:	f7 65 f0             	mull   -0x10(%ebp)
  101971:	39 d7                	cmp    %edx,%edi
  101973:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101976:	72 12                	jb     10198a <__udivdi3+0xfa>
  101978:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10197c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10197f:	d3 e2                	shl    %cl,%edx
  101981:	39 c2                	cmp    %eax,%edx
  101983:	73 08                	jae    10198d <__udivdi3+0xfd>
  101985:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  101988:	75 03                	jne    10198d <__udivdi3+0xfd>
  10198a:	8d 76 ff             	lea    -0x1(%esi),%esi
  10198d:	31 d2                	xor    %edx,%edx
  10198f:	e9 3e ff ff ff       	jmp    1018d2 <__udivdi3+0x42>
	...

001019a0 <__umoddi3>:
  1019a0:	55                   	push   %ebp
  1019a1:	89 e5                	mov    %esp,%ebp
  1019a3:	57                   	push   %edi
  1019a4:	56                   	push   %esi
  1019a5:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  1019a9:	8b 7d 14             	mov    0x14(%ebp),%edi
  1019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1019af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1019b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  1019b5:	85 ff                	test   %edi,%edi
  1019b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1019ba:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  1019bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1019c0:	89 f2                	mov    %esi,%edx
  1019c2:	75 14                	jne    1019d8 <__umoddi3+0x38>
  1019c4:	39 f1                	cmp    %esi,%ecx
  1019c6:	76 40                	jbe    101a08 <__umoddi3+0x68>
  1019c8:	f7 f1                	div    %ecx
  1019ca:	89 d0                	mov    %edx,%eax
  1019cc:	31 d2                	xor    %edx,%edx
  1019ce:	8d 64 24 20          	lea    0x20(%esp),%esp
  1019d2:	5e                   	pop    %esi
  1019d3:	5f                   	pop    %edi
  1019d4:	5d                   	pop    %ebp
  1019d5:	c3                   	ret    
  1019d6:	66 90                	xchg   %ax,%ax
  1019d8:	39 f7                	cmp    %esi,%edi
  1019da:	77 4c                	ja     101a28 <__umoddi3+0x88>
  1019dc:	0f bd c7             	bsr    %edi,%eax
  1019df:	83 f0 1f             	xor    $0x1f,%eax
  1019e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1019e5:	75 51                	jne    101a38 <__umoddi3+0x98>
  1019e7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  1019ea:	0f 87 e8 00 00 00    	ja     101ad8 <__umoddi3+0x138>
  1019f0:	89 f2                	mov    %esi,%edx
  1019f2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  1019f5:	29 ce                	sub    %ecx,%esi
  1019f7:	19 fa                	sbb    %edi,%edx
  1019f9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  1019fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019ff:	8d 64 24 20          	lea    0x20(%esp),%esp
  101a03:	5e                   	pop    %esi
  101a04:	5f                   	pop    %edi
  101a05:	5d                   	pop    %ebp
  101a06:	c3                   	ret    
  101a07:	90                   	nop
  101a08:	85 c9                	test   %ecx,%ecx
  101a0a:	75 0b                	jne    101a17 <__umoddi3+0x77>
  101a0c:	b8 01 00 00 00       	mov    $0x1,%eax
  101a11:	31 d2                	xor    %edx,%edx
  101a13:	f7 f1                	div    %ecx
  101a15:	89 c1                	mov    %eax,%ecx
  101a17:	89 f0                	mov    %esi,%eax
  101a19:	31 d2                	xor    %edx,%edx
  101a1b:	f7 f1                	div    %ecx
  101a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a20:	f7 f1                	div    %ecx
  101a22:	eb a6                	jmp    1019ca <__umoddi3+0x2a>
  101a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101a28:	89 f2                	mov    %esi,%edx
  101a2a:	8d 64 24 20          	lea    0x20(%esp),%esp
  101a2e:	5e                   	pop    %esi
  101a2f:	5f                   	pop    %edi
  101a30:	5d                   	pop    %ebp
  101a31:	c3                   	ret    
  101a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101a38:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101a3c:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  101a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101a46:	29 45 f0             	sub    %eax,-0x10(%ebp)
  101a49:	d3 e7                	shl    %cl,%edi
  101a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a4e:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101a52:	89 f2                	mov    %esi,%edx
  101a54:	d3 e8                	shr    %cl,%eax
  101a56:	09 f8                	or     %edi,%eax
  101a58:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101a5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a62:	d3 e0                	shl    %cl,%eax
  101a64:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101a6e:	d3 ea                	shr    %cl,%edx
  101a70:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101a74:	d3 e6                	shl    %cl,%esi
  101a76:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101a7a:	d3 e8                	shr    %cl,%eax
  101a7c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101a80:	09 f0                	or     %esi,%eax
  101a82:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101a85:	d3 e6                	shl    %cl,%esi
  101a87:	f7 75 e4             	divl   -0x1c(%ebp)
  101a8a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  101a8d:	89 d6                	mov    %edx,%esi
  101a8f:	f7 65 f4             	mull   -0xc(%ebp)
  101a92:	89 d7                	mov    %edx,%edi
  101a94:	89 c2                	mov    %eax,%edx
  101a96:	39 fe                	cmp    %edi,%esi
  101a98:	89 f9                	mov    %edi,%ecx
  101a9a:	72 30                	jb     101acc <__umoddi3+0x12c>
  101a9c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  101a9f:	72 27                	jb     101ac8 <__umoddi3+0x128>
  101aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101aa4:	29 d0                	sub    %edx,%eax
  101aa6:	19 ce                	sbb    %ecx,%esi
  101aa8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101aac:	89 f2                	mov    %esi,%edx
  101aae:	d3 e8                	shr    %cl,%eax
  101ab0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101ab4:	d3 e2                	shl    %cl,%edx
  101ab6:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101aba:	09 d0                	or     %edx,%eax
  101abc:	89 f2                	mov    %esi,%edx
  101abe:	d3 ea                	shr    %cl,%edx
  101ac0:	8d 64 24 20          	lea    0x20(%esp),%esp
  101ac4:	5e                   	pop    %esi
  101ac5:	5f                   	pop    %edi
  101ac6:	5d                   	pop    %ebp
  101ac7:	c3                   	ret    
  101ac8:	39 fe                	cmp    %edi,%esi
  101aca:	75 d5                	jne    101aa1 <__umoddi3+0x101>
  101acc:	89 f9                	mov    %edi,%ecx
  101ace:	89 c2                	mov    %eax,%edx
  101ad0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  101ad3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  101ad6:	eb c9                	jmp    101aa1 <__umoddi3+0x101>
  101ad8:	39 f7                	cmp    %esi,%edi
  101ada:	0f 82 10 ff ff ff    	jb     1019f0 <__umoddi3+0x50>
  101ae0:	e9 17 ff ff ff       	jmp    1019fc <__umoddi3+0x5c>
