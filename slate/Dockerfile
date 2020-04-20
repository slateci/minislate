FROM centos:7

ENV KUBECONFIG=/etc/rancher/k3s/k3s.yaml

WORKDIR /src

COPY slate/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
COPY slate/aws-sdk.repo /etc/yum.repos.d/aws-sdk.repo
COPY slate/slate-server.repo /etc/yum.repos.d/slate-server.repo
RUN yum install -y epel-release
RUN yum install -y ca-certificates git vim which kubectl boost zlib openssl libcurl openssl gcc python-devel libffi-devel net-tools supervisor

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
RUN helm repo add stable https://kubernetes-charts.storage.googleapis.com/

RUN mkdir /root/.kube

RUN curl -s -O https://jenkins.slateci.io/artifacts/client/slate-linux.tar.gz
RUN tar xzf slate-linux.tar.gz && chmod +x slate && mv slate /usr/bin/

RUN yum install -y slate-api-server

RUN yum clean all && rm -rf /var/cache/yum

WORKDIR /opt/slate-portal
RUN rm -rf /src
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python
RUN pip install virtualenv
RUN git clone https://github.com/slateci/slate-portal.git .
RUN bash -c 'virtualenv venv && source venv/bin/activate && pip install --no-cache-dir -r requirements.txt'
RUN mkdir /opt/slate-portal/instance && cp /opt/slate-portal/portal/portal.conf /opt/slate-portal/instance/
RUN sed -i -e 's/localhost/0\.0\.0\.0/g' -e 's/ssl_context=([^)]*)//' /opt/slate-portal/run_*
RUN pip install -r /opt/slate-portal/requirements.txt

WORKDIR /
RUN dd if=/dev/urandom of=encryptionKey bs=1024 count=1
RUN mkdir /root/.slate && mkdir -p /etc/slate/secrets
RUN sh -c 'echo "http://localhost:18080" | tee /root/.slate/endpoint /opt/slate-portal/slate_api_endpoint.txt > /dev/null'
RUN sh -c 'echo "5B121807-7D5D-407A-8E22-5F001EF594D4" | tee /root/.slate/token /etc/slate/secrets/slate_api_token.txt > /dev/null'
RUN chmod -R 600 /root/.slate

COPY slate/slate_portal_user /
COPY slate/init.sh /
EXPOSE 5000 51000 18080
RUN chmod +x init.sh

COPY slate/supervisord.conf /etc/supervisord.conf
