$token = .\Get-RootToken.ps1
$env:VAULT_TOKEN="$token"
$env:VAULT_ADDR='http://localhost:8200'