############################################################
# Dockerfile to build xpaas-base-docker container image including:
#   - Supervisor daemon
#   - Supervisor-stdout
#   - Git client
#   - Python PIP
#   - Net tools
#   - Telnet client
#   - Open SSH server & client
#   - Unzip tool
#   - wget tool
#   - Java 1.7.0 OpenJDK & development package
#   - Maven 3.0.5 & JBoss Nexus repositories configured
# Based on Fedora docker image
# Version: 1.0
############################################################

####### BASE ############
FROM fedora:20

####### MAINTAINER ############
MAINTAINER "JBoss XPaaS Team" "xpass-eng@redhat.com"

####### BASE VARIABLES ############
ENV JAVA_HOME /usr/lib/jvm/jre
ENV ROOT_PASSWORD xpaas
ENV PATH $MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

####### BASE SOFTWARE ############
# telnet is required by some fabric command. without it you have silent failures
RUN yum install -y net-tools java-1.7.0-openjdk java-devel which telnet unzip openssh-server sudo openssh-clients supervisor wget python-pip git; \ 
yum clean all; \ 
pip install supervisor-stdout

####### BASE SOFTWARE CONFIGURATION ############

# Configure the SSH daemon
RUN mkdir -p /var/run/sshd
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_key; \ 
ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_rsa_key; \ 
ssh-keygen -b 1024 -t dsa -f /etc/ssh/ssh_host_dsa_key

# Configure supervisor
RUN mkdir -p /var/log/supervisord /etc/supervisord/conf.d
ADD conf/supervisord/supervisord.conf /etc/supervisord.conf


####### SYSTEM PRIVILEGES CONFIGURATION ############
WORKDIR /
# enabling sudo group
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
# enabling sudo over ssh
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

####### PORT EXPOSING ###########
# SSH daemon port
EXPOSE 22

####### HELPER SCRIPTS ###########
WORKDIR /
RUN mkdir -p /jboss/scripts
ADD conf/scripts/docker-ip.sh /jboss/scripts/docker-ip.sh

####### CONFIGURE & RUN THE SUPERVISOR DAEMON ###########
ADD conf/scripts/init.sh /jboss/scripts/init.sh
ADD conf/scripts/root-password.sh /jboss/scripts/root-password.sh
ADD conf/scripts/supervisord/start.sh /jboss/scripts/start.sh
ADD conf/scripts/supervisord/restart.sh /jboss/scripts/restart.sh
ADD conf/scripts/supervisord/stop.sh /jboss/scripts/stop.sh

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
