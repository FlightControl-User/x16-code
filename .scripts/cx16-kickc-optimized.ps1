& "./.scripts/cx16-config.ps1" $args[0] $args[1] $args[2]

# Optimized compile
java -jar "$kickc_jar" -I "$user_include" -I "$kickc_stdinclude" -L "$user_lib" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -t=cx16 -a -Sc -Si -v  -Ocoalesce -Xassembler=-symbolfile -odir "$workspacedir/$dir/../target" "$workspacedir/$dir/$file"


Remove-Item -path "$workspacedir/$dir/../target/*.dbg"
$filelower = $file.ToString().Replace(".c","") + ".prg"
$fileupper = $file.ToString().ToUpper().Replace(".C","") + ".PRG"
Rename-Item -path "$workspacedir/$dir/../target/$filelower" -NewName $fileupper
