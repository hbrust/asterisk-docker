FROM ubuntu:20.04

# Environment
ENV TZ="Europe/Berlin"
ENV ARI_ALLOWED_ORIGINS="*"

# install packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y asterisk asterisk-config

# config changes
RUN sed -i 's/;enabled=yes/enabled=yes/g' /etc/asterisk/http.conf && \
    sed -i 's/bindaddr=127.0.0.1/bindaddr=0.0.0.0/g' /etc/asterisk/http.conf


# build additional config directory
# add tryinclude to all .conf files
RUN mkdir /config && \
    chown asterisk:asterisk /config && \
    cd /etc/asterisk/ && \
    for f in $(ls *.conf | egrep -v "asterisk.conf|modules.conf"); do echo "\n#tryinclude /config/$f" >> $f; done

# entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 8088
EXPOSE 5060/udp

ENTRYPOINT ["/docker-entrypoint.sh"]