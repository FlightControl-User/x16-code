extern __varcall __asm_import("equinoxe_palette") __zp_reserve( 4,5,7 ) void palette_init(__zp(7) char bram_bank);
extern __varcall __asm_import("equinoxe_palette") __zp_reserve( 6 ) __zp(6) char palette_alloc_bram();
extern __varcall __asm_import("equinoxe_palette") __zp_reserve( 2,3,7 ) __zp(2) struct palette_16_s * palette_ptr_bram(__zp(7) char palette_index);
extern __varcall __asm_import("equinoxe_palette") __zp_reserve( 2,3,4,5,6,7,8 ) __zp(6) char palette_use_vram(__zp(8) char palette_index);
extern __varcall __asm_import("equinoxe_palette") __zp_reserve( 2,3,4,5 ) void palette_unuse_vram(__zp(2) unsigned int bram_index);
extern __varcall __asm_import("equinoxe_palette") __zp_reserve( 2,3,4,5 ) void palette_free_vram(__zp(2) unsigned int bram_index);
extern __phicall __asm_import("equinoxe_palette") void __equinoxe_palette_start();
