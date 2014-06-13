#
# Dockerfile for mod_mruby on ubuntu 14.04 64bit
#

#
# Building
#   docker build -t matsumotory:mod_mruby .
#
# Runing
#   docker run -d -p 10080:80 matsumotory:mod_mruby
#
# Access
#   curl http://127.0.0.1:10080/mruby
#

FROM stackbrew/ubuntu:14.04

MAINTAINER doragon

RUN apt-get -y update
RUN apt-get -y install sudo openssh-server
RUN apt-get -y install git
RUN apt-get -y install curl
RUN apt-get -y install apache2 apache2-dev apache2-utils
RUN apt-get -y install rake
RUN apt-get -y install ruby2.0 ruby2.0-dev
RUN apt-get -y install bison
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install libhiredis-dev
RUN apt-get -y install libmarkdown2-dev
RUN apt-get -y install libcap-dev
RUN apt-get -y install libcgroup-dev

RUN cd /usr/local/src/ && git clone git://github.com/matsumoto-r/mod_mruby.git
RUN cd /usr/local/src/mod_mruby && sh build.sh && make install
RUN echo "" >> /etc/apache2/mods-enabled/mruby.load
RUN echo "  mrubyHandlerMiddleCode 'Apache.echo \"hello mod_mruby world.\"" >> /etc/apache2/mods-enabled/mruby.load
RUN echo "" >> /etc/apache2/mods-enabled/mruby.load
RUN service apache2 restart && curl http://127.0.0.1/mruby

EXPOSE 80
env APACHE_RUN_USER www-data
env APACHE_RUN_GROUP www-data
env APACHE_PID_FILE /var/run/apache2.pid
env APACHE_RUN_DIR /var/run/apache2
env APACHE_LOCK_DIR /var/lock/apache2
env APACHE_LOG_DIR /var/log/apache2
env LANG C

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
