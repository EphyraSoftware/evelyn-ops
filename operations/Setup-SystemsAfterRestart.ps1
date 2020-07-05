$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
& "$scriptDir\..\packages\vault\environments\edge\Unseal-Vault.ps1"
