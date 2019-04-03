FROM docker:stable-dind

WORKDIR /minislate
RUN apk update && apk add --no-cache python3 python3-dev py3-pip musl-dev libffi-dev gcc make openssl-dev
RUN pip3 install docker-compose
RUN ln -s /usr/bin/python3 /usr/bin/python
