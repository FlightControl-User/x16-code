extern __varcall __asm_import("lib-animate") void animate_init();
extern __varcall __asm_import("lib-animate") __zp_reserve(5, $d, $c, 2, 8, $b, 5) __zp(5) char animate_add(__zp(5) char count, __zp($d) char state, __zp($c) char loop, __zp(2) char speed, __zp(8) signed char direction, __zp($b) char reverse);
extern __varcall __asm_import("lib-animate") __zp_reserve(2) void animate_logic(__zp(2) char a);
extern __varcall __asm_import("lib-animate") __zp_reserve(5, 2) __zp(2) char animate_is_waiting(__zp(5) char a);
extern __varcall __asm_import("lib-animate") __zp_reserve($c, 2) __zp(2) char animate_get_image(__zp($c) char a);
extern __varcall __asm_import("lib-animate") __zp_reserve($d, 2) __zp(2) char animate_get_transition(__zp($d) char a);
extern __varcall __asm_import("lib-animate") __zp_reserve(5, 2) __zp(2) char animate_del(__zp(5) char a);
extern __varcall __asm_import("lib-animate") __zp_reserve(8, 9, $e) void animate_player(__zp(8) char a, __zp(9) int x, __zp($e) int px);
extern __varcall __asm_import("lib-animate") __zp_reserve($b, 9) void animate_tower(__zp($b) char a);
extern __phicall __asm_import("lib-animate") void __lib_animate_start();
