@echo off
chcp 65001
setlocal EnableDelayedExpansion
set position=%~dp0
cd Projects
cls
set blender=%position%Blender\blender-launcher.exe
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
%blender% !projects[%choice%]!
echo Program finished.
timeout /t 5
exit

:error
cls
echo Unvalid Input!
timeout /t 5
exit /b 0