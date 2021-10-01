/*++
Copyright (c) 1997  Microsoft Corporation

Module Name:

    kbfilter.h

Abstract:

    This module contains the common private declarations for the keyboard
    packet filter

Environment:

    kernel mode only

Notes:


Revision History:


--*/

#ifndef KBFILTER_H
#define KBFILTER_H

#include "ntddk.h"
#include "kbdmou.h"
#include <ntddkbd.h>
#include <ntdd8042.h>
#include <windef.h>
#include "Buffer.h"
#include "LockCount.h"

#define MAKEVERSION(b1, b2, b3, b4)  MAKELONG(MAKEWORD((b4), (b3)), MAKEWORD((b2), (b1)))
#define DRIVER_VERSION  MAKEVERSION(1, 0, 0, 7)

//#define VIEW_INT64(Str, Numb)  KdPrint(("%s: 0x%08lu%08lu", Str, (ULONG) (((LONGLONG) (Numb)) >> 32), (ULONG) (Numb)))

#define STX                         0x02
#define STATE_READBYTE_BEGIN           0
#define STATE_READBYTE_END             1
#define STATE_READCADR_WAIT_STX        0
#define STATE_READCADR_WAIT_LENGTH     1
#define STATE_READCADR_WAIT_DATA       2

#define MODE_READ_BYTE			0
#define MODE_READ_CADR			1

#define SYSTIME2MILLISEC(Time)  ((ULONG) ((Time) / (1000*10)))
#define MILLISEC2SYSTIME(Time)  (((LONGLONG) (Time))*1000*10)
#define TIMEOUT_READ_BYTE       MILLISEC2SYSTIME(300)
#define TIMEOUT_READ_CADR       MILLISEC2SYSTIME(1200)
#define TIMEOUT_WAIT_STATUS_OK  MILLISEC2SYSTIME(300)
#define RESEND_ITERATIONS       3

#define KBD_CMD_BLOCK_ON        0xF5
#define KBD_CMD_BLOCK_OFF       0xF4

#define IOCTL_WRITE_DATA   CTL_CODE(FILE_DEVICE_KEYBOARD, 2048, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define IOCTL_SEND_DATA    CTL_CODE(FILE_DEVICE_KEYBOARD, 2049, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define IOCTL_GET_VERSION  CTL_CODE(FILE_DEVICE_KEYBOARD, 2050, METHOD_BUFFERED, FILE_ANY_ACCESS)

#define KBFILTER_POOL_TAG (ULONG) 'tlfK'
#undef ExAllocatePool
#define ExAllocatePool(type, size) \
            ExAllocatePoolWithTag (type, size, KBFILTER_POOL_TAG)

#if DBG

#define TRAP()                      DbgBreakPoint()
#define DbgRaiseIrql(_x_,_y_)       KeRaiseIrql(_x_,_y_)
#define DbgLowerIrql(_x_)           KeLowerIrql(_x_)

#define DebugPrint(_x_) DbgPrint _x_

#else   // DBG

#define TRAP()
#define DbgRaiseIrql(_x_,_y_)
#define DbgLowerIrql(_x_)

#define DebugPrint(_x_) 

#endif

#define MIN(_A_,_B_) (((_A_) < (_B_)) ? (_A_) : (_B_))

typedef struct _DEVICE_EXTENSION
{
    //
    // A backpointer to the device object for which this is the extension
    //
    PDEVICE_OBJECT  Self;

    //
    // "THE PDO"  (ejected by the root bus or ACPI)
    //
    PDEVICE_OBJECT  PDO;

    //
    // The top of the stack before this filter was added.  AKA the location
    // to which all IRPS should be directed.
    //
    PDEVICE_OBJECT  TopOfStack;

    //
    // Number of creates sent down
    //
    LONG EnableCount;

    //
    // The real connect data that this driver reports to
    //
    CONNECT_DATA UpperConnectData;

    //
    // Previous initialization and hook routines (and context)
    //                               
    PVOID UpperContext;
    PI8042_KEYBOARD_INITIALIZATION_ROUTINE UpperInitializationRoutine;
    PI8042_KEYBOARD_ISR UpperIsrHook;

    //
    // Write function from within KbFilter_IsrHook
    //
    IN PI8042_ISR_WRITE_PORT IsrWritePort;

    //
    // Queue the current packet (ie the one passed into KbFilter_IsrHook)
    //
    IN PI8042_QUEUE_PACKET QueueKeyboardPacket;

    //
    // Context for IsrWritePort, QueueKeyboardPacket
    //
    IN PVOID CallContext;

    //
    // current power state of the device
    //
    DEVICE_POWER_STATE  DeviceState;

    BOOLEAN         Started;
    BOOLEAN         SurpriseRemoved;
    BOOLEAN         Removed;

		// Main device

		PDEVICE_OBJECT	MainDevice;
		BOOLEAN					IsSolitaryObject;
		USHORT   				DataLength;						         // Длина данных
		UCHAR						ReadData[258];				         // Прочитанные данные
    TBuffer         ReadBuf;                       // Буфер чтения
    TLockCount      ReadState;                     // Блокировка клавиатуры
    KEYBOARD_TYPEMATIC_PARAMETERS TypematicParam;  // Параметры клавиатуры

} DEVICE_EXTENSION, *PDEVICE_EXTENSION;

