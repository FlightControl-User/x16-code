extern __varcall __asm_import("lib-palette") __zp_reserve(7, 4, 4, 4) void palette_init(__zp(7) char bram_bank);
extern __varcall __asm_import("lib-palette") __zp_reserve(6) __zp(6) char palette_alloc_bram();
extern __varcall __asm_import("lib-palette") __zp_reserve(7, 2, 2, 2, 2) __zp(2) palette_ptr_t palette_ptr_bram(__zp(7) char palette_index);
extern __varcall __asm_import("lib-palette") __zp_reserve(8, 6, 6, 4, 2, 6, 6, 4, 2, 6) __zp(6) char palette_use_vram(__zp(8) char palette_index);
extern __varcall __asm_import("lib-palette") __zp_reserve(2, 4) void palette_unuse_vram(__zp(2) unsigned int bram_index);
extern __varcall __asm_import("lib-palette") __zp_reserve(2, 4, 2) void palette_free_vram(__zp(2) unsigned int bram_index);
extern __phicall __asm_import("lib-palette") void __lib_palette_start();
