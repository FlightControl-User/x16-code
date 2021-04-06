echo $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]
x16emu -echo -sdcard "C:\SDCARD\X16.vhd" -prg $filedir\$filename -debug -keymap fr-be
