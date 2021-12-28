Write-Output  $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]

cl65 -t cx16 -O "$filedir/$filename" 
