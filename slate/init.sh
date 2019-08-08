#!/bin/bash
set -e
bold=$(tput bold)
normal=$(tput sgr0)
helm init --service-account tiller
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system
helm install --namespace kube-system --set nfs.server=nfs --set nfs.path=/ --set storageClass.defaultClass=true stable/nfs-client-provisioner
pip install -r /opt/slate-portal/requirements.txt
slate group create my-group --field 'Resource Provider'
slate cluster create my-cluster --group my-group --org SLATE --no-ingress -y
printf "\n${bold}=============================================================\n${normal}"
printf "\n${bold}Default Group:${normal} my-group\n${bold}Default Cluster:${normal} my-cluster\n"
echo "Deploying squid proxy instance..."

cat << EOF > squidconfig
Instance: cvmfs
Service:
  Port: 3128
  ExternalVisibility: ClusterIP
SquidConf:
  CacheMem: 128
  CacheSize: 10000
IPRange: 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
EOF

slate app install osg-frontier-squid --cluster my-cluster --group my-group --conf squidconfig

rm -rf squidconfig

export CLUSTER_IP=$(kubectl get --namespace slate-group-$CLUSTERGROUP -o jsonpath="{.spec.clusterIP}" service osg-frontier-squid-cvmfs)

echo "Adding CVMFS..."

kubectl create namespace cvmfs

git clone https://github.com/Mansalu/prp-osg-cvmfs.git

cd prp-osg-cvmfs

git checkout slate

cd k8s/cvmfs

cat << EOF > default.local 
CVMFS_SERVER_URL="http://cvmfs-s1bnl.opensciencegrid.org:8000/cvmfs/@fqrn@;http://cvmfs-s1fnal.opensciencegrid.org:8000/cvmfs/@fqrn@;http://cvmfs-s1goc.opensciencegrid.org:8000/cvmfs/@fqrn@"
CVMFS_KEYS_DIR=/etc/cvmfs/keys/opensciencegrid.org/
CVMFS_USE_GEOAPI=yes
CVMFS_HTTP_PROXY="http://$CLUSTER_IP:3128"
CVMFS_QUOTA_LIMIT=5000
CVMFS_REPOSITORIES=atlas.cern.ch,atlas-condb.cern.ch,atlas-nightlies.cern.ch,sft.cern.ch,geant4.cern.ch,grid.cern.ch,cms.cern.ch,oasis.opensciencegrid.org
EOF

kubectl create configmap cvmfs-osg-config -n cvmfs --from-file=default.local

kubectl create -f  accounts/

kubectl create -f csi-processes/

kubectl create -f storageclasses/
