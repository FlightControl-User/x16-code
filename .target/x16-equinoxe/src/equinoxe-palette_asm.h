extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35 ) void palette_init(__mem() char bram_bank);
extern __varcall __asm_import("equinoxe-palette") __mem() char palette_alloc_bram();
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35 ) __zp($22) struct palette_16_s * palette_ptr_bram(__mem() char palette_index);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35 ) __mem() char palette_use_vram(__mem() char palette_index);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35 ) void palette_unuse_vram(__mem() unsigned int bram_index);
extern __varcall __asm_import("equinoxe-palette") __zp_reserve( 34,35 ) void palette_free_vram(__mem() unsigned int bram_index);
extern __phicall __asm_import("equinoxe-palette") void __equinoxe_palette_start();
