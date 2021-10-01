/*

Copyright (c) 1990-1998 Microsoft Corporation, All Rights Reserved

Module Name:

    i8042prt.h

Abstract:

    These are the structures and defines that are used in the
    Intel i8042 port driver.

Revision History:

--*/

#ifndef _I8042PRT_
#define _I8042PRT_

#include "ntddk.h"
#include <ntddkbd.h>
#include <ntddmou.h>
#include <ntdd8042.h>
#include "kbdmou.h"
#include "wmilib.h"
#include "i8042cfg.h"
#include "i8042str.h"

#define I8042_POOL_TAG (ULONG) '2408'
#undef ExAllocatePool
#define ExAllocatePool(type, size) \
            ExAllocatePoolWithTag (type, size, I8042_POOL_TAG)

#if DBG
#ifdef PAGED_CODE
#undef PAGED_CODE
#endif

#define PAGED_CODE() \
    if (KeGetCurrentIrql() > APC_LEVEL) { \
    KdPrint(( "8042: Pageable code called at IRQL %d\n", KeGetCurrentIrql() )); \
        DbgBreakPoint(); \
        }
#endif

#define MOUSE_RECORD_ISR     DBG
#define I8042_VERBOSE        DBG 
#define KEYBOARD_RECORD_INIT DBG

#define DELAY_SYSBUTTON_COMPLETION 1

//
// Define the timer values.
//


#define I8042_ASYNC_NO_TIMEOUT -1
#define I8042_ASYNC_TIMEOUT     3

//
// Define the default number of entries in the input data queue.
//

#define DATA_QUEUE_SIZE    100

//
// Define the default stall value.
//

#define I8042_STALL_DEFAULT      50

//
// Custom resource type used when pruning the fdo's resource lists
// 
#define I8X_REMOVE_RESOURCE 0xef

//
// Length (including NULL) of the PnP string identifying the mouse
//
// New style mice will respond with MSHxxxx
// Old style mice will respond with pnpxxxx
// 
#define MOUSE_PNPID_LENGTH 8

//
// Number of times to poll the hardware (determined empiracally)
//
#define I8X_POLL_ITERATIONS_MAX (11200)

//
// Define the default "sync time" used to determine when the start
// of a new mouse data packet is expected.  The value is in units
// of 100 nanoseconds.
//

#define MOUSE_SYNCH_PACKET_100NS 10000000UL // 1 second, in 100 ns units

//
// Time, in ms, for the mouse to respond to the query ID sequence
//
#define WHEEL_DETECTION_TIMEOUT 1500

//
// Default for how to initialize the mouse
//
#define I8X_INIT_POLLED_DEFAULT 0


#define IOCTL_INTERNAL_MOUSE_RESET  \
            CTL_CODE(FILE_DEVICE_MOUSE, 0x0FFF, METHOD_NEITHER, FILE_ANY_ACCESS)

//
// Define booleans.
//

#define WAIT_FOR_ACKNOWLEDGE    TRUE
#define NO_WAIT_FOR_ACKNOWLEDGE FALSE
#define AND_OPERATION           TRUE
#define OR_OPERATION            FALSE
#define ENABLE_OPERATION        TRUE
#define DISABLE_OPERATION       FALSE

//
// Default keyboard scan code mode.
//

#define KEYBOARD_SCAN_CODE_SET 0x01

//
// Default number of function keys, number of LED indicators, and total
// number of keys located on the known types of keyboard.
//

#define NUM_KNOWN_KEYBOARD_TYPES                   8
#if defined(NEC_98)
#define KEYBOARD_TYPE_DEFAULT                      7
#define KEYBOARD_INDICATORS_DEFAULT                0x70
#else // defined(NEC_98)
#define KEYBOARD_TYPE_DEFAULT                      4
#define KEYBOARD_INDICATORS_DEFAULT                0
#endif // defined(NEC_98)

typedef struct _KEYBOARD_TYPE_INFORMATION {
    USHORT NumberOfFunctionKeys;
    USHORT NumberOfIndicators;
    USHORT NumberOfKeysTotal;
} KEYBOARD_TYPE_INFORMATION, *PKEYBOARD_TYPE_INFORMATION;

static const
KEYBOARD_TYPE_INFORMATION KeyboardTypeInformation[NUM_KNOWN_KEYBOARD_TYPES] = {
    {10, 3, 84},     // PC/XT 83- 84-key keyboard (and compatibles)
    {12, 3, 102},    // Olivetti M24 102-key keyboard (and compatibles)
    {10, 3, 84},     // All AT type keyboards (84-86 keys)
    {12, 3, 101},    // Enhanced 101- or 102-key keyboards (and compatibles)
    {12, 3, 101},    // 5:
    {12, 3, 101},    // 6:
#if defined(NEC_98)
    {15, 2, 106},    // 7:  NEC 106 keyboard
#else // defined(NEC_98)
    { 0, 0, 0},      // 7: Japanese Keyboard
#endif // defined(NEC_98)
    { 0, 0, 0}       // 8: Korean keyboard
};

typedef struct _KEYBOARD_OEM_INFORMATION {
    KEYBOARD_ID               KeyboardId;
    KEYBOARD_TYPE_INFORMATION KeyboardTypeInformation;
} KEYBOARD_OEM_INFORMATION, *PKEYBOARD_OEM_INFORMATION;

//
// Keyboard hardware OEM id. by MSKK
//
#define MSFT    0x0 // Microsoft
#define AX      0x1 // AX consortium
#define TOSHIBA 0x2 // TOSHIBA
#define EPSON   0x4 // EPSON
#define FJ      0x5 // Fujitsu
#define IBMJ    0x7 // IBM Japan
#define DECJ    0x8 // DEC Japan
#define PANA    0xA // Panasonic
#define NEC     0xD // NEC

#define FE_SUBTYPE(SubType,OemId) ((SubType)|((OemId<<4)))

#define IBM02_KEYBOARD(Id)     (((Id).Type == 0x7) && ((Id).Subtype == FE_SUBTYPE(3,MSFT)))
#define AX_KEYBOARD(Id)        (((Id).Type == 0x7) && ((Id).Subtype == FE_SUBTYPE(1,MSFT)))
#define OYAYUBI_KEYBOARD(Id)   (((Id).Type == 0x7) && ((Id).Subtype == FE_SUBTYPE(2,FJ)))
#define DEC_KANJI_KEYBOARD(Id) (((Id).Type == 0x7) && (((Id).Subtype == FE_SUBTYPE(1,DECJ)) || \
                                                       ((Id).Subtype == FE_SUBTYPE(2,DECJ))))

static const
KEYBOARD_OEM_INFORMATION KeyboardFarEastOemInformation[] = {
#if defined(NEC_98)
    {{7, FE_SUBTYPE(1,0)}, {15,2,106}}, // PC-9800 Standard keyboard
    {{7, FE_SUBTYPE(2,0)}, {10,2,106}}, // PC-9801 VX/UX,PC-98XL/XL2(Normal mode) keyboard
    {{7, FE_SUBTYPE(3,0)}, {15,2,106}}, // PC-98XL/XL2(Hireso mode) keyboard
    {{7, FE_SUBTYPE(4,0)}, {15,2,106}}, // PC-9800 Laptop keyboard
    {{7, FE_SUBTYPE(5,0)}, {12,2,106}}, // PC-9800 N106(PAO) keyboard
    {{0, FE_SUBTYPE(0,0)}, { 0,0,  0}}  // Array terminator
#else // defined(NEC_98)
    {{7, FE_SUBTYPE(1,MSFT)}, {12,3,101}}, // PC/AT 101 Enhanced Japanese Keyboard
    {{7, FE_SUBTYPE(1,MSFT)}, {12,4,105}}, // AX standard Japanese keyboard
    {{7, FE_SUBTYPE(2,MSFT)}, {12,3,106}}, // PC/AT 106 Japanese Keyboard
    {{7, FE_SUBTYPE(3,MSFT)}, {12,3,106}}, // IBM 5576-002 keyboard
    {{7, FE_SUBTYPE(1,MSFT)}, {12,4,105}}, // AX consortium compatible keyboard
    {{7, FE_SUBTYPE(2,FJ  )}, {12,3,108}}, // Fujitsu OYAYUBI shift keyboard
    {{7, FE_SUBTYPE(1,DECJ)}, {17,3,111}}, // DEC LK411 (Ansi layout) keyboard
    {{7, FE_SUBTYPE(2,DECJ)}, {17,3,112}}, // DEC LK411 (JIS layout) keyboard
    {{8, FE_SUBTYPE(3,MSFT)}, {12,3,101}}, // PC/AT 101 Enhanced Korean Keyboard (A)
    {{8, FE_SUBTYPE(4,MSFT)}, {12,3,101}}, // PC/AT 101 Enhanced Korean Keyboard (B)
    {{8, FE_SUBTYPE(5,MSFT)}, {12,3,101}}, // PC/AT 101 Enhanced Korean Keyboard (C)
    {{8, FE_SUBTYPE(6,MSFT)}, {12,3,103}}, // PC/AT 103 Enhanced Korean Keyboard
    {{0, FE_SUBTYPE(0,MSFT)}, { 0,0,  0}}  // Array terminator
#endif // defined(NEC_98)
};


//
// Minimum, maximum, and default values for keyboard typematic rate and delay.
//

#define KEYBOARD_TYPEMATIC_RATE_MINIMUM     2
#define KEYBOARD_TYPEMATIC_RATE_MAXIMUM    30
#define KEYBOARD_TYPEMATIC_RATE_DEFAULT    30
#define KEYBOARD_TYPEMATIC_DELAY_MINIMUM  250
#define KEYBOARD_TYPEMATIC_DELAY_MAXIMUM 1000
#define KEYBOARD_TYPEMATIC_DELAY_DEFAULT  250


//
// Define the 8042 mouse status bits.
//
#define LEFT_BUTTON        0x01
#define RIGHT_BUTTON       0x02
#define MIDDLE_BUTTON      0x04
#define BUTTON_4           0x10
#define BUTTON_5           0x20

#define X_DATA_SIGN        0x10
#define Y_DATA_SIGN        0x20
#define X_OVERFLOW         0x40
#define Y_OVERFLOW         0x80

#define MOUSE_SIGN_OVERFLOW_MASK (X_DATA_SIGN | Y_DATA_SIGN | X_OVERFLOW | Y_OVERFLOW)

//
// Define the maximum positive and negative values for mouse motion.
//

#define MOUSE_MAXIMUM_POSITIVE_DELTA 0x000000FF
#define MOUSE_MAXIMUM_NEGATIVE_DELTA 0xFFFFFF00

//
// Default number of buttons and sample rate for the i8042 mouse.
//

#define MOUSE_NUMBER_OF_BUTTONS     2
#define MOUSE_SAMPLE_RATE           60

//
// Define the mouse resolution specifier.  Note that (2**MOUSE_RESOLUTION)
// specifies counts-per-millimeter.  Counts-per-centimeter is
// (counts-per-millimeter * 10).
//

