#!/usr/bin/bash
sudo yum install tar wget unzip vim epel-release open-vm-tools iproute-tc nfs-utils -y 
sudo systemctl enable remote-fs.target
sudo yum install screen -y
sudo yum update -y 
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
sudo reboot
