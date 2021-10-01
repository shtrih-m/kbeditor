@set prjdir=%cd%
call C:\WinDDK\7600.16385.1\bin\setenv.bat C:\WinDDK\7600.16385.1\ fre x64 WIN7
cd /D %prjdir%
build
