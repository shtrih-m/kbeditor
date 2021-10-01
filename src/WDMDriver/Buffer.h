//=============================================================================================
// ����� (���������)
//=============================================================================================
#pragma once
#include "ntddk.h"

// ����. ���-�� ��-��� � ������
#define BUFFER_SIZE  ((ULONG) 512)

typedef struct  {
  UCHAR Buf[BUFFER_SIZE];   //�����
  ULONG BufHead;            //������� ������
  ULONG BufEnd;             //������� ������
  KEVENT StateEvent;        //No signal - ������ ����
  KSPIN_LOCK SyncSpinLock;  //�����. ����. �������
} TBuffer;

   void Buffer_Init(TBuffer *pB);
   void Buffer_Reset(TBuffer *pB);
BOOLEAN Buffer_SetChar(TBuffer *pB, UCHAR Char);
BOOLEAN Buffer_GetChar(TBuffer *pB, UCHAR *pChar);
BOOLEAN Buffer_GetCharEx(TBuffer *pB, UCHAR *pChar);
   void Buffer_RefreshEvent(TBuffer *pB);
