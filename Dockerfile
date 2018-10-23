FROM bash:latest as helm
WORKDIR /src
RUN apk update && apk --no-cache add ca-certificates wget openssl
ENV HELM_INSTALL_DIR="/src"
RUN wget -q -O- https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash >/dev/null 2>&1; exit 0

FROM ubuntu:18.04
ENV KUBECONFIG=/etc/kubernetes/admin.conf
ARG CORES=1
WORKDIR /src
RUN apt-get update && apt-get install -y apt-transport-https curl gnupg software-properties-common screen
RUN /bin/sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"
RUN /bin/sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"
RUN apt-get update && apt-get install -y g++ cmake git libcurl4-openssl-dev zlib1g-dev libssl-dev libboost-all-dev subversion libyaml-cpp-dev python-pip kubectl=1.11.0-00 && apt-get clean
COPY --from=helm /src/helm /usr/local/bin/helm
RUN mkdir /root/.kube
RUN curl http://jenkins.slateci.io/artifacts/slate-linux.tar.gz -O
RUN tar xzvf slate-linux.tar.gz && chmod +x slate && mv slate /usr/bin/
WORKDIR /opt/slate-api-server
RUN rm -rf /src
RUN git clone https://github.com/slateci/slate-api-server.git .
RUN mkdir aws && cd aws && curl -LO https://github.com/aws/aws-sdk-cpp/archive/1.4.70.tar.gz && tar xzf 1.4.70.tar.gz && mkdir aws-sdk-cpp-1.4.70-build
RUN cd aws/aws-sdk-cpp-1.4.70-build && cmake ../aws-sdk-cpp-1.4.70 -DBUILD_ONLY="dynamodb" -DBUILD_SHARED_LIBS=Off && make -j${CORES} && make install
RUN mkdir build && cd build && cmake .. && make -j${CORES}
RUN cd build && dd if=/dev/urandom of=encryptionKey bs=1024 count=1
WORKDIR /opt/slate-portal
RUN pip install virtualenv
RUN git clone https://github.com/slateci/prototype-portal.git .
RUN bash -c 'virtualenv venv && source venv/bin/activate && pip install --no-cache-dir -r requirements.txt'
WORKDIR /
