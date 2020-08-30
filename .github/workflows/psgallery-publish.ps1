Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$ManifestFile = Resolve-Path -Path "*\$ENV:PROJECT_NAME.psd1"
$ModuleFile = Resolve-Path -Path "*\$ENV:PROJECT_NAME.psm1"
$ModulePath = Split-Path -Parent $ModuleFile
$ReleaseNotes = $ENV:RELEASE_NOTES -ireplace "(?s)#{1,} ?Installation.*",""
Update-ModuleManifest -Path $ManifestFile.Path -ReleaseNotes $ReleaseNotes -ModuleVersion $ENV:RELEASE_VERSION
Try {
    Test-ModuleManifest -Path $ManifestFile.Path -ErrorAction Stop
    Publish-Module -Path $ModulePath -NuGetApiKey $ENV:PSGALLERY_APIKEY -Force -ErrorAction Stop
}
Catch {
    Throw "Unable to publish module: $_"
}