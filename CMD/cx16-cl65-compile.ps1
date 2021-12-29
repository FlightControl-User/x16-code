Write-Output  $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]

$user_dev = (Get-Location).Path

$user_lib = ($user_dev + "\cx16_lib")
$user_include = ($user_dev + "\cx16_include")

Write-Output ("user_dev = " + $user_dev)
Write-Output ("user_lib = " + $user_lib)
Write-Output ("user_include = " + $user_include)


cl65 -I $user_include -L $user_lib -t cx16 -v -O "$filedir/$filename" 
