echo $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]
x16emu -echo -sdcard "D:\Users\svenv\OneDrive\Documents\GitHub\X16_Code\VHD\X16.vhd" -prg $filedir\$filename -debug
