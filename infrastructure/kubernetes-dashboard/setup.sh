# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml

# To set up an admin user with far too much priviledge!
kubectl apply -f dashboard-service-account.yml
kubectl apply -f dashboard-cluster-role-binding.yml

# Use this or the next command to get a token to log into the dashboard.
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
kubectl -n kubernetes-dashboard describe secret
