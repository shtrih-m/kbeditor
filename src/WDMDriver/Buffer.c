//=============================================================================================
// ����� (���������)
//=============================================================================================
#include "Buffer.h"


//=============================================================================================
// ������������� ������
//=============================================================================================
void Buffer_Init(TBuffer *pB)  {

  pB->BufHead = pB->BufEnd = 0;
  KeInitializeEvent(&pB->StateEvent, NotificationEvent, FALSE);
  KeInitializeSpinLock(&pB->SyncSpinLock);
}

//=============================================================================================
// ��������� ������
//=============================================================================================
void Buffer_Reset(TBuffer *pB)  {

  pB->BufEnd = pB->BufHead;
  Buffer_RefreshEvent(pB);
}

//=============================================================================================
// ������ ������� � �����
//=============================================================================================
BOOLEAN Buffer_SetChar(TBuffer *pB, UCHAR Char)  {

  ULONG NewHead = (pB->BufHead+1 == BUFFER_SIZE) ? 0: pB->BufHead+1;
  if (NewHead == pB->BufEnd)  return FALSE;
  pB->Buf[pB->BufHead] = Char;
  pB->BufHead = NewHead;
  return TRUE;
}

//=============================================================================================
// ������ ������� �� ������
//=============================================================================================
BOOLEAN Buffer_GetChar(TBuffer *pB, UCHAR *pChar)  {

  if (pB->BufHead == pB->BufEnd)  return FALSE;
  *pChar = pB->Buf[pB->BufEnd];
  pB->BufEnd = (pB->BufEnd+1 == BUFFER_SIZE) ? 0: pB->BufEnd+1;
  return TRUE;
}

//=============================================================================================
// ������ ������� �� ������ + ���������� �������
//=============================================================================================
BOOLEAN Buffer_GetCharEx(TBuffer *pB, UCHAR *pChar)  {

  BOOLEAN RetVal = Buffer_GetChar(pB, pChar);
  Buffer_RefreshEvent(pB);
  return RetVal;
}

//=============================================================================================
// �������� ��������� �������
//=============================================================================================
void Buffer_RefreshEvent(TBuffer *pB)  {

  KIRQL OldIRQL;
  KeAcquireSpinLock(&pB->SyncSpinLock, &OldIRQL);
  if (pB->BufHead == pB->BufEnd)  KeClearEvent(&pB->StateEvent);
  else  KeSetEvent(&pB->StateEvent, IO_NO_INCREMENT, FALSE);
  KeReleaseSpinLock(&pB->SyncSpinLock, OldIRQL);
}
