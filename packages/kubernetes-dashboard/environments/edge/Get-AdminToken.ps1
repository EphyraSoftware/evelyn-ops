$output = terraform output -json | ConvertFrom-Json -AsHashTable
$secretName = $output['admin-secret-name']['value']

$token = kubectl -n kube-system get secret $secretName -o=jsonpath='{.data.token}'

[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($token))