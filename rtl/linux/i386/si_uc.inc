{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2005 by Michael Van Canneyt, Peter Vreman,
    & Daniel Mantione, members of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{
 Linux/uClibc startup code for Free Pascal
    taken from uClibc/sysdeps/linux/i386/crt1.S

 %edx  Contains a function pointer to be registered with `atexit'.
       This is how the dynamic linker arranges to have DT_FINI
       functions called for shared libraries that have been loaded
       before this code runs.
   

 Stack layout at program start:

         nil
         envn
         ....
         ....           ENVIRONMENT VARIABLES
         env1
         env0
         nil
         argn
         ....
         ....           COMMAND LINE OPTIONS
         arg1
         arg0
         argc <--- esp
}


var
  dlexitproc: pointer; { atexit from loader }

procedure uclibc_init; external name '__uClibc_init';
procedure uclibc_fini; external name '__uClibc_fini';
procedure uclibc_exit; external name '_exit';
procedure uclibc_main; external name '__uClibc_main';
procedure PASCALMAIN; external name 'PASCALMAIN';

{ Some helpers }

{$ifdef FPC_PIC}
function get3eipasebx : pointer; compilerproc; nostackframe; assembler; 
asm  
  movl (%esp),%ebx  
  ret  
end;
{$endif FPC_PIC}

procedure _init_fini_dummy; compilerproc; nostackframe; assembler;
asm
  ret
end; 

{******************************************************************************
                       glibc 2.1 lib + profiling start/halt
 ******************************************************************************}
{$asmmode ATT}

procedure _FPC_libc21_start; assembler; nostackframe; public name '_start';
asm
  xorl    %ebp,%ebp
  { First locate the start of the environment variables }

  popl    %ecx                    { Get argc in ecx }

  movl    %esp,%ebx               { Esp now points to the arguments }
  leal    4(%esp,%ecx,4),%eax     { The start of the environment is: esp+4*eax+4 }
  andl    $0xfffffff8,%esp        { Align stack }

  {$ifdef FPC_PIC}
        pushl %edx
        pushl %ebx
        pushl %ecx
	
	call get3eipasebx
        addl  $_GLOBAL_OFFSET_TABLE_,%ebx

	movl  dlexitproc@GOT(%ebx),%ecx 
	movl  %edx,(%ecx)

	movl  operatingsystem_parameter_envp@GOT(%ebx),%ecx
	movl  %eax,(%ecx)

	movl  operatingsystem_parameter_argc@GOT(%ebx),%edx
	popl  %ecx
	movl  %ecx,(%edx)

	movl  operatingsystem_parameter_argv@GOT(%ebx),%edx
	popl  %ebx
	movl  %ebx,(%edx)
	popl  %edx
  {$else FPC_PIC}
  	movl  %edx, dlexitproc
  	movl  %eax,operatingsystem_parameter_envp
  	movl  %ecx,operatingsystem_parameter_argc
  	movl  %ebx,operatingsystem_parameter_argv
  {$endif FPC_PIC}

  { Save initial stackpointer }
  {$ifdef FPC_PIC}
        pushl %ebx
        call  get3eipasebx
        addl  $_GLOBAL_OFFSET_TABLE_,%ebx
	movl  initialstkptr@GOT(%ebx),%ebx
  	movl  %esp,(%ebx)
	popl  %ebx
  {$else FPC_PIC}
  	movl    %esp,initialstkptr
  {$endif FPC_PIC}

        { int __libc_start_main(
		int *(main) (int, char * *, char * *), 
		int argc, 
		char * * ubp_av, 
		void (*init) (void), 
		void (*fini) (void), 
		void (*rtld_fini) (void), 
		void (* stack_end)); } 

        pushl %ebp   			{ padding }
        pushl %esp   			{ stack_end }
        pushl %edx   			{ function to be registered with
                      			  atexit(), passed by loader }
  	pushl $_init_fini_dummy
  	pushl $_init_fini_dummy
	pushl %ebx             		{ Push second argument: argv.  }
	pushl %ecx             		{ Push first argument: argc.  }

	pushl $PASCALMAIN

  	call  uclibc_main
	hlt
end;

procedure _FPC_libc21_haltproc; assembler; nostackframe; public name '_haltproc';
asm
.Lhaltproc:

  {$ifdef FPC_PIC}
        call    get3eipasebx
        addl    $_GLOBAL_OFFSET_TABLE_,%ebx
        movl    ExitCode@GOT(%ebx),%ebx
    {$if sizeof(ExitCode)=2}
        movzwl  (%ebx),%ebx
    {$else}
        mov     (%ebx),%ebx
    {$endif}
  {$else FPC_PIC}
    {$if sizeof(ExitCode)=2}
        movzwl  ExitCode,%ebx
    {$else}
        mov     ExitCode,%ebx
    {$endif}
  {$endif FPC_PIC}

  pushl   %ebx
  call    uclibc_exit
  xorl    %eax,%eax
  incl    %eax                    { eax=1, exit call }
  popl    %ebx
  int     $0x80
  jmp     .Lhaltproc

end;
