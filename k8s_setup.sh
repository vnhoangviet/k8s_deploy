#!/usr/bin/bash
sudo echo "10.10.1.101 master01.9prints.internal" >> /etc/hosts
sudo echo "10.10.1.102 worker01.9prints.internal" >> /etc/hosts
sudo echo "10.10.1.103 worker02.9prints.internal" >> /etc/hosts
sudo firewall-cmd --permanent --add-port={179/tcp,5473/tcp,6443/tcp,2379/tcp,2380/tcp,10250/tcp,10251/tcp,10252/tcp,10255/tcp,4789/udp}
sudo firewall-cmd --permanent --add-masquerade
sudo firewall-cmd --reload
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
sudo dnf clean all ; sudo dnf makecache 
sudo dnf -y install epel-release vim git curl iproute-tc wget kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sudo dnf clean all ; sudo dnf makecache 
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf clean all ; sudo dnf makecache 
yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin iscsi-initiator-utils -y
sudo mkdir -p /etc/containerd 
sudo containerd config default > /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
lsmod | grep br_netfilter
sudo systemctl enable kubelet
sudo systemctl start systemd-resolved
sudo systemctl enable systemd-resolved
sudo kubeadm config images pull
sudo curl -L https://github.com/projectcalico/calico/releases/download/v3.24.5/calicoctl-linux-amd64 -o /bin/calicoctl ; sudo chmod +x /bin/calicoctl ; sudo ln -s /bin/calicoctl /usr/local/bin/calicoctl
sudo cp /vagrant/calico.conf /etc/NetworkManager/conf.d/
sudo systemctl restart NetworkManager
sudo systemctl enable --now iscsid
