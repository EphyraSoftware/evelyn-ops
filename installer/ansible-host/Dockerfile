FROM ubuntu:19.10

RUN apt-get update && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        dos2unix \
        dnsutils \
        iproute2 \
        iputils-ping \
        openssh-server \
        software-properties-common \
    && apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y --no-install-recommends ansible

COPY ./ssh/ /ssh/
RUN chmod 400 /ssh/id_rsa && chmod 400 /ssh/id_rsa.pub

WORKDIR /scripts

COPY init.sh ./
RUN dos2unix init.sh

WORKDIR /play
