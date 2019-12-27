#!/bin/bash
set -e
# DNS for kubelet
echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf
echo "FallbackDNS=8.8.4.4" >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved
# K3s
curl -sfL https://get.k3s.io | sh
# Calico
kubectl apply -f calico.yaml


