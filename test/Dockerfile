FROM docker:stable-dind

WORKDIR /minislate
RUN apk update && apk add --no-cache python3 py3-pip
RUN pip3 install docker-compose
RUN ln -s /usr/bin/python3 /usr/bin/python
