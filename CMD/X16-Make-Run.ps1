echo $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]
#$filedir="D:\Users\svenv\OneDrive\Documents\GitHub\X16_Code"
diskpart /s cmd/attach.dsk
Remove-Item -Path X:\* -Recurse
copy $filedir\Target\* X:\ -verbose
copy $filedir\*.prg X:\ -verbose
diskpart /s cmd/detach.dsk
x16emu -echo -sdcard "C:\SDCARD\X16.vhd" -prg $filedir\$filename -debug -keymap fr-be
