#include <cx16.h>
#include <kernal.h>
#include <string.h>

/*
B-28. Function Name: SETLFS

  Purpose: Set up a logical file
  Call address: $FFBA (hex) 65466 (decimal)
  Communication registers: A, X, Y
  Preparatory routines: None
  Error returns: None
  Stack requirements: 2
  Registers affected: None


  Description: This routine sets the logical file number, device address,
and secondary address (command number) for other KERNAL routines.
  The logical file number is used by the system as a key to the file
table created by the OPEN file routine. Device addresses can range from 0
to 31. The following codes are used by the Commodore 64 to stand for the
CBM devices listed below:


                ADDRESS          DEVICE

                   0            Keyboard
                   1            Datassette(TM)
                   2            RS-232C device
                   3            CRT display
                   4            Serial bus printer
                   8            CBM serial bus disk drive


  Device numbers 4 or greater automatically refer to devices on the
serial bus.
  A command to the device is sent as a secondary address on the serial
bus after the device number is sent during the serial attention
handshaking sequence. If no secondary address is to be sent, the Y index
register should be set to 255.

How to Use:

  1) Load the accumulator with the logical file number.
  2) Load the X index register with the device number.
  3) Load the Y index register with the command.

EXAMPLE:

  FOR LOGICAL FILE 32, DEVICE #4, AND NO COMMAND:
  LDA #32
  LDX #4
  LDY #255
  JSR SETLFS
*/
void cbm_k_setlfs(char channel, char device, char secondary) {
    asm {
        ldx device
        lda channel
        ldy secondary
        jsr CBM_SETLFS
    }
}

/*
B-30. Function Name: SETNAM

  Purpose: Set file name
  Call address: $FFBD (hex) 65469 (decimal)
  Communication registers: A, X, Y
  Preparatory routines:
  Stack requirements: 2
  Registers affected:

  Description: This routine is used to set up the file name for the OPEN,
SAVE, or LOAD routines. The accumulator must be loaded with the length of
the file name. The X and Y registers must be loaded with the address of
the file name, in standard 6502 low-byte/high-byte format. The address
can be any valid memory address in the system where a string of
characters for the file name is stored. If no file name is desired, the
accumulator must be set to 0, representing a zero file length. The X and
Y registers can be set to any memory address in that case.

How to Use:

  1) Load the accumulator with the length of the file name.
  2) Load the X index register with the low order address of the file
     name.
  3) Load the Y index register with the high order address.
  4) Call this routine.

EXAMPLE:

  LDA #NAME2-NAME     ;LOAD LENGTH OF FILE NAME
  LDX #<NAME          ;LOAD ADDRESS OF FILE NAME
  LDY #>NAME
  JSR SETNAM
*/
void cbm_k_setnam(char* filename) {
    char filename_len = (char)strlen(filename);
    asm {
        lda filename_len
        ldx filename
        ldy filename+1
        jsr CBM_SETNAM
    }
}

/*
B-18. Function Name: OPEN

  Purpose: Open a logical file
  Call address: $FFC0 (hex) 65472 (decimal)
  Communication registers: None
  Preparatory routines: SETLFS, SETNAM
  Error returns: 1,2,4,5,6,240, READST
  Stack requirements: None
  Registers affected: A, X, Y

  Description: This routine is used to OPEN a logical file. Once the
logical file is set up, it can be used for input/output operations. Most
of the I/O KERNAL routines call on this routine to create the logical
files to operate on. No arguments need to be set up to use this routine,
but both the SETLFS and SETNAM KERNAL routines must be called before
using this routine.

How to Use:

  0) Use the SETLFS routine.
  1) Use the SETNAM routine.
  2) Call this routine.
*/
char cbm_k_open() {
    char status;
    asm {
        //.byte $db
        jsr CBM_OPEN
        bcs !error+
        lda #$ff
        !error:
        sta status
    }
    return status;
}

/*
B-9. Function Name: CLOSE

  Purpose: Close a logical file
  Call address: $FFC3 (hex) 65475 (decimal)
  Communication registers: A
  Preparatory routines: None
  Error returns: 0,240 (See READST)
  Stack requirements: 2+
  Registers affected: A, X, Y

  Description: This routine is used to close a logical file after all I/O
operations have been completed on that file. This routine is called after
the accumulator is loaded with the logical file number to be closed (the
same number used when the file was opened using the OPEN routine).

How to Use:

  1) Load the accumulator with the number of the logical file to be
     closed.
  2) Call this routine.
*/
char cbm_k_close(char channel) {
    char status;
    asm {
        //.byte $db
        lda channel
        jsr CBM_CLOSE
        bcs !error+
        lda #$ff
        !error:
        sta status
    }
    return status;
}


