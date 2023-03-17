@echo off
chcp 65001
setlocal EnableDelayedExpansion
set position=%~dp0
start Control_Panel.cmd 8000
exit