FROM solita/ubuntu-systemd:18.04

WORKDIR /

ENV KUBECONFIG=/etc/kubernetes/admin.conf

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    nfs-common \
    curl \
    lxc \
    iptables

RUN curl -sSL https://get.docker.com/ | sh

VOLUME /var/lib/docker

RUN /bin/sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
RUN /bin/sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
RUN apt-get update && apt-get install -y kubelet kubeadm kubectl && apt-get clean
RUN curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
RUN helm init --client-only

COPY hyperkube.tar .
COPY config.yaml .
COPY init.sh .
RUN chmod +x init.sh
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
