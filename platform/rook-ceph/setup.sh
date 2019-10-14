# https://rook.io/
# https://ceph.io/

git clone https://github.com/rook/rook
git checkout release-1.1
cd cluster/examples/kubernetes/ceph

kubectl create -f common.yaml
kubectl create -f operator.yaml
kubectl create -f cluster.yaml

# Note that the provided copies of the 3 files from above, should be diffed and updated! This is because
# some settings have been changed.

# To expose the dashboard
kubectl create -f dashboard-external.yml

# Navigate to https://<kubernetes-cluster-public-ip>:<node-port>
# Login with admin as the username and get the password using
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['user']}" | base64 --decode && echo
