$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
& "$scriptDir\..\packages\vault\environments\edge\Configure-ShellSession.ps1"
& "$scriptDir\..\packages\evelyn-ci\environments\edge\Configure-BuildKitSession.ps1"
