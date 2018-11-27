FROM bash:latest as helm
WORKDIR /src
RUN apk update && apk --no-cache add ca-certificates wget openssl
ENV HELM_INSTALL_DIR="/src"
RUN wget -q -O- https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash >/dev/null 2>&1; exit 0

FROM centos:7
ENV KUBECONFIG=/etc/kubernetes/admin.conf
WORKDIR /src
ADD kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN yum -y update && yum install -y epel-release
RUN yum -y update && yum install -y ca-certificates git which kubectl gcc gcc-c++.x86_64 boost-devel.x86_64 zlib-devel openssl-devel libcurl-devel subversion.x86_64 yaml-cpp-devel.x86_64 python-pip
RUN yum clean all && rm -rf /var/cache/yum
COPY --from=helm /src/helm /usr/local/bin/helm
RUN mkdir /root/.kube
RUN curl http://jenkins.slateci.io/artifacts/slate-linux.tar.gz -O
RUN tar xzf slate-linux.tar.gz && chmod +x slate && mv slate /usr/bin/
RUN curl http://jenkins.slateci.io/artifacts/slate-api-server.tar.gz -O
RUN tar xzf slate-api-server.tar.gz && rm -f slate-api-server.tar.gz && mv slate-service /usr/bin/
RUN curl http://jenkins.slateci.io/artifacts/static/aws-sdk-cpp-dynamodb-libs-1.5.25-1.el7.centos.x86_64.rpm -O
RUN yum install -y aws-sdk-cpp-dynamodb-libs-1.5.25-1.el7.centos.x86_64.rpm
WORKDIR /opt/slate-portal
RUN rm -rf /src
RUN pip install virtualenv
RUN git clone https://github.com/slateci/prototype-portal.git .
RUN bash -c 'virtualenv venv && source venv/bin/activate && pip install --no-cache-dir -r requirements.txt'
WORKDIR /
RUN dd if=/dev/urandom of=encryptionKey bs=1024 count=1
