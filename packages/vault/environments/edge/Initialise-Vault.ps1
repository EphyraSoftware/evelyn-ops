$podName = $(kubectl -n vault get pods -o=jsonpath='{.items[0].metadata.name}')

kubectl -n vault exec $podName -- sh -c 'vault operator init > /tmp/init.txt'

kubectl cp vault/$podName`:/tmp/init.txt init.txt

New-Item -ItemType Directory -Force -Path \\nas.evelyn.internal\terraform\.files\vault
Move-Item -Force -Path init.txt -Destination \\nas.evelyn.internal\terraform\.files\vault\init.txt

kubectl -n vault exec $podName -- sh -c 'rm /tmp/init.txt'
