echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]

#$filedir="D:\Users\svenv\OneDrive\Documents\GitHub\X16_Code"
diskpart /s cmd/attach.dsk
Remove-Item -Path X:\* -Recurse
echo "Copying graphics"
copy-item  -Verbose -Recurse -Force -Path "$workspacedir/$dir/../graphics/*/*.BIN" "X:/"
echo "Copying Program"
copy-item -Verbose -Path "$workspacedir/$dir/../target/*.prg" "X:/" 
diskpart /s cmd/detach.dsk
x16emu -echo -sdcard "C:\SDCARD\CX16.vhd" -prg $workspacedir\$dir\..\target\$file.prg -debug -keymap fr-be
