FROM ubuntu:14.04

MAINTAINER Pramod Shehan (pramodshehan@gmail.com)

# install java and other required packages
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y

# install java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk7-installer

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# elasticserach version
ENV ELASTIC_PKG elasticsearch-5.2.1 

# add user to avoid starting elasticsearch as root user
RUN groupadd testgroup -g 1000
RUN useradd -G testgroup -d /home/esuser -m esuser -u 1000

WORKDIR /home/esuser

# /data as a volume 
#VOLUME ["/home/esuser/data"]
RUN mkdir /home/esuser/data

# download and install elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/${ELASTIC_PKG}.tar.gz
RUN tar xvzf ${ELASTIC_PKG}.tar.gz
RUN rm -f ${ELASTIC_PKG}.tar.gz
RUN mv /home/esuser/$ELASTIC_PKG /home/esuser/elasticsearch

# running port
EXPOSE 9200 9300

# add elastisearch config 
ADD elasticsearch.yml /home/esuser/elasticsearch/config/elasticsearch.yml 

# run elastic search as senzuser
RUN chown -R esuser:esuser /home/esuser/elasticsearch 
RUN chown -R esuser:esuser /home/esuser/data 

USER esuser

# start elasticsearch
CMD ["/home/esuser/elasticsearch/bin/elasticsearch"] 
