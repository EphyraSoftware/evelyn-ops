Make sure you have run
`apt install lvm2`
before installing ceph, otherwise OSDs get confused by reboots.

Log into the dashboard with `admin` as the username and get the password using
`kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo`

Connect to the toolbox with
`kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') bash`