#define MOUSE_RESOLUTION            3

//
// Define the maximum number of resets we allow without success before we
// give up and consider the mouse dead
//
#define MOUSE_RESET_TIMEOUT         (1500 * 1000 * 10)

#define MOUSE_RESETS_MAX             3
#define MOUSE_RESENDS_MAX            4
#define MOUSE_RESET_RESENDS_MAX      10

//
//
#define KEYBOARD_HARDWARE_PRESENT               0x001
#define MOUSE_HARDWARE_PRESENT                  0x002
#define BALLPOINT_HARDWARE_PRESENT              0x004
#define WHEELMOUSE_HARDWARE_PRESENT             0x008
#define DUP_KEYBOARD_HARDWARE_PRESENT           0x010
#define DUP_MOUSE_HARDWARE_PRESENT              0x020
#define KEYBOARD_HARDWARE_INITIALIZED           0x100
#define MOUSE_HARDWARE_INITIALIZED              0x200
#define FIVE_BUTTON_HARDWARE_PRESENT           0x1000

#define KEYBOARD_PRESENT()      TEST_HARDWARE_PRESENT(KEYBOARD_HARDWARE_PRESENT)
#define MOUSE_PRESENT()         TEST_HARDWARE_PRESENT(MOUSE_HARDWARE_PRESENT) 
#define WHEEL_PRESENT()         TEST_HARDWARE_PRESENT(WHEELMOUSE_HARDWARE_PRESENT)
#define FIVE_PRESENT()         TEST_HARDWARE_PRESENT(FIVE_BUTTON_HARDWARE_PRESENT)
#define KEYBOARD_INITIALIZED() \
                            TEST_HARDWARE_PRESENT(KEYBOARD_HARDWARE_INITIALIZED)
#define MOUSE_INITIALIZED()    \
                            TEST_HARDWARE_PRESENT(MOUSE_HARDWARE_INITIALIZED) 
#define CLEAR_MOUSE_PRESENT() CLEAR_HW_FLAGS(MOUSE_HARDWARE_INITIALIZED | MOUSE_HARDWARE_PRESENT | WHEELMOUSE_HARDWARE_PRESENT)
#define CLEAR_KEYBOARD_PRESENT() CLEAR_HW_FLAGS(KEYBOARD_HARDWARE_INITIALIZED | KEYBOARD_HARDWARE_PRESENT)

#define KBD_POWERED_UP_STARTED      0x0001
#define MOU_POWERED_UP_STARTED      0x0010
#define MOU_POWERED_UP_SUCCESS      0x0100
#define MOU_POWERED_UP_FAILURE      0x0200
#define KBD_POWERED_UP_SUCCESS      0x1000
#define KBD_POWERED_UP_FAILURE      0x2000

#define KEYBOARD_POWERED_UP_STARTED()       SET_PWR_FLAGS(KBD_POWERED_UP_STARTED)
#define MOUSE_POWERED_UP_STARTED()          SET_PWR_FLAGS(MOU_POWERED_UP_STARTED)

#define KEYBOARD_POWERED_UP_SUCCESSFULLY()  SET_PWR_FLAGS(KBD_POWERED_UP_SUCCESS)
#define MOUSE_POWERED_UP_SUCCESSFULLY()     SET_PWR_FLAGS(MOU_POWERED_UP_SUCCESS)

#define KEYBOARD_POWERED_UP_FAILED()  SET_PWR_FLAGS(KBD_POWERED_UP_FAILURE)
#define MOUSE_POWERED_UP_FAILED()     SET_PWR_FLAGS(MOU_POWERED_UP_FAILURE)

#define KEYBOARD_POWERED_UP_SUCCESS() CMP_PWR_FLAGS(KBD_POWERED_UP_SUCCESS)
#define MOUSE_POWERED_UP_SUCCESS()    CMP_PWR_FLAGS(MOU_POWERED_UP_SUCCESS)
#define A_POWERED_UP_SUCCEEDED() \
            TEST_PWR_FLAGS(KBD_POWERED_UP_SUCCESS | MOU_POWERED_UP_SUCCESS)
                    



//
// Define macros for performing I/O on the 8042 command/status and data
// registers.
//
#define I8X_PUT_COMMAND_BYTE(Address, Byte)                                  \
    WRITE_PORT_UCHAR(Address, (UCHAR) Byte)
    
#define I8X_PUT_DATA_BYTE(Address, Byte)                                     \
    WRITE_PORT_UCHAR(Address, (UCHAR) Byte)
    
#define I8X_GET_STATUS_BYTE(Address)                                         \
    READ_PORT_UCHAR(Address)
    
#define I8X_GET_DATA_BYTE(Address)                                           \
    READ_PORT_UCHAR(Address)
    
#define I8X_WRITE_CMD_TO_MOUSE( )                                            \
    I8xPutByteAsynchronous(                                                  \
        (CCHAR) CommandPort,                                                 \
        (UCHAR) I8042_WRITE_TO_AUXILIARY_DEVICE                              \
        ) 

#define I8X_MOUSE_COMMAND( Byte )                                            \
    I8xPutByteAsynchronous(                                                  \
        (CCHAR) DataPort,                                                    \
        (UCHAR) Byte                                                         \
        )
        
//
// Define commands to the 8042 controller.
//
#define I8042_READ_CONTROLLER_COMMAND_BYTE      0x20
#define I8042_WRITE_CONTROLLER_COMMAND_BYTE     0x60
#define I8042_DISABLE_MOUSE_DEVICE              0xA7
#define I8042_ENABLE_MOUSE_DEVICE               0xA8
#define I8042_AUXILIARY_DEVICE_TEST             0xA9
#define I8042_KEYBOARD_DEVICE_TEST              0xAB
#define I8042_DISABLE_KEYBOARD_DEVICE           0xAD
#define I8042_ENABLE_KEYBOARD_DEVICE            0xAE
#define I8042_WRITE_TO_AUXILIARY_DEVICE         0xD4

//
// Define the 8042 Controller Command Byte.
//

#define CCB_ENABLE_KEYBOARD_INTERRUPT 0x01
#define CCB_ENABLE_MOUSE_INTERRUPT    0x02
#define CCB_DISABLE_KEYBOARD_DEVICE   0x10
#define CCB_DISABLE_MOUSE_DEVICE      0x20
#define CCB_KEYBOARD_TRANSLATE_MODE   0x40


//
// Define the 8042 Controller Status Register bits.
//

#define OUTPUT_BUFFER_FULL       0x01
#define INPUT_BUFFER_FULL        0x02
#define MOUSE_OUTPUT_BUFFER_FULL 0x20

//
// Define the 8042 responses.
//
#if defined(NEC_98)
#define ACKNOWLEDGE               0xFA
#define RESEND                    0xFC
#define FAILURE                   0xFD // what is this really?
//
// Define commands to the keyboard (through the 8042 data port).
//
#define SET_KEYBOARD_INDICATORS           0x9D
#define GET_KEYBOARD_INDICATORS           0x60
#define SELECT_SCAN_CODE_SET              0xF0
#define READ_KEYBOARD_ID                  0x9F
#define READ_KEYBOARD_2ND_ID              0x96
#define SET_KEYBOARD_TYPEMATIC            0x9C
#define SET_ALL_TYPEMATIC_MAKE_BREAK      0xFA
#define KEYBOARD_RESET                    0xFF

#define PC98_STOP_AUTO_REPEAT             0x70
#define SET_PAO_KEYBOARD_MODE             0x94
#define SET_PAO_KEYBOARD_MODE_VMODE       0x72
#define SET_WIN95_KEYBOARD_MODE           0x95
#define SET_WIN95_KEYBOARD_MODE_NOMAL     0x01 // Win95 Normal 98
#define SET_WIN95_KEYBOARD_MODE_SHIFT     0x02 // Win95 Shift separate
#define SET_WIN95_KEYBOARD_MODE_WIN95     0x03 // Win95 Win95 mode

//
// keyboard 2nd ID request.
//
#define PC98_KEYBOARD_ID_FIRST_BYTE       0xA0
#define PC98_KEYBOARD_ID_2ND_BYTE_STD     0x80
#define PC98_KEYBOARD_ID_2ND_BYTE_PTOS    0x81
#define PC98_KEYBOARD_ID_2ND_BYTE_N106    0x82
#define PC98_KEYBOARD_ID_2ND_BYTE_Win95   0x83
#else // defined(NEC_98)
#define ACKNOWLEDGE         0xFA
#define RESEND              0xFE
#define FAILURE             0xFC

//
// Define commands to the keyboard (through the 8042 data port).
//

#define SET_KEYBOARD_INDICATORS           0xED
#define SELECT_SCAN_CODE_SET              0xF0
#define READ_KEYBOARD_ID                  0xF2
#define SET_KEYBOARD_TYPEMATIC            0xF3
#define SET_ALL_TYPEMATIC_MAKE_BREAK      0xFA
#define KEYBOARD_RESET                    0xFF

#endif // defined(NEC_98)
//
// Define the keyboard responses.
//

#define KEYBOARD_COMPLETE_SUCCESS 0xAA
#define KEYBOARD_COMPLETE_FAILURE 0xFC
#define KEYBOARD_BREAK_CODE       0xF0
#define KEYBOARD_DEBUG_HOTKEY_ENH 0x37 // SysReq scan code for Enhanced Keyboard
#define KEYBOARD_DEBUG_HOTKEY_AT  0x54 // SysReq scan code for 84-key Keyboard

//
// Define keyboard power scan codes
//
#define KEYBOARD_POWER_CODE        0x5E
#define KEYBOARD_SLEEP_CODE        0x5F
#define KEYBOARD_WAKE_CODE         0x63

/*
Power event 
        Set1:   Make = E0, 5E   Break = E0, DE
        Set2:   Make = E0, 37   Break = E0, F0, 37
Sleep event 
        Set1:   Make = E0, 5F   Break = E0, DF
        Set2:   Make = E0, 3F   Break = E0, F0, 3F
Wake event 
        Set1:   Make = E0, 63   Break = E0, E3
        Set2:   Make = E0, 5E   Break = E0, F0, 5E
*/

//
// Define commands to the mouse (through the 8042 data port).
//

#define SET_MOUSE_RESOLUTION              0xE8
#define SET_MOUSE_SAMPLING_RATE           0xF3
#define MOUSE_RESET                       0xFF
#define ENABLE_MOUSE_TRANSMISSION         0xF4
#define SET_MOUSE_SCALING_1TO1            0xE6
#define READ_MOUSE_STATUS                 0xE9
#define GET_DEVICE_ID                     0xF2

//
// Define the mouse responses.
//

#define MOUSE_COMPLETE      0xAA
#define MOUSE_ID_BYTE       0x00
#define WHEELMOUSE_ID_BYTE  0x03
#define FIVEBUTTON_ID_BYTE  0x04

//
// Define the i8042 controller input/output ports.
//

typedef enum _I8042_IO_PORT_TYPE {
    DataPort = 0,
    CommandPort,
    MaximumPortCount

} I8042_IO_PORT_TYPE;

