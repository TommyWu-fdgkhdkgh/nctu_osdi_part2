#include <inc/mmu.h>
#include <inc/trap.h>

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps


.text

/* TODO: Interface declaration for ISRs
 * Note: Use TRAPHANDLER_NOEC macro define other isr enrty
 *       The Trap number are declared in inc/trap.h which might come in handy
 *       when declaring interface for ISRs.
 */
	#第一個參數意思應該是function名稱
	#第二個參數意思應該是....
	TRAPHANDLER_NOEC(timer, 0x20) 
	TRAPHANDLER_NOEC(keyboard, 0x21) 



.globl default_trap_handler;
_alltraps:
  /* TODO: Since we are going to call default_trap_handler, we have to prepare
   *       the argument for it, which is placed on the stack.
   *       Thus push registers to fillup the Trapframe data structure.
   * 
   * Note: The x86 CPU will automatically save some register when interrupts
   *       occurs. Thus, you do not have to push those registers.
   *       Please reference lab3.docx for what registers are pushed by
   *       CPU.
   */

	push %ds
	push %es
	push %eax
	push %ecx
	push %edx
	push %ebx
	push $0  #useless
	push %ebp
	push %esi
	push %edi
	pushl %esp # Pass a pointer which points to the Trapframe as an argument to default_trap_handler()
	call default_trap_handler

	add $8, %esp # Cleans up the pushed error code and pushed ISR number
	add $0x2c, %esp #0x4*11
	iret # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!

