echo $args[0] $args[1]
$filedir=$args[0]
$filename=$args[1]
#$filedir="C:\Users\svenv\OneDrive\Documents\GitHub\X16_Code"

kickc_dev -t=cx16 -a -Sc -Si -Onouplift -Xassembler=-symbolfile "${filedir}/${filename}" 
# kickc_dev -t=cx16 -fragment pbuz1_derefidx_vbuc1_eq_vbuc2_then_la1
# kickc_dev -t=cx16 -v -vfragment -a -Sc -Si -Onouplift -Xassembler=-symbolfile "d:/Users/svenv/OneDrive/Documents/GitHub/X16_Code/cx16-equinoxe/equinoxe-flightengine.c"
# kickc_dev -t=cx16 -a -Sc -Si -Onouplift -Xassembler=-symbolfile "d:/Users/svenv/OneDrive/Documents/GitHub/X16_Code/cx16-equinoxe/equinoxe-flightengine.c"
