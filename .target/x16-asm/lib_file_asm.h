struct cx16_conio_s;
struct printf_buffer_number;
extern __asm_import("lib_file") __mem() struct cx16_conio_s __conio;
extern __asm_import("lib_file") __mem() struct printf_buffer_number printf_buffer;
extern __varcall __asm_import("lib_file") __zp_reserve( 44,34,45,35,46,36,47,37,48,40,41,42,43 ) __zp($29) FILE * fopen(__zp($24) const char *path, __zp($22) const char *mode);
extern __varcall __asm_import("lib_file") __zp_reserve( 41,42 ) __mem() int fclose(__zp($29) FILE *stream);
extern __varcall __asm_import("lib_file") __zp_reserve( 44,34,35,38,39,43 ) __mem() unsigned int fgets(__zp($2b) char *ptr, __mem() unsigned int size, __zp($22) FILE *stream);
extern __phicall __asm_import("lib_file") void conio_x16_init();
extern __phicall __asm_import("lib_file") void __lib_file_start();
