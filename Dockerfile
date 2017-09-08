FROM ubuntu:16.04

RUN apt update
RUN apt upgrade -y

RUN apt install -y software-properties-common debconf-utils wget unzip xterm

#java
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

#xpra
COPY ./keyboard /etc/default/keyboard
RUN echo "deb http://winswitch.org/ xenial main" > /etc/apt/sources.list.d/winswitch.org.list
RUN wget -q http://winswitch.org/gpg.asc -O- | apt-key add -
RUN apt update
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

#audio codecs for tws
RUN apt install -y libavcodec-extra libavcodec-ffmpeg-extra56 ffmpeg libavformat-ffmpeg56 libavutil-ffmpeg54 libglib2.0-0

RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer

#IB gateway
RUN mkdir -p /opt/ibgateway
WORKDIR /opt/ibgateway
#source; https://www.interactivebrokers.com/en/index.php?f=16457#tws-platforms-03
# stable
#RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh
# latest
RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh
RUN chmod +x ibgateway-latest-standalone-linux-x64.sh
RUN yes n | ./ibgateway-latest-standalone-linux-x64.sh
RUN rm ibgateway-latest-standalone-linux-x64.sh

#ib-controller
RUN mkdir -p /opt/IBController/
WORKDIR /opt/IBController/
RUN wget -q https://github.com/ib-controller/ib-controller/releases/download/3.4.0/IBController-3.4.0.zip
RUN unzip IBController-3.4.0.zip
RUN rm IBController-3.4.0.zip
RUN sed -i 's/963/967/' *.sh
RUN chmod +x *.sh Scripts/*.sh


ADD start-ssh-xpra /start-ssh-xpra
ADD start-ib-gateway /start-ib-gateway
ADD start-ib-tws /start-ib-tws

EXPOSE 22

EXPOSE 4002

WORKDIR /
