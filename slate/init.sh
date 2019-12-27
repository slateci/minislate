#!/bin/bash
set -e
bold=$(tput bold)
normal=$(tput sgr0)
kubectl config set clusters.default.server https://kube:6443
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install --namespace kube-system --set nfs.server=nfs --set nfs.path=/ --set storageClass.defaultClass=true stable/nfs-client-provisioner --generate-name
slate group create my-group --field 'Resource Provider'
slate cluster create my-cluster --group my-group --org SLATE --no-ingress -y
printf "\n${bold}=============================================================\n${normal}"
printf "\n${bold}Default Group:${normal} my-group\n${bold}Default Cluster:${normal} my-cluster\n"
