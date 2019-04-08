FROM amd64/alpine:3.9

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S civetweb && adduser -S -G civetweb civetweb
RUN apk update && apk add --no-cache wget build-base cmake openssl-dev bash 'su-exec>=0.2'
# USER root
# WORKDIR ~

ENV CIVETWEB_VERSION 1.11
ENV CIVETWEB_DOWNLOAD_URL https://github.com/civetweb/civetweb/archive/v1.11.tar.gz
ENV CIVETWEB_DOWNLOAD_SHA de7d5e7a2d9551d325898c71e41d437d5f7b51e754b242af897f7be96e713a42

RUN \
    mkdir civetweb; \
    wget -q -O civetweb.tar.gz "$CIVETWEB_DOWNLOAD_URL"; \
    echo "$CIVETWEB_DOWNLOAD_SHA *civetweb.tar.gz" | sha256sum -c -; \
    tar -xzf civetweb.tar.gz -C civetweb --strip-components 1; \
    rm civetweb.tar.gz; \
    cd civetweb; \
    make; \
    make install;

RUN chown civetweb:civetweb /usr/local/bin/civetweb
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080
CMD [ "civetweb" ]
