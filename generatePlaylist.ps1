#Author:	Jack Hatch
#Filename:	playlistGenerate.txt
#Purpose:	To automatically create a folder with all the songs in a playlist in a given folder from a M3U file (assuming the file paths are correct).


$m3uPath = Read-Host "Enter M3U playlist file directory path(including name)"	#takes user input

$destination = Read-Host "Enter the directory path of the destination folder"


#Tests if file directory exists
if ((-not (Test-Path -LiteralPath $destination)) -or (-not (Test-Path -LiteralPath $m3uPath))) {
	Write-Host "Error: Given directory does not exist for either the file or folder given."
    return
}

Get-Content $m3uPath -Encoding UTF8 | ForEach-Object {

	$line = $_.Trim()	
    

	if ($line -eq "" -or $line.StartsWith("#")) {
		return
	}

	$fullDir = Split-Path $line -Parent
	$fileDir1 = Split-Path $fullDir -Parent     #gets the artist and album the song is from via filepath

	$fullPath = Join-Path $destination (Join-Path (Split-Path $fileDir1 -Leaf) (Split-Path $fullDir -Leaf))

	if (-not (Test-Path  $fullPath )) {	#tests if the artist is already in the directory
		New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
	}


	if (Test-Path -LiteralPath $line) {
		Copy-Item -LiteralPath $line -Destination $fullPath -Force
	
	}else {
		Write-Warning "Directory not found: $line"
	}

}