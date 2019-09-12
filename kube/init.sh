#!/bin/bash
set -e
# DNS for kubelet
echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf
echo "FallbackDNS=8.8.4.4" >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved

# Import cached hyperkube image
# docker pull k8s.gcr.io/hyperkube:v1.14.0 && docker save -o hyperkube.tar k8s.gcr.io/hyperkube:v1.14.0
# docker load -i /hyperkube.tar
# rm -f /hyperkube.tar

# Try grabbing packages manually instead of hyperkube
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

# Deploy Kubernetes
kubeadm init --config config.yaml --ignore-preflight-errors=all
# Remove master taint
kubectl taint nodes --all node-role.kubernetes.io/master-
# Calico
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/etcd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/rbac.yaml
kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/calico.yaml
kubectl rollout status ds/calico-node -n kube-system
systemctl restart kubelet
# Tiller (Helm)
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
