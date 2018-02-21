FROM ubuntu:14.04
MAINTAINER Pramod Sheahan <pramodshehan@gmail.com>

#DECLARE VERSION AND FILE NAME
ENV VERSION 1.7.0
ENV FILE elasticsearch-$VERSION.tar.gz

#Install Elasticsearch
RUN wget -O /tmp/$FILE https://download.elasticsearch.org/elasticsearch/elasticsearch/$FILE
RUN tar -xzf /tmp/$FILE -C /tmp
RUN mv /tmp/elasticsearch-$VERSION /elasticsearch

# Install Plugins
RUN /elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head
RUN /elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf/master
RUN /elasticsearch/bin/plugin -install elasticsearch/elasticsearch-cloud-aws/2.1.1

VOLUME ["/data"]

# Working directory
WORKDIR /data

# Expose ports (9200: HTTP, 9300: Transport)
EXPOSE 9200 9300

# RUN
CMD ["/elasticsearch/bin/elasticsearch"]
