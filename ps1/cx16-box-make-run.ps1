echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]

diskpart /s ps1/attach.dsk
Remove-Item -Path X:\* -Recurse

echo "Copying graphics"
copy-item  -Verbose -Recurse -Force -Path "$workspacedir/$dir/../graphics/*/*.BIN" "X:/"
echo "Copying Program"
copy-item -Verbose -Path "$workspacedir/$dir/../target/*.PRG" "X:/" 
copy-item -Verbose -Path "$workspacedir/$dir/../target/*.BIN" "X:/" 

diskpart /s ps1/detach.dsk

box16 -echo -sdcard "C:\SDCARD\CX16.vhd" -sym "$workspacedir/$dir/$file.vs" -vsync none -keymap fr-be -prg $workspacedir/$dir/../target/$file.prg
