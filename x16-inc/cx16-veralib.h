/**
 * @file cx16-veralib.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Commander X16 vera library for the kickc compiler.
 * Commander X16 VERA (Versatile Embedded Retro Adapter) Video and Audio Processor
 * https://github.com/commanderx16/x16-docs/blob/master/VERA%20Programmer's%20Reference.md
 * @version 0.1
 * @date 2021-06-14
 *
 * @copyright Copyright (c) 2021
 *
 */

#include <cx16-veralib-typedefs.h>

inline void vera_vram_data0_address(unsigned long bankaddr, enum vera_inc_dec inc_dec);
inline void vera_vram_data1_address(unsigned long bankaddr, enum vera_inc_dec inc_dec);
inline void vera_vram_data0_bank_offset(vera_bank bank, vera_offset offset, enum vera_inc_dec inc_dec);
inline void vera_vram_data1_bank_offset(vera_bank bank, vera_offset offset, enum vera_inc_dec inc_dec);

/// --- VERA active display management ---

// #define vera_vram_data0_bank_offset(bank, offset, inc_dec) *VERA_CTRL &= ~VERA_ADDRSEL; *VERA_ADDRX_L = BYTE0(offset); *VERA_ADDRX_M = BYTE1(offset); *VERA_ADDRX_H = bank | inc_dec;



inline void vera_display_set_scale_none();
inline void vera_display_set_scale_double();
inline void vera_display_set_scale_triple();
vera_scale vera_display_get_hscale();
vera_scale vera_display_get_vscale();
vera_height vera_display_get_height();
vera_width vera_display_get_width();
inline void vera_display_set_border_color(char color);
inline void vera_display_set_hstart(char start);
inline void vera_display_set_hstop(char stop);
inline void vera_display_set_vstart(char start);
inline void vera_display_set_vstop(char stop);


/// --- VERA LAYERS ---

void vera_layers_reset();

void vera_layer0_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp );
void vera_layer1_mode_tile(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char bpp );

void vera_layer0_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode);
void vera_layer1_mode_text(char mapbase_bank, unsigned int mapbase_offset, char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char mapheight, char tilewidth, char tileheight, char color_mode);

void vera_layer0_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char color_depth);
void vera_layer1_mode_bitmap(char tilebase_bank, unsigned int tilebase_offset, char mapwidth, char color_depth);

inline void vera_layer0_set_mapbase(vera_bank mapbase_bank, vera_offset mapbase_offset);
inline void vera_layer1_set_mapbase(vera_bank mapbase_bank, vera_offset mapbase_offset);
inline void vera_layer0_set_tilebase(vera_bank tilebase_bank, vera_offset tilebase_offset);
inline void vera_layer1_set_tilebase(vera_bank tilebase_bank, vera_offset tilebase_offset);

inline void vera_layer0_set_bitmap_mode();
inline void vera_layer1_set_bitmap_mode();

inline void vera_layer0_set_tilemap_mode();
inline void vera_layer1_set_tilemap_mode();


inline void vera_layer0_set_tile_height(char tileheight);
inline void vera_layer1_set_tile_height(char tileheight);
inline void vera_layer0_set_tile_width(char tilewidth);
inline void vera_layer1_set_tile_width(char tilewidth);

inline void vera_layer0_set_config(vera_config config);
inline void vera_layer1_set_config(vera_config config);
vera_config vera_layer0_get_config();
vera_config vera_layer1_get_config();

void vera_layer0_set_text_color_mode(vera_color_mode color_mode);
void vera_layer1_set_text_color_mode(vera_color_mode color_mode);

inline void vera_layer0_set_width_32();
inline void vera_layer0_set_width_64();
inline void vera_layer0_set_width_128();
inline void vera_layer0_set_width_256();
inline void vera_layer1_set_width_32();
inline void vera_layer1_set_width_64();
inline void vera_layer1_set_width_128();
inline void vera_layer1_set_width_256();
inline void vera_layer0_set_width(char mapwidth);
inline void vera_layer1_set_width(char mapwidth);

