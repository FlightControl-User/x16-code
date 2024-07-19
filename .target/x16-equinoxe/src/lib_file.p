extern __varcall __lib_import("lib_file") __zp FILE * fopen(__zp const char *path, __zp const char *mode);
extern __varcall __lib_import("lib_file") __mem() int fclose(__zp FILE *stream);
extern __varcall __lib_import("lib_file") __mem() unsigned int fgets(__zp char *ptr, __mem() unsigned int size, __zp FILE *stream);
extern __phicall __lib_import("lib_file") void conio_x16_init();
extern __phicall __lib_import("lib_file") void __lib_file_start();
