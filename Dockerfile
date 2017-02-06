FROM ubuntu:trusty
MAINTAINER Jonathan Hawk <jonathan@appertly.com>

ENV HHVM_VERSION 3.15.5~trusty

# Install HHVM
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 \
    && echo deb http://dl.hhvm.com/ubuntu trusty-lts-3.15 main | tee /etc/apt/sources.list.d/hhvm.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates hhvm=$HHVM_VERSION libdouble-conversion1 liblz4-1 ttf-liberation librsvg2-bin \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/log/apt/* \
    && rm -rf /var/log/dpkg.log \
    && rm -rf /var/log/bootstrap.log \
    && rm -rf /var/log/alternatives.log

ADD php.ini /etc/hhvm/php.ini
ADD server.ini /etc/hhvm/server.ini
ADD start.sh /scripts/start.sh

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/hhvm/error.log \
    && chmod +x /scripts/start.sh

# HHVM on FastCGI with default port of 9000
EXPOSE 9000

# Default command
CMD ["/scripts/start.sh"]