//
// Define the device types attached to the i8042 controller.
//

typedef enum _I8042_DEVICE_TYPE {
    ControllerDeviceType,
    KeyboardDeviceType,
    MouseDeviceType,
    UndefinedDeviceType
} I8042_DEVICE_TYPE;

#if defined(NEC_98)
//
// procedures to translate scancode(PC9800 -> PC/AT 106)
//
typedef NTSTATUS (*LPSCANCODEPROC)(UCHAR*, USHORT*);
#endif // defined(NEC_98)

//
// Intel i8042 configuration information.
//

#ifdef FE_SB
#define KBD_IDENTIFIER  0x10
#endif

typedef struct _I8042_CONFIGURATION_INFORMATION {

    //
    // Bus interface type.
    //
    INTERFACE_TYPE InterfaceType;

    //
    // Bus Number.
    //
    ULONG BusNumber;

    //
    // The port/register resources used by this device.
    //
    CM_PARTIAL_RESOURCE_DESCRIPTOR PortList[MaximumPortCount];
    ULONG PortListCount;

    //
    // The highest IRQL between the two potential interrupts
    //
    KIRQL InterruptSynchIrql;

    //
    // Number of retries allowed.
    //
    USHORT ResendIterations;

    //
    // Number of polling iterations allowed.
    //
    USHORT PollingIterations;

    //
    // Maximum number of polling iterations allowed.
    //
    USHORT PollingIterationsMaximum;

    //
    // Maximum number of times to check the Status register in
    // the ISR before deciding the interrupt is spurious.
    //
    USHORT PollStatusIterations;

    //
    // Microseconds to stall in KeStallExecutionProcessor calls.
    //
    USHORT StallMicroseconds;

    //
    // Tracking resolution on the mouse
    //
    // USHORT MouseResolution;

    //
    // Flag that indicates whether floating point context should be saved.
    //
    BOOLEAN FloatingSave;

    //
    // Flag indicating if the interrupts should be shared
    //
    BOOLEAN SharedInterrupts;

#ifdef FE_SB
    //
    // Detected Device Identifier
    //
    WCHAR OverrideKeyboardIdentifier[KBD_IDENTIFIER];
#endif

} I8042_CONFIGURATION_INFORMATION, *PI8042_CONFIGURATION_INFORMATION;

//
// Define the common portion of the keyboard/mouse device extension.
//
typedef struct COMMON_DATA {
    //
    // Pointer back to the this extension's device object.
    //
    PDEVICE_OBJECT      Self;
 
    PKINTERRUPT InterruptObject;

    //
    // The spin lock guarding the object's ISR
    //
    KSPIN_LOCK          InterruptSpinLock;         
 
    //
    // The top of the stack before this filter was added.  AKA the location
    // to which all IRPS should be directed.
    //
    PDEVICE_OBJECT      TopOfStack;
 
    //
    // "THE PDO"  (ejected by root)
    //
    PDEVICE_OBJECT      PDO;
 
    //
    // The IRP sent to the device to power it to D0
    //
    PIRP OutstandingPowerIrp;

    //
    // Current power state that the device is in
    //
    DEVICE_POWER_STATE PowerState;

    POWER_ACTION ShutdownType; 

    // 
    // Number of input data items currently in the InputData queue
    //
    ULONG InputCount;
      
    //
    // Reference count for number of keyboard enables.
    //
    LONG EnableCount;

    //
    // Timer used to retry the ISR DPC routine when the class
    // driver is unable to consume all the port driver's data.
    //
    KTIMER DataConsumptionTimer;
 
    //
    // DPC queue for completion of requests that fail by exceeding
    // the maximum number of retries.
    //
    KDPC RetriesExceededDpc;

    //
    // DPC queue for logging overrun and internal driver errors.
    //
    KDPC ErrorLogDpc;

    //
    // DPC queue for command timeouts.
    //
    KDPC TimeOutDpc;

    //
    // DPC queue for resetting the device 
    //
    KDPC ResetDpc;

    //
    // Request sequence number (used for error logging).
    //
    ULONG SequenceNumber;
  
    //
    // Class connection data.
    //
    CONNECT_DATA ConnectData;

    //
    // WMI Information
    //
    WMILIB_CONTEXT WmiLibInfo;

    //
    // Current output buffer being written to the device
    //
    OUTPUT_PACKET CurrentOutput;

    //
    // Translated resource descriptor for the interrupt
    //
    CM_PARTIAL_RESOURCE_DESCRIPTOR InterruptDescriptor;

    PNP_DEVICE_STATE PnpDeviceState;

    //
    // Current resend count.
    //
    SHORT ResendCount;

    //
    // Indicates whether it is okay to log overflow errors.
    //
    BOOLEAN OkayToLogOverflow;

    BOOLEAN Initialized;

    BOOLEAN IsIsrActivated;

    BOOLEAN IsKeyboard;

    //
    // Has it been started?
    // Has the device been manually removed?
    //
    BOOLEAN             Started;
    BOOLEAN             _unused;

} *PCOMMON_DATA;

#define GET_COMMON_DATA(ext) ((PCOMMON_DATA) ext)
#define MANUALLY_REMOVED(ext) ((ext)->PnpDeviceState & PNP_DEVICE_REMOVED)

//
// Define the keyboard portion of the port device extension.
//
typedef struct _PORT_KEYBOARD_EXTENSION {

    // 
    // Data in common with the mouse extension;
    //
    struct COMMON_DATA;
     
    //
    // bitfield which represents the power capabilities of the kb
    //
    UCHAR PowerCaps;

    //
    // A newly found power event which we need to inform the PO system of
    //
    UCHAR PowerEvent;
    
    UCHAR _Unused[2];

    //
    // Irp to be completed when one the power buttons is pressed
    //
    PIRP SysButtonEventIrp;

    //
    // DPC to handle power button events (updating our caps and completing
    // previous IOCTL requests)
    //
    KDPC SysButtonEventDpc; 

    //
    // Spin lock to guard the cancel routine and the IOCTL handler
    //
    KSPIN_LOCK SysButtonSpinLock;

    //
    // Symbolic name for the interface
    //
    UNICODE_STRING SysButtonInterfaceName; 

    //
    // Keyboard attributes.
    //
    KEYBOARD_ATTRIBUTES KeyboardAttributes;

    //
    // Initial values of keyboard typematic rate and delay.
    //
    KEYBOARD_TYPEMATIC_PARAMETERS KeyRepeatCurrent;

    //
    // Current indicator (LED) setting.
    //
    KEYBOARD_INDICATOR_PARAMETERS KeyboardIndicators;

    //
    // Keyboard ISR DPC queue.
    //
    KDPC KeyboardIsrDpc;

    //
    // Keyboard ISR DPC recall queue.
    //
    KDPC KeyboardIsrDpcRetry;

    //
    // Used by the ISR and the ISR DPC (in I8xDpcVariableOperation calls)
    // to control processing by the ISR DPC.
    //
    LONG DpcInterlockKeyboard;
 
    //
    // Start of the port keyboard input data queue (really a circular buffer).
    //
    PKEYBOARD_INPUT_DATA InputData;
 
    //
    // Insertion pointer for keyboard InputData.
    //
    PKEYBOARD_INPUT_DATA DataIn;
 
    //
    // Removal pointer for keyboard InputData.
    //
    PKEYBOARD_INPUT_DATA DataOut;
 
    //
    // Points one input packet past the end of the InputData buffer.
    //
    PKEYBOARD_INPUT_DATA DataEnd;
 
    //
    // Current keyboard input packet.
    //
    KEYBOARD_INPUT_DATA CurrentInput;
 
    //
    // Current keyboard scan input state.
    //
    KEYBOARD_SCAN_STATE CurrentScanState;
  
    //
    // Routine to call after the mouse is reset
    //
    PI8042_KEYBOARD_INITIALIZATION_ROUTINE InitializationHookCallback;
    
    //
    // Routine to call when a byte is received via the interrupt
    //
    PI8042_KEYBOARD_ISR IsrHookCallback;
     
    //
    // Context variable for InitializationRoutine
    //
    PVOID HookContext;

//#if defined(FE_SB) && defined(_X86_)
    //
    // Crash by key combination.
    //
    LONG Dump1Keys;           // CrashDump call first press keys flag
                              //  7 6 5 4 3 2 1 0 bit
                              //    | | |   | | +--- Right Shift Key
                              //    | | |   | +----- Right Ctrl Key
                              //    | | |   +------- Right Alt Key
                              //    | | +----------- Left Shift Key
                              //    | +------------- Left Ctrl Key
                              //    +--------------- Left Alt Key
    LONG Dump2Key;            // CrashDump call second twice press key no
    LONG DumpFlags;           // Key press flags
//#endif // defined(FE_SB) && defined(_X86_)

#if defined(NEC_98)
    //
    // Keyboard type identifier.
    //
    ULONG KeyboardTypeNEC;

    //
    // A pointer to scancode translation procedure.
    //
    LPSCANCODEPROC ScancodeProc;

    //
    // VFKey Emulation Flag
    //
    // if 0(emulation off),  vf3 -> vf3, vf4 -> vf4, vf5 -> vf4
    // otherwise(emulation on),  vf3 -> ScrollLock, vf4 -> Pause, vf5 -> NumLock
    //
    ULONG VfKeyEmulation;

    //
    // Ctrl Key Status
    //
    USHORT CtrlKeyStatus;  // Bit 1 = Right Ctrl, Bit 5 = Left Ctrl

#endif // defined(NEC_98)

} PORT_KEYBOARD_EXTENSION, *PPORT_KEYBOARD_EXTENSION;

//
// Define the structure used to enable the mouse
//
typedef struct _ENABLE_MOUSE { 
    KDPC Dpc;
    KTIMER Timer;

    USHORT    Count;
    BOOLEAN   FirstTime;
    BOOLEAN   Enabled;
} ENABLE_MOUSE;

typedef enum _INTERNAL_RESET_STATE {
    InternalContinueTimer = 0x0,
    InternalMouseReset,
    InternalPauseOneSec
} INTERNAL_RESET_STATE;

typedef enum _ISR_RESET_STATE {
    IsrResetNormal = 0x0,
    IsrResetStopResetting,

    IsrResetQueueReset,
    IsrResetPause 
} ISR_RESET_STATE;

typedef enum _ISR_DPC_CAUSE {
    IsrDpcCauseKeyboardWriteComplete = 1,
    IsrDpcCauseMouseWriteComplete,
    IsrDpcCauseMouseResetComplete
} ISR_DPC_CAUSE;

typedef struct _RESET_MOUSE {
    KDPC Dpc;
    KTIMER Timer;

    ISR_RESET_STATE IsrResetState;

} RESET_MOUSE;

#define I8X_MOUSE_INIT_COUNTERS(mouExt)                                     \
    {                                                                       \
        (mouExt)->ResetCount = (mouExt)->FailedCompleteResetCount = -1;     \
        (mouExt)->ResendCount = 0;                                          \
    }

