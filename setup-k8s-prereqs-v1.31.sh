#!/bin/sh -x

# Setup the kubernetes preprequisites
#
echo $(hostname -i) $(hostname) >> /etc/hosts
sudo sed -i "/swap/s/^/#/" /etc/fstab
sudo swapoff -a
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /
EOF

KUBE_DPKG_VERSION=1.31.2-1.1
apt-get update
apt-get install -y ebtables ethtool
apt-get install -y docker.io
＃拉取正确的 Pause 镜像（解决警告）
sudo docker pull registry.k8s.io/pause:3.10
apt-get install -y apt-transport-https
apt-get install -y kubelet=$KUBE_DPKG_VERSION kubeadm=$KUBE_DPKG_VERSION kubectl=$KUBE_DPKG_VERSION
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

. /etc/os-release
if [ "$UBUNTU_CODENAME" = "bionic" ]; then
    modprobe br_netfilter
fi
sysctl net.bridge.bridge-nf-call-iptables=1
