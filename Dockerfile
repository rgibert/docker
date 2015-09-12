FROM ubuntu:trusty
MAINTAINER Richard Gibert <richard@gibert.ca>
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y apache2 apache2-utils && \
    unset DEBIAN_FRONTEND && \
    rm -r /var/lib/apt/lists/* /etc/apache2/sites-*/* && \
    a2enmod ssl
COPY etc /etc/
RUN a2ensite http && \
    a2ensite https
EXPOSE 80 443