inline void vera_layer0_set_height_32();
inline void vera_layer0_set_height_64();
inline void vera_layer0_set_height_128();
inline void vera_layer0_set_height_256();
inline void vera_layer1_set_height_32();
inline void vera_layer1_set_height_64();
inline void vera_layer1_set_height_128();
inline void vera_layer1_set_height_256();
inline void vera_layer0_set_height(char mapheight);
inline void vera_layer1_set_height(char mapheight);

inline unsigned int vera_layer0_get_width();
inline unsigned int vera_layer0_get_height();
inline unsigned int vera_layer1_get_width();
inline unsigned int vera_layer1_get_height();

inline void vera_layer0_set_color_depth_1BPP();
inline void vera_layer0_set_color_depth_2BPP();
inline void vera_layer0_set_color_depth_4BPP();
inline void vera_layer0_set_color_depth_8BPP();
inline char vera_layer0_get_color_depth();
inline void vera_layer1_set_color_depth_1BPP();
inline void vera_layer1_set_color_depth_2BPP();
inline void vera_layer1_set_color_depth_4BPP();
inline void vera_layer1_set_color_depth_8BPP();
inline char vera_layer1_get_color_depth();
inline void vera_layer0_set_color_depth(char bpp);
inline void vera_layer1_set_color_depth(char bpp);

  
inline void vera_layer0_show();
inline void vera_layer1_show();
inline void vera_layer0_hide();
inline void vera_layer1_show();
char vera_layer0_is_visible();
char vera_layer1_is_visible();

char vera_layer0_get_mapbase_bank();
unsigned int vera_layer0_get_mapbase_offset();
char vera_layer1_get_mapbase_bank();
unsigned int vera_layer1_get_mapbase_offset();

vera_tile_offset vera_layer0_get_tilebase();
vera_tile_offset vera_layer1_get_tilebase();

inline void vera_layer0_set_horizontal_scroll(unsigned int scroll);
inline void vera_layer1_set_horizontal_scroll(unsigned int scroll);
inline void vera_layer0_set_vertical_scroll(unsigned int scroll);
inline void vera_layer1_set_vertical_scroll(unsigned int scroll);

inline unsigned char vera_layer0_get_rowshift();
inline unsigned int vera_layer0_get_rowskip();
inline unsigned char vera_layer1_get_rowshift();
inline unsigned int vera_layer1_get_rowskip();

// --- SPRITES ---

inline vera_sprite_offset vera_sprite_get_offset(vera_sprite_id sprite_id);
inline vera_sprite_id vera_sprite_get_id(vera_sprite_offset sprite_offset);
inline vera_sprite_image_offset vera_sprite_get_image_offset(vera_bank bank, vera_offset offset);
inline void vera_sprite_set_image_offset(vera_sprite_offset sprite_offset, vera_sprite_image_offset sprite_image_offset);

inline void vera_sprite_address(vera_sprite_offset sprite_offset, unsigned long address);
inline void vera_sprite_bank_offset(vera_sprite_offset sprite_offset, vera_bank bank, vera_offset offfset);

