$info = Get-Content src/info.json | ConvertFrom-Json
$path = "$env:APPDATA/factorio/mods/$($info.name)"
if (Test-Path $path) {
	Remove-Item -R $path
}
Copy-Item -R src/ $path
