extern __varcall __lib_import("equinoxe-bullet") __bank( cx16_ram, 7 ) __mem() char bullet_add(__mem() unsigned int sx, __mem() unsigned int sy, __mem() unsigned int tx, __mem() unsigned int ty, __mem() char speed, __mem() char side, __mem() char sprite_bullet);
extern __varcall __lib_import("equinoxe-bullet") __bank( cx16_ram, 7 ) void bullet_logic();
extern __phicall __lib_import("equinoxe-bullet") void conio_x16_init();
extern __phicall __lib_import("equinoxe-bullet") void __equinoxe_bullet_start();
