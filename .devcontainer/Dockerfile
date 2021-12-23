FROM ubuntu:22.04

COPY ./site.yml /root/.ansible/site.yml

RUN apt update && \
    apt install -y ansible && \
    ansible-playbook /root/.ansible/site.yml
