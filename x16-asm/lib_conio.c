/* Generate a library for printing. */

#pragma encoding(screencode_mixed)
#pragma var_model(mem)
#pragma struct_model(classic) // This is important or kickc messes up the parameters ...

#pragma asm_library

#pragma calling(__varcall)
#pragma asm_export(clrscr)
#pragma asm_export(gotoxy)
#pragma asm_export(wherex, wherey)
#pragma asm_export(screensize, screensizex, screensizey, cputln )
#pragma asm_export(cputcxy, cputs, cputsxy, textcolor, bgcolor, bordercolor )
#pragma asm_export(kbhit, cursor, scroll )
#pragma asm_export(screenlayer1, screenlayer2)
#pragma asm_export(cpeekc, cpeekcxy)

#pragma calling(__varcall)
#pragma asm_export(printf_str)
#pragma asm_export(printf_uint, printf_sint)
#pragma asm_export(printf_ulong, printf_slong)
#pragma asm_export(printf_uchar, printf_schar)

#pragma calling(__stackcall)
#pragma asm_export(cputc)

#pragma calling(__phicall)

#include <conio.h>
#include <printf.h>
