#include "cx16-mouse.h"

/*
Function Name: MOUSE_CONFIG

  Purpose: Configure the mouse pointer 
  Call address: $FF68 
  Communication registers: .A, .X 
  Preparatory routines: None 
  Error returns: None 
  Stack requirements: 0 
  Registers affected: .A, .X, .Y

  Description: The routine mouse_config configures the mouse pointer.

  The argument in .A specifies whether the mouse pointer should be visible or not, 
  and what shape it should have. For a list of possible values, see the basic statement MOUSE.
  The argument in .X specifies the scale. 
  Use a scale of 1 for a 640x480 screen, and a scale of 2 for a 320x240 screen. 
  A value of 0 does not change the scale.

  EXAMPLE:

  LDA #1
  JSR mouse_config ; show the default mouse pointer
*/
void cx16_mouse_config(char visible, char scale) {
    asm {
        //.byte $db
        lda visible
        ldx scale
        jsr CX16_MOUSE_CONFIG
    }
}

/*
Function Name: MOUSE_SCAN

  Purpose: Query the mouse and save its state 
  Call address: $FF71 
  Communication registers: None 
  Preparatory routines: None 
  Error returns: None 
  Stack requirements: ? 
  Registers affected: .A, .X, .Y

  Description: The routine mouse_scan retrieves all state from the mouse and saves it. 
  
  It can then be retrieved using mouse_get. 
  The default interrupt handler already takes care of this, 
  so this routine should only be called if the interrupt handler has been completely replaced.
*/

void cx16_mouse_scan() {
    asm {
        //.byte $db
        jsr CX16_MOUSE_SCAN
    }
}

/*
Function Name: MOUSE_GET

  Purpose: Get the mouse state 
  Call address: $FF6B 
  Communication registers: .X 
  Preparatory routines: mouse_config 
  Error returns: None 
  Stack requirements: 0 
  Registers affected: .A

  Description: The routine mouse_get returns the state of the mouse. 
  
  The caller passes the offset of a zero-page location in .X, 
  which the routine will populate with the mouse position in 4 consecutive bytes:

  Offset  Size    Description
  0	      2       X Position
  2	      2       Y Position
  The state of the mouse buttons is returned in the .A register:

  Bit      Description
  0        Left Button
  1        Right Button
  2        Middle Button
  If a button is pressed, the corresponding bit is set.

  EXAMPLE:

  LDX #$70
  JSR mouse_get ; get mouse position in $70/$71 (X) and $72/$73 (Y)
  AND #1
  BNE BUTTON_PRESSED
*/
char cx16_mouse_get() {
    char status;
    asm {
        //.byte $db
        ldx #$03
        jsr CX16_MOUSE_GET
        sta status
    }
    return status;
}
