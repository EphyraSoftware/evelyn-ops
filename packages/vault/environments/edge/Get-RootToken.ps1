$selectRootToken = Get-Content \\nas.evelyn.internal\terraform\.files\vault\init.txt | Select-String -Pattern 'Initial Root Token: (.*)'
$rootToken = $selectRootToken.Matches.Groups[1].Value

Write-Output $rootToken
