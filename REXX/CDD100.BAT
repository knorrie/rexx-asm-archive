@echo off
:begin
if "%1"=="" goto help
if "%1"=="/?" goto help
if "%1"=="/h" goto help
if "%1"=="/H" goto help
:change
%1
cd %2
echo.
goto exit
:help
echo.
echo --- Directory and drive changer ---
echo     --- v1.00 by Hans v. K. ---
echo.
echo usage: cdd [drive] [directory]
echo        e.g. cdd g: \program
echo.
echo /?, /h or no input gives this help information.
echo.
:exit
