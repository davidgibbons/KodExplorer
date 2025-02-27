FROM php:7.1-apache

RUN set -x \
  && mkdir -p /usr/src/kodexplorer \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove ca-certificates wget \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
  && docker-php-ext-install -j$(nproc) iconv mcrypt \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && rm -rf /var/cache/apk/*

WORKDIR /var/www/html

COPY --chown=www-data:www-data . .

CMD ["apache2-foreground"]

