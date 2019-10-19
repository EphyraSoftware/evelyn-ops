# https://rook.io/
# https://ceph.io/

# Make sure you have run
apt install lvm2
# Before installing ceph, otherwise OSDs get confused by reboots.

git clone https://github.com/rook/rook
git checkout release-1.1
cd cluster/examples/kubernetes/ceph

# To prepare any devices which you want to be used by Ceph, you'll need to wipe them using
wipefs -a /dev/device
# Find the devices you want with lsblk
# If you have already launched the operator and want to scan for disks again (should happen automatically, but to foce it) run
kubectl -n rook-ceph delete pod -l app=rook-ceph-operator

kubectl create -f common.yaml
kubectl create -f operator.yaml
kubectl create -f cluster.yaml

# Note that the provided copies of the 3 files from above, should be diffed and updated! This is because
# some settings have been changed.

# Set up the storage class for use with PVCs
kubectl create -f storageclass-test.yml

# To expose the dashboard
kubectl create -f dashboard-external.yml

# Navigate to https://<kubernetes-cluster-public-ip>:<node-port>
# Login with admin as the username and get the password using
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo

# Lastly, you may want the toolbox
kubectl create -f toolbox.yml
# and connect
kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash

# If you have issues with tearing down the namespace
kubectl -n rook-ceph patch cephclusters.ceph.rook.io rook-ceph -p '{"metadata":{"finalizers": []}}' --type=merge

# Useful instructions here on cleaning up OSDs https://gist.github.com/cheethoe/49d9c1d0003e44423e54a060e0b3fbf1
