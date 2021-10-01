//=============================================================================================
// —четчик блокировок
//=============================================================================================
#pragma once
#include "ntddk.h"

typedef ULONG TLockCount;

 void LockCount_Init(TLockCount *pLC);
ULONG LockCount_IsLocked(TLockCount *pLC);
 void LockCount_Lock(TLockCount *pLC);
 void LockCount_Unlock(TLockCount *pLC);
