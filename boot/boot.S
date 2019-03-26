#include <inc/mmu.h>

.set PROT_MODE_CSEG, 0x8         # kernel code segment selector
.set PROT_MODE_DSEG, 0x10        # kernel data segment selector
.set CR0_PE_ON,      0x1         # protected mode enable flag


.globl start
start:
	.code16                     # Assemble for 16-bit mode


	# Set up the important data segment registers (DS, ES, SS).
	xorw    %ax,%ax             # Segment number zero
	movw    %ax,%ds             # -> Data Segment
	movw    %ax,%es             # -> Extra Segment
	movw    %ax,%ss             # -> Stack Segment

	cli                         # Disable interrupts
	cld                         # String operations increment

        # Print some inane message

        mov     $0x03, %ah              # read cursor pos
        xor     %bh, %bh
        int     $0x10

        mov     $24, %cx
        mov     $0x0007, %bx            # page 0, attribute 7 (normal)
        #lea    msg1, %bp
        mov     $msg1, %bp
        mov     $0x1301, %ax            # write string, move cursor
        int     $0x10


	# Switch from real to protected mode, using a bootstrap GDT
	# and segment translation that makes virtual addresses 
	# identical to their physical addresses, so that the 
	# effective memory map does not change during the switch.
	lgdt    gdtdesc

        
	movl    %cr0, %eax
	orl     $CR0_PE_ON, %eax
	movl    %eax, %cr0

	# Jump to next instruction, but in 32-bit code segment.
	# Switches processor into 32-bit mode.
        #$PROT_MODE_CSEG這裡當segment selector來用
	ljmp    $PROT_MODE_CSEG, $protcseg


.code32                     # Assemble for 32-bit mode
protcseg:


	# Set up the protected-mode data segment registers
	movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
	movw    %ax, %ds                # -> DS: Data Segment
	movw    %ax, %es                # -> ES: Extra Segment
	movw    %ax, %fs                # -> FS
	movw    %ax, %gs                # -> GS
	movw    %ax, %ss                # -> SS: Stack Segment

	# Set up the stack pointer and call into C.
        # Q:是把之前用過得code段當作stack來用嗎？
	movl    $start, %esp

	call bootmain

loop:
	jmp loop

# Bootstrap GDT
	.p2align 2                                # force 4 byte alignment
gdt:
# TODO: Fillup GDT entry with SEG macro
#       One for kernel code segment
#       One for kernel data segment
#
#       Please reference lab3_reference.pdf for the meaning of
#       each bit inside segment descriptor.
#
#       You may reference mmu.h for Application Segment Type for 
#       easy-to-use macro when defining segmentation type.

	SEG_NULL    # NULL segment

        #8388608 = 0x800 * 4096(左移12bits)
        #這裡lim的單位是bytes
        #SEG(type, base, lim)
	SEG(0x0a, 0x0, 8388608)     # Kernel code segment
	SEG(0x02, 0x0, 8388608)     # Kernel data segment


# TODO: Please fillup the GDT register for gdt in order to used
#       with "lgdt" instruction.
# Note: You can reference lab3_reference page 13 for detail meaning
#       of each bit of GDT register.
gdtdesc: 
	.word	0x800# gdt limit
	.word	gdt, 0# gdt base
msg1:
        .byte 13,10
        .ascii "Loading system ..."
        .byte 13,10

