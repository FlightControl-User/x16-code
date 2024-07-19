/* Generate a library for printing. */

#pragma encoding(screencode_mixed)
#pragma var_model(mem)
#pragma struct_model(classic) // This is important or kickc messes up the parameters ...
#pragma zp_reserve(0x00..0x01)

#pragma lib_configure

#pragma calling(__stackcall)
#pragma lib_export(clrscr)
#pragma lib_export(gotoxy)
#pragma lib_export(wherex, wherey)
#pragma lib_export(screensize, screensizex, screensizey, cputln )
#pragma lib_export(cputcxy, cputs, cputsxy, textcolor, bgcolor, bordercolor )
#pragma lib_export(kbhit, cursor, scroll )
#pragma lib_export(screenlayer1, screenlayer2)
#pragma lib_export(cpeekc, cpeekcxy)

#pragma calling(__stackcall)
#pragma lib_export(printf_str)
#pragma lib_export(printf_uint, printf_sint)
#pragma lib_export(printf_ulong, printf_slong)
#pragma lib_export(printf_uchar, printf_schar)

#pragma lib_export(__stackcall, cputc)

#pragma calling(__phicall)

#include <conio.h>
#include <printf.h>
