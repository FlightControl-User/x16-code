extern __varcall __lib_import("equinoxe-player") void player_init();
extern __varcall __lib_import("equinoxe-player") void player_add(__mem() char sprite_player, __mem() char sprite_engine);
extern __varcall __lib_import("equinoxe-player") void player_remove(__mem() char p);
extern __varcall __lib_import("equinoxe-player") void player_hit(__mem() char p, __mem() signed char impact);
extern __varcall __lib_import("equinoxe-player") void player_logic(__mem() unsigned int mouse_x, __mem() unsigned int mouse_px, __mem() unsigned int mouse_y, __mem() char mouse_status);
extern __phicall __lib_import("equinoxe-player") void conio_x16_init();
extern __phicall __lib_import("equinoxe-player") void __equinoxe_player_start();
