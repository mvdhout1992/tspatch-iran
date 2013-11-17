copy dta.dat dta.exe
::tools\petool.exe dta.exe edit AUTO rwxc
::tools\petool.exe dta.exe add .patch rwxci 131072
tools\linker.exe src\main.asm src\main.inc dta.exe tools\nasm.exe -I./include/
