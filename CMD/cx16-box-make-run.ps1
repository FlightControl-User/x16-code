echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]

#$filedir="D:\Users\svenv\OneDrive\Documents\GitHub\X16_Code"
diskpart /s cmd/attach.dsk
Remove-Item -Path X:\* -Recurse
copy $workspacedir/$dir/../graphics/*.BIN X:/ -Verbose -Recurse
copy $workspacedir/$dir/../target/*.prg X:/ -verbose
diskpart /s cmd/detach.dsk
box16 -echo -sdcard "C:\SDCARD\CX16.vhd" -sym "$workspacedir/$dir/$file.vs" -vsync none -keymap fr-be -prg $workspacedir/$dir/../target/$file.prg