//
// Define the mouse portion of the port device extension.
//
typedef struct _PORT_MOUSE_EXTENSION {

    struct COMMON_DATA;

    //
    // Mouse attributes.
    //
    MOUSE_ATTRIBUTES MouseAttributes;

    //
    // Reset IRP used in StartIO
    //
    PIRP ResetIrp;

    //
    // Mouse ISR DPC queue.
    //
    KDPC MouseIsrDpc;
 
    //
    // Mouse ISR DPC recall queue.
    //
    KDPC MouseIsrDpcRetry;

    //
    // Mouse ISR reset queue.
    //
    KDPC MouseIsrResetDpc;

    //
    // These two structs represent different methods of initialization.  
    //
    union {
        RESET_MOUSE  ResetMouse; 
        ENABLE_MOUSE EnableMouse;
    };

    //
    // Used by the ISR and the ISR DPC (in I8xDpcVariableOperation calls)
    // to control processing by the ISR DPC.
    //
    LONG DpcInterlockMouse;
 
    //
    // Start of the port mouse input data queue (really a circular buffer).
    //
    PMOUSE_INPUT_DATA InputData;
 
    //
    // Insertion pointer for mouse InputData.
    //
    PMOUSE_INPUT_DATA DataIn;
 
    //
    // Removal pointer for mouse InputData.
    //
    PMOUSE_INPUT_DATA DataOut;
 
    //
    // Points one input packet past the end of the InputData buffer.
    //
    PMOUSE_INPUT_DATA DataEnd;
 
    //
    // Current mouse input packet.                   (24 bytes)
    //
    MOUSE_INPUT_DATA CurrentInput;
 
    //
    // Current mouse input state.
    //
    MOUSE_STATE InputState;
    MOUSE_RESET_SUBSTATE InputResetSubState;
 
    MOUSE_RESET_SUBSTATE WorkerResetSubState;

    //
    // Count the number of times we have reset and failed
    //
    UCHAR ResetCount;

    //
    // Count the number of times we have reset and not gone through the entire
    // reset process
    //
    UCHAR FailedCompleteResetCount;

    //
    // Current mouse sign and overflow data.
    //
    UCHAR CurrentSignAndOverflow;
 
    //
    // Previous mouse sign and overflow data.
    //
    UCHAR PreviousSignAndOverflow;

    //
    // The tick count (since system boot) at which the mouse last interrupted.
    // Retrieved via KeQueryTickCount.  Used to determine whether a byte of
    // the mouse data packet has been lost.  Allows the driver to synch
    // up with the true mouse input state.
    //
    LARGE_INTEGER PreviousTick;
 
    //
    // Number of interval timer ticks to wait before deciding that the
    // next mouse interrupt is for the start of a new packet.  Used to
    // synch up again if a byte of the mouse packet gets lost.
    //
    ULONG SynchTickCount;

    //
    // The amount of time that is valid between sending a set sampling sequence
    //  (of 20, 40, and 60) and receiving the first pnp id packet from the mouse
    //
    // Expressed in terms of system ticks
    //
    ULONG WheelDetectionTimeout;

    //
    // Contains a multi sz list of pnp mouse IDs to check for a wheel mouse
    //
    UNICODE_STRING WheelDetectionIDs;

    //
    // Plug n Play ID received from the mouse during reset
    //
    WCHAR PnPID[MOUSE_PNPID_LENGTH];

    //
    // An upper filter callback hook to call when processing mouse bytes
    //
    PI8042_MOUSE_ISR IsrHookCallback;
     
    //
    // Context variable for IsrHookCallback
    //
    PVOID HookContext;

    PVOID NotificationEntry;

    //
    // List of sample rates to send to the mouse during a reset
    //
    PUCHAR SampleRates;

    ULONG MouseResetStallTime;

    //
    // Index into the SampleRates array
    //
    UCHAR SampleRatesIndex;

    //
    // Previous mouse button data.
    //
    UCHAR PreviousButtons;

    //
    // Statue to transition to after the last sample rate from SampleRates has
    // been sent to the mouse
    //
    USHORT PostSamplesState;

    //
    // Keep track of last byte of data received from mouse so we can detect
    // the two-byte string which indicates a potential reset
    //
    UCHAR LastByteReceived;

    //
    // Tracking resolution on the mouse
    //
    UCHAR Resolution;
 
    //
    // One of 3 states that determines whether we should try and detect the wheel
    // on the mouse or not
    //
    UCHAR EnableWheelDetection;
 
    //
    // Skip button detection if it overridden in the registry.  
    //
    UCHAR NumberOfButtonsOverride;

    //
    // If 0, then initalize the mouse via the interrupt, if non zero, initialize
    // the mouse via polling
    //
    UCHAR InitializePolled;

#if MOUSE_RECORD_ISR
    ULONG RecordHistoryFlags;
    ULONG RecordHistoryCount;
    ULONG RecordHistoryState;
#endif

} PORT_MOUSE_EXTENSION, *PPORT_MOUSE_EXTENSION;

//
// controller specific data used by both devices
//
typedef struct _CONTROLLER_DATA { 

    //
    // Indicate which hardware is actually present (keyboard and/or mouse).
    //
    ULONG HardwarePresent;
    
    //
    // IOCTL synchronization object
    //
    PCONTROLLER_OBJECT ControllerObject;

    //
    // Port configuration information.
    //
    I8042_CONFIGURATION_INFORMATION Configuration; 

    //
    // Timer used to timeout i8042 commands.
    //
    KTIMER CommandTimer;

    //
    // Spin lock to guard freeing of bytes written to device
    //
    KSPIN_LOCK BytesSpinLock;

    //
    // Spin lockt o guard powering the devices back up
    //
    KSPIN_LOCK PowerUpSpinLock;

    //
    // Default buffer to use for a write to a device if the request <=4 bytes
    // (avoid lots of tiny sized allocs)
    //
    UCHAR DefaultBuffer[4];

    //
    // Timer count used by the command time out routine.
    //
    LONG TimerCount;

    //
    // Interrupt to synchronize against
    //
    // IN PKINTERRUPT HigherInterrupt;

    //
    // The mapped addresses for this device's registers.
    //
    PUCHAR DeviceRegisters[MaximumPortCount];

    //
    // List of ports in IRP_MN_FILTER_RESOURCE_REQUIREMENTS
    //
    PHYSICAL_ADDRESS KnownPorts[MaximumPortCount];

    ULONG KnownPortsCount;

#if DBG
    ULONG CurrentIoControlCode;
#endif

} CONTROLLER_DATA, *PCONTROLLER_DATA;

#define POST_BUTTONDETECT_COMMAND                 (SET_MOUSE_RESOLUTION)
#define POST_BUTTONDETECT_COMMAND_SUBSTATE        (ExpectingSetResolutionDefaultACK)

#define POST_WHEEL_DETECT_COMMAND                 (GET_DEVICE_ID)
#define POST_WHEEL_DETECT_COMMAND_SUBSTATE        (ExpectingGetDeviceId2ACK)

#define ExpectingPnpId                            (I8042ReservedMinimum+  2)
#define PostWheelDetectState                      (I8042ReservedMinimum+  3)

#define QueueingMouseReset                        (I8042ReservedMinimum+100)
#define MouseResetFailed                          (I8042ReservedMinimum+101)

#define ExpectingLegacyPnpIdByte2_Make            (I8042ReservedMinimum+200)
#define ExpectingLegacyPnpIdByte2_Break           (I8042ReservedMinimum+201)
#define ExpectingLegacyPnpIdByte3_Make            (I8042ReservedMinimum+202)
#define ExpectingLegacyPnpIdByte3_Break           (I8042ReservedMinimum+203)
#define ExpectingLegacyPnpIdByte4_Make            (I8042ReservedMinimum+204)
#define ExpectingLegacyPnpIdByte4_Break           (I8042ReservedMinimum+205)
#define ExpectingLegacyPnpIdByte5_Make            (I8042ReservedMinimum+206)
#define ExpectingLegacyPnpIdByte5_Break           (I8042ReservedMinimum+207)
#define ExpectingLegacyPnpIdByte6_Make            (I8042ReservedMinimum+208)
#define ExpectingLegacyPnpIdByte6_Break           (I8042ReservedMinimum+209)
#define ExpectingLegacyPnpIdByte7_Make            (I8042ReservedMinimum+210)
#define ExpectingLegacyPnpIdByte7_Break           (I8042ReservedMinimum+211)

#define QueueingMousePolledReset                  (I8042ReservedMinimum+300)

#define KeepOldSubState                           (I8042ReservedMinimum+400)

#define RECORD_INIT               0x00000001
#define RECORD_RESUME_FROM_POWER  0x00000002
#define RECORD_DPC_RESET          0x00000004
#define RECORD_DPC_RESET_POLLED   0x00000008
#define RECORD_HW_PROFILE_CHANGE  0x00000010

#if MOUSE_RECORD_ISR
typedef struct _MOUSE_STATE_RECORD {
    USHORT InputResetSubState;
    USHORT InputState;
    UCHAR  LastByte;
    UCHAR  Reserved;
    UCHAR  Byte;
    UCHAR  Command;
    LARGE_INTEGER Time;
} MOUSE_STATE_RECORD, *PMOUSE_STATE_RECORD;

extern PMOUSE_STATE_RECORD IsrStateHistory;
extern PMOUSE_STATE_RECORD CurrentIsrState;
extern PMOUSE_STATE_RECORD IsrStateHistoryEnd;
extern ULONG               IsrStateCount;

#define RECORD_ISR_STATE(devExt, byte, lastbyte, time)                  \
    if ((devExt->RecordHistoryFlags & devExt->RecordHistoryState)) {    \
        if (CurrentIsrState >= IsrStateHistoryEnd) {                    \
            CurrentIsrState = IsrStateHistory;                          \
            RtlFillMemory(CurrentIsrState, sizeof(MOUSE_STATE_RECORD), 0x88);  \
            CurrentIsrState++;                                          \
        }                                                               \
        CurrentIsrState->InputState = (USHORT) devExt->InputState;      \
        CurrentIsrState->InputResetSubState = (USHORT) devExt->InputResetSubState;    \
        CurrentIsrState->Byte = byte;                                   \
        CurrentIsrState->LastByte = lastbyte;                           \
        CurrentIsrState->Time = time;                                   \
        CurrentIsrState++;                                              \
    }

#define RECORD_ISR_STATE_COMMAND(devExt, command)                     \
    if ((devExt->RecordHistoryFlags & devExt->RecordHistoryState))    \
            CurrentIsrState->Command = command;                       

#define RECORD_ISR_STATE_TRANSITION(devExt, state)                          \
    if ((devExt->RecordHistoryFlags & devExt->RecordHistoryState)) {        \
        if (CurrentIsrState >= IsrStateHistoryEnd) CurrentIsrState = IsrStateHistory; \
        RtlFillMemory(CurrentIsrState, sizeof(MOUSE_STATE_RECORD), 0xFF);   \
        CurrentIsrState->Time.LowPart  = state;                             \
        CurrentIsrState++;                                                  \
    }

