# Nginx / PHP webserver

FROM phusion/baseimage:0.9.15
MAINTAINER Márton Juhász <m@juhaszmarton.hu>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN add-apt-repository ppa:nginx/stable
RUN add-apt-repository ppa:ondrej/php5-5.6
# Add key for the PHP ppa, since add-apte-repository will fail it...
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C

RUN apt-get update && apt-get install -y nginx php5-common php5-fpm php5-cli php5-curl php5-gd php5-mysql php5-sqlite postfix

# Create the base data directory.
RUN mkdir -p /data/www
COPY data/www/index.php /data/www/index.php

# Nginx config
RUN rm /etc/nginx/sites-available/default
COPY nginx/sites-available/default /etc/nginx/sites-available/default

# Start nginx
RUN mkdir /etc/service/nginx
ADD services/nginx.sh /etc/service/nginx/run

# Start php5-fpm
RUN mkdir /etc/service/php5-fpm
ADD services/php5-fpm.sh /etc/service/php5-fpm/run