//
// Prototypes of functions defined in kbfiltr.c
//

DRIVER_INITIALIZE DriverEntry;

__drv_dispatchType(IRP_MJ_CREATE)
__drv_dispatchType(IRP_MJ_CLOSE)
DRIVER_DISPATCH KbFilter_CreateClose;

__drv_dispatchType(IRP_MJ_DEVICE_CONTROL)
DRIVER_DISPATCH KbFilter_IoCtl;

__drv_dispatchType(IRP_MJ_PNP)
DRIVER_DISPATCH KbFilter_PnP;

__drv_dispatchType(IRP_MJ_POWER)
DRIVER_DISPATCH KbFilter_Power;

__drv_dispatchType(IRP_MJ_INTERNAL_DEVICE_CONTROL)
DRIVER_DISPATCH KbFilter_InternIoCtl;

DRIVER_ADD_DEVICE KbFilter_AddDevice;

DRIVER_UNLOAD KbFilter_Unload;


__drv_dispatchType(IRP_MJ_CREATE)
__drv_dispatchType(IRP_MJ_CREATE_NAMED_PIPE)
__drv_dispatchType(IRP_MJ_READ)
__drv_dispatchType(IRP_MJ_WRITE)
__drv_dispatchType(IRP_MJ_QUERY_INFORMATION)
__drv_dispatchType(IRP_MJ_SET_INFORMATION)
__drv_dispatchType(IRP_MJ_QUERY_EA)
__drv_dispatchType(IRP_MJ_SET_EA)
__drv_dispatchType(IRP_MJ_FLUSH_BUFFERS)
__drv_dispatchType(IRP_MJ_QUERY_VOLUME_INFORMATION)
__drv_dispatchType(IRP_MJ_SET_VOLUME_INFORMATION)
__drv_dispatchType(IRP_MJ_DIRECTORY_CONTROL)
__drv_dispatchType(IRP_MJ_FILE_SYSTEM_CONTROL)
__drv_dispatchType(IRP_MJ_SHUTDOWN)
__drv_dispatchType(IRP_MJ_LOCK_CONTROL)
__drv_dispatchType(IRP_MJ_CLEANUP)
__drv_dispatchType(IRP_MJ_CREATE_MAILSLOT)
__drv_dispatchType(IRP_MJ_QUERY_SECURITY)
__drv_dispatchType(IRP_MJ_SET_SECURITY)
__drv_dispatchType(IRP_MJ_SYSTEM_CONTROL)
__drv_dispatchType(IRP_MJ_DEVICE_CHANGE)
__drv_dispatchType(IRP_MJ_QUERY_QUOTA)
__drv_dispatchType(IRP_MJ_SET_QUOTA)
DRIVER_DISPATCH KbFilter_DispatchPassThrough;


NTSTATUS
KbFilter_AddDevice(
    IN PDRIVER_OBJECT DriverObject,
    IN PDEVICE_OBJECT BusDeviceObject
    );

NTSTATUS
KbFilter_CreateClose (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KbFilter_DispatchPassThrough(
        IN PDEVICE_OBJECT DeviceObject,
        IN PIRP Irp
        );
   
NTSTATUS
KbFilter_InternIoCtl (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KbFilter_IoCtl (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KbFilter_PnP (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KbFilter_Power (
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KbFilter_InitializationRoutine(
    IN PDEVICE_OBJECT                 DeviceObject,    // InitializationContext
    IN PVOID                           SynchFuncContext,
    IN PI8042_SYNCH_READ_PORT          ReadPort,
    IN PI8042_SYNCH_WRITE_PORT         WritePort,
    OUT PBOOLEAN                       TurnTranslationOn
    );

BOOLEAN
KbFilter_IsrHook(
    PDEVICE_OBJECT         DeviceObject,               // IsrContext
    PKEYBOARD_INPUT_DATA   CurrentInput, 
    POUTPUT_PACKET         CurrentOutput,
    UCHAR                  StatusByte,
    PUCHAR                 DataByte,
    PBOOLEAN               ContinueProcessing,
    PKEYBOARD_SCAN_STATE   ScanState
    );

VOID
KbFilter_ServiceCallback(
    IN PDEVICE_OBJECT DeviceObject,
    IN PKEYBOARD_INPUT_DATA InputDataStart,
    IN PKEYBOARD_INPUT_DATA InputDataEnd,
    IN OUT PULONG InputDataConsumed
    );

VOID
KbFilter_Unload (
    IN PDRIVER_OBJECT DriverObject
    );

NTSTATUS
I8xSendIoctl(
    PDEVICE_OBJECT Target,
    ULONG Ioctl,
    PVOID InputBuffer,
    ULONG InputBufferLength
    );

#endif  // KBFILTER_H
