FROM ubuntu:20.04

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get -qq update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y tzdata aria2 git python3 python3-pip \
    locales python3-lxml \
    curl pv jq ffmpeg \
    p7zip-full p7zip-rar
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && \
    apt-get -qq install -y p7zip-full p7zip-rar aria2 wget curl pv jq ffmpeg locales python3-lxml && \
    apt-get purge -y software-properties-common

RUN wget https://raw.githubusercontent.com/MonkTeam/Ss/main/authorized_chats.txt
COPY token.pickle .
COPY requirements.txt .
RUN pip3 uninstall appdirs
RUN pip3 install appdirs
COPY extract /usr/local/bin
RUN chmod +x /usr/local/bin/extract
RUN pip3 install --no-cache-dir -r requirements.txt && \
    apt-get -qq purge git
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY . .
COPY netrc /root/.netrc
RUN chmod +x aria.sh

CMD ["bash","start.sh"]
