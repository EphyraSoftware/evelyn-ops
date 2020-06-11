$podName = $(kubectl -n vault get pods -o=jsonpath='{.items[0].metadata.name}')
Write-Output $podName

kubectl -n vault exec $podName -- ls
