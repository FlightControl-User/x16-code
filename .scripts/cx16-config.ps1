$global:workspacedir=$args[0]
$global:dir=$args[1]
$global:file=$args[2]
echo $args[0] $args[1] $args[2]

$global:user_dev = ($workspacedir)
$global:kickc = Get-Content Env:KICKC # Returns the environment variable of KICKC defined on the system.
$global:kickc_dev = Get-Content Env:KICKCDEV # Returns the environment variable of KICKCDEV defined on the system.

$global:kickc_stdlib = ($kickc_dev + "\src\main\kc\lib")
$global:kickc_stdinclude = ($kickc_dev + "\src\main\kc\include")
$global:kickc_fragment_home = ($kickc_dev + "\src\main\fragment")
$global:kickc_platform_home = ($kickc_dev + "\src\main\kc\target")
$global:kickc_jar = ($kickc + "\jar\kickc-release.jar")
$global:user_lib = ($user_dev + "\lib")
$global:user_include = ($user_dev + "\inc")

Write-Output ("user_dev = " + $user_dev)
Write-Output ("user_lib = " + $user_lib)
Write-Output ("user_include = " + $user_include)
Write-Output ("kickc = " + $kickc)
Write-Output ("kickc_dev = " + $kickc_dev)
Write-Output ("kickc_stdinclude = " + $kickc_stdinclude)
Write-Output ("kickc_stdlib = " + $kickc_stdlib)
Write-Output ("kickc_fragment_home = " + $kickc_fragment_home)
Write-Output ("kickc_platform_home = " + $kickc_platform_home)
Write-Output ("kickc_jar = " + $kickc_jar)

cd (Get-Location).Path