/*
B-2. Function Name: CHKIN

  Purpose: Open a channel for input
  Call address: $FFC6 (hex) 65478 (decimal)
  Communication registers: X
  Preparatory routines: (OPEN)
  Error returns:
  Stack requirements: None
  Registers affected: A, X

  Description: Any logical file that has already been opened by the
KERNAL OPEN routine can be defined as an input channel by this routine.
Naturally, the device on the channel must be an input device. Otherwise
an error will occur, and the routine will abort.
  If you are getting data from anywhere other than the keyboard, this
routine must be called before using either the CHRIN or the GETIN KERNAL
routines for data input. If you want to use the input from the keyboard,
and no other input channels are opened, then the calls to this routine,
and to the OPEN routine are not needed.
  When this routine is used with a device on the serial bus, it auto-
matically sends the talk address (and the secondary address if one was
specified by the OPEN routine) over the bus.

How to Use:

  0) OPEN the logical file (if necessary; see description above).
  1) Load the X register with number of the logical file to be used.
  2) Call this routine (using a JSR command).

Possible errors are:

  #3: File not open
  #5: Device not present
  #6: File not an input file
*/
char cbm_k_chkin(char channel) {
    char status;
    asm {
        ldx channel
        jsr CBM_CHKIN
        bcs !error+
        lda #$ff
        !error:
        sta status
    }
    return status;
}

/*
B-10. Function Name: CLRCHN

  Purpose: Clear I/O channels
  Call address: $FFCC (hex) 65484 (decimal)
  Communication registers: None
  Preparatory routines: None
  Error returns:
  Stack requirements: 9
  Registers affected: A, X

  Description: This routine is called to clear all open channels and re-
store the I/O channels to their original default values. It is usually
called after opening other I/O channels (like a tape or disk drive) and
using them for input/output operations. The default input device is 0
(keyboard). The default output device is 3 (the Commodore 64 screen).
  If one of the channels to be closed is to the serial port, an UNTALK
signal is sent first to clear the input channel or an UNLISTEN is sent to
clear the output channel. By not calling this routine (and leaving lis-
tener(s) active on the serial bus) several devices can receive the same
data from the Commodore 64 at the same time. One way to take advantage
of this would be to command the printer to TALK and the disk to LISTEN.
This would allow direct printing of a disk file.
  This routine is automatically called when the KERNAL CLALL routine is
executed.

How to Use:
  1) Call this routine using the JSR instruction.
*/
void cbm_k_clrchn() {
    asm {
        jsr CBM_CLRCHN
    }
}


/*
B-4. Function Name: CHRIN

  Purpose: Get a character from the input channel
  Call address: $FFCF (hex) 65487 (decimal)
  Communication registers: A
  Preparatory routines: (OPEN, CHKIN)
  Error returns: 0 (See READST)
  Stack requirements: 7+
  Registers affected: A, X

  Description: This routine gets a byte of data from a channel already
set up as the input channel by the KERNAL routine CHKIN. If the CHKIN has
NOT been used to define another input channel, then all your data is
expected from the keyboard. The data byte is returned in the accumulator.
The channel remains open after the call.
  Input from the keyboard is handled in a special way. First, the cursor
is turned on, and blinks until a carriage return is typed on the
keyboard. All characters on the line (up to 88 characters) are stored in
the BASIC input buffer. These characters can be retrieved one at a time
by calling this routine once for each character. When the carriage return
is retrieved, the entire line has been processed. The next time this
routine is called, the whole process begins again, i.e., by flashing the
cursor.

How to Use:

FROM THE KEYBOARD

  1) Retrieve a byte of data by calling this routine.
  2) Store the data byte.
  3) Check if it is the last data byte (is it a CR?)
  4) If not, go to step 1.

FROM OTHER DEVICES

  0) Use the KERNAL OPEN and CHKIN routines.
  1) Call this routine (using a JSR instruction).
  2) Store the data.
*/
char cbm_k_chrin() {
    char value;
    asm {
        //.byte $db
        jsr CBM_CHRIN
        sta value
    }
    return value;
}

