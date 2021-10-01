@echo off

rem =============================== P A T H ===============================
SET DDK_DIR=C:\98DDK
SET VXD_NAME=SMKBDDRV
SET SOURCE_FILES=%VXD_NAME% Filter kbdfunc MixFunc

rem ================================ D E L ================================
if -%1- == -/checked-  goto del_checked

:del_release
echo y | del %VXD_NAME%.vxd
goto del_exit

:del_checked
echo y | del %VXD_NAME%.vxd
goto del_exit

:del_exit

rem ============================= C O M P I L =============================
SET PARAM_DEFINE=
if -%1- == -/checked-  SET PARAM_DEFINE=/Zi /Zd /DDEBUG
for %%f in (%SOURCE_FILES%) do  call PARAM_DEFINE_ADD.bat %%f.asm
%DDK_DIR%\bin\win98\ml /DBLD_COFF /DMINIVDD /DIS_32 /DMASM6 /DSupport_Reboot /I %DDK_DIR%\inc\win98 /W2 /coff /c /Cx %PARAM_DEFINE%

rem =============================== L I N K ===============================
SET PARAM_DEFINE=
if -%1- == -/checked-  SET PARAM_DEFINE=/DEBUG
for %%f in (%SOURCE_FILES%) do  call PARAM_DEFINE_ADD.bat %%f.obj
%DDK_DIR%\bin\link /VXD /DEF:%VXD_NAME%.def /OUT:%VXD_NAME%.vxd %PARAM_DEFINE%

rem ========================== M O V E   F I L E ==========================
if EXIST %VXD_NAME%.lib  del %VXD_NAME%.lib
if EXIST %VXD_NAME%.exp  del %VXD_NAME%.exp
if EXIST %VXD_NAME%.pdb  del %VXD_NAME%.pdb
rem if EXIST %VXD_NAME%.___  del %VXD_NAME%.___

for %%f in (%SOURCE_FILES%) do  if EXIST %%f.obj  del %%f.obj

if -%1- == -/checked-  goto move_checked

:move_release
move %VXD_NAME%.vxd Release\%VXD_NAME%.vxd
goto move_exit

:move_checked
move %VXD_NAME%.vxd Debug\%VXD_NAME%.vxd
goto move_exit

:move_exit

rem =========================== D E L   P A T H ===========================
SET DDK_DIR=
SET VXD_NAME=
SET SOURCE_FILES=
SET PARAM_DEFINE=
