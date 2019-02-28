#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)
helm init --service-account tiller
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system
helm install --namespace kube-system --set nfs.server=nfs --set nfs.path=/ stable/nfs-client-provisioner
pip install -r /opt/slate-portal/requirements.txt
sed -i 's/localhost/0\.0\.0\.0/g' /opt/slate-portal/run_*
cd /opt/slate-portal && ./run_portal.py &
slate group create ms-group --field 'Resource Provider'
slate cluster create ms-c --group ms-group --org SLATE -y
printf "\n=============================================================\n"
printf "\n${bold}Default Group:${normal} ms-group\n${bold}Default Cluster:${normal} ms-c\n\n"
