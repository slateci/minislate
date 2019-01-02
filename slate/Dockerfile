FROM centos:7
ENV KUBECONFIG=/etc/kubernetes/admin.conf
WORKDIR /src
ADD kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN yum install -y ca-certificates git which kubectl gcc gcc-c++.x86_64 boost-devel.x86_64 zlib-devel openssl-devel libcurl-devel subversion.x86_64 openssl which
RUN yum clean all && rm -rf /var/cache/yum
RUN curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | sh
RUN mkdir /root/.kube
RUN curl -s -O http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/y/yaml-cpp-0.5.1-1.el7.2.x86_64.rpm
RUN yum install -y yaml-cpp-0.5.1-1.el7.2.x86_64.rpm
RUN curl -s -O http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/y/yaml-cpp-devel-0.5.1-1.el7.2.x86_64.rpm
RUN yum install -y yaml-cpp-devel-0.5.1-1.el7.2.x86_64.rpm
RUN curl -s -O https://jenkins.slateci.io/artifacts/client/slate-linux.tar.gz
RUN tar xzf slate-linux.tar.gz && chmod +x slate && mv slate /usr/bin/
RUN curl -s -O http://jenkins.slateci.io/artifacts/static/aws-sdk-cpp-dynamodb-libs-1.5.25-1.el7.centos.x86_64.rpm
RUN yum install -y aws-sdk-cpp-dynamodb-libs-1.5.25-1.el7.centos.x86_64.rpm
RUN curl -s -O http://jenkins.slateci.io/artifacts/slate-api-server-0.1.0-1.el7.x86_64.rpm
RUN yum install -y slate-api-server-0.1.0-1.el7.x86_64.rpm
WORKDIR /opt/slate-portal
RUN rm -rf /src
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python
RUN pip install virtualenv
RUN git clone https://github.com/slateci/prototype-portal.git .
RUN bash -c 'virtualenv venv && source venv/bin/activate && pip install --no-cache-dir -r requirements.txt'
WORKDIR /
RUN dd if=/dev/urandom of=encryptionKey bs=1024 count=1
RUN mkdir /root/.slate && mkdir -p /etc/slate/secrets
RUN sh -c 'echo "http://localhost:18080" | tee /root/.slate/endpoint /opt/slate-portal/slate_api_endpoint.txt > /dev/null'
RUN sh -c 'echo "5B121807-7D5D-407A-8E22-5F001EF594D4" | tee /root/.slate/token /etc/slate/secrets/slate_api_token.txt > /dev/null'
RUN chmod -R 600 /root/.slate
ADD slate_portal_user /
