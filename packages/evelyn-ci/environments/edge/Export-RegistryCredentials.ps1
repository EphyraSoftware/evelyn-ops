$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Push-Location $scriptDir
$outputs = $(terraform output -json | ConvertFrom-Json -AsHashTable)
Pop-Location

$env:REGISTRY_USERNAME = $outputs["registry-username"]["value"]
$env:REGISTRY_PASSWORD = $outputs["registry-password"]["value"]