/*
B-22. Function Name: READST

  Purpose: Read status word
  Call address: $FFB7 (hex) 65463 (decimal)
  Communication registers: A
  Preparatory routines: None
  Error returns: None
  Stack requirements: 2
  Registers affected: A

  Description: This routine returns the current status of the I/O devices
in the accumulator. The routine is usually called after new communication
to an I/O device. The routine gives you information about device status,
or errors that have occurred during the I/O operation.
  The bits returned in the accumulator contain the following information:
(see table below)

+---------+------------+---------------+------------+-------------------+
|  ST Bit | ST Numeric |    Cassette   |   Serial   |    Tape Verify    |
| Position|    Value   |      Read     |  Bus R/W   |      + Load       |
+---------+------------+---------------+------------+-------------------+
|    0    |      1     |               |  time out  |                   |
|         |            |               |  write     |                   |
+---------+------------+---------------+------------+-------------------+
|    1    |      2     |               |  time out  |                   |
|         |            |               |    read    |                   |
+---------+------------+---------------+------------+-------------------+
|    2    |      4     |  short block  |            |    short block    |
+---------+------------+---------------+------------+-------------------+
|    3    |      8     |   long block  |            |    long block     |
+---------+------------+---------------+------------+-------------------+
|    4    |     16     | unrecoverable |            |   any mismatch    |
|         |            |   read error  |            |                   |
+---------+------------+---------------+------------+-------------------+
|    5    |     32     |    checksum   |            |     checksum      |
|         |            |     error     |            |       error       |
+---------+------------+---------------+------------+-------------------+
|    6    |     64     |  end of file  |  EOI line  |                   |
+---------+------------+---------------+------------+-------------------+
|    7    |   -128     |  end of tape  | device not |    end of tape    |
|         |            |               |   present  |                   |
+---------+------------+---------------+------------+-------------------+

How to Use:

  1) Call this routine.
  2) Decode the information in the A register as it refers to your pro-
     gram.
*/
char cbm_k_readst() {
    char status;
    asm {
        //.byte $db
        jsr CBM_READST
        sta status
    }
    return status;
}


/*
Function Name: LOAD

  Purpose: Load RAM from device
  Call address: $FFD5 (hex) 65493 (decimal)
  Communication registers: A, X, Y
  Preparatory routines: SETLFS, SETNAM
  Error returns: 0,4,5,8,9, READST
  Stack requirements: None
  Registers affected: A, X, Y

  Description: This routine LOADs data bytes from any input device di-
rectly into the memory of the Commodore 64. It can also be used for a
verify operation, comparing data from a device with the data already in
memory, while leaving the data stored in RAM unchanged.
  The accumulator (.A) must be set to 0 for a LOAD operation, or 1 for a
verify, If the input device is OPENed with a secondary address (SA) of 0
the header information from the device is ignored. In this case, the X
and Y registers must contain the starting address for the load. If the
device is addressed with a secondary address of 1, then the data is
loaded into memory starting at the location specified by the header. This
routine returns the address of the highest RAM location loaded.
  Before this routine can be called, the KERNAL SETLFS, and SETNAM
routines must be called.


+-----------------------------------------------------------------------+
| NOTE: You can NOT LOAD from the keyboard (0), RS-232 (2), or the      |
| screen (3).                                                           |
+-----------------------------------------------------------------------+


How to Use:

  0) Call the SETLFS, and SETNAM routines. If a relocated load is de-
     sired, use the SETLFS routine to send a secondary address of 0.
  1) Set the A register to 0 for load, 1 for verify.
  2) If a relocated load is desired, the X and Y registers must be set
     to the start address for the load.
  3) Call the routine using the JSR instruction.

EXAMPLE:

        ;LOAD   A FILE FROM TAPE

         LDA #DEVICE1        ;SET DEVICE NUMBER
         LDX #FILENO         ;SET LOGICAL FILE NUMBER
         LDY CMD1            ;SET SECONDARY ADDRESS
         JSR SETLFS
         LDA #NAME1-NAME     ;LOAD A WITH NUMBER OF
                             ;CHARACTERS IN FILE NAME
         LDX #<NAME          ;LOAD X AND Y WITH ADDRESS OF
         LDY #>NAME          ;FILE NAME
         JSR SETNAM
         LDA #0              ;SET FLAG FOR A LOAD
         LDX #$FF            ;ALTERNATE START
         LDY #$FF
         JSR LOAD
         STX VARTAB          ;END OF LOAD
         STY VARTA B+1
         JMP START
 NAME    .BYT 'FILE NAME'
 NAME1                       ;
*/
char cbm_k_load(char* address, char verify) {
    char status;
    asm {
        //LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
        // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
        // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
        .byte $db
        ldx address
        ldy address+1
        lda verify
        jsr $ffd5
        bcs !error+
        lda #$ff
        !error:
        sta status
    }
    return status;
}

// GETIN. Read a byte from the input channel
// return: next byte in buffer or 0 if buffer is empty.
char getin() {
    char ch;
    unsigned char bnk;
    bnk = cx16_bram_bank_set(0);
    asm {
        jsr $ffe4
        sta ch
    }
    cx16_bram_bank_set(bnk);
    return ch;
}

