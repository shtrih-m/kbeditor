
#include "stdarg.h"
#include "stdio.h"
#include "string.h"
#include "i8042prt.h"
#include "i8042log.h"

#define ResendIterations                3
#define StallMicroseconds               50
#define KeyboardDataPort                0x60
#define KeyboardCommandPort             0x64
#define PollingIterations               12000

#ifdef ALLOC_PRAGMA
#pragma alloc_text (PAGE, I8xToggleInterrupts)
#endif

VOID
I8xDrainOutputBuffer(
    IN PUCHAR DataAddress,
    IN PUCHAR CommandAddress
    )

/*++

Routine Description:

    This routine drains the i8042 controller's output buffer.  This gets
    rid of stale data that may have resulted from the user hitting a key
    or moving the mouse, prior to the execution of I8042Initialize.

Arguments:

    DataAddress - Pointer to the data address to read/write from/to.

    CommandAddress - Pointer to the command/status address to
        read/write from/to.


Return Value:

    None.

--*/

{
    UCHAR byte;
    ULONG i, limit;
    LARGE_INTEGER li;

    //DbgPrint(("I8xDrainOutputBuffer: enter\n"));

#ifndef NEC_98
    //
    // Wait till the input buffer is processed by keyboard
    // then go and read the data from keyboard.  Don't wait longer
    // than 1 second in case hardware is broken.  This fix is
    // necessary for some DEC hardware so that the keyboard doesn't
    // lock up.
    //
    limit = 1000;
    li.QuadPart = -10000;       

    for (i = 0; i < limit; i++) {
        if (!(I8X_GET_STATUS_BYTE(CommandAddress)&INPUT_BUFFER_FULL)) {
            break;
        }

        KeDelayExecutionThread(KernelMode,              // Mode
                               FALSE,                   // Alertable
                               &li);                    // Delay in (micro s)
    }

    while (I8X_GET_STATUS_BYTE(CommandAddress) & OUTPUT_BUFFER_FULL) {
#else // defined(NEC_98)
    while (I8X_GET_STATUS_BYTE(CommandAddress) & PC98_8251_DATA_READY) {
#endif // defined(NEC_98)
        //
        // Eat the output buffer byte.
        //
        byte = I8X_GET_DATA_BYTE(DataAddress);
    }

    //DbgPrint(("I8xDrainOutputBuffer: exit\n"));
}

NTSTATUS
I8xPutBytePolled(
    IN CCHAR PortType,
    IN BOOLEAN WaitForAcknowledge,
    IN CCHAR AckDeviceType,
    IN UCHAR Byte
    )

/*++

Routine Description:

    This routine sends a command or data byte to the controller or keyboard
    or mouse, in polling mode.  It waits for acknowledgment and resends
    the command/data if necessary.

Arguments:

    PortType - If CommandPort, send the byte to the command register,
        otherwise send it to the data register.

    WaitForAcknowledge - If true, wait for an ACK back from the hardware.

    AckDeviceType - Indicates which device we expect to get the ACK back
        from.

    Byte - The byte to send to the hardware.

Return Value:

    STATUS_IO_TIMEOUT - The hardware was not ready for input or did not
    respond.

    STATUS_SUCCESS - The byte was successfully sent to the hardware.

--*/

{
    ULONG i,j;
    UCHAR response;
    NTSTATUS status;
    BOOLEAN keepTrying;
    PUCHAR dataAddress, commandAddress;

    //DbgPrint(("I8xPutBytePolled: enter\n"));

    if (AckDeviceType == MouseDeviceType) {

        //
        // We need to precede a PutByte for the mouse device with
        // a PutByte that tells the controller that the next byte
        // sent to the controller should go to the auxiliary device
        // (by default it would go to the keyboard device).  We
        // do this by calling I8xPutBytePolled recursively to send
        // the "send next byte to auxiliary device" command
        // before sending the intended byte to the mouse.  Note that
        // there is only one level of recursion, since the AckDeviceType
        // for the recursive call is guaranteed to be UndefinedDeviceType,
        // and hence this IF statement will evaluate to FALSE.
        //

        I8xPutBytePolled(
            (CCHAR) CommandPort,
            NO_WAIT_FOR_ACKNOWLEDGE,
            (CCHAR) UndefinedDeviceType,
            (UCHAR) I8042_WRITE_TO_AUXILIARY_DEVICE
            );
    }

    dataAddress = (PUCHAR) KeyboardDataPort;
    commandAddress = (PUCHAR) KeyboardCommandPort;

    for (j=0;j < (ULONG)ResendIterations;j++) {

#ifndef NEC_98
        //
        // Make sure the Input Buffer Full controller status bit is clear.
        // Time out if necessary.
        //

        i = 0;
        while ((i++ < (ULONG)PollingIterations)
               && (I8X_GET_STATUS_BYTE(commandAddress) & INPUT_BUFFER_FULL)) {
            //DbgPrint(("I8xPutBytePolled: stalling\n"));
            KeStallExecutionProcessor(StallMicroseconds);
        }
        if (i >= (ULONG)PollingIterations) {
            //DbgPrint(("I8xPutBytePolled: timing out\n"));
            status = STATUS_IO_TIMEOUT;
            break;
        }
#endif // defined(NEC_98)

        //
        // Drain the i8042 output buffer to get rid of stale data.
        //

        I8xDrainOutputBuffer(dataAddress, commandAddress);

        //
        // Send the byte to the appropriate (command/data) hardware register.
        //

        if (PortType == CommandPort) {
            //DbgPrint(("I8xPutBytePolled: sending 0x%x to command port\n", Byte));
            I8X_PUT_COMMAND_BYTE(commandAddress, Byte);
        } else {
            //DbgPrint(("I8xPutBytePolled: sending 0x%x to data port\n", Byte));
#if defined(NEC_98)
            status = NEC98_KeyboardCommandByte(Byte);
            if (status != STATUS_SUCCESS){
                //DbgPrint(("I8xPutBytePolled: KeyboardCommand Time out exit\n"));

                return(status);
            }
#else // defined(NEC_98)
            I8X_PUT_DATA_BYTE(dataAddress, Byte);
#endif // defined(NEC_98)
        }

        //
        // If we don't need to wait for an ACK back from the controller,
        // set the status and break out of the for loop.
        //
        //

        if (WaitForAcknowledge == NO_WAIT_FOR_ACKNOWLEDGE) {
            status = STATUS_SUCCESS;
            break;
        }

        //
        // Wait for an ACK back from the controller.  If we get an ACK,
        // the operation was successful.  If we get a RESEND, break out to
        // the for loop and try the operation again.  Ignore anything other
        // than ACK or RESEND.
        //

        //DbgPrint(("I8xPutBytePolled: waiting for ACK\n"));
        keepTrying = FALSE;
        while ((status = I8xGetBytePolled(
                             AckDeviceType,
                             &response
                             )
               ) == STATUS_SUCCESS) {

            if (response == ACKNOWLEDGE) {
                //DbgPrint(("I8xPutBytePolled: got ACK\n"));
                break;
            } else if (response == RESEND) {
                //DbgPrint(("I8xPutBytePolled: got RESEND\n"));

                if (AckDeviceType == MouseDeviceType) {

                    //
                    // We need to precede the "resent" PutByte for the
                    // mouse device with a PutByte that tells the controller
                    // that the next byte sent to the controller should go
                    // to the auxiliary device (by default it would go to
                    // the keyboard device).  We do this by calling
                    // I8xPutBytePolled recursively to send the "send next
                    // byte to auxiliary device" command before resending
                    // the byte to the mouse.  Note that there is only one
                    // level of recursion, since the AckDeviceType for the
                    // recursive call is guaranteed to be UndefinedDeviceType.
                    //

                    I8xPutBytePolled(
                        (CCHAR) CommandPort,
                        NO_WAIT_FOR_ACKNOWLEDGE,
                        (CCHAR) UndefinedDeviceType,
                        (UCHAR) I8042_WRITE_TO_AUXILIARY_DEVICE
                        );
                }

                keepTrying = TRUE;
                break;
            }

           //
           // Ignore any other response, and keep trying.
           //

        }

        if (!keepTrying)
            break;
    }

    //
    // Check to see if the number of allowable retries was exceeded.
    //

    if (j >= (ULONG)ResendIterations) {
        //DbgPrint(("I8xPutBytePolled: exceeded number of retries\n"));
        status = STATUS_IO_TIMEOUT;
    }

    //DbgPrint(("I8xPutBytePolled: exit\n"));

    return(status);
}

#ifndef NEC_98
NTSTATUS
I8xPutControllerCommand(
    IN UCHAR Byte
    )

/*++

Routine Description:

    This routine writes the 8042 Controller Command Byte.

Arguments:

    Byte - The byte to store in the Controller Command Byte.

Return Value:

    Status is returned.

--*/

{
    NTSTATUS status;

    //DbgPrint(("I8xPutControllerCommand: enter\n"));

    //
    // Send a command to the i8042 controller to write the Controller
    // Command Byte.
    //

    status = I8xPutBytePolled(
                 (CCHAR) CommandPort,
                 NO_WAIT_FOR_ACKNOWLEDGE,
                 (CCHAR) UndefinedDeviceType,
                 (UCHAR) I8042_WRITE_CONTROLLER_COMMAND_BYTE
                 );

    if (!NT_SUCCESS(status)) {
        return(status);
    }

    //
    // Write the byte through the i8042 data port.
    //

    //DbgPrint(("I8xPutControllerCommand: exit\n"));

    return(I8xPutBytePolled(
               (CCHAR) DataPort,
               NO_WAIT_FOR_ACKNOWLEDGE,
               (CCHAR) UndefinedDeviceType,
               (UCHAR) Byte
               )
    );
}
#endif // NEC_98

NTSTATUS
I8xGetBytePolled(
    IN CCHAR DeviceType,
    OUT PUCHAR Byte
    )

/*++

Routine Description:

    This routine reads a data byte from the controller or keyboard
    or mouse, in polling mode.

Arguments:

    DeviceType - Specifies which device (i8042 controller, keyboard, or
        mouse) to read the byte from.

    Byte - Pointer to the location to store the byte read from the hardware.

Return Value:

    STATUS_IO_TIMEOUT - The hardware was not ready for output or did not
    respond.

    STATUS_SUCCESS - The byte was successfully read from the hardware.

    As a side-effect, the byte value read is stored.

--*/

{
    ULONG i;
    UCHAR response;
    UCHAR desiredMask;
    PSTR  device;
    PUCHAR DataPortAddress = (PUCHAR)KeyboardDataPort;
    PUCHAR CommandPortAddress = (PUCHAR)KeyboardCommandPort;

    //DbgPrint(("I8xGetBytePolled: enter\n"));

    if (DeviceType == KeyboardDeviceType) {
        device = "keyboard";
    } else if (DeviceType == MouseDeviceType) {
        device = "mouse";
    } else {
        device = "8042 controller";
    }
    //DbgPrint(("I8xGetBytePolled: %s\n", device));

    i = 0;
    desiredMask = (DeviceType == MouseDeviceType)?
#if defined(NEC_98)
                  (UCHAR) (PC98_8251_DATA_READY | MOUSE_OUTPUT_BUFFER_FULL):
                  (UCHAR) PC98_8251_DATA_READY;
#else // defined(NEC_98)
                  (UCHAR) (OUTPUT_BUFFER_FULL | MOUSE_OUTPUT_BUFFER_FULL):
                  (UCHAR) OUTPUT_BUFFER_FULL;
#endif // defined(NEC_98)


    //
    // Poll until we get back a controller status value that indicates
    // the output buffer is full.  If we want to read a byte from the mouse,
    // further ensure that the auxiliary device output buffer full bit is
    // set.
    //

    while ((i < (ULONG)PollingIterations) &&
           ((UCHAR)((response =
               I8X_GET_STATUS_BYTE(CommandPortAddress))
               & desiredMask) != desiredMask)) {
#if defined(NEC_98)
        //DbgPrint(("I8xGetBytePolled: stalling\n"));
        KeStallExecutionProcessor(StallMicroseconds);
        i += 1;
#else // defined(NEC_98)
        if (response & OUTPUT_BUFFER_FULL) {

            //
            // There is something in the i8042 output buffer, but it
            // isn't from the device we want to get a byte from.  Eat
            // the byte and try again.
            //

            *Byte = I8X_GET_DATA_BYTE(DataPortAddress);
            //DbgPrint(("I8xGetBytePolled: ate 0x%x\n", *Byte));
        } else {
            //DbgPrint(("I8xGetBytePolled: stalling\n"));
            KeStallExecutionProcessor(StallMicroseconds);
            i += 1;
        }
#endif // defined(NEC_98)
    }
    if (i >= (ULONG)PollingIterations) {
        //DbgPrint(("I8xGetBytePolled: timing out\n"));
        return(STATUS_IO_TIMEOUT);
    }

    //
    // Grab the byte from the hardware, and return success.
    //

    *Byte = I8X_GET_DATA_BYTE(DataPortAddress);

    //DbgPrint(("I8xGetBytePolled: exit with Byte 0x%x\n", *Byte));

    return(STATUS_SUCCESS);
}

NTSTATUS
I8xGetControllerCommand(
    IN ULONG HardwareDisableEnableMask,
    OUT PUCHAR Byte
    )

/*++

Routine Description:

    This routine reads the 8042 Controller Command Byte.

Arguments:

    HardwareDisableEnableMask - Specifies which hardware devices, if any,
        need to be disabled/enable around the operation.

    Byte - Pointer to the location into which the Controller Command Byte is
        read.

Return Value:

    Status is returned.

--*/

{
    NTSTATUS status;
    NTSTATUS secondStatus;
    ULONG retryCount;

    //DbgPrint(("I8xGetControllerCommand: enter\n"));

    //
    // Disable the specified devices before sending the command to
    // read the Controller Command Byte (otherwise data in the output
    // buffer might get trashed).
    //

    if (HardwareDisableEnableMask & KEYBOARD_HARDWARE_PRESENT) {
        status = I8xPutBytePolled(
                     (CCHAR) CommandPort,
                     NO_WAIT_FOR_ACKNOWLEDGE,
                     (CCHAR) UndefinedDeviceType,
                     (UCHAR) I8042_DISABLE_KEYBOARD_DEVICE
                     );
        if (!NT_SUCCESS(status)) {
            return(status);
        }
    }

    if (HardwareDisableEnableMask & MOUSE_HARDWARE_PRESENT) {
        status = I8xPutBytePolled(
                     (CCHAR) CommandPort,
                     NO_WAIT_FOR_ACKNOWLEDGE,
                     (CCHAR) UndefinedDeviceType,
                     (UCHAR) I8042_DISABLE_MOUSE_DEVICE
                     );
        if (!NT_SUCCESS(status)) {

            //
            // Re-enable the keyboard device, if necessary, before returning.
            //

            if (HardwareDisableEnableMask & KEYBOARD_HARDWARE_PRESENT) {
                secondStatus = I8xPutBytePolled(
                                   (CCHAR) CommandPort,
                                   NO_WAIT_FOR_ACKNOWLEDGE,
                                   (CCHAR) UndefinedDeviceType,
                                   (UCHAR) I8042_ENABLE_KEYBOARD_DEVICE
                                   );
            }
            return(status);
        }
    }

    //
    // Send a command to the i8042 controller to read the Controller
    // Command Byte.
    //

    status = I8xPutBytePolled(
                 (CCHAR) CommandPort,
                 NO_WAIT_FOR_ACKNOWLEDGE,
                 (CCHAR) UndefinedDeviceType,
                 (UCHAR) I8042_READ_CONTROLLER_COMMAND_BYTE
                 );

    //
    // Read the byte from the i8042 data port.
    //

    if (NT_SUCCESS(status)) {
        for (retryCount = 0; retryCount < 5; retryCount++) {
            status = I8xGetBytePolled(
                         (CCHAR) ControllerDeviceType,
                         Byte
                         );
            if (NT_SUCCESS(status)) {
                break;
            }
            if (status == STATUS_IO_TIMEOUT) {
                KeStallExecutionProcessor(StallMicroseconds);
            } else {
                break;
            }
        }
    }

    //
    // Re-enable the specified devices.  Clear the device disable
    // bits in the Controller Command Byte by hand (they got set when
    // we disabled the devices, so the CCB we read lacked the real
    // device disable bit information).
    //

    if (HardwareDisableEnableMask & KEYBOARD_HARDWARE_PRESENT) {
        secondStatus = I8xPutBytePolled(
                           (CCHAR) CommandPort,
                           NO_WAIT_FOR_ACKNOWLEDGE,
                           (CCHAR) UndefinedDeviceType,
                           (UCHAR) I8042_ENABLE_KEYBOARD_DEVICE
                           );
        if (!NT_SUCCESS(secondStatus)) {
            if (NT_SUCCESS(status))
                status = secondStatus;
        } else if (status == STATUS_SUCCESS) {
            *Byte &= (UCHAR) ~CCB_DISABLE_KEYBOARD_DEVICE;
        }

    }

    if (HardwareDisableEnableMask & MOUSE_HARDWARE_PRESENT) {
        secondStatus = I8xPutBytePolled(
                           (CCHAR) CommandPort,
                           NO_WAIT_FOR_ACKNOWLEDGE,
                           (CCHAR) UndefinedDeviceType,
                           (UCHAR) I8042_ENABLE_MOUSE_DEVICE
                           );
        if (!NT_SUCCESS(secondStatus)) {
            if (NT_SUCCESS(status))
                status = secondStatus;
        } else if (NT_SUCCESS(status)) {
            *Byte &= (UCHAR) ~CCB_DISABLE_MOUSE_DEVICE;
        }
    }

    //DbgPrint(("I8xGetControllerCommand: exit\n"));

    return(status);

}

VOID
I8xTransmitControllerCommand(
    IN PI8042_TRANSMIT_CCB_CONTEXT TransmitCCBContext
    )

/*++

Routine Description:

    This routine reads the 8042 Controller Command Byte, performs an AND
    or OR operation using the specified ByteMask, and writes the resulting
    ControllerCommandByte.

Arguments:

    Context - Pointer to a structure containing the HardwareDisableEnableMask,
        the AndOperation boolean, and the ByteMask to apply to the Controller
        Command Byte before it is rewritten.

Return Value:

    None.  Status is returned in the Context structure.

--*/

{
    UCHAR  controllerCommandByte;
    UCHAR  verifyCommandByte;
    PIO_ERROR_LOG_PACKET errorLogEntry;

    KdPrint(("I8xTransmitControllerCommand: enter\n"));

    //
    // Get the current Controller Command Byte.
    //
    TransmitCCBContext->Status =
        I8xGetControllerCommand(
            TransmitCCBContext->HardwareDisableEnableMask,
            &controllerCommandByte
            );

    if (!NT_SUCCESS(TransmitCCBContext->Status)) {
        return;
    }

    KdPrint(("I8xTransmitControllerCommand: current CCB 0x%x\n",
         controllerCommandByte
         ));

    //
    // Diddle the desired bits in the Controller Command Byte.
    //

    if (TransmitCCBContext->AndOperation) {
        controllerCommandByte &= TransmitCCBContext->ByteMask;
    }
    else {
        controllerCommandByte |= TransmitCCBContext->ByteMask;
    }

    //
    // Write the new Controller Command Byte.
    //

PutControllerCommand:
    TransmitCCBContext->Status =
        I8xPutControllerCommand(controllerCommandByte);

    KdPrint(("I8xTransmitControllerCommand: new CCB 0x%x\n",
         controllerCommandByte
         ));

    //
    // Verify that the new Controller Command Byte really got written.
    //

    TransmitCCBContext->Status =
        I8xGetControllerCommand(
            TransmitCCBContext->HardwareDisableEnableMask,
            &verifyCommandByte
            );

    if (verifyCommandByte == 0xff) {
        KeStallExecutionProcessor(50);
        //
        // Stall for about a second
        //
        goto PutControllerCommand;
    }

    if (NT_SUCCESS(TransmitCCBContext->Status)
        && (verifyCommandByte != controllerCommandByte)
        && (verifyCommandByte != ACKNOWLEDGE) 
//        && (verifyCommandByte != KEYBOARD_RESET)
        ) {
        TransmitCCBContext->Status = STATUS_DEVICE_DATA_ERROR;

        KdPrint(("I8xTransmitControllerCommand:  wrote 0x%x, failed verification (0x%x)\n",
              (int) controllerCommandByte,
              (int) verifyCommandByte
              ));
    }

    KdPrint(("I8xTransmitControllerCommand: exit\n"));

    return;
}

NTSTATUS
I8xToggleInterrupts(
    BOOLEAN State
    )
/*++

Routine Description:

    This routine is called by KeSynchronizeExecution to turn toggle the 
    interrupt(s).
     
Arguments:

    ToggleContext - indicates whether to turn the interrupts on or off plus it
                    stores the results of the operation
                    
Return Value:

    success of the toggle
    
--*/
{
    I8042_TRANSMIT_CCB_CONTEXT transmitCCBContext;

    PAGED_CODE();

    if (State) {
        transmitCCBContext.HardwareDisableEnableMask =
            MOUSE_HARDWARE_PRESENT || KEYBOARD_HARDWARE_PRESENT;
        transmitCCBContext.AndOperation = OR_OPERATION;
        transmitCCBContext.ByteMask =   
                                         CCB_ENABLE_KEYBOARD_INTERRUPT || CCB_ENABLE_MOUSE_INTERRUPT;
    }
    else {
        transmitCCBContext.HardwareDisableEnableMask = 0;
        transmitCCBContext.AndOperation = AND_OPERATION;
        transmitCCBContext.ByteMask = (UCHAR)
             ~((UCHAR) CCB_ENABLE_KEYBOARD_INTERRUPT |
               (UCHAR) CCB_ENABLE_MOUSE_INTERRUPT);
    }

    I8xTransmitControllerCommand((PVOID) &transmitCCBContext);

    if (!NT_SUCCESS(transmitCCBContext.Status)) 
                {
        KdPrint(("I8xToggleInterrupts: failed to %sable the interrupts, status 0x%x\n",
             State ? "en" : "dis",
             transmitCCBContext.Status 
             ));

    }

    return transmitCCBContext.Status;
}
