#!/bin/bash -x

sudo swapoff -a
sudo apt-get update -y
sudo systemctl stop ufw && ufw disable && iptables -F

echo "===========download rke2============"
curl -sfL https://get.rke2.io | sudo  sh -

sudo systemctl enable rke2-server.service

sudo mkdir -p /etc/rancher/rke2/



sudo cat <<EOF > /etc/rancher/rke2/config.yaml
write-kubeconfig-mode: "0644"
tls-san:
  - $EXTERNAL_IP
etcd-expose-metrics: true
EOF

echo "=======rke2-server start============"
sudo systemctl start rke2-server.service

# kubeconfig
echo "=====kubeconfig settings======="
mkdir -p ~/.kube/
cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
sudo cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin
export PATH=$PATH:/var/lib/rancher/rke2/bin/
echo 'export PATH=/usr/local/bin:/var/lib/rancher/rke2/bin:$PATH' >> ~/.bashrc

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc


