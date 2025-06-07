@echo off


setlocal


:: Debug = 0, Release = 1
if "%2" == "" (
    set release_mode=0
) else if "%2" == "--debug" (
    set release_mode=0
) else if "%2" == "--release" (
    set release_mode=1
) else (
    goto :HELP
)


set flags=--keep-executable

if %release_mode% equ 0 ( REM Debug
    set flags=%flags% -debug
) else ( REM Release
    set flags=%flags% -o:speed -no-bounds-check -subsystem:windows
)


if        "%1" == "lifegame"        ( goto :LIFEGAME
) else if "%1" == "flappy"          ( goto :FLAPPY
) else                              ( goto :HELP
)


:HELP
    echo Usage : $ run.cmd [directory's name] [--debug^|--release]
    echo   Example: $ run.cmd lifegame           (debug mode)
    echo            $ run.cmd lifegame --debug   (debug mode)
    echo            $ run.cmd lifegame --release (release mode)
goto :EOF


:LIFEGAME
    odin run %1 %flags% -out:%1\%1.exe
goto :EOF

:FLAPPY
    odin run %1 %flags% -out:%1\%1.exe
goto :EOF


REM vim: ft=dosbatch fenc=utf8 ff=dos
