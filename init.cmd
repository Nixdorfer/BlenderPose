@echo off
chcp 65001
setlocal EnableDelayedExpansion
set position=%~dp0
if "%1"=="" (goto no_args)
del /s /q init.reg
cd %position%Projects
cls
set blender=%position%Blender\blender.exe
:begin
set flag=0
set projects[0]=""
cls
echo 0. New Project
echo.
for /f %%i in ('dir /b /a-d-r') do (
	set full_name=%%i
	if !full_name:~-5!==blend (
		set /a flag+=1
		set projects[!flag!]=%%i
		echo !flag!. %%i
	)
)
echo.
set /p choice=Choose your project: 
if %choice%==0 (
	set /a number=%flag%+1
	set name=0000!number!
	copy Pose_0000.blend Pose_!name:~-4!.blend
	goto begin)
if %choice% LSS 0 (
	call :error
	goto begin)
if %choice% GTR !flag! (
	call :error
	goto begin)
%blender% %position%projects\!projects[%choice%]!
echo Program finished.
timeout /t 5
exit

:error
cls
echo Unvalid Input!
timeout /t 5
exit /b 0

:no_args
if not exist init.reg (call :write_reg)
start init.reg
exit /b 0

:write_reg
(echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND]
echo @="Blender Browser Support"
echo "URL Protocol"="%position:\=\\%\\init.cmd %l"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\DefaultIcon]
echo @="%%SystemRoot%%\\system32\\url.dll,0"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\Shell]
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\Shell\open]
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\Shell\open\command]
echo @="%position:\=\\%\\init.cmd %l")>init.reg
exit /b 0