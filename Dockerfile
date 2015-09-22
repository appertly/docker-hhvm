FROM debian:jessie
MAINTAINER Jonathan Hawk <jonathan@appertly.com>

ENV HHVM_VERSION 3.9.1~jessie

# Install HHVM
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 \
    && echo deb http://dl.hhvm.com/debian jessie main | tee /etc/apt/sources.list.d/hhvm.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates hhvm=$HHVM_VERSION \
    && rm -rf /var/lib/apt/lists/*

ADD php.ini /etc/hhvm/php.ini
ADD server.ini /etc/hhvm/server.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/hhvm/error.log

ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# HHVM on FastCGI with default port of 9000
EXPOSE 9000

# Default command
CMD ["/scripts/start.sh"]
