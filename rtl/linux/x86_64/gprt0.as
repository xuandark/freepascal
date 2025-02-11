/* This is the canonical entry point, usually the first thing in the text
   segment.  The SVR4/i386 ABI (pages 3-31, 3-32) says that when the entry
   point runs, most registers' values are unspecified, except for:

   %rdx		Contains a function pointer to be registered with `atexit'.
		This is how the dynamic linker arranges to have DT_FINI
		functions called for shared libraries that have been loaded
		before this code runs.

   %rsp		The stack contains the arguments and environment:
		0(%rsp)			argc
		8(%rsp)			argv[0]
		...
		(8*argc)(%rsp)		NULL
		(8*(argc+1))(%rsp)	envp[0]
		...
					NULL
*/

	.text
	.globl _start
	.type _start,@function
_start:
	/* Clear the frame pointer.  The ABI suggests this be done, to mark
	   the outermost frame obviously.  */
	xorq %rbp, %rbp

	/* Extract the arguments as encoded on the stack and set up
	   the arguments for __libc_start_main (int (*main) (int, char **, char **),
		   int argc, char *argv,
		   void (*init) (void), void (*fini) (void),
		   void (*rtld_fini) (void), void *stack_end).
	   The arguments are passed via registers and on the stack:
	main:		%rdi
	argc:		%rsi
	argv:		%rdx
	init:		%rcx
	fini:		%r8
	rtld_fini:	%r9
	stack_end:	stack.	*/

	movq %rdx, %r9		/* Address of the shared library termination
				   function.  */
	popq %rsi		/* Pop the argument count.  */
	movq %rsp, %rdx		/* argv starts just at the current stack top.  */

        movq     %rsi,operatingsystem_parameter_argc
	movq     %rsp,operatingsystem_parameter_argv   /* argv starts just at the current stack top.  */
        leaq     8(,%rsi,8),%rax
        addq     %rsp,%rax
        movq     %rax,operatingsystem_parameter_envp

	/* Align the stack to a 16 byte boundary to follow the ABI.  */
	andq  $~15, %rsp

	pushq %rax		/* Push garbage because we push 8 more bytes.  */

	/* Provide the highest stack address to the user code (for stacks
	   which grow downwards).  */
	pushq %rsp

	/* Pass address of our own entry points to .fini and .init.  */
	movq $_init_dummy, %r8
	movq $_fini_dummy, %rcx

	movq $main_stub, %rdi

	/* Call the user's main function, and exit with its value.
	   But let the libc call main.	  */
	call __libc_start_main

	hlt			/* Crash if somehow `exit' does return.	 */

/* fake main routine which will be run from libc */
main_stub:
        /* save return address */
        popq    %rax

	// stack alignment
        pushq   %rax

        movq    %rax,___fpc_ret
        movq    %rbp,___fpc_ret_rbp
        pushq   %rax

	/* Initialize gmon */
        movq    $_etext,%rsi
        movq    $_start,%rdi
        call    monstartup

        movq    $_mcleanup,%rdi
        call    atexit

        /* Save initial stackpointer */
        movq    %rsp,__stkptr

        /* start the program */
        xorq    %rbp,%rbp
        call    PASCALMAIN
        hlt

        .globl _haltproc
        .type _haltproc,@function
_haltproc:
        movzwq    operatingsystem_result,%rax /* load and save exitcode */

        movq    ___fpc_ret,%rdx         /* return to libc */
        movq    ___fpc_ret_rbp,%rbp
        pushq    %rdx
_init_dummy:
_fini_dummy:
        ret

/* Define a symbol for the first piece of initialized data.  */
	.data
	.globl __data_start
__data_start:
	.long 0
	.weak data_start
	data_start = __data_start

        .globl  ___fpc_brk_addr         /* heap management */
        .type   ___fpc_brk_addr,@object
        .size   ___fpc_brk_addr,8
___fpc_brk_addr:
        .quad   0

___fpc_ret:                             /* return address to libc */
        .quad   0
___fpc_ret_rbp:
        .quad   0

.bss
        .comm __stkptr,8

        .comm operatingsystem_parameter_envp,8
        .comm operatingsystem_parameter_argc,8
        .comm operatingsystem_parameter_argv,8

/* We need this stuff to make gdb behave itself, otherwise
   gdb will chokes with SIGILL when trying to debug apps.
*/
        .section ".note.ABI-tag", "a"
        .align 4
        .long 1f - 0f
        .long 3f - 2f
        .long  1
0:      .asciz "GNU"
1:      .align 4
2:      .long 0
        .long 2,4,0
3:      .align 4

	.section	.note.GNU-stack,"",@progbits
