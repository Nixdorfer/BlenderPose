@echo off
chcp 65001
setlocal EnableDelayedExpansion
set position=%~dp0
cd %position%
if exist init.reg (del /f /q init.reg)
if "%1"=="" (goto no_args)
title BlenderPose辅助程序[自动模式]
cd Projects
cls
set blender=%position%Blender\blender.exe
:begin_auto
set flag=0
set projects[0]=""
cls
echo 当前运行在[自动模式]下, WebAPI已激活: 连接至%1
echo.
echo n. 打开一个手动模式终端
echo r. 重新读取可用项目列表
echo.
echo 0. 新建一个项目
echo.
echo 可用的项目列表:
for /f %%i in ('dir /b /a-d-r') do (
	set full_name=%%i
	if !full_name:~-5!==blend (
		set /a flag+=1
		set projects[!flag!]=%%i
		echo !flag!. %%i
	)
)
echo.
set /p choice=你要选择的项目: 
if %choice%==n (
	start %position%Control_Panel.cmd
	goto begin_auto)
if %choice%==r (goto begin_auto)
if %choice%==0 (
	set /a number=%flag%+1
	set name=0000!number!
	copy Pose_0000.blend Pose_!name:~-4!.blend
	goto begin_auto)
if %choice% LSS 0 (
	call :error
	goto begin_auto)
if %choice% GTR !flag! (
	call :error
	goto begin_auto)
%blender% %position%projects\!projects[%choice%]!
cls
echo 功能执行完毕，程序将在5秒后自动退出
timeout /t 5
exit

:error
cls
echo 无效的输入!
timeout /t 5
exit /b 0

:no_args
cd %position%
cls
title BlenderPose辅助程序[手动模式]
echo 当前运行在[手动模式]下, WebAPI未激活
echo.
echo 1. 初始化自动化环境
echo 2. 手动打开项目
echo 3. 删除项目
echo 4. 清理缓存图片
echo.
set /p choice=请选择你要执行的项目: 
if %choice%==1 (goto init_env)
if %choice%==2 (goto start_project)
if %choice%==3 (goto delete_project)
if %choice%==4 (goto cleansing)
call :error
goto no_args
exit

:cleansing
cls
title 清理缓存 - BlenderPose辅助程序[手动模式]
cd Projects
set /p confirm=你确定要清理全部缓存吗(Y/N): 
if %confirm%==Y (call :cleansing_continue)
if %confirm%==y (call :cleansing_continue)
if %confirm%==N (
	echo 缓存清理已经取消
	timeout /t 5
	goto no_args)
if %confirm%==n (
	echo 缓存清理已经取消
	timeout /t 5
	goto no_args)

:cleansing_continue
if exist Body (rd /s /q Body)
if exist Depth (rd /s /q Depth)
if exist Canny (rd /s /q Canny)
for /f %%i in ('dir /b /a-d-r') do (
	set full_name=%%i
	if !full_name:~-5! NEQ blend (del /s /q !full_name!)
)
echo 缓存已经清理完毕
timeout /t 5
goto no_args

:delete_project
cls
title 打开项目 - BlenderPose辅助程序[手动模式]
cd Projects
cls
set blender=%position%Blender\blender-launcher.exe
:begin_del
set flag=0
set projects[0]=""
cls
for /f %%i in ('dir /b /a-d-r') do (
	set full_name=%%i
	if !full_name:~-5!==blend (
		set /a flag+=1
		set projects[!flag!]=%%i
		echo !flag!. %%i
	)
)
echo.
echo b. 返回上级菜单
echo.
set /p choice=选择你要删除的项目: 
if %choice%==b (goto no_args)
if %choice% LSS 1 (
	call :error
	goto begin_del)
if %choice% GTR !flag! (
	call :error
	goto begin_del)
:confirm_del
cls
set /p confirm=你确定要删除!projects[%choice%]!吗(Y/N): 
if %confirm%==Y (
	del /s /q !projects[%choice%]!
	echo 项目!projects[%choice%]!已经删除
	timeout /t 5
	goto no_args)
if %confirm%==y (
	del /s /q !projects[%choice%]!
	echo 项目!projects[%choice%]!已经删除
	timeout /t 5
	goto no_args)
if %confirm%==N (
	echo 针对!projects[%choice%]!的删除程序已经取消
	timeout /t 5
	goto :delete_project)
if %confirm%==n (
	echo 针对!projects[%choice%]!的删除程序已经取消
	timeout /t 5
	goto :delete_project)
call :error
goto confirm_del
cls
echo 功能执行完毕
timeout /t 5
goto no_args

:init_env
cls
title 初始化环境 - BlenderPose辅助程序[手动模式]
if not exist init.reg (call :write_reg)
start init.reg
cls
echo 功能执行完毕
timeout /t 5
exit

:start_project
cls
title 打开项目 - BlenderPose辅助程序[手动模式]
cd Projects
cls
set blender=%position%Blender\blender-launcher.exe
:begin_dev
set flag=0
set projects[0]=""
cls
echo 0. 新建一个项目
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
echo b. 返回上级菜单
echo.
set /p choice=选择你要打开的项目: 
if %choice%==b (goto no_args)
if %choice%==0 (
	set /a number=%flag%+1
	set name=0000!number!
	copy Pose_0000.blend Pose_!name:~-4!.blend
	goto begin_dev)
if %choice% LSS 0 (
	call :error
	goto begin_dev)
if %choice% GTR !flag! (
	call :error
	goto begin_dev)
%blender% !projects[%choice%]!
cls
echo 功能执行完毕，程序将在5秒后自动退出
timeout /t 5
exit

:write_reg
(echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND]
echo @="Blender Browser Support"
echo "URL Protocol"="%position:\=\\%\\Control_Panel.cmd %%l"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\DefaultIcon]
echo @="%%SystemRoot%%\\system32\\url.dll,0"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\Shell]
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\Shell\open]
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Classes\BLEND\Shell\open\command]
echo @="%position:\=\\%\\Control_Panel.cmd %%l")>init.reg
exit /b 0