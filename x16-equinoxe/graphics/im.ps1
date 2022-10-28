

#magick "%d.png[0-25]" ( "%d.png[0-25]" -channel A -threshold 50% -quantize transparent +dither -colors 15 +remap -trim +repage -resize 64x64 -gravity center -background black -extent 64x64 +append color.gif ) -remap color.gif +adjoin "e001_64x64_%02d.png"

$source=$args[0]
$target=$args[1]
$mask=$args[2]
$name=$args[3]
$size=$args[4]

Write-Output ( "equinoxe graphics converter: " )
Write-Output ( "source = " + $source )
Write-Output ( "target = " + $target )
Write-Output ( "mask = " + $mask ) 
Write-Output ( "name = " + $name ) 
Write-Output ( "size = " + $size )

$read = $source + "\" + $mask
$color = $target + "\" + $name + "_color.gif"
$file = $target + "\" + $name + "_" + $size + "_%02d.png"
. magick "$read" +repage -resize $size -channel A -ordered-dither o2x2 -colors 16  +adjoin "$file"

#. magick "$read" -channel A -threshold 50% -quantize transparent +dither -trim +repage -resize $size -gravity center -background transparent -extent $size -remap "$color" +adjoin "$file"
