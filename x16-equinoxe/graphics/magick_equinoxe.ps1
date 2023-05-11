

#magick "%d.png[0-25]" ( "%d.png[0-25]" -channel A -threshold 50% -quantize transparent +dither -colors 15 +remap -trim +repage -resize 64x64 -gravity center -background black -extent 64x64 +append color.gif ) -remap color.gif +adjoin "e001_64x64_%02d.png"

$source=$args[0]
$target=$args[1]
$mask=$args[2]
$name=$args[3]
$size=$args[4]

Write-Output ( "equinoxe graphics inputs: " )
Write-Output ( "mask = " + $mask ) 
Write-Output ( "name = " + $name ) 
Write-Output ( "size = " + $size )
Write-Output ( "source = " + $source )
Write-Output ( "target = " + $target )

$read = $source + "\" + $mask
$blender = $target + "\" + $name + "_blender.png" 
$color = $target + "\" + $name + "_color.gif"
$sheet = $target + "\" + $name + "_sheet_" + $size + ".png"

Write-Output ( "outputs: " )
Write-Output ( "blender = " + $blender ) 
Write-Output ( "color = " + $color ) 
Write-Output ( "sheet = " + $sheet )

. magick montage "$read" -quantize transparent -background transparent -tile x1 -geometry $size "$blender"
. magick "$blender" -channel A -threshold 50%   +dither -colors 16 +remap +append "$color"
#. magick "$read" -channel A -threshold 50% -quantize transparent +dither -trim +repage -resize $size -gravity center -background transparent -extent $size -remap "$color" +adjoin "$file"
. magick "$blender" -channel A -threshold 50% -quantize transparent +dither -background transparent -remap "$color" +adjoin "$sheet"
