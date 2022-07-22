@echo off

SETLOCAL EnableExtensions
SETLOCAL DisableDelayedExpansion
set v_params=%*
set v_params=%v_params:\=/%
set v_params=%v_params:c:=/mnt/c%
REM set v_params=%v_params:"=\"%
C:\Windows\system32\wsl.exe KRB5CCNAME="DIR:/tmp" SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock %~n0 %v_params%
