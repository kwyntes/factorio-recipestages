$info = Get-Content src/info.json | ConvertFrom-Json
$filename = "$($info.name)_$($info.version)"
Copy-Item -R src/ $filename
if (Test-Path "$filename.zip") {
	Remove-Item "$filename.zip"
}
Compress-Archive $filename "$filename.zip"
Remove-Item -R $filename
