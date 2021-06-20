$path = $PSScriptRoot
write-host $PSScriptRoot

$script:json = ""

function get-folders {
    Param ($path)
    $items = Get-ChildItem -LiteralPath "$path"

    foreach ($item in $items) {
        # List all the folders
        if ($item.Mode -eq "d-----") {
           $script:json += "{"
           $script:json += "`"folder`":`"$item`","
           $script:json += "`"contents`":"
           $script:json += "["

           $itemname = $item.Name
           $fullpath = "$path\$itemname"

           write-host $fullpath
           get-folders $fullpath #Recursively list if it is a directory

           $script:json += "]"
           $script:json += "},"
        }
        # Print out any files
        #if (($item.Mode -eq "-a----") -and ($item.Extension.ToLower() -in @('.apng','.avif','.gif','.jpg','.jpeg','.jfif','.pjpeg','.pjp','.png','.svg','.webp','.bmp','.ico','.cur','.tif','.tiff'))) {
        if ($item.Extension.ToLower() -in @('.apng','.avif','.gif','.jpg','.jpeg','.jfif','.pjpeg','.pjp','.png','.svg','.webp','.bmp','.ico','.cur','.tif','.tiff')) {
           $script:json += "`"$item`","
        }
  }
}

$script:json += "records=["
get-folders $path
$script:json += "]"

#write-host $script:json

$script:json | Out-File -FilePath "$PSScriptRoot\LocalImgShelveJson.txt"
