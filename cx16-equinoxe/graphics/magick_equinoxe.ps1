

#magick "%d.png[0-25]" ( "%d.png[0-25]" -channel A -threshold 50% -quantize transparent +dither -colors 15 +remap -trim +repage -resize 64x64 -gravity center -background black -extent 64x64 +append color.gif ) -remap color.gif +adjoin "e001_64x64_%02d.png"

$mask=$args[0]
$name=$args[1]
$size=$args[2]
$source=$args[3]
$target=$args[4]

Write-Output ( "equinoxe graphics converter: " )
Write-Output ( "name = " + $mask ) 
Write-Output ( "name = " + $name ) 
Write-Output ( "size = " + $size )
Write-Output ( "source = " + $source )
Write-Output ( "target = " + $target )

$read = $source + "\" + $mask
$color = $target + "\" + $name + "_color.gif"
$file = $target + "\" + $name + "_" + $size + "_%02d.gif"
. magick "$read" -channel A -threshold 50% -quantize transparent +dither -colors 16 +remap +append "$color"
. magick "$read" -channel A -threshold 50% -quantize transparent +dither -trim +repage -resize $size -gravity center -background transparent -extent $size -remap "$color" +adjoin "$file"
