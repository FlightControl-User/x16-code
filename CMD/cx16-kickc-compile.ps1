echo $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]

$user_dev = (Get-Location).Path
$kickc = Get-Content Env:KICKC # Returns the environment variable of KICKC defined on the system.
$kickc_dev = Get-Content Env:KICKCDEV # Returns the environment variable of KICKCDEV defined on the system.

$kickc_stdlib = ($kickc_dev + "\src\main\kc\lib")
$kickc_stdinclude = ($kickc_dev + "\src\main\kc\include")
$kickc_fragment_home = ($kickc_dev + "\src\main\fragment")
$kickc_platform_home = ($kickc_dev + "\src\main\kc\target")
$kickc_jar = ($kickc + "\jar\kickc-release.jar")
$user_lib = ($user_dev + "\cx16_lib")
$user_include = ($user_dev + "\cx16_include")

Write-Output ("kickc = " + $kickc)
Write-Output ("kickc_dev = " + $kickc_dev)
Write-Output ("kickc_stdinclude = " + $kickc_stdinclude)
Write-Output ("kickc_stdlib = " + $kickc_stdlib)
Write-Output ("kickc_fragment_home = " + $kickc_fragment_home)
Write-Output ("kickc_platform_home = " + $kickc_platform_home)
Write-Output ("kickc_jar = " + $kickc_jar)
Write-Output ("user_lib = " + $user_lib)
Write-Output ("user_include = " + $user_include)


#java -jar "$kickc_jar" -I "$user_include" -I "$kickc_stdinclude" -L "$user_lib" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -t=cx16 -a -Sc -Si -vasmout -Xassembler=-symbolfile "$filedir/$filename"
java -jar "$kickc_jar" -I "$user_include" -I "$kickc_stdinclude" -L "$user_lib" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -t=cx16 -a -Sc -Si -Onouplift -vasmout -Xassembler=-symbolfile "$filedir/$filename"
