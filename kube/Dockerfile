FROM solita/ubuntu-systemd:18.04

WORKDIR /

ENV KUBECONFIG=/etc/rancher/k3s/k3s.yaml

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    nfs-common \
    curl \
    lxc \
    iptables \
    gnupg-agent \
    lsof

# This directory needs to be on a "real" filesystem, so it is volumed to the host
VOLUME /var/lib/docker

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker-ce.list
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y docker-ce && apt-get clean

# Increase vm.max_map_count, originally for elasticsearch
RUN echo "vm.max_map_count=262144" >> /etc/sysctl.conf

COPY kube/config.yaml .
COPY kube/init.sh .
COPY kube/calico.yaml .

RUN chmod +x init.sh
EXPOSE 30000-30100
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
