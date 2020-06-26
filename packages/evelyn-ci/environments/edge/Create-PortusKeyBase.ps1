$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$keyBasePath = "${scriptDir}\..\..\modules\portus\secrets\keybase.secret.txt"

Write-Output "Checking if the key base already exists"
if (-Not (Test-Path $keyBasePath)) {
    Write-Output "Not found, creating now"
    openssl rand -out $keyBasePath -hex 64
} else {
    Write-Output "Already exists"
}
