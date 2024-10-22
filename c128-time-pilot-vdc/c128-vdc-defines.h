// vdc.h - Header file for VDC (Video Display Controller) on Commodore 128
// This file contains definitions and explanations for the VDC registers and ports.

// VDC Ports
volatile byte* const VDC_REGISTER_PORT = (byte*)0xD600;  // VDC Register Select Port
volatile byte* const VDC_DATA_PORT     = (byte*)0xD601;  // VDC Data Port

// VDC Horizontal Total Register (R0-HTOT)
// Bits 7-0: Total Number of Character Cells per Line
const byte VDC_R0_HTOT                    = 0x00;
const byte VDC_R0_HTOT_7_0_HORIZ_TOTAL    = 0xFF;  // R0 - 0-7 - Total Number of Character Cells per Line

// VDC Horizontal Displayed Register (R1-HDIS)
// Bits 7-0: Number of Character Cells Displayed per Line
const byte VDC_R1_HDIS                    = 0x01;
const byte VDC_R1_HDIS_7_0_HORIZ_DISPLAYED = 0xFF;  // R1 - 0-7 - Number of Character Cells Displayed per Line

// VDC Horizontal Sync Position Register (R2-HSST)
// Bits 7-0: Horizontal Sync Position
const byte VDC_R2_HSST                    = 0x02;
const byte VDC_R2_HSST_7_0_HORIZ_SYNC_POS = 0xFF;  // R2 - 0-7 - Horizontal Sync Position

// VDC Sync Width Register (R3-SYWD)
// Bits 7-4: Vertical Sync Width
// Bits 3-0: Horizontal Sync Width
const byte VDC_R3_SYWD                        = 0x03;
const byte VDC_R3_SYWD_3_0_HORIZ_SYNC_WIDTH   = 0x0F;  // R3 - 0-3 - Horizontal Sync Width
const byte VDC_R3_SYWD_7_4_VERT_SYNC_WIDTH    = 0xF0;  // R3 - 4-7 - Vertical Sync Width

// VDC Vertical Total Register (R4-VTOT)
// Bits 7-0: Total Number of Raster Lines per Frame
const byte VDC_R4_VTOT                    = 0x04;
const byte VDC_R4_VTOT_7_0_VERT_TOTAL     = 0xFF;  // R4 - 0-7 - Total Number of Raster Lines per Frame

// VDC Vertical Total Adjust Register (R5-VTAD)
// Bits 3-0: Vertical Total Adjust (Add Extra Lines)
const byte VDC_R5_VTAD                    = 0x05;
const byte VDC_R5_VTAD_3_0_VERT_TOTAL_ADJ = 0x0F;  // R5 - 0-3 - Vertical Total Adjust (Add Extra Lines)

// VDC Vertical Displayed Register (R6-VDIS)
// Bits 7-0: Number of Visible Raster Lines
const byte VDC_R6_VDIS                    = 0x06;
const byte VDC_R6_VDIS_7_0_VERT_DISPLAYED = 0xFF;  // R6 - 0-7 - Number of Visible Raster Lines

// VDC Vertical Sync Position Register (R7-VSST)
// Bits 7-0: Vertical Sync Position
const byte VDC_R7_VSST                    = 0x07;
const byte VDC_R7_VSST_7_0_VERT_SYNC_POS  = 0xFF;  // R7 - 0-7 - Vertical Sync Position

// VDC Interlace Mode Register (R8-IMOD)
// Bit 0: Interlace Enable (0 = Disabled, 1 = Enabled)
const byte VDC_R8_IMOD                    = 0x08;
const byte VDC_R8_IMOD_0_INTERLACE_ENABLE = 0x01;  // R8 - 0   - Interlace Enable (0 = Disabled, 1 = Enabled)

// VDC Character Total Vertical Register (R9-CTVT)
// Bits 4-0: Character Height in Scan Lines
const byte VDC_R9_CTVT                    = 0x09;
const byte VDC_R9_CTVT_4_0_CHAR_TOTAL_VERT = 0x1F;  // R9 - 0-4 - Character Height in Scan Lines