#define SET_RECORD_STATE(devExt, state)                                 \
    {                                                                   \
        if (IsrStateHistory) devExt->RecordHistoryState |= (state);     \
        RECORD_ISR_STATE_TRANSITION(devExt, state);                     \
    }

#define CLEAR_RECORD_STATE(devExt) devExt->RecordHistoryState = 0x0;

#define SET_RECORD_FLAGS(devExt, flags) if (IsrStateHistory) devExt->RecordHistoryFlags |= (flags)
#define CLEAR_RECORD_FLAGS(devExt, flags) devExt->RecordHistoryFlags &= ~(flags)

#else

#define RECORD_ISR_STATE(devExt, byte, lastbyte, time) 
#define RECORD_ISR_STATE_COMMAND(devExt, command)
#define SET_RECORD_STATE(devExt, state)
#define CLEAR_RECORD_STATE(devExt)
#define SET_RECORD_FLAGS(devExt, flags) 
#define CLEAN_RECORD_FLAGS(devExt, flags) 

#endif // MOUSE_RECORD_ISR

typedef struct _I8X_KEYBOARD_WORK_ITEM {
    PIO_WORKITEM  Item;
    ULONG MakeCode;
    PIRP Irp;
} I8X_KEYBOARD_WORK_ITEM, *PI8X_KEYBOARD_WORK_ITEM;

#ifndef NEC_98
typedef struct _I8X_MOUSE_RESET_INFO {
    PPORT_MOUSE_EXTENSION MouseExtension;
    INTERNAL_RESET_STATE  InternalResetState;
} I8X_MOUSE_RESET_INFO, * PI8X_MOUSE_RESET_INFO;

//
// Define the port TransmitControllerCommandByte context structure.
//
typedef struct _I8042_TRANSMIT_CCB_CONTEXT {
    IN ULONG HardwareDisableEnableMask;
    IN BOOLEAN AndOperation;
    IN UCHAR ByteMask;
    OUT NTSTATUS Status;
} I8042_TRANSMIT_CCB_CONTEXT, *PI8042_TRANSMIT_CCB_CONTEXT;
#endif // defined(NEC_98)

//
// Define the port InitializeDataQueue context structure.
//
typedef struct _I8042_INITIALIZE_DATA_CONTEXT {
    IN PVOID DeviceExtension;
    IN CCHAR DeviceType;
} I8042_INITIALIZE_DATA_CONTEXT, *PI8042_INITIALIZE_DATA_CONTEXT;

//
// Define the port Get/SetDataQueuePointer context structures.
//
typedef struct _GET_DATA_POINTER_CONTEXT {
    IN PVOID DeviceExtension;
    IN CCHAR DeviceType;
    OUT PVOID DataIn;
    OUT PVOID DataOut;
    OUT ULONG InputCount;
} GET_DATA_POINTER_CONTEXT, *PGET_DATA_POINTER_CONTEXT;

typedef struct _SET_DATA_POINTER_CONTEXT {
    IN PVOID DeviceExtension;
    IN CCHAR DeviceType;
    IN ULONG InputCount;
    IN PVOID DataOut;
} SET_DATA_POINTER_CONTEXT, *PSET_DATA_POINTER_CONTEXT;

//
// Define the port timer context structure.
//
typedef struct _TIMER_CONTEXT {
    IN PDEVICE_OBJECT DeviceObject;
    IN PLONG TimerCounter;
    OUT LONG NewTimerCount;
} TIMER_CONTEXT, *PTIMER_CONTEXT;

//
// Define the device InitiateOutput context structure.
//
typedef struct INITIATE_OUTPUT_CONTEXT {
    IN PDEVICE_OBJECT DeviceObject;
    IN PUCHAR Bytes;
    IN ULONG ByteCount;
} INITIATE_OUTPUT_CONTEXT, *PINITIATE_OUTPUT_CONTEXT;

//
// Statically allocate the (known) scancode-to-indicator-light mapping.
// This information is returned by the
// IOCTL_KEYBOARD_QUERY_INDICATOR_TRANSLATION device control request.
//

#define KEYBOARD_NUMBER_OF_INDICATORS              3

static const INDICATOR_LIST IndicatorList[KEYBOARD_NUMBER_OF_INDICATORS] = {
        {0x3A, KEYBOARD_CAPS_LOCK_ON},
        {0x45, KEYBOARD_NUM_LOCK_ON},
        {0x46, KEYBOARD_SCROLL_LOCK_ON}};

//
// Define the context structure and operations for I8xDpcVariableOperation.
//
typedef enum _OPERATION_TYPE {
        IncrementOperation,
        DecrementOperation,
        WriteOperation,
        ReadOperation
} OPERATION_TYPE;

typedef struct _VARIABLE_OPERATION_CONTEXT {
    IN PLONG VariableAddress;
    IN OPERATION_TYPE Operation;
    IN OUT PLONG NewValue;
} VARIABLE_OPERATION_CONTEXT, *PVARIABLE_OPERATION_CONTEXT;

//
// Define the actions to be taked on processing a system button
//
typedef enum _SYS_BUTTON_ACTION {
    NoAction =0,
    SendAction,
    UpdateAction
} SYS_BUTTON_ACTION;

//
// Function prototypes.
//

// begin_i8042dep
NTSTATUS
DriverEntry(
    IN PDRIVER_OBJECT DriverObject,
    IN PUNICODE_STRING RegistryPath
    );

BOOLEAN
I8xDetermineSharedInterrupts(
    VOID
    );

VOID
I8xDrainOutputBuffer(
    IN PUCHAR DataAddress,
    IN PUCHAR CommandAddress
    );

VOID
I8xGetByteAsynchronous(
    IN CCHAR DeviceType,
    OUT PUCHAR Byte
    );

NTSTATUS
I8xGetBytePolled(
    IN CCHAR DeviceType,
    OUT PUCHAR Byte
    );

VOID
I8xGetDataQueuePointer(
    IN PGET_DATA_POINTER_CONTEXT Context
    );

VOID
I8xInitializeHardware(
    NTSTATUS *KeyboardStatus,
    NTSTATUS *MouseStatus,
    BOOLEAN  FirstInit 
    );

NTSTATUS
I8xInitializeHardwareAtBoot(
    NTSTATUS *KeyboardStatus,
    NTSTATUS *MouseStatus
    );

VOID
I8xLogError(
    IN PDEVICE_OBJECT DeviceObject,
    IN NTSTATUS ErrorCode,
    IN ULONG UniqueErrorValue,
    IN NTSTATUS FinalStatus,
    IN PULONG DumpData,
    IN ULONG DumpCount
    );

VOID
I8xPutByteAsynchronous(
    IN CCHAR PortType,
    IN UCHAR Byte
    );

NTSTATUS
I8xPutBytePolled(
    IN CCHAR PortType,
    IN BOOLEAN WaitForAcknowledge,
    IN CCHAR AckDeviceType,
    IN UCHAR Byte
    );

VOID
I8xReinitializeHardware (
    PWORK_QUEUE_ITEM Item
    );

VOID
I8xServiceParameters(
    IN PUNICODE_STRING RegistryPath
    );

#ifndef NEC_98
NTSTATUS
I8xGetControllerCommand(
    IN ULONG HardwareDisableEnableMask,
    OUT PUCHAR Byte
    );

NTSTATUS
I8xPutControllerCommand(
    IN UCHAR Byte
    );

NTSTATUS
I8xToggleInterrupts(
    BOOLEAN State
    );

NTSTATUS
I8xPutControllerCommand(
    IN UCHAR Byte
    );

VOID
I8xTransmitControllerCommand(
    IN PI8042_TRANSMIT_CCB_CONTEXT TransmitCCBContext
    );
#endif // NEC_98
// end_i8042dep

// begin_i8042cmn
NTSTATUS
I8xClose (
    IN PDEVICE_OBJECT    DeviceObject,
    IN PIRP              Irp
    );

VOID
I8042CompletionDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN ISR_DPC_CAUSE IsrDpcCause
    );

IO_ALLOCATION_ACTION
I8xControllerRoutine (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP           Irp,
    IN PVOID          MapRegisterBase,
    IN PVOID          Context
    );

NTSTATUS
I8xCreate (
    IN PDEVICE_OBJECT    DeviceObject,
    IN PIRP              Irp
    );

VOID
I8xDecrementTimer(
    IN PTIMER_CONTEXT Context
    );

VOID
I8xDpcVariableOperation(
    IN  PVOID Context
    );

VOID
I8042ErrorLogDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN PVOID Context
    );

NTSTATUS
I8xFlush(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

VOID
I8xInitializeDataQueue(
    IN PI8042_INITIALIZE_DATA_CONTEXT InitializeDataContext
    );

VOID
I8xInitiateOutputWrapper(
    IN PINITIATE_OUTPUT_CONTEXT InitiateContext 
    );

VOID
I8xInitiateIo(
    IN PDEVICE_OBJECT DeviceObject
    );

NTSTATUS
I8xDeviceControl(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
I8xInternalDeviceControl(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

VOID
I8042RetriesExceededDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN PVOID Context
    );

BOOLEAN
I8xSanityCheckResources(
    VOID
    );

NTSTATUS
I8xSendIoctl(
    PDEVICE_OBJECT      Target,
    ULONG               Ioctl,
    PVOID               InputBuffer,
    ULONG               InputBufferLength
    );

VOID
I8xSetDataQueuePointer(
    IN PSET_DATA_POINTER_CONTEXT Context
    );

VOID
I8xStartIo(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

VOID
I8042TimeOutDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN PVOID SystemContext1,
    IN PVOID SystemContext2
    );
// end_i8042cmn

// begin_kbddep
UCHAR
I8xConvertTypematicParameters(
    IN USHORT Rate,
    IN USHORT Delay
    );

NTSTATUS
I8xInitializeKeyboard(
    VOID
    );

NTSTATUS
I8xKeyboardConfiguration(
    IN PPORT_KEYBOARD_EXTENSION KeyboardExtension,
    IN PCM_RESOURCE_LIST ResourceList
    );

BOOLEAN
I8042KeyboardInterruptService(
    IN PKINTERRUPT Interrupt,
    IN PDEVICE_OBJECT DeviceObject
    );

VOID
I8xKeyboardServiceParameters(
    IN PUNICODE_STRING          RegistryPath,
    IN PPORT_KEYBOARD_EXTENSION KeyboardExtension
    );

VOID
I8xQueueCurrentKeyboardInput(
    IN PDEVICE_OBJECT DeviceObject
    );
// end_kbddep

// begin_kbdcmn
VOID
I8042KeyboardIsrDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN PVOID Context
    );

BOOLEAN
I8xWriteDataToKeyboardQueue(
    IN PPORT_KEYBOARD_EXTENSION KeyboardExtension,
    IN PKEYBOARD_INPUT_DATA InputData
    );
// end_kbdcmn

// begin_kbdpnp
NTSTATUS
I8xKeyboardConnectInterrupt(
    PPORT_KEYBOARD_EXTENSION KeyboardExtension
    );

NTSTATUS
I8xKeyboardInitializeHardware(
    PPORT_KEYBOARD_EXTENSION    KeyboardExtension,
    PPORT_MOUSE_EXTENSION       MouseExtension
    );

VOID
I8xKeyboardRemoveDevice(
    PDEVICE_OBJECT DeviceObject
    );

NTSTATUS
I8xKeyboardStartDevice(
    IN OUT PPORT_KEYBOARD_EXTENSION KeyboardExtension,
    IN PCM_RESOURCE_LIST ResourceList
    );
// end_kbdpnp

// begin_moucmn
VOID
I8042MouseIsrDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN PVOID Context
    );

