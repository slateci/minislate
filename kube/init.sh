#!/bin/bash
# DNS for kubelet
echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf
echo "FallbackDNS=8.8.4.4" >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
systemctl restart kubelet
# Install Kubernetes
kubeadm init --config config.yaml --ignore-preflight-errors=all
#kubeadm init --ignore-preflight-errors=all --pod-network-cidr=192.168.0.0/16 --apiserver-cert-extra-sans kube
export KUBECONFIG=/etc/kubernetes/admin.conf
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
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
# Default hostPath StorageClass
kubectl apply -f https://github.com/kubernetes/minikube/raw/master/deploy/addons/storage-provisioner/storage-provisioner.yaml
kubectl apply -f https://github.com/kubernetes/minikube/raw/master/deploy/addons/storageclass/storageclass.yaml