// VDC Cursor Start Scan Register (R10-CURS)
// Bits 4-0: Cursor Start Scan Line
const byte VDC_R10_CURS                    = 0x0A;
const byte VDC_R10_CURS_4_0_CURSOR_START   = 0x1F;  // R10 - 0-4 - Cursor Start Scan Line

// VDC Cursor End Scan Register (R11-CURE)
// Bits 4-0: Cursor End Scan Line
const byte VDC_R11_CURE                    = 0x0B;
const byte VDC_R11_CURE_4_0_CURSOR_END     = 0x1F;  // R11 - 0-4 - Cursor End Scan Line

// VDC Display Start Address High Byte Register (R12-SAH)
// Bits 7-0: Display Start Address High Byte
const byte VDC_R12_SAH                    = 0x0C;
const byte VDC_R12_SAH_7_0_DISPLAY_ADDR_H = 0xFF;  // R12 - 0-7 - Display Start Address High Byte

// VDC Display Start Address Low Byte Register (R13-SAL)
// Bits 7-0: Display Start Address Low Byte
const byte VDC_R13_SAL                    = 0x0D;
const byte VDC_R13_SAL_7_0_DISPLAY_ADDR_L = 0xFF;  // R13 - 0-7 - Display Start Address Low Byte

// VDC Cursor Position High Byte Register (R14-CPH)
// Bits 7-0: Cursor Position High Byte
const byte VDC_R14_CPH                    = 0x0E;
const byte VDC_R14_CPH_7_0_CURSOR_POS_H   = 0xFF;  // R14 - 0-7 - Cursor Position High Byte

// VDC Cursor Position Low Byte Register (R15-CPL)
// Bits 7-0: Cursor Position Low Byte
const byte VDC_R15_CPL                    = 0x0F;
const byte VDC_R15_CPL_7_0_CURSOR_POS_L   = 0xFF;  // R15 - 0-7 - Cursor Position Low Byte

// VDC Light Pen Vertical Register (R16-LPEN)
// Bits 7-0: Light Pen Vertical Position
const byte VDC_R16_LPEN                    = 0x10;
const byte VDC_R16_LPEN_7_0_LIGHT_PEN_VERT = 0xFF;  // R16 - 0-7 - Light Pen Vertical Position

// VDC Light Pen Horizontal Register (R17-LPEN)
// Bits 7-0: Light Pen Horizontal Position
const byte VDC_R17_LPEN                    = 0x11;
const byte VDC_R17_LPEN_7_0_LIGHT_PEN_HORIZ = 0xFF;  // R17 - 0-7 - Light Pen Horizontal Position

// VDC Update Address High Byte Register (R18-UADH)
// Bits 7-0: Update Address High Byte
const byte VDC_R18_UADH                    = 0x12;
const byte VDC_R18_UADH_7_0_UPDATE_ADDR_H  = 0xFF;  // R18 - 0-7 - Update Address High Byte

// VDC Update Address Low Byte Register (R19-UADL)
// Bits 7-0: Update Address Low Byte
const byte VDC_R19_UADL                    = 0x13;
const byte VDC_R19_UADL_7_0_UPDATE_ADDR_L  = 0xFF;  // R19 - 0-7 - Update Address Low Byte

// VDC Attribute Start Address High Byte Register (R20-ASAH)
// Bits 7-0: Attribute Start Address High Byte
const byte VDC_R20_ASAH                    = 0x14;
const byte VDC_R20_ASAH_7_0_ATTR_ADDR_H    = 0xFF;  // R20 - 0-7 - Attribute Start Address High Byte

// VDC Attribute Start Address Low Byte Register (R21-ASAL)
// Bits 7-0: Attribute Start Address Low Byte
const byte VDC_R21_ASAL                    = 0x15;
const byte VDC_R21_ASAL_7_0_ATTR_ADDR_L    = 0xFF;  // R21 - 0-7 - Attribute Start Address Low Byte

