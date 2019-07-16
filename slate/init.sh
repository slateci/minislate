#!/bin/bash
set -e
bold=$(tput bold)
normal=$(tput sgr0)
helm init --service-account tiller
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system
helm install --namespace kube-system --set nfs.server=nfs --set nfs.path=/ --set storageClass.defaultClass=true stable/nfs-client-provisioner
pip install -r /opt/slate-portal/requirements.txt
slate group create ms-group --field 'Resource Provider'
slate cluster create ms-c --group ms-group --org SLATE --no-ingress -y
printf "\n${bold}=============================================================\n${normal}"
printf "\n${bold}Default Group:${normal} ms-group\n${bold}Default Cluster:${normal} ms-c\n"
