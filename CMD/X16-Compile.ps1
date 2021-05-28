echo $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]
#$filedir="C:\Users\svenv\OneDrive\Documents\GitHub\X16_Code"
kickc_dev -t=cx16 -a -Sc -Si -Ocoalesce -Xassembler=-symbolfile "${filedir}/${filename}"