// VDC Character Total Horizontal Register (R22-CTHO)
// R22(3-0) CHARACTER DISPLAYED, HORIZONTAL
// This number sets the width of the displayed part of the character and defines the 
// horizontal intercharacter spacing to the right of the displayed part.
// R22(7-4) CHARACTER TOTAL, HORIZONTAL
// The number of pixels (horizontal) in a character, minus 1. This number includes 
// the displayed part of a character and the horizontal intercharacter spacing to the 
// right of the displayed part.
const byte VDC_R22_CTHO                    = 0x16;
const byte VDC_R22_CTHO_3_0_CHAR_DISPLAYED_HORIZ  = 0x0F;  // R22 - 0-3 - Character Displayed, Horizontal
const byte VDC_R22_CTHO_7_4_CHAR_TOTAL_HORIZ      = 0xF0;  // R22 - 4-7 - Character Total, Horizontal

// VDC Character Displayed Vertical Register (R23-CDVT)
// R23(4-0) CHARACTER DISPLAYED, VERTICAL
// The number of scan lines, minus 1, of the displayed part of a character. This number
// sets the height of the displayed part of the character and defines the vertical intercharacter
// spacing below the displayed part.
const byte VDC_R23_CDVT                      = 0x17;
const byte VDC_R23_CDVT_4_0_CHAR_DISPLAYED_VERT = 0x1F;  // R23 - 0-4 - Character Displayed, Vertical

// VDC Vertical Smooth Scroll and Control Register (R24-VSST)
// R24(4-0) VERTICAL SMOOTH SCROLL
// Controls vertical smooth scrolling by skipping scan lines to create a smooth upward
// scroll effect. The value can range from 0 to R9(4-0), which defines the maximum
// number of scan lines that can be scrolled smoothly before needing to adjust the 
// display start address.
//
// R24(5) CHARACTER BLINK RATE
// Determines the blink rate of characters when the attribute is enabled. 
// 0 = Blink rate is 1/16th of the frame rate, 1 = Blink rate is 1/32nd of the frame rate.
//
// R24(6) REVERSE SCREEN
// Controls the screen color inversion. 
// 0 = Normal foreground/background colors, 1 = Reversed foreground/background colors.
//
// R24(7) BLOCK COPY
// Enables block copy operations. 
// 0 = Block Write mode, 1 = Block Copy mode.
const byte VDC_R24_VSST                       = 0x18;
const byte VDC_R24_VSST_4_0_VERT_SMOOTH_SCROLL = 0x1F;  // R24 - 0-4 - Vertical Smooth Scroll
const byte VDC_R24_VSST_5_CHAR_BLINK_RATE       = 0x20;  // R24 - 5   - Character Blink Rate
const byte VDC_R24_VSST_6_REVERSE_SCREEN        = 0x40;  // R24 - 6   - Reverse Screen
const byte VDC_R24_VSST_7_BLOCK_COPY            = 0x80;  // R24 - 7   - Block Copy

