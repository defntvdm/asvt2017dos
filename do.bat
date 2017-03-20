tasm /m5 /z /zi /la %1.asm 
tlink /t /x %1.obj 
del *.obj>nul
del *.lst > nul
