FROM solita/ubuntu-systemd:18.04

WORKDIR /

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
    
RUN curl -sSL https://get.docker.com/ | sh

VOLUME /var/lib/docker

RUN /bin/sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
RUN /bin/sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
RUN apt-get update && apt-get install -y kubelet kubeadm kubectl && apt-get clean

ADD 10-kubeadm.conf /etc/systemd/system/kubelet.service.d/
ADD config.yaml /etc/systemd/system/kubelet.service.d/

ADD ./init.sh .
RUN chmod +x ./init.sh
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
