& "./.scripts/cx16-config.ps1" $args[0] $args[1] $args[2]



#Fragment compile
java -jar "$kickc_jar" -I "$user_include" -I "$kickc_stdinclude" -L "$user_lib" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -v -fragment "$file" -t=cx16 -a  -Sc -Si -Onouplift -vasmout -Xassembler=-symbolfile

