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
