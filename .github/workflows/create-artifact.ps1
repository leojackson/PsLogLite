$ManifestFile = Resolve-Path -Path "*\$ENV:PROJECT_NAME.psd1"
Update-ModuleManifest -Path $ManifestFile.Path -ReleaseNotes '' -ModuleVersion $ENV:RELEASE_VERSION
Compress-Archive -Path ".\$ENV:PROJECT_NAME" -DestinationPath ".\$ENV:PROJECT_NAME-$Env:RELEASE_VERSION.zip" -CompressionLevel Optimal