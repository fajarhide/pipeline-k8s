FROM nimmis/alpine-micro

MAINTAINER fajarhide <fajarhide@gmail.com>

RUN apk update && apk upgrade && \
    apk add nginx && \
    mkdir /web && \
    rm -rf /var/cache/apk/*


COPY rootfs /

VOLUME /web

EXPOSE 80 443