BOOLEAN
I8xWriteDataToMouseQueue(
    IN PPORT_MOUSE_EXTENSION MouseExtension,
    IN PMOUSE_INPUT_DATA InputData
    );
// end_moucmn

// begin_moudep
NTSTATUS
I8xMouseConfiguration(
    IN PPORT_MOUSE_EXTENSION MouseExtension,
    IN PCM_RESOURCE_LIST ResourceList
    );

VOID
MouseCopyWheelIDs(
    PUNICODE_STRING Destination,
    PUNICODE_STRING Source
    );

NTSTATUS
I8xMouseEnableTransmission(
    IN PPORT_MOUSE_EXTENSION MouseExtension
    );

NTSTATUS
I8xFindWheelMouse(
    IN PPORT_MOUSE_EXTENSION MouseExension
    );

NTSTATUS
I8xInitializeMouse(
    VOID
    );

BOOLEAN
I8042MouseInterruptService(
    IN PKINTERRUPT Interrupt,
    IN PVOID Context
    );

NTSTATUS
I8xQueryNumberOfMouseButtons(
    OUT PUCHAR          NumberOfMouseButtons
    );

NTSTATUS
I8xResetMouse(
    PPORT_MOUSE_EXTENSION MouseExtension
    );

VOID
I8xResetMouseFailed(
    PPORT_MOUSE_EXTENSION MouseExtension
    );

VOID
I8xSendResetCommand (
    PPORT_MOUSE_EXTENSION MouseExtension
    );

VOID
I8xMouseServiceParameters(
    IN PUNICODE_STRING       RegistryPath,
    IN PPORT_MOUSE_EXTENSION MouseExtension
    );

VOID
I8xQueueCurrentMouseInput(
    IN PDEVICE_OBJECT DeviceObject
    );

BOOLEAN
I8xVerifyMousePnPID(
    PPORT_MOUSE_EXTENSION   MouseExtension,
    PWSTR                   MouseID
    );
// end_moudep

// begin_moupnp
NTSTATUS
I8xMouseConnectInterruptAndEnable(
    PPORT_MOUSE_EXTENSION MouseExtension
    );

NTSTATUS
I8xMouseInitializeHardware(
    PPORT_KEYBOARD_EXTENSION    KeyboardExtension,
    PPORT_MOUSE_EXTENSION       MouseExtension
    );

NTSTATUS
I8xProfileNotificationCallback(
    IN PHWPROFILE_CHANGE_NOTIFICATION NotificationStructure,
    PPORT_MOUSE_EXTENSION MouseExtension
    );

VOID
I8xMouseRemoveDevice(
    PDEVICE_OBJECT DeviceObject
    );

NTSTATUS
I8xMouseStartDevice(
    PPORT_MOUSE_EXTENSION MouseExtension,
    IN PCM_RESOURCE_LIST ResourceList
    );

#ifndef NEC_98

BOOLEAN
I8xMouseEnableSynchRoutine(
    IN PPORT_MOUSE_EXTENSION    MouseExtension
    );

VOID
I8xMouseEnableDpc(
    IN PKDPC                    Dpc,
    IN PPORT_MOUSE_EXTENSION    MouseExtension,
    IN PVOID                    SystemArg1, 
    IN PVOID                    SystemArg2
    );

VOID 
I8xIsrResetDpc(
    IN PKDPC                    Dpc,
    IN PPORT_MOUSE_EXTENSION    MouseExtension,
    IN ULONG                    ResetPolled,
    IN PVOID                    SystemArg2
    );

VOID
I8xMouseResetTimeoutProc(
    IN PKDPC                    Dpc,
    IN PPORT_MOUSE_EXTENSION    MouseExtension,
    IN PVOID                    SystemArg1, 
    IN PVOID                    SystemArg2
    );

BOOLEAN
I8xMouseResetSynchRoutine(
    PI8X_MOUSE_RESET_INFO ResetInfo 
    );

VOID
I8xMouseInitializeInterruptWorker(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIO_WORKITEM   Item 
    );

VOID
I8xMouseInitializePolledWorker(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIO_WORKITEM   Item 
    );
#endif // NEC_98
// end_moupnp

// begin_pnp
NTSTATUS
I8xAddDevice (
    IN PDRIVER_OBJECT   Driver,
    IN PDEVICE_OBJECT   PDO
    );

