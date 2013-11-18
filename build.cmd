copy Game.dat Game.exe
::tools\petool.exe dta.exe add .patch rwxci 131072
tools\linker.exe src\main.asm src\main.inc Game.exe tools\nasm.exe -I./include/
