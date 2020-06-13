Function Extract-Token {
    Param(
        [string]$PatternPrefix
    )

    $tokenMatch = Get-Content \\nas.evelyn.internal\terraform\.files\vault\init.txt | Select-String -Pattern "$PatternPrefix`: (.*)"
    $tokenMatch.Matches.Groups[1].Value
}

$unsealToken1 = Extract-Token -PatternPrefix 'Unseal Key 1'
$unsealToken2 = Extract-Token -PatternPrefix 'Unseal Key 2'
$unsealToken3 = Extract-Token -PatternPrefix 'Unseal Key 3'

$podName = $(kubectl -n vault get pods -o=jsonpath='{.items[0].metadata.name}')

kubectl -n vault exec $podName -- sh -c "vault operator unseal $unsealToken1"
kubectl -n vault exec $podName -- sh -c "vault operator unseal $unsealToken2"
kubectl -n vault exec $podName -- sh -c "vault operator unseal $unsealToken3"
