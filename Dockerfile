FROM gliderlabs/alpine
MAINTAINER Richard Gibert <richard@gibert.ca>
RUN apk-install \
        apache2 \
        apache2-ssl \
        apache2-utils \
        bash \
        && \
    ln -s /etc/apache2/vhosts.d /var/www/vhosts.d && \
    ln -s /etc/apache2/modules.d /var/www/modules.d && \
    ln -s /etc/apache2/ssl /var/www/ssl && \
    rm -rf /var/www/localhost /etc/apache2/original /etc/apache2/conf.d /var/www/conf.d && \
    mkdir -p /var/www/htdocs
COPY etc/ /etc/
COPY usr/local/bin/entrypoint /usr/local/bin/entrypoint
EXPOSE 80 443
VOLUME /var/www/logs
ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "apache2" ]

