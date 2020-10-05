#!/bin/bash
echo Waiting for SLATE server
for i in 1 2 3 4 5 6 7 8 
do
   sleep 4
   echo "..."
done
set -e
kubectl config set clusters.default.server https://kube:6443
slate group create my-group --field 'Resource Provider'
slate cluster create my-cluster --group my-group --org SLATE --no-ingress -y --kubeconfig /etc/rancher/k3s/k3s.yaml
echo -e "\e[1m=============================================================\e[0m"
echo -e "\e[1mDefault Group: my-group\nDefault Cluster: my-cluster\e[0m"