inline void vera_sprite_set_xy(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
inline void vera_sprite_set_xy_and_image_offset(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y, vera_sprite_image_offset sprite_image_offset);
vera_sprite_coordinate vera_sprite_x_get(vera_sprite_offset sprite_offset);
vera_sprite_coordinate vera_sprite_y_get(vera_sprite_offset sprite_offset);

inline void vera_sprite_4bpp(vera_sprite_offset sprite_offset);
inline void vera_sprite_8bpp(vera_sprite_offset sprite_offset);
inline void vera_sprite_bpp(vera_sprite_offset sprite_offset, char bpp);
inline vera_sprite_bpp_t vera_sprite_bpp_get(vera_sprite_offset sprite_offset);
vera_sprite_bpp_t vera_sprite_bpp_get_bitmap(char bpp);
unsigned char vera_sprite_bpp_get_value(vera_sprite_bpp_t bpp);


inline void vera_sprite_hflip_on(vera_sprite_offset sprite_offset);
inline void vera_sprite_hflip_off(vera_sprite_offset sprite_offset);
void vera_sprite_hflip(vera_sprite_offset sprite_offset, char hflip);
inline vera_sprite_hflip_t vera_sprite_hflip_get_bitmap(char hflip);
inline unsigned char vera_sprite_hflip_get_value(vera_sprite_hflip_t hflip);

inline void vera_sprite_vflip_on(vera_sprite_offset sprite_offset);
inline void vera_sprite_vflip_off(vera_sprite_offset sprite_offset);
void vera_sprite_vflip(vera_sprite_offset sprite_offset, char vflip);
unsigned char vera_sprite_vflip_get_bitmap(char vflip);
inline vera_sprite_vflip_t vera_sprite_vflip_get_bitmap(char vflip);
inline unsigned char vera_sprite_vflip_get_value(vera_sprite_vflip_t vflip);

inline void vera_sprite_disable(vera_sprite_offset sprite_offset);
inline void vera_sprite_zdepth_between_background_and_layer0(vera_sprite_offset sprite_offset);
inline void vera_sprite_zdepth_between_layer0_and_layer1(vera_sprite_offset sprite_offset);
inline void vera_sprite_zdepth_in_front(vera_sprite_offset sprite_offset);
inline void vera_sprite_zdepth(vera_sprite_offset sprite_offset, unsigned char zdepth);
inline vera_sprite_zdepth_t vera_sprite_zdepth_get_bitmap(char zdepth);
inline unsigned char vera_sprite_zdepth_get_value(vera_sprite_zdepth_t zdepth);

inline void vera_sprite_width_8(vera_sprite_offset sprite_offset);
inline void vera_sprite_width_16(vera_sprite_offset sprite_offset);
inline void vera_sprite_width_32(vera_sprite_offset sprite_offset);
inline void vera_sprite_width_64(vera_sprite_offset sprite_offset);
void vera_sprite_width(vera_sprite_offset sprite_offset, char width);
inline vera_sprite_width_t vera_sprite_width_get(vera_sprite_offset sprite_offset);
inline vera_sprite_width_t vera_sprite_width_get_bitmap(char width);
inline unsigned char vera_sprite_width_get_value(vera_sprite_width_t width);

inline void vera_sprite_height_8(vera_sprite_offset sprite_offset);
inline void vera_sprite_height_16(vera_sprite_offset sprite_offset);
inline void vera_sprite_height_32(vera_sprite_offset sprite_offset);
inline void vera_sprite_height_64(vera_sprite_offset sprite_offset);
void vera_sprite_height(vera_sprite_offset sprite_offset, char height);
inline vera_sprite_height_t vera_sprite_height_get(vera_sprite_offset sprite_offset);
inline vera_sprite_height_t vera_sprite_height_get_bitmap(char height);
inline unsigned char vera_sprite_height_get_value(vera_sprite_height_t height); 

inline void vera_sprite_palette_offset(vera_sprite_offset sprite_offset, vera_palette_offset palette_offset);
inline void vera_sprite_set_collision_mask(vera_sprite_offset sprite_offset, vera_collision_mask mask);
inline void vera_sprites_show();
inline void vera_sprites_hide();

inline void vera_sprites_collision_on();
inline void vera_sprites_collision_off();
inline char vera_sprite_is_collision();
inline void vera_sprite_collision_clear();
inline unsigned char vera_sprite_get_collision();

inline void vera_sprite_attributes_set(vera_sprite_offset sprite_offset, struct VERA_SPRITE sprite_attr);
inline void vera_sprite_attributes_get(vera_sprite_offset sprite_offset, struct VERA_SPRITE *sprite_attr);
