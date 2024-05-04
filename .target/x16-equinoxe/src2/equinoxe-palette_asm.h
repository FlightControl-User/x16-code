extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 36,37,39 ) void palette_init(__zp($27) char bram_bank);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 38 ) __zp($26) char palette_alloc_bram();
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35,39 ) __zp($22) struct palette_16_s * palette_ptr_bram(__zp($27) char palette_index);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35,36,37,38,39,40 ) __zp($26) char palette_use_vram(__zp($28) char palette_index);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35,36,37 ) void palette_unuse_vram(__zp($22) unsigned int bram_index);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35,36,37 ) void palette_free_vram(__zp($22) unsigned int bram_index);
extern __phicall __asm_import("equinoxe-palette") void __equinoxe_palette_start();
