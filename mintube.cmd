@ECHO off
setlocal

set param=%~1

IF "%param%" == "" (
    set /p param="Enter Video ID or CSV file: "
)
IF "%param%" == "" (
    echo parameter is empty
    exit /b
)

call :SETFILE %param%
IF "%extension%"==".csv" (
    CALL :PLAYLIST %param%
    exit /b
)
set vid=%name%
call :PLAYVID
exit /b


:PLAYLIST
set /a cnt=0
set arr[0]=
for /F "skip=1 tokens=1,2 usebackq delims=," %%A in ("%1") do (
    call :CNTUP "%%A" %%B
)
:SELECT
set /p channel="Select Channel: "
call set vid=%%arr[%channel%]%%
IF "%vid%"=="" echo Index out of range
call :PLAYVID
exit /b

:CNTUP
set /a cnt=cnt+1
echo|set /p=%cnt% 
echo %1
set arr[%cnt%]=%2
exit /b


:PLAYVID
if "%vid%"=="" call :SETVID
if "%vid%"=="" (
    echo Video ID is empty
    exit /b
)
.\mpv\mpv https://www.youtube.com/watch?v=%vid% --include=".\mpv.conf" --profile=min
exit /b


:SETVID
IF "%vid%"=="" (
    set /p vid="Enter V=: "
)
exit /b


:SETFILE
    set name=%~n1
    set extension=%~x1
exit /b
