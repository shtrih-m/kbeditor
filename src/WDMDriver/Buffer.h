//=============================================================================================
// Буфер (кольцевой)
//=============================================================================================
#pragma once
#include "ntddk.h"

// Макс. кол-во эл-тов в буфере
#define BUFFER_SIZE  ((ULONG) 512)

typedef struct  {
  UCHAR Buf[BUFFER_SIZE];   //Буфер
  ULONG BufHead;            //Позиция головы
  ULONG BufEnd;             //Позиция хвоста
  KEVENT StateEvent;        //No signal - буффер пуст
  KSPIN_LOCK SyncSpinLock;  //Синхр. разл. потоков
} TBuffer;

   void Buffer_Init(TBuffer *pB);
   void Buffer_Reset(TBuffer *pB);
BOOLEAN Buffer_SetChar(TBuffer *pB, UCHAR Char);
BOOLEAN Buffer_GetChar(TBuffer *pB, UCHAR *pChar);
BOOLEAN Buffer_GetCharEx(TBuffer *pB, UCHAR *pChar);
   void Buffer_RefreshEvent(TBuffer *pB);
