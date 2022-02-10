# syntax=docker/dockerfile:1
FROM centos:7

# Docker image build arguments:
ARG endpoint='http://localhost:18080'
ARG token='5B121807-7D5D-407A-8E22-5F001EF594D4'

# Docker container environmental variables:
ENV KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Set up custom yum repos:
COPY slate/resources/yum.repos.d/* /etc/yum.repos.d/

# Package installs/updates:
RUN yum install -y epel-release
RUN yum install -y ca-certificates git vim which kubectl-1.19.1 boost zlib openssl libcurl openssl gcc libffi-devel net-tools supervisor

# Install Python 3 package and modify yum to still use Python 2 (prevents errors):
RUN yum install -y python3-devel && \
    alternatives --install /usr/bin/python python /usr/bin/python2 50 && \
    alternatives --install /usr/bin/python python /usr/bin/python3 60
RUN sed -i 's:bin/python:bin/python2.7:g' /usr/bin/yum && \
    sed -i 's:bin/python:bin/python2.7:g' /usr/libexec/urlgrabber-ext-down

# Install the SLATE API Server and clean up yum:
RUN yum install -y slate-api-server && \
    yum clean all && \
    rm -rf /var/cache/yum

# Install Helm 3:
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
RUN helm repo add stable https://charts.helm.sh/stable

# Download and install the SLATE CLI:
RUN curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.tar.gz && \
    curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.sha256
RUN sha256sum -c slate-linux.sha256 || exit 1
RUN tar xzvf slate-linux.tar.gz && \
    mv slate /usr/bin/slate && \
    rm slate-linux.tar.gz slate-linux.sha256

# Change working directory:
WORKDIR /opt/slate-portal

# Clone the SLATE Portal repo:
# TODO: Clone a specific tag instead for slate-portal.git rather than the master branch.
RUN git clone https://github.com/slateci/slate-portal.git .

# Configure the SLATE Portal with a modern version of Pip:
RUN pip3 install virtualenv
RUN bash -c 'virtualenv venv && source venv/bin/activate && pip install --no-cache-dir -r requirements.txt'
RUN mkdir ./instance && \
    cp ./portal/portal.conf ./instance/
RUN sed -i -e 's/localhost/0\.0\.0\.0/g' -e 's/ssl_context=([^)]*)//' ./run_*

# Set global secrets:
RUN dd if=/dev/urandom of=/encryptionKey bs=1024 count=1
RUN mkdir -p /etc/slate/secrets && \
    echo ${token} > /etc/slate/secrets/slate_api_token.txt && \
    echo ${endpoint} > /opt/slate-portal/slate_api_endpoint.txt

# Change working directory:
WORKDIR /root

# Prepare root home directory:
RUN mkdir ./.kube ./.slate

# Set user-level secrets:
RUN echo ${token} > ./.slate/token && \
    echo ${endpoint} > ./.slate/endpoint && \
    chmod -R 600 ./.slate

# Change working directory:
WORKDIR /

# Copy remaining resources:
COPY slate/resources/supervisord.conf /etc/supervisord.conf
COPY slate/resources/users/slate_portal_user .
COPY slate/scripts/init.sh .
RUN chmod +x init.sh

# Ports:
EXPOSE 5000 51000 18080
