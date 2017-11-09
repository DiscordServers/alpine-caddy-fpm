FROM php:rc-fpm-alpine
MAINTAINER discordservers <admin@discordservers.com>

ENV BUILD_PACKAGES="git zip make gcc g++ openssh-client tar python py-pip" \
    ESSENTIAL_PACKAGES="curl openssl-dev zlib supervisor pcre linux-headers go postgresql-dev" \
    GOPATH="/root/go"

RUN apk add --update --no-cache --progress $ESSENTIAL_PACKAGES $BUILD_PACKAGES \
    && pip install supervisor-stdout \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql \
    && pecl install redis apcu swoole \
    && echo "extension=redis.so" >> /usr/local/etc/php/php.ini \
    && echo "extension=apcu.so" >> /usr/local/etc/php/php.ini \
    && echo "extension=swoole.so" >> /usr/local/etc/php/php.ini \
    && mkdir -p $GOPATH/src \
    && cd $GOPATH/src \
    && go get -u github.com/mholt/caddy \
    && go get -u github.com/caddyserver/builds \
    && cd $GOPATH/src/github.com/mholt/caddy/caddy \
    && git checkout tags/v0.10.10 \
    && go run build.go -goos=linux -goarch=amd64 \
    && mv caddy /usr/local/sbin/caddy \
    && apk del $BUILD_PACKAGES

COPY ./manifest /

EXPOSE 80

CMD /usr/bin/supervisord -n -c /etc/supervisord.conf