// VDC Mode Control and Smooth Horizontal Scroll Register (R25-MODE)
// R25(3-0) SMOOTH HORIZONTAL SCROLL
// Controls smooth horizontal scrolling by moving all characters on the screen to the left by the specified 
// number of pixels. The value can range from 0 to R22(7-4), which defines the maximum scroll distance.
// 
// R25(4) PIXEL DOUBLE WIDTH
// Controls the width of each pixel. If set to 0, the pixel width is one DCLK period. If set to 1, the pixel 
// width is doubled, resulting in a 40-column display instead of 80.
// 
// R25(5) SEMIGRAPHIC MODE
// Enables semigraphic mode, which allows the last displayed pixel of a character to extend into the 
// horizontal intercharacter space. If set to 1, semigraphics operation occurs, allowing characters to 
// touch the next character.
// 
// R25(6) ATTRIBUTE ENABLE
// Enables or disables attribute usage. If set to 1, attributes like underline, reverse, and blink are enabled. 
// If set to 0, attributes are disabled, reducing RAM usage, and the foreground color for all characters 
// will be determined by R26(7-4).
// 
// R25(7) MODE SELECT (Text/Bitmap)
// Selects the display mode. If set to 0, the 8563 operates in text mode. If set to 1, the 8563 operates in 
// bitmap mode, where each pixel is controlled by a unique bit in 8563 RAM memory.
const byte VDC_R25_MODE                        = 0x19;
const byte VDC_R25_MODE_3_0_HORIZ_SMOOTH_SCROLL = 0x0F;  // R25 - 0-3 - Smooth Horizontal Scroll
const byte VDC_R25_MODE_4_PIXEL_DOUBLE_WIDTH    = 0x10;  // R25 - 4   - Pixel Double Width
const byte VDC_R25_MODE_5_SEMIGRAPHIC_MODE      = 0x20;  // R25 - 5   - Semigraphic Mode
const byte VDC_R25_MODE_6_ATTRIBUTE_ENABLE      = 0x40;  // R25 - 6   - Attribute Enable
const byte VDC_R25_MODE_7_MODE_SELECT           = 0x80;  // R25 - 7   - Mode Select (Text/Bitmap)

// VDC Foreground/Background Color Register (R26-FG/BG)
// Bits 7-4: Background Color
// Bits 3-0: Foreground Color
const byte VDC_R26_FGBG                    = 0x1A;
const byte VDC_R26_FGBG_3_0_FOREGROUND_COLOR = 0x0F;  // R26 - 0-3 - Foreground Color
const byte VDC_R26_FGBG_7_4_BACKGROUND_COLOR = 0xF0;  // R26 - 4-7 - Background Color

// VDC Address Increment per Row Register (R27-INCR)
// R27 ADDRESS INCREMENT PER ROW
// Controls the number of bytes to skip at the end of each scan line in bit-mapped mode, 
// allowing horizontal smooth scrolling. The value in R27 is used to increment the address 
// of the bit-mapped data and the attributes from one scan line to the next. A nonzero 
// value in R27 is necessary for horizontal smooth scrolling to work properly.
const byte VDC_R27_INCR                    = 0x1B;
const byte VDC_R27_INCR_7_0_ADDR_INCREMENT_PER_ROW = 0xFF;  // R27 - 0-7 - Address Increment per Row

// VDC Character Base Address and RAM Type Register (R28-CBAD)
// R28(4) 8563 RAM TYPE (4416/4164)
// Selects the type of external RAM used by the 8563. 
// 0 = 4416 DRAM (16K x 4), 1 = 4164 DRAM (64K x 1).
//
// R28(7-5) CHARACTER SET START ADDRESS
// Sets the starting location of the character set in display RAM. These bits form the 
// most significant 3 bits of the 16-bit address used to access character data. If R9(4-0) 
// is greater than 15, only bits 7-6 of R28 are used.
const byte VDC_R28_CBAD                     = 0x1C;
const byte VDC_R28_CBAD_4_RAM_TYPE          = 0x10;  // R28 - 4   - 8563 RAM Type (4416/4164)
const byte VDC_R28_CBAD_7_5_CHAR_SET_START  = 0xE0;  // R28 - 5-7 - Character Set Start Address

// VDC Underline Scan Line Register (R29-USLN)
// R29(4-0) UNDERLINE SCAN LINE COUNT
// Defines the scan line within a character that will be used for underlining. 
// The value specifies which scan line (0-15) within the character cell will be underlined.
// Scan line 0 refers to the scan line at the top of the character.
const byte VDC_R29_USLN                      = 0x1D;
const byte VDC_R29_USLN_4_0_UNDERLINE_SCAN_LINE = 0x1F;  // R29 - 0-4 - Underline Scan Line Count

