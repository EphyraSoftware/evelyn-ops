$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Push-Location $scriptDir
$outputs = $(terraform output -json | ConvertFrom-Json -AsHashTable)
Pop-Location

$certKey = $outputs["client-cert-key"]["value"]
$certPem = $outputs["client-cert-pem"]["value"]
$caBundle = $outputs["ca-bundle"]["value"]

$keyPath = "$scriptDir\key.pem"
Set-Content -Path $keyPath -Value $certKey
$certPath = "$scriptDir\cert.pem"
Set-Content -Path $certPath -Value $certPem
$caBundlePath = "$scriptDir\ca-bundle.pem"
Set-Content -Path $caBundlePath -Value $caBundle

$env:EVELYN_CI_BUILDCTL = "buildctl --addr tcp://buildkit.evelyn.internal:443 --tlscacert $caBundlePath --tlscert $certPath --tlskey $keyPath"
