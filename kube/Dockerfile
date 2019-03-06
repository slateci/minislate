FROM solita/ubuntu-systemd:18.04

WORKDIR /

ENV KUBECONFIG=/etc/kubernetes/admin.conf

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    nfs-common \
    curl \
    lxc \
    iptables \
    gnupg-agent

VOLUME /var/lib/docker

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker-ce.list
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y docker-ce kubelet kubeadm kubectl && apt-get clean
RUN curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
RUN helm init --client-only

COPY hyperkube.tar .
COPY config.yaml .
COPY init.sh .
RUN chmod +x init.sh
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
