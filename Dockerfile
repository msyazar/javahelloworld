FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y wget vim
EXPOSE 80 8080
RUN mkdir /data/myvol -p
RUN echo "put some text here" > /data/myvol/test
VOLUME /data/myvol
yeni satır
ikinci satır
asdfasdf
dsddssd
