
boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
start:
	.code16                     # Assemble for 16-bit mode


	# Set up the important data segment registers (DS, ES, SS).
	xorw    %ax,%ax             # Segment number zero
    7c00:	31 c0                	xor    %eax,%eax
	movw    %ax,%ds             # -> Data Segment
    7c02:	8e d8                	mov    %eax,%ds
	movw    %ax,%es             # -> Extra Segment
    7c04:	8e c0                	mov    %eax,%es
	movw    %ax,%ss             # -> Stack Segment
    7c06:	8e d0                	mov    %eax,%ss

	cli                         # Disable interrupts
    7c08:	fa                   	cli    
	cld                         # String operations increment
    7c09:	fc                   	cld    

        # Print some inane message

        mov     $0x03, %ah              # read cursor pos
    7c0a:	b4 03                	mov    $0x3,%ah
        xor     %bh, %bh
    7c0c:	30 ff                	xor    %bh,%bh
        int     $0x10
    7c0e:	cd 10                	int    $0x10

        mov     $24, %cx
    7c10:	b9 18 00 bb 07       	mov    $0x7bb0018,%ecx
        mov     $0x0007, %bx            # page 0, attribute 7 (normal)
    7c15:	00 bd 6a 7c b8 01    	add    %bh,0x1b87c6a(%ebp)
        #lea    msg1, %bp
        mov     $msg1, %bp
        mov     $0x1301, %ax            # write string, move cursor
    7c1b:	13 cd                	adc    %ebp,%ecx
        int     $0x10
    7c1d:	10 0f                	adc    %cl,(%edi)

	# Switch from real to protected mode, using a bootstrap GDT
	# and segment translation that makes virtual addresses 
	# identical to their physical addresses, so that the 
	# effective memory map does not change during the switch.
	lgdt    gdtdesc
    7c1f:	01 16                	add    %edx,(%esi)
    7c21:	64                   	fs
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>

        
	movl    %cr0, %eax
    7c24:	20 c0                	and    %al,%al
	orl     $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0

	# Jump to next instruction, but in 32-bit code segment.
	# Switches processor into 32-bit mode.
        #$PROT_MODE_CSEG這裡當segment selector來用
	ljmp    $PROT_MODE_CSEG, $protcseg
    7c2d:	ea 32 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c32

00007c32 <protcseg>:
.code32                     # Assemble for 32-bit mode
protcseg:


	# Set up the protected-mode data segment registers
	movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds                # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
	movw    %ax, %es                # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
	movw    %ax, %fs                # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs                # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
	movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss

	# Set up the stack pointer and call into C.
        # Q:是把之前用過得code段當作stack來用嗎？
	movl    $start, %esp
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp

	call bootmain
    7c45:	e8 cd 00 00 00       	call   7d17 <bootmain>

00007c4a <loop>:

loop:
	jmp loop
    7c4a:	eb fe                	jmp    7c4a <loop>

00007c4c <gdt>:
	...
    7c54:	00 08                	add    %cl,(%eax)
    7c56:	00 00                	add    %al,(%eax)
    7c58:	00 9a c0 00 00 08    	add    %bl,0x80000c0(%edx)
    7c5e:	00 00                	add    %al,(%eax)
    7c60:	00 92 c0 00 00 08    	add    %dl,0x80000c0(%edx)

00007c64 <gdtdesc>:
    7c64:	00 08                	add    %cl,(%eax)
    7c66:	4c                   	dec    %esp
    7c67:	7c 00                	jl     7c69 <gdtdesc+0x5>
	...

00007c6a <msg1>:
    7c6a:	0d 0a 4c 6f 61       	or     $0x616f4c0a,%eax
    7c6f:	64 69 6e 67 20 73 79 	imul   $0x73797320,%fs:0x67(%esi),%ebp
    7c76:	73 
    7c77:	74 65                	je     7cde <readsect+0x4d>
    7c79:	6d                   	insl   (%dx),%es:(%edi)
    7c7a:	20 2e                	and    %ch,(%esi)
    7c7c:	2e                   	cs
    7c7d:	2e                   	cs
    7c7e:	0d 0a ba f7 01       	or     $0x1f7ba0a,%eax

00007c80 <waitdisk>:

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c80:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c85:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c86:	25 c0 00 00 00       	and    $0xc0,%eax
    7c8b:	83 f8 40             	cmp    $0x40,%eax
    7c8e:	75 f5                	jne    7c85 <waitdisk+0x5>
		/* do nothing */;
}
    7c90:	c3                   	ret    

00007c91 <readsect>:

