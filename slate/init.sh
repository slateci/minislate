#!/bin/bash
echo Waiting for SLATE server
for i in 1 2 3 4 5 6 7 8 
do
   sleep 4
   echo "..."
done
set -e
bold=$(tput bold)
normal=$(tput sgr0)
kubectl config set clusters.default.server https://kube:6443
slate group create my-group --field 'Resource Provider'
slate cluster create my-cluster --group my-group --org SLATE --no-ingress -y --kubeconfig /etc/rancher/k3s/k3s.yaml
printf "\n${bold}=============================================================\n${normal}"
printf "\n${bold}Default Group:${normal} my-group\n${bold}Default Cluster:${normal} my-cluster\n"
