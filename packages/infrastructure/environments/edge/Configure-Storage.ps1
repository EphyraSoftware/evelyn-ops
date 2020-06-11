$className = $(kubectl get storageclass -o=jsonpath='{.items[0].metadata.name}')

Write-Output "Marking storage class [${className}] as default."

kubectl patch storageclass $className -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"}}}'

kubectl get storageclass