void
readsect(void *dst, uint32_t offset)
{
    7c91:	57                   	push   %edi
    7c92:	53                   	push   %ebx
    7c93:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	// wait for disk to be ready
	waitdisk();
    7c97:	e8 e4 ff ff ff       	call   7c80 <waitdisk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7c9c:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca1:	b0 01                	mov    $0x1,%al
    7ca3:	ee                   	out    %al,(%dx)
    7ca4:	b2 f3                	mov    $0xf3,%dl
    7ca6:	88 d8                	mov    %bl,%al
    7ca8:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
    7ca9:	89 d8                	mov    %ebx,%eax
    7cab:	b2 f4                	mov    $0xf4,%dl
    7cad:	c1 e8 08             	shr    $0x8,%eax
    7cb0:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
    7cb1:	89 d8                	mov    %ebx,%eax
    7cb3:	b2 f5                	mov    $0xf5,%dl
    7cb5:	c1 e8 10             	shr    $0x10,%eax
    7cb8:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
    7cb9:	c1 eb 18             	shr    $0x18,%ebx
    7cbc:	b2 f6                	mov    $0xf6,%dl
    7cbe:	88 d8                	mov    %bl,%al
    7cc0:	83 c8 e0             	or     $0xffffffe0,%eax
    7cc3:	ee                   	out    %al,(%dx)
    7cc4:	b0 20                	mov    $0x20,%al
    7cc6:	b2 f7                	mov    $0xf7,%dl
    7cc8:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7cc9:	e8 b2 ff ff ff       	call   7c80 <waitdisk>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    7cce:	8b 7c 24 0c          	mov    0xc(%esp),%edi
    7cd2:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cd7:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cdc:	fc                   	cld    
    7cdd:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
    7cdf:	5b                   	pop    %ebx
    7ce0:	5f                   	pop    %edi
    7ce1:	c3                   	ret    

00007ce2 <readseg>:
// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
// 
void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7ce2:	57                   	push   %edi
    7ce3:	56                   	push   %esi
    7ce4:	53                   	push   %ebx
    7ce5:	8b 74 24 18          	mov    0x18(%esp),%esi
    7ce9:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	uint32_t end_pa;

	end_pa = pa + count;
    7ced:	8b 7c 24 14          	mov    0x14(%esp),%edi

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTSIZE) + 1;
    7cf1:	c1 ee 09             	shr    $0x9,%esi
    7cf4:	46                   	inc    %esi
void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
	uint32_t end_pa;

	end_pa = pa + count;
    7cf5:	01 df                	add    %ebx,%edi

	// round down to sector boundary
	pa &= ~(SECTSIZE - 1);
    7cf7:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
    7cfd:	eb 10                	jmp    7d0f <readseg+0x2d>
		// Since we haven't enabled paging yet and we're using
		// an identity segment mapping (see boot.S), we can
		// use physical addresses directly.  This won't be the
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
    7cff:	56                   	push   %esi
		pa += SECTSIZE;
		offset++;
    7d00:	46                   	inc    %esi
	while (pa < end_pa) {
		// Since we haven't enabled paging yet and we're using
		// an identity segment mapping (see boot.S), we can
		// use physical addresses directly.  This won't be the
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
    7d01:	53                   	push   %ebx
		pa += SECTSIZE;
    7d02:	81 c3 00 02 00 00    	add    $0x200,%ebx
	while (pa < end_pa) {
		// Since we haven't enabled paging yet and we're using
		// an identity segment mapping (see boot.S), we can
		// use physical addresses directly.  This won't be the
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
    7d08:	e8 84 ff ff ff       	call   7c91 <readsect>
		pa += SECTSIZE;
		offset++;
    7d0d:	58                   	pop    %eax
    7d0e:	5a                   	pop    %edx
	offset = (offset / SECTSIZE) + 1;

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (pa < end_pa) {
    7d0f:	39 fb                	cmp    %edi,%ebx
    7d11:	72 ec                	jb     7cff <readseg+0x1d>
		// case once JOS enables the MMU.
		readsect((uint8_t*) pa, offset);
		pa += SECTSIZE;
		offset++;
	}
}
    7d13:	5b                   	pop    %ebx
    7d14:	5e                   	pop    %esi
    7d15:	5f                   	pop    %edi
    7d16:	c3                   	ret    

00007d17 <bootmain>:
void readseg(uint32_t, uint32_t, uint32_t);

//read the kernel and jump to it
void
bootmain(void)
{
    7d17:	56                   	push   %esi
    7d18:	53                   	push   %ebx
    7d19:	83 ec 04             	sub    $0x4,%esp

	struct Proghdr *ph, *eph;

	// read 1st page off disk
	readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d1c:	6a 00                	push   $0x0
    7d1e:	68 00 10 00 00       	push   $0x1000
    7d23:	68 00 00 01 00       	push   $0x10000
    7d28:	e8 b5 ff ff ff       	call   7ce2 <readseg>

	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d2d:	83 c4 0c             	add    $0xc,%esp
    7d30:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d37:	45 4c 46 
    7d3a:	75 39                	jne    7d75 <bootmain+0x5e>
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d3c:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d42:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d49:	81 c3 00 00 01 00    	add    $0x10000,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d4f:	c1 e0 05             	shl    $0x5,%eax
    7d52:	8d 34 03             	lea    (%ebx,%eax,1),%esi
	for (; ph < eph; ph++)
    7d55:	eb 14                	jmp    7d6b <bootmain+0x54>
		// p_pa is the load address of this segment (as well
		// as the physical address)
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d57:	ff 73 04             	pushl  0x4(%ebx)
    7d5a:	ff 73 14             	pushl  0x14(%ebx)
    7d5d:	ff 73 0c             	pushl  0xc(%ebx)
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d60:	83 c3 20             	add    $0x20,%ebx
		// p_pa is the load address of this segment (as well
		// as the physical address)
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d63:	e8 7a ff ff ff       	call   7ce2 <readseg>
		goto bad;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d68:	83 c4 0c             	add    $0xc,%esp
    7d6b:	39 f3                	cmp    %esi,%ebx
    7d6d:	72 e8                	jb     7d57 <bootmain+0x40>

	// call the entry point from the ELF header
	// note: does not return!
	 
	
	((void (*)(void)) (ELFHDR->e_entry))();
    7d6f:	ff 15 18 00 01 00    	call   *0x10018
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7d75:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7d7a:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7d7f:	66 ef                	out    %ax,(%dx)
    7d81:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d86:	66 ef                	out    %ax,(%dx)
    7d88:	eb fe                	jmp    7d88 <bootmain+0x71>