// VDC Word Count Register (R30-WORD)
// Bits 7-0: Word Count for Block Operations
const byte VDC_R30_WORD                    = 0x1E;
const byte VDC_R30_WORD_7_0_WORD_COUNT     = 0xFF;  // R30 - 0-7 - Word Count for Block Operations

// VDC Data Register (R31-DATA)
// Bits 7-0: Data for Block Operations
const byte VDC_R31_DATA                    = 0x1F;
const byte VDC_R31_DATA_7_0_DATA           = 0xFF;  // R31 - 0-7 - Data for Block Operations

// VDC Block Copy Source Address High Byte Register (R32-BSAH)
// R32 BLOCK COPY SOURCE ADDRESS (HIGH BYTE)
// The most significant byte of the source address for the Block Copy operation. This 
// address specifies where the 8563 will start copying data from in memory.
const byte VDC_R32_BSAH                    = 0x20;
const byte VDC_R32_BSAH_7_0_BLOCK_SRC_ADDR_H = 0xFF;  // R32 - 0-7 - Block Copy Source Address High Byte

// VDC Block Copy Source Address Low Byte Register (R33-BSAL)
// R33 BLOCK COPY SOURCE ADDRESS (LOW BYTE)
// The least significant byte of the source address for the Block Copy operation. This 
// address, combined with the high byte in R32, specifies the starting point for copying data.
const byte VDC_R33_BSAL                    = 0x21;
const byte VDC_R33_BSAL_7_0_BLOCK_SRC_ADDR_L = 0xFF;  // R33 - 0-7 - Block Copy Source Address Low Byte

// VDC Display Enable Begin Register (R34-DEBN)
// R34 DISPLAY ENABLE BEGIN
// Specifies the number of characters from the first displayed character of a row to the 
// first blanked character in that row. This register sets the starting point for horizontal blanking.
const byte VDC_R34_DEBN                    = 0x22;
const byte VDC_R34_DEBN_7_0_DISPLAY_ENABLE_BEGIN = 0xFF;  // R34 - 0-7 - Display Enable Begin

// VDC Display Enable End Register (R35-DEEN)
// R35 DISPLAY ENABLE END
// Specifies the number of characters from the first displayed character of a row to the 
// last blanked character in that row. This register sets the ending point for horizontal blanking.
const byte VDC_R35_DEEN                    = 0x23;
const byte VDC_R35_DEEN_7_0_DISPLAY_ENABLE_END = 0xFF;  // R35 - 0-7 - Display Enable End

// VDC DRAM Refresh Rate Register (R36-REFR)
// R36(3-0) 8563 RAM REFRESH/SCAN LINE
// Specifies the number of Dynamic RAM refresh cycles that occur every scan line. 
// These refresh cycles are essential for maintaining data integrity in the 8563 RAM. 
// The refresh operation occurs on both displayed and non-displayed scan lines, 
// and across all areas of the screen, including blanked scan lines and vertical borders. 
// The refresh address increments through all 65,536 addresses of the 8563 RAM.
const byte VDC_R36_REFR                    = 0x24;
const byte VDC_R36_REFR_3_0_RAM_REFRESH_SCAN_LINE = 0x0F;  // R36 - 0-3 - 8563 RAM Refresh per Scan Line

// VDC Sync Polarity Register (R37-SYPL)
// R37(3-0) HORIZONTAL SYNC POLARITY
// Controls the polarity of the horizontal sync signal. This setting determines whether the 
// horizontal sync pulse is active high or active low.
//
// R37(7-4) VERTICAL SYNC POLARITY
// Controls the polarity of the vertical sync signal. This setting determines whether the 
// vertical sync pulse is active high or active low.
const byte VDC_R37_SYPL                    = 0x25;
const byte VDC_R37_SYPL_3_0_HORIZ_SYNC_POLARITY = 0x0F;  // R37 - 0-3 - Horizontal Sync Polarity
const byte VDC_R37_SYPL_7_4_VERT_SYNC_POLARITY  = 0xF0;  // R37 - 4-7 - Vertical Sync Polarity