NTSTATUS
I8xFilterResourceRequirements(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
I8xFindPortCallout(
    IN PVOID                        Context,
    IN PUNICODE_STRING              PathName,
    IN INTERFACE_TYPE               BusType,
    IN ULONG                        BusNumber,
    IN PKEY_VALUE_FULL_INFORMATION *BusInformation,
    IN CONFIGURATION_TYPE           ControllerType,
    IN ULONG                        ControllerNumber,
    IN PKEY_VALUE_FULL_INFORMATION *ControllerInformation,
    IN CONFIGURATION_TYPE           PeripheralType,
    IN ULONG                        PeripheralNumber,
    IN PKEY_VALUE_FULL_INFORMATION *PeripheralInformation
    );

LONG
I8xManuallyRemoveDevice(
    PCOMMON_DATA CommonData
    );

NTSTATUS
I8xPnP (
    IN PDEVICE_OBJECT    DeviceObject,
    IN PIRP              Irp
    );

NTSTATUS
I8xPnPComplete (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN PKEVENT Event
    );

NTSTATUS
I8xPower (
    IN PDEVICE_OBJECT    DeviceObject,
    IN PIRP              Irp
    );

NTSTATUS
I8xPowerUpToD0Complete(IN PDEVICE_OBJECT DeviceObject,
                       IN PIRP Irp,
                       IN PVOID Context
                       );

NTSTATUS
I8xRegisterDeviceInterface(
    PDEVICE_OBJECT PDO,
    CONST GUID *Guid,
    PUNICODE_STRING SymbolicName
    );

BOOLEAN
I8xRemovePort(
    IN PIO_RESOURCE_DESCRIPTOR ResDesc
    );

NTSTATUS
I8xSendIrpSynchronously (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN BOOLEAN Strict
    );

VOID
I8xUnload(
    IN PDRIVER_OBJECT DriverObject
    );
// end_pnp

// begin_sysbtn
VOID
I8xCompleteSysButtonIrp(
    PIRP Irp,
    ULONG Event,
    NTSTATUS Status
    );

#if DELAY_SYSBUTTON_COMPLETION
VOID 
I8xCompleteSysButtonEventWorker(
    IN PDEVICE_OBJECT DeviceObject,
    IN PI8X_KEYBOARD_WORK_ITEM Item
    );
#endif

NTSTATUS
I8xKeyboardGetSysButtonCaps(
    PPORT_KEYBOARD_EXTENSION KeyboardExtension,
    PIRP Irp
    );

NTSTATUS 
I8xKeyboardGetSysButtonEvent(
    PPORT_KEYBOARD_EXTENSION KeyboardExtension,
    PIRP Irp
    );

VOID
I8xKeyboardSysButtonEventDpc(
    IN PKDPC Dpc,
    IN PDEVICE_OBJECT DeviceObject,
    IN SYS_BUTTON_ACTION Action, 
    IN ULONG ButtonEvent 
    );

VOID
I8xSysButtonCancelRoutine( 
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );
// end_sysbtn

// begin_hook
VOID
I8xMouseIsrWritePort(
    IN PDEVICE_OBJECT   DeviceObject,
    IN UCHAR            Value
    );

VOID
I8xKeyboardIsrWritePort(
    IN PDEVICE_OBJECT   DeviceObject,
    IN UCHAR            Value
    );

NTSTATUS 
I8xKeyboardSynchReadPort (
    IN PDEVICE_OBJECT   DeviceObject,
    IN PUCHAR           Value
    );

NTSTATUS 
I8xKeyboardSynchWritePort (
    IN PDEVICE_OBJECT   DeviceObject,                           
    IN UCHAR            Value,
    IN BOOLEAN          WaitForACK
    );
// end_hook

// begin_wmi
NTSTATUS
I8xSystemControl (
    IN PDEVICE_OBJECT    DeviceObject,
    IN PIRP              Irp
    );

NTSTATUS
I8xInitWmi(
    PCOMMON_DATA CommonData
    );

NTSTATUS
I8xSetWmiDataBlock(
    IN PDEVICE_OBJECT   DeviceObject,
    IN PIRP             Irp,
    IN ULONG            GuidIndex,
    IN ULONG            InstanceIndex,
    IN ULONG            BufferSize,
    IN PUCHAR           Buffer
    );

NTSTATUS
I8xSetWmiDataItem(
    IN PDEVICE_OBJECT   DeviceObject,
    IN PIRP             Irp,
    IN ULONG            GuidIndex,
    IN ULONG            InstanceIndex,
    IN ULONG            DataItemId,
    IN ULONG            BufferSize,
    IN PUCHAR           Buffer
    );

NTSTATUS
I8xKeyboardQueryWmiDataBlock(
    IN PDEVICE_OBJECT   DeviceObject,
    IN PIRP             Irp,
    IN ULONG            GuidIndex,
    IN ULONG            InstanceIndex,
    IN ULONG            InstanceCount,
    IN OUT PULONG       InstanceLengthArray,
    IN ULONG            BufferAvail,
    OUT PUCHAR          Buffer
    );

NTSTATUS
I8xMouseQueryWmiDataBlock(
    IN PDEVICE_OBJECT   DeviceObject,
    IN PIRP             Irp,
    IN ULONG            GuidIndex,
    IN ULONG            InstanceIndex,
    IN ULONG            InstanceCount,
    IN OUT PULONG       InstanceLengthArray,
    IN ULONG            BufferAvail,
    OUT PUCHAR          Buffer
    );

NTSTATUS
I8xQueryWmiRegInfo(
    IN PDEVICE_OBJECT   DeviceObject,
    OUT PULONG          RegFlags,
    OUT PUNICODE_STRING InstanceName,
    OUT PUNICODE_STRING *RegistryPath,
    OUT PUNICODE_STRING MofResourceName,
    OUT PDEVICE_OBJECT  *Pdo
    );


extern WMIGUIDREGINFO KbWmiGuidList[1];
extern WMIGUIDREGINFO MouWmiGuidList[1];
// end_wmi

// #if defined(FE_SB) && defined(_X86_)
VOID
I8xServiceCrashDump(
    IN PPORT_KEYBOARD_EXTENSION DeviceExtension,
    IN PUNICODE_STRING          RegistryPath
    );
// #endif // defined(FE_SB) && defined(_X86_)

#if defined(_X86_) && !defined(NEC_98)
#ifndef _FJKBD_H_
#define _FJKBD_H_

//
// oyayubi-shift keyboard internal input mode value.
//
#define THUMB_NOROMAN_ALPHA_CAPSON     0x01
#define THUMB_NOROMAN_ALPHA_CAPSOFF    0x02
#define THUMB_NOROMAN_HIRAGANA         0x03
#define THUMB_NOROMAN_KATAKANA         0x04
#define THUMB_ROMAN_ALPHA_CAPSON       0x05
#define THUMB_ROMAN_ALPHA_CAPSOFF      0x06
#define THUMB_ROMAN_HIRAGANA           0x07
#define THUMB_ROMAN_KATAKANA           0x08

//
// Following functions are oyayubi-shift keyboard use only.
//
NTSTATUS
I8042SetIMEStatusForOasys(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp,
    IN OUT PINITIATE_OUTPUT_CONTEXT InitiateContext
    );

ULONG
I8042QueryIMEStatusForOasys(
    IN PKEYBOARD_IME_STATUS KeyboardIMEStatus
    );

VOID
I8xKeyboardInitiateIoForOasys(
    IN PDEVICE_OBJECT DeviceObject
    );
#endif // _FJKBD_H_
#endif // _X86_ && !NEC_98

#if DBG
#define DEFAULT_DEBUG_FLAGS 0x88888808 // 0x8cc8888f
#else 
#define DEFAULT_DEBUG_FLAGS 0x0 
#endif


#if I8042_VERBOSE
//
//Debug messaging and breakpoint macros
//
#define DBG_ALWAYS                 0x00000000

#define DBG_STARTUP_SHUTDOWN_MASK  0x0000000F
#define DBG_SS_NOISE               0x00000001
#define DBG_SS_TRACE               0x00000002
#define DBG_SS_INFO                0x00000004
#define DBG_SS_ERROR               0x00000008

#define DBG_CALL_MASK              0x000000F0
#define DBG_CALL_NOISE             0x00000010
#define DBG_CALL_TRACE             0x00000020
#define DBG_CALL_INFO              0x00000040
#define DBG_CALL_ERROR             0x00000080

#define DBG_IOCTL_MASK             0x00000F00
#define DBG_IOCTL_NOISE            0x00000100
#define DBG_IOCTL_TRACE            0x00000200
#define DBG_IOCTL_INFO             0x00000400
#define DBG_IOCTL_ERROR            0x00000800

#define DBG_DPC_MASK              0x0000F000
#define DBG_DPC_NOISE             0x00001000
#define DBG_DPC_TRACE             0x00002000
#define DBG_DPC_INFO              0x00004000
#define DBG_DPC_ERROR             0x00008000

#define DBG_CREATE_CLOSE_MASK      0x000F0000
#define DBG_CC_NOISE               0x00010000
#define DBG_CC_TRACE               0x00020000
#define DBG_CC_INFO                0x00040000
#define DBG_CC_ERROR               0x00080000

#define DBG_POWER_MASK             0x00F00000
#define DBG_POWER_NOISE            0x00100000
#define DBG_POWER_TRACE            0x00200000
#define DBG_POWER_INFO             0x00400000
#define DBG_POWER_ERROR            0x00800000

#define DBG_PNP_MASK               0x0F000000
#define DBG_PNP_NOISE              0x01000000
#define DBG_PNP_TRACE              0x02000000
#define DBG_PNP_INFO               0x04000000
#define DBG_PNP_ERROR              0x08000000

#define DBG_BUFIO_MASK            0xF0000000
#define DBG_BUFIO_NOISE           0x10000000
#define DBG_BUFIO_TRACE           0x20000000
#define DBG_BUFIO_INFO            0x40000000
#define DBG_BUFIO_ERROR           0x80000000

#define DBG_KBISR_NOISE           0x00000001
#define DBG_KBISR_TRACE           0x00000002
#define DBG_KBISR_INFO            0x00000004
#define DBG_KBISR_ERROR           0x00000008

#define DBG_KBISR_STATE           0x00000010
#define DBG_KBISR_SCODE           0x00000020
#define DBG_KBISR_BREAK           0x00000040
#define DBG_KBISR_EMUL            0x00000080

#define DBG_KBISR_POWER            0x00000100

#define DBG_MOUISR_MASK            0x000F0000
#define DBG_MOUISR_NOISE           0x00010000
#define DBG_MOUISR_TRACE           0x00020000
#define DBG_MOUISR_INFO            0x00040000
#define DBG_MOUISR_ERROR           0x00080000

#define DBG_MOUISR_STATE           0x00100000
#define DBG_MOUISR_BYTE            0x00200000
#define DBG_MOUISR_RESETTING       0x00400000
#define DBG_MOUISR_ACK             0x00800000

#define DBG_MOUISR_PNPID           0x01000000
#define DBG_MOUISR_BREAK           0x02000000
// #define DBG_MOUISR_BREAK           0x04000000

#define TRAP() DbgBreakPoint()

#else

#define Print(_l_,_x_)
#define IsrPrint(_l_,_x_)
#define TRAP()

#endif  // I8042_VERBOSE

static UCHAR ScanCodeToUChar[] = {
    0x00,            // Nothing
    0x00,            // Esc
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    '-',
    '=',
    0x00,           // Backspace
    0x00,           // Tab
    'Q',
    'W',
    'E',
    'R',
    'T',
    'Y',
    'U',
    'I',
    'O',
    'P',
    '[',
    ']',
    '\\',
    0x00,            // Caps lock
    'A',
    'S',
    'D',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    ';',
    '\'',
    0x00,           // Return
    0x00,           // Shift left
    'Z',
    'X',
    'C',
    'V',
    'B',
    'N',
    'M',
    ',',
    '.',
    '/'
    };


static const int ScanCodeToUCharCount = sizeof(ScanCodeToUChar)/sizeof(UCHAR);
    /*
    0x00,           // Shift right
    0x00,           // Ctrl left
    0x00,           // Alt left
    ' ', 
    0x00,           // Alt right
    0x00,           // Ctrl right
    0x00,           // num lock
    */

#if defined(NEC_98)
//
// define the scancodes.
//
#define CTRL_KEY                0x1d
#define HANKAKU_ZENKAKU_KEY     0x29
#define SHIFT_KEY               0x2a
#define CAPS_KEY                0x3a
#define COPY_KEY                0x37
#define PRINTSCREEN_KEY         0x37
#define ALT_KEY                 0x38
#define F1_KEY                  0x3b
#define F10_KEY                 0x44
#define PAUSE_KEY               0x45
#define NUMLOCK_KEY             0x45  // +E0
#define STOP_KEY                0x46  // +E0
#define SCROLLLOCK_KEY          0x46
#define HOME_KEY                0x47
#define INS_KEY                 0x52
#define VF1_KEY                 0x57
#define VF2_KEY                 0x58
#define VF3_KEY                 0x5D
#define VF4_KEY                 0x5E
#define VF5_KEY                 0x5F
#define KANA_KEY                0x70


//
// Defined the keyboard LED Status.
//
#define KEYBOARD_KANA_LOCK_ON 8
#define KEYBOARD_PC98_LAPTOP_NUMKEY_ON  1

//
//  Keyboard type identifier.
//
#define PC98_106KEY             0x00000000
#define PC98_NmodeKEY           0x00000000
#define PC98_HmodeKEY           0x00000000
#define PC98_LaptopKEY          0x00000000
#define PC98_PTOSKEY            0x00000000
#define PC98_Win95KEY           0x00000001
#define PC98_Win95NOTEKEY       0x00000001
#define PC98_N106KEY            0x00000002

//
// PC9800 specific function prototypes.
//
NTSTATUS
NEC98_KeyboardCommandByte(
    IN UCHAR KeyboardCommand
    );

NTSTATUS
NEC98_QueueEmulationKey(
    IN PDEVICE_OBJECT deviceObject,
    IN PKEYBOARD_INPUT_DATA input
    );

VOID
NEC98_KeyboardReset(
    VOID
    );

NTSTATUS
NEC98_TranslateScancodeNEC98(
    IN UCHAR *ScanCode,
    IN USHORT *InputFlags
    );

NTSTATUS
NEC98_TranslateScancodeN106(
    IN UCHAR *ScanCode,
    IN USHORT *InputFlags
    );

VOID
NEC98_PauseKeyEmulation(
    IN PDEVICE_OBJECT deviceObject,
    IN PKEYBOARD_INPUT_DATA input
    );

ULONG
NEC98_KeyboardDetection(
    VOID 
    );

NTSTATUS
NEC98_GetKeyboardSpecificData(
    IN PVOID Context,
    IN PUNICODE_STRING PathName,
    IN INTERFACE_TYPE BusType,
    IN ULONG BusNumber,
    IN PKEY_VALUE_FULL_INFORMATION *BusInformation,
    IN CONFIGURATION_TYPE ControllerType,
    IN ULONG ControllerNumber,
    IN PKEY_VALUE_FULL_INFORMATION *ControllerInformation,
    IN CONFIGURATION_TYPE PeripheralType,
    IN ULONG PeripheralNumber,
    IN PKEY_VALUE_FULL_INFORMATION *PeripheralInformation
    );

VOID
NEC98_EnableExtKeys(
    VOID
    );

VOID
NEC98_SetIndicators(
    IN PINITIATE_OUTPUT_CONTEXT InitiateContext
    );

//
// PC-9800 Keyboard ScanCode --> PC/AT 106 Keyboard ScanCode Set
//
static UCHAR ScanCodeSet1_98[128] = {
                0x01,                // 00 ESC
                0x02,                // 01 1
                0x03,                // 02 2
                0x04,                // 03 3
                0x05,                // 04 4
                0x06,                // 05 5
                0x07,                // 06 6
                0x08,                // 07 7
                0x09,                // 08 8
                0x0a,                // 09 9
                0x0b,                // 0A 0
                0x0c,                // 0B -
                0x0d,                // 0C ^                 VK_OEM_7
                0x7d,                // 0D \                 VK_OEM_5
                0x0e,                // 0E BS
                0x0f,                // 0F TAB

                0x10,                // 10 Q
                0x11,                // 11 W
                0x12,                // 12 E
                0x13,                // 13 R
                0x14,                // 14 T
                0x15,                // 15 Y
                0x16,                // 16 U
                0x17,                // 17 I
                0x18,                // 18 O
                0x19,                // 19 P
                0x1a,                // 1A @                 VK_OEM_3
                0x1b,                // 1B [                 VK_OEM_4
                0x1c,                // 1C Enter
                0x1e,                // 1D A
                0x1f,                // 1E S
                0x20,                // 1F D

                0x21,                // 20 F
                0x22,                // 21 G
                0x23,                // 22 H
                0x24,                // 23 J
                0x25,                // 24 K
                0x26,                // 25 L
                0x27,                // 26 ;                 VK_OEM_PLUS
                0x28,                // 27 :                 VK_OEM_1
                0x2b,                // 28 }                 VK_OEM_6
                0x2c,                // 29 Z
                0x2d,                // 2A X
                0x2e,                // 2B C
                0x2f,                // 2C V
                0x30,                // 2D B
                0x31,                // 2E N
                0x32,                // 2F M

                0x33,                // 30 ,                 VK_OEM_COMMA
                0x34,                // 31 .                 VK_OEM_PERIOD
                0x35,                // 32 /                 VK_OEM_2
                0x73,                // 33 _                 VK_OEM_8
                0x39,                // 34 Space             VK_SPACE
                0x79,                // 35 XFER              VK_KANJI
                0x51,                // 36 ROLL UP           VK_NEXT
                0x49,                // 37 ROLL DOWN         VK_PRIOR
                0x52,                // 38 INS               VK_INSERT
                0x53,                // 39 DEL               VK_DELETE
                0x48,                // 3A Up Arrow          VK_UP
                0x4B,                // 3B Left Arrow        VK_LEFT
                0x4D,                // 3C Right Arrow       VK_RIGHT
                0x50,                // 3D Down Arrow        VK_DOWN
                0x47,                // 3E CLR               VK_CLEAR
                0x4f,                // 3F HELP              VK_END

                0x4a,                // 40 -(Num)            VK_SUBTRACT
                0x35,                // 41 /(Num)            VK_DIVIDE
                0x47,                // 42 7(Num)
                0x48,                // 43 8(Num)
                0x49,                // 44 9(Num)
                0x37,                // 45 *(Num)            VK_MULTIPRY
                0x4b,                // 46 4(Num)
                0x4c,                // 47 5(Num)
                0x4d,                // 48 6(Num)
                0x4e,                // 49 +(Num)            VK_ADD
                0x4f,                // 4A 1(Num)
                0x50,                // 4B 2(Num)
                0x51,                // 4C 3(Num)
                0x59,                // 4D =(Num)            VK_OEM_EQU
                0x52,                // 4E 0(Num)
                0x5c,                // 4F ,(Num)            VK_SEPARATER

                0x53,                // 50 .(Num)            VK_DELETE
                0x7b,                // 51 NFER
                0x57,                // 52 vf1
                0x58,                // 53 vf2
                0x5d,                // 54 vf3               VK_F13
                0x5e,                // 55 vf4               VK_F14
                0x5f,                // 56 vf5               VK_F15
                0xff,                // 57 none
                0xff,                // 58 none
                0xff,                // 59 none
                0xff,                // 5A none
                0xff,                // 5B none
                0xff,                // 5C none
                0xff,                // 5D none
                0xff,                // 5E none
                0xff,                // 5F none

                0x46,                // 60 STOP              VK_CANCEL
                0x37,                // 61 COPY              VK_SNAPSHOT
                0x3b,                // 62 f1
                0x3c,                // 63 f2
                0x3d,                // 64 f3
                0x3e,                // 65 f4
                0x3f,                // 66 f5
                0x40,                // 67 f6
                0x41,                // 68 f7
                0x42,                // 69 f8
                0x43,                // 6A f9
                0x44,                // 6B f10
                0x5e,                // 6C Power             VK_POWER
                0x5f,                // 6D Sleep             VK_SLEEP
                0xff,                // 6E none
                0x60,                // 6F Wake              VK_WAKE

                0x2a,                // 70 SHIFT             VK_SHIFT
                0x3a,                // 71 CAPS              VK_CAPITAL
                0x70,                // 72 KANA              VK_KANA
                0x38,                // 73 GRPH              VK_MENU
                0x1d,                // 74 CTRL              VK_CONTROL
                0xff,                // 75 none
                0xff,                // 76 none
                0x5b,                // 77 Left Windows      VK_LWIN
                0x5c,                // 78 Right Windows     VK_RWIN
                0x5d,                // 79 Apprication       VK_APP
                0xff,                // 7A none
                0xff,                // 7B none
                0xff,                // 7C none
                0x36,                // 7D SHIFT(Right)      VK_RSHIFT
                0xff,                // 7E none
                0xff                 // 7F none
};

//
// E0 Flags conversion
//
static UCHAR Ext0FlgNEC98[128] = {
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x00 - 0x0f
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x10 - 0x1f
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x20 - 0x2f
    0, 0, 0, 0, 0, 0, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1,  // 0x30 - 0x3f
    0, 1, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x40 - 0x4f
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  // 0x50 - 0x5f
    1, 1, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 1, 0, 1,  // 0x60 - 0x6f
    0, 0, 0, 0, 0, 0, 0, 1,  1, 1, 0, 0, 0, 0, 0, 0,  // 0x70 - 0x7f
};

//
// PC-9800 106 Keyboard ScanCode --> PC/AT 106 Keyboard ScanCode Set
//
static UCHAR ScanCodeSet1_N106[128] = {
                0x01,                // 00 ESC
                0x02,                // 01 1
                0x03,                // 02 2
                0x04,                // 03 3
                0x05,                // 04 4
                0x06,                // 05 5
                0x07,                // 06 6
                0x08,                // 07 7
                0x09,                // 08 8
                0x0a,                // 09 9
                0x0b,                // 0A 0
                0x0c,                // 0B -
                0x0d,                // 0C ^                 VK_OEM_7
                0x7d,                // 0D \                 VK_OEM_5
                0x0e,                // 0E BS
                0x0f,                // 0F TAB

                0x10,                // 10 Q
                0x11,                // 11 W
                0x12,                // 12 E
                0x13,                // 13 R
                0x14,                // 14 T
                0x15,                // 15 Y
                0x16,                // 16 U
                0x17,                // 17 I
                0x18,                // 18 O
                0x19,                // 19 P
                0x1a,                // 1A @                 VK_OEM_3
                0x1b,                // 1B [                 VK_OEM_4
                0x1c,                // 1C Enter
                0x1e,                // 1D A
                0x1f,                // 1E S
                0x20,                // 1F D

                0x21,                // 20 F
                0x22,                // 21 G
                0x23,                // 22 H
                0x24,                // 23 J
                0x25,                // 24 K
                0x26,                // 25 L
                0x27,                // 26 ;                 VK_OEM_PLUS
                0x28,                // 27 :                 VK_OEM_1
                0x2b,                // 28 }                 VK_OEM_6
                0x2c,                // 29 Z
                0x2d,                // 2A X
                0x2e,                // 2B C
                0x2f,                // 2C V
                0x30,                // 2D B
                0x31,                // 2E N
                0x32,                // 2F M

                0x33,                // 30 ,                 VK_OEM_COMMA
                0x34,                // 31 .                 VK_OEM_PERIOD
                0x35,                // 32 /                 VK_OEM_2
                0x73,                // 33 _                 VK_OEM_8
                0x39,                // 34 Space             VK_SPACE
                0x79,                // 35 Maekouho/Henkan   VK_KANJI
                0x51,                // 36 PageDown          VK_NEXT
                0x49,                // 37 PageUp            VK_PRIOR
                0x52,                // 38 Insert            VK_INSERT
                0x53,                // 39 Delete            VK_DELETE
                0x48,                // 3A Up Arrow          VK_UP
                0x4B,                // 3B Left Arrow        VK_LEFT
                0x4D,                // 3C Rihgt Arrow       VK_RIGHT
                0x50,                // 3D Down Arrow        VK_DOWN
                0x47,                // 3E Home              VK_CLEAR
                0x4f,                // 3F End               VK_END

                0x4a,                // 40 -(Num)            VK_SUBTRACT
                0x35,                // 41 /(Num)            VK_DIVIDE
                0x47,                // 42 7(Num)
                0x48,                // 43 8(Num)
                0x49,                // 44 9(Num)
                0x37,                // 45 *(Num)            VK_MULTIPRY
                0x4b,                // 46 4(Num)
                0x4c,                // 47 5(Num)
                0x4d,                // 48 6(Num)
                0x4e,                // 49 +(Num)            VK_ADD
                0x4f,                // 4A 1(Num)
                0x50,                // 4B 2(Num)
                0x51,                // 4C 3(Num)
                0xff,                // 4D none
                0x52,                // 4E 0(Num)
                0xff,                // 4F none

                0x53,                // 50 .                 VK_DELETE
                0x7b,                // 51 Muhenkan
                0x57,                // 52 F11
                0x58,                // 53 F12
                0xff,                // 54 none
                0xff,                // 55 none
                0xff,                // 56 none
                0xff,                // 57 none
                0xff,                // 58 none
                0xff,                // 59 none
                0xff,                // 5A none
                0x45,                // 5B Numlock
                0x1c,                // 5C Enter(Num)
                0x46,                // 5D ScrollLock
                0xff,                // 5E none
                0x29,                // 5F Zenkaku-Hankaku

                0x45,                // 60 Pause             VK_PAUSE
                0x37,                // 61 Print Scrn        VK_SNAPSHOT
                0x3b,                // 62 F1
                0x3c,                // 63 F2
                0x3d,                // 64 F3
                0x3e,                // 65 F4
                0x3f,                // 66 F5
                0x40,                // 67 F6
                0x41,                // 68 F7
                0x42,                // 69 F8
                0x43,                // 6A F9
                0x44,                // 6B F10
                0xff,                // 6C none
                0xff,                // 6D none
                0xff,                // 6E none
                0xff,                // 6F none

                0x2a,                // 70 Shift(Left)       VK_LSHIFT
                0x3a,                // 71 CapsLock          VK_CAPITAL
                0x70,                // 72 Katakana/Hiragana VK_KANA
                0x38,                // 73 Alt(Left)         VK_MENU
                0x1d,                // 74 Ctrl(Left)        VK_LCONTROL
                0x1d,                // 75 Ctrl(Right)       VK_RCONTROL
                0x38,                // 76 Alt(Right)        VK_RMENU
                0xff,                // 77 none
                0xff,                // 78 none
                0xff,                // 79 none
                0xff,                // 7A none
                0xff,                // 7B none
                0xff,                // 7C none
                0x36,                // 7D Shift(Right)      VK_RSHIFT
                0xff,                // 7E none
                0xff,                // 7F none
};

//
// E0 Flags conversion
//
static UCHAR Ext0FlgN106[128] = {
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x00 - 0x0f
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x10 - 0x1f
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x20 - 0x2f
    0, 0, 0, 0, 0, 0, 1, 1,  1, 1, 1, 1, 1, 1, 1, 1,  // 0x30 - 0x3f
    0, 1, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x40 - 0x4f
    0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 1, 0, 0, 0,  // 0x50 - 0x5f
    1, 1, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x60 - 0x6f
    0, 0, 0, 0, 0, 1, 1, 0,  0, 0, 0, 0, 0, 0, 0, 0,  // 0x70 - 0x7f
};
#endif // defined(NEC_98)
#endif // _I8042PRT_

