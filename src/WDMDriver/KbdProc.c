//=============================================================================================
// Основные функции
//=============================================================================================


//=============================================================================================
// DPC процедура
//=============================================================================================
IO_DPC_ROUTINE DPCRoutine;

VOID DPCRoutine(IN PKDPC Dpc, IN PDEVICE_OBJECT DeviceObject, IN PIRP Irp, IN PVOID Context)  {

  PDEVICE_EXTENSION devExt = DeviceObject->DeviceExtension;
  Buffer_RefreshEvent(&devExt->ReadBuf);
}

//=============================================================================================
// Процедура фильтрации данных от клавиатуры
// Вход:  UCHAR DataByte - байт от клавиатуры
// Выход: BOOLEAN ContinueProcessing - Отдать стандартному обработчику
//=============================================================================================
BOOLEAN FilterKbdProc(IN PDEVICE_OBJECT DeviceObject, UCHAR DataByte)  {

  PDEVICE_EXTENSION devExt = DeviceObject->DeviceExtension;

  KdPrint(("<- 0x%02X", DataByte));
  if (!LockCount_IsLocked(&devExt->ReadState))  return TRUE;
  Buffer_SetChar(&devExt->ReadBuf, DataByte);
  IoRequestDpc(DeviceObject, NULL, NULL);
  return FALSE;
}

//=============================================================================================
// IsSolitaryObject
//=============================================================================================
BOOLEAN IsSolitaryObject(PDEVICE_OBJECT DeviceObject)  {

  PDEVICE_EXTENSION devExt;
  devExt = (PDEVICE_EXTENSION) DeviceObject->DeviceExtension;
  return devExt->IsSolitaryObject;
}

//=============================================================================================
// Ожидание готовности к записи
// RetVal: STATUS_SUCCESS
//         STATUS_IO_TIMEOUT
//=============================================================================================
NTSTATUS KbdWaitStatusWrite(void)  {

  PUCHAR address;
  LARGE_INTEGER BgTime, CurTime;
  KeQuerySystemTime(&BgTime);

  do  
  {
    address = (PUCHAR)I8042_PHYSICAL_BASE + I8042_STATUS_REGISTER_OFFSET;
    if (!(READ_PORT_UCHAR(address) & 0x02)) return STATUS_SUCCESS;

    KeQuerySystemTime(&CurTime);
  } while (CurTime.QuadPart-BgTime.QuadPart < TIMEOUT_WAIT_STATUS_OK);

  KdPrint(("KbdWaitStatusWrite: Timeout"));
  return STATUS_IO_TIMEOUT;
}

//=============================================================================================
// Запись байта в клавиатуру
//=============================================================================================
void KbdWriteByte(UCHAR Byte)  
{
  PUCHAR address;

  KdPrint(("-> 0x%02X", Byte));
  KbdWaitStatusWrite();
  address = (PUCHAR)I8042_PHYSICAL_BASE + I8042_DATA_REGISTER_OFFSET;
  WRITE_PORT_UCHAR(address, Byte);
}

//=============================================================================================
// Запись команды контроллера клавиатуры
//=============================================================================================
void KbdWriteCmd(UCHAR Byte)  
{
  PUCHAR address;

  //KdPrint(("-> 0x%02X (Cmd)", Byte));
  KbdWaitStatusWrite();
  address = (PUCHAR)I8042_PHYSICAL_BASE + I8042_COMMAND_REGISTER_OFFSET;
  WRITE_PORT_UCHAR(address, Byte);
}

//=============================================================================================
// Запись командного байта клавиатуры
//=============================================================================================
void WriteCommandByte(IN PDEVICE_EXTENSION devExt, IN UCHAR CommandByte)  {

  KbdWriteCmd(I8042_WRITE_CONTROLLER_COMMAND_BYTE);
  KbdWriteByte(CommandByte);
}

//=============================================================================================
// Чтение данных
//=============================================================================================
NTSTATUS ReadData(IN PDEVICE_EXTENSION devExt, UCHAR ReadMode)  {

    USHORT NeedRead;
  LARGE_INTEGER Timeout, BgTime, CurTime;

  UCHAR Byte, StateReadByte = STATE_READBYTE_BEGIN;
  UCHAR StateReadCadr = STATE_READCADR_WAIT_STX;

  devExt->DataLength = 0;
  BgTime.QuadPart = CurTime.QuadPart = 0;
  switch (ReadMode)  {
    case MODE_READ_CADR:  Timeout.QuadPart = TIMEOUT_READ_CADR; break;
    default:              Timeout.QuadPart = TIMEOUT_READ_BYTE; break;
  }

  do  {
    Timeout.QuadPart -= (CurTime.QuadPart - BgTime.QuadPart);
    KeQuerySystemTime(&BgTime);
    CurTime.QuadPart = -Timeout.QuadPart;

    if (KeWaitForSingleObject(&devExt->ReadBuf.StateEvent, Executive, KernelMode, FALSE, &CurTime) != STATUS_SUCCESS)  return STATUS_IO_TIMEOUT;
    switch (ReadMode)  {

      // Чтение байта
      case MODE_READ_BYTE:
        Buffer_GetCharEx(&devExt->ReadBuf, &devExt->ReadData[devExt->DataLength]);
        ++devExt->DataLength;
        return STATUS_SUCCESS;

      // Чтение кадра
      case MODE_READ_CADR:
        switch (StateReadByte)  {

          case STATE_READBYTE_BEGIN:
            Buffer_GetCharEx(&devExt->ReadBuf, &Byte);
            devExt->ReadData[devExt->DataLength] = Byte & 0x0F;
            StateReadByte = STATE_READBYTE_END;
            break;

          case STATE_READBYTE_END:
            Buffer_GetCharEx(&devExt->ReadBuf, &Byte);
            devExt->ReadData[devExt->DataLength] += (Byte << 4);
            StateReadByte = STATE_READBYTE_BEGIN;

            switch (StateReadCadr)  {

              // Ожидание STX
              case STATE_READCADR_WAIT_STX:
                if (devExt->ReadData[devExt->DataLength] == STX)  {
                  ++devExt->DataLength;
                  StateReadCadr = STATE_READCADR_WAIT_LENGTH;
                }
                break;

                        // Ожидаем длину кадра
                      case STATE_READCADR_WAIT_LENGTH:
                  NeedRead = devExt->ReadData[devExt->DataLength] + 1;
                ++devExt->DataLength;
                NeedRead += devExt->DataLength;
                StateReadCadr = STATE_READCADR_WAIT_DATA;
                          break;

              // Ожидаем данные
              case STATE_READCADR_WAIT_DATA:
                ++devExt->DataLength;
                if (devExt->DataLength == NeedRead)  return STATUS_SUCCESS;
                break;
            }
            break;
        }
        break;
    }

    KeQuerySystemTime(&CurTime);
  } while (CurTime.QuadPart-BgTime.QuadPart < Timeout.QuadPart);

  KdPrint(("ReadData: Timeout, Status = %lu, Reading = %lu", ReadMode, devExt->DataLength));
  return STATUS_IO_TIMEOUT;
}

