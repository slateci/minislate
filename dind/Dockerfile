FROM centos/systemd

RUN yum install -y ca-certificates curl lxc iptables
    
RUN curl -sSL https://get.docker.com/ | sh > /dev/null
RUN systemctl enable docker.service

VOLUME /var/lib/docker

ADD ./kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN yum install -y kubelet kubeadm kubectl && yum clean all && rm -rf /var/cache/yum

ADD 10-kubeadm.conf /etc/systemd/system/kubelet.service.d/
ADD config.yaml /etc/systemd/system/kubelet.service.d/

RUN systemctl enable kubelet.service

ADD ./init.sh .
RUN chmod +x ./init.sh
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
