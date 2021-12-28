// CX16 CBM Mouse Routines
const word CX16_MOUSE_CONFIG = 0xFF68; // Mouse pointer configuration.
const word CX16_MOUSE_SCAN   = 0xFF71; // ISR routine to scan the mouse state.
const word CX16_MOUSE_GET    = 0xFF6B; // Get the mouse state;

#pragma zp_reserve(0x03..0x06)

__address(0x03) int cx16_mousex = 0;
__address(0x05) int cx16_mousey = 0;

