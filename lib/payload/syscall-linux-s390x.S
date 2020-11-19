/* Copyright (C) 2001-2020 Free Software Foundation, Inc.
   Contributed by Martin Schwidefsky (schwidefsky@de.ibm.com).
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

#define frida_asm_align 16
#define frida_asm_custom_entry(f)
#define frida_asm_custom_end(f)
#define frida_asm_function_type @function

#include "syscall-linux.h"

ENTRY_PRIVATE (syscall)
        stmg   %r6,%r7,48(%r15)    /* Save registers.  */

        lgr    %r1,%r2             /* Move syscall number.  */
        lgr    %r2,%r3             /* First parameter.  */
        lgr    %r3,%r4             /* Second parameter.  */
        lgr    %r4,%r5             /* Third parameter.  */
        lgr    %r5,%r6             /* Fourth parameter.  */
        lmg    %r6,%r7,160(%r15)   /* Fifth / Sixth parameter.  */
        svc    0

        lmg    %r6,%r7,48(%r15)    /* Load registers.  */

        lghi   %r0,-FRIDA_MAX_ERRNO
        clgr   %r2,%r0             /* Check R2 for error.  */
        jgnl   _frida_set_errno
        br     %r14                /* Return to caller.  */
END (syscall)
