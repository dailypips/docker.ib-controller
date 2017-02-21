FROM ubuntu:16.04

RUN apt update
RUN apt upgrade -y

RUN apt install -y software-properties-common debconf-utils wget unzip

#java
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

#xpra
COPY ./keyboard /etc/default/keyboard
RUN apt -y install xpra

#ssh server
RUN apt install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
COPY ./authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

#networking
RUN apt install -y net-tools lsof socat

RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer

#IB gateway
RUN mkdir -p /opt/ibgateway
WORKDIR /opt/ibgateway
#source; https://www.interactivebrokers.com/en/index.php?f=16457#tws-platforms-03
RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh
RUN chmod +x ibgateway-stable-standalone-linux-x64.sh
RUN yes n | ./ibgateway-stable-standalone-linux-x64.sh
RUN rm ibgateway-stable-standalone-linux-x64.sh

#ib-controller
RUN mkdir -p /opt/IBController/
WORKDIR /opt/IBController/
RUN wget -q https://github.com/ib-controller/ib-controller/releases/download/3.2.0/IBController-3.2.0.zip
RUN unzip IBController-3.2.0.zip
RUN rm IBController-3.2.0.zip
RUN chmod +x *.sh Scripts/*.sh


ADD run-ib-controller /run-ib-controller

EXPOSE 22

EXPOSE 4002

WORKDIR /

CMD ["/run-ib-controller"]