//=============================================================================================
// Начать чтение
//=============================================================================================
void StartRead(IN PDEVICE_EXTENSION devExt)  {

  Buffer_Reset(&devExt->ReadBuf);
  LockCount_Lock(&devExt->ReadState);
}

//=============================================================================================
// Закончить чтение
//=============================================================================================
NTSTATUS StopRead(IN PDEVICE_EXTENSION devExt, UCHAR ReadMode)  {

  NTSTATUS RetVal = ReadData(devExt, ReadMode);
  LockCount_Unlock(&devExt->ReadState);
  return RetVal;
}

//=============================================================================================
// Отменить чтение
//=============================================================================================
void CancelRead(IN PDEVICE_EXTENSION devExt)  {

  LockCount_Unlock(&devExt->ReadState);
}

//=============================================================================================
// Чтение командного байта из клавиатуры
// RetVal: STATUS_SUCCESS
//         STATUS_IO_TIMEOUT
//=============================================================================================
NTSTATUS ReadCommandByte(IN PDEVICE_EXTENSION devExt, OUT PUCHAR CommandByte)  {

  NTSTATUS Status;
  StartRead(devExt);
  KbdWriteCmd(I8042_READ_CONTROLLER_COMMAND_BYTE);
  Status = StopRead(devExt, MODE_READ_BYTE);
  if (Status == STATUS_SUCCESS)  *CommandByte = devExt->ReadData[0];
    return Status;
}

//=============================================================================================
// Запись данных в клавиатуру с ожиданием ответа
// RetVal: STATUS_SUCCESS
//         STATUS_IO_TIMEOUT
//=============================================================================================
NTSTATUS KbdWriteData(IN PDEVICE_EXTENSION devExt, PUCHAR InputBuffer, ULONG InputBufferLength)  {

  ULONG i, i_resend;
  NTSTATUS RetVal;

  for (i = 0; i < InputBufferLength; ++i)  {
    for (i_resend = 0; i_resend < RESEND_ITERATIONS; ++i_resend)  {
      StartRead(devExt);
      KbdWriteByte(InputBuffer[i]);
      RetVal = StopRead(devExt, MODE_READ_BYTE);
      if (RetVal != STATUS_SUCCESS)  return RetVal;
      if (devExt->ReadData[0] == ACKNOWLEDGE)  break;
      else if (devExt->ReadData[0] == RESEND)  KdPrint(("Resend"));
      else  return STATUS_IO_TIMEOUT;
    }

    if (i_resend >= RESEND_ITERATIONS)  {
      KdPrint(("Resend out"));
      return STATUS_IO_TIMEOUT;
    }
  }
  return STATUS_SUCCESS;
}

//=============================================================================================
// Включаем мышь
//=============================================================================================
void EnableMouse(void)  {

  KbdWriteCmd(I8042_ENABLE_MOUSE_DEVICE);
}

//=============================================================================================
// Включаем клавиатуру
//=============================================================================================
void EnableKeyboard(void)  {

  KbdWriteCmd(I8042_ENABLE_KEYBOARD_DEVICE);
}

//=============================================================================================
// Отключаем мышь
//=============================================================================================
void DisableMouse(void)  {

  KbdWriteCmd(I8042_DISABLE_MOUSE_DEVICE);
}

//=============================================================================================
// Отключаем клавиатуру
//=============================================================================================
void DisableKeyboard(void)  {

  KbdWriteCmd(I8042_DISABLE_KEYBOARD_DEVICE);
}

//=============================================================================================
// Блокировка клавиатуры
// Вход: BOOLEAN fBlock - TRUE  - установить
//                      - FALSE - снять
// RetVal: STATUS_SUCCESS
//         STATUS_IO_TIMEOUT
//=============================================================================================
NTSTATUS KbdBlock(IN PDEVICE_EXTENSION devExt, IN BOOLEAN fBlock)  {

  UCHAR Cmd;
  if (fBlock)  {
    Cmd = KBD_CMD_BLOCK_ON;
    DisableMouse();
  }
  else  {
    KdPrint(("-> Old keyboard param"));
    I8xSendIoctl(devExt->Self, IOCTL_KEYBOARD_SET_TYPEMATIC, &devExt->TypematicParam, sizeof(devExt->TypematicParam));

    Cmd = KBD_CMD_BLOCK_OFF;
    EnableMouse();
  }

  return KbdWriteData(devExt, &Cmd, sizeof(Cmd));
}
