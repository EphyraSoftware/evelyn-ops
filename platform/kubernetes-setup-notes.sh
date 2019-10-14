#
#
# Docker installation
#
#

apt update

apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt update

apt install docker-ce=5:18.09.9~3-0~debian-buster

apt-mark hold docker-ce

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

#
#
# Verify machine before installation
#
#

# Should have unique MAC address
ip link

# Should have unique product uuid
cat /sys/class/dmi/id/product_uuid

# Disable SWAP
blkid # Look for TYPE="swap"
lsblk # Identify swap partition
swapoff /dev/mapper/centos-swap # Remove specific swap
swapoff -a # Remove all swap
vi /etc/fstab # To disable permanently, comment out the swap line in here.
rm -rf /dev/sda5 # Remove swap to tidy up
reboot # Restart needed
lsblk # To check it's worked

# Two missing packages on buster for the next section
apt install arptables
apt install ebtables
# Legacy mode required for iptables
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy

#
#
# Install the bits
#
#
apt update && apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Pick a pod network addon before starting! Cilium at first try
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network

# Initialise the cluster
kubeadm init --pod-network-cidr=10.217.0.0/16

# Your Kubernetes control-plane has initialized successfully!

# To start using your cluster, you need to run the following as a regular user:

adduser kubeaccount
usermod -aG sudo kubeaccount

#   mkdir -p $HOME/.kube
#   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#   sudo chown $(id -u):$(id -g) $HOME/.kube/config

# This is important!
kubectl taint nodes poweredge1 node-role.kubernetes.io/master:NoSchedule-

# Get Helm...
cd ~; curl -L https://get.helm.sh/helm-v3.0.0-beta.4-linux-amd64.tar.gz -o helm.tar.gz
tar xzvf helm.tar.gz
cd linux-amd64/
sudo mv helm /usr/local/bin

# Or I could have done
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.6/install/kubernetes/quick-install.yaml
# If I'd waited a bit and slowed down lol.

# So the first method didn't work follow this https://docs.cilium.io/en/v1.6/gettingstarted/k8s-install-default/

# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#   https://kubernetes.io/docs/concepts/cluster-administration/addons/

# Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.170:6443 --token pud9mo.460oor1h5clp94sy \
    --discovery-token-ca-cert-hash sha256:***
