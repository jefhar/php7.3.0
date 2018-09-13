#####
# PHP 7.3.0Beta 3 CLI Image #
#####

FROM ubuntu:bionic as build
ENV PHP_VERSION php-7.3.0beta3
ENV CONF_DIR /etc/php/7.3/conf.d
WORKDIR /php/source
COPY 118BCCB6.pub 118BCCB6.pub
RUN  apt-get update \
    && apt-get install -y \
        bison \
        build-essential \
        gpg \
        lbzip2 \
        libbz2-dev \
        libcurl4 \
        libcurl4-openssl-dev \
        libfreetype6 \
        libfreetype6-dev \
        libjpeg8 \
        libjpeg-dev \
        libpng16-16 \
        libpng-dev \
        libpspell-dev \
        libaspell15 \
        libreadline-dev \
        libreadline7 \
        libsodium23 \
        libsodium-dev \
        libssl1.1 \
        libssl-dev \
        libwebp6 \
        libwebp-dev \
        libxml2 \
        libxml2-dev \
        libxpm-dev \
        libxpm4 \
        libzip-dev \
        libzip4 \
        wget \
    && gpg --import 118BCCB6.pub \
    && wget https://downloads.php.net/~cmb/$PHP_VERSION.tar.bz2.asc \
    && wget https://downloads.php.net/~cmb/$PHP_VERSION.tar.bz2 \
    && gpg --verify $PHP_VERSION.tar.bz2.asc $PHP_VERSION.tar.bz2 \
    && tar -xjf $PHP_VERSION.tar.bz2 \
    && cd /php/source/$PHP_VERSION \
	&& ./configure \
       --disable-fpm \
       --enable-bcmath \
       --enable-calendar \
       --enable-cli \
       --enable-dba \
       --enable-exif \
       --enable-filter \
       --enable-ftp \
       --enable-intl \
       --enable-mbstring \
       --enable-pcntl \
       --enable-shmop \
       --enable-simplexml \
       --enable-soap \
       --enable-sockets \
       --enable-sysvmsg \
       --enable-sysvshm \
       --enable-wddx \
       --enable-xmlreader \
       --enable-xmlwriter \
       --enable-zip \
       --with-bz2 \
       --with-config-file-path=/etc/php/7.3/cli \
       --with-config-file-scan-dir=/etc/php/7.3/conf.d \
       --with-curl \
       --with-freetype-dir \
       --with-gd \
       --with-gettext \
       --with-jpeg-dir \
       --with-mhash \
       --with-mysql-sock=/var/run/mysqld/mysqld.sock \
       --with-mysqli \
       --with-mysqli=mysqlnd \
       --with-openssl \
       --with-pdo-mysql=mysqlnd \
       --with-pdo-sqlite \
       --with-png-dir \
       --with-pspell \
       --with-readline \
       --with-sodium \
       --with-sqlite3 \
       --with-zlib \
	&& make \
	&& make install \
	&& wget https://raw.githubusercontent.com/composer/getcomposer.org/f084c2e65e0bf3f3eac0f73107450afff5c2d666/web/installer -O - -q | php -- --quiet \
	&& mv composer.phar /usr/local/bin/composer \
	&& mkdir -p $CONF_DIR \
	&& mkdir -p /etc/php/7.3/cli \
    && echo "; priority=20\nextension=calendar.so" > $CONF_DIR/calendar.ini \
    && echo "; priority=20\nextension=ctype.so" > $CONF_DIR/ctype.ini \
    && echo "; priority=20\nextension=exif.so" > $CONF_DIR/exif.ini \
    && echo "; priority=20\nextension=fileinfo.so" > $CONF_DIR/exif.ini \
    && echo "; priority=20\nextension=ftp.so" > $CONF_DIR/ftp.ini \
    && echo "; priority=20\nextension=gettext.so" > $CONF_DIR/gettext.ini \
    && echo "; priority=20\nextension=iconf.so" > $CONF_DIR/iconv.ini \
    && echo "; priority=20\nextensio=json.so" > $CONF_DIR/json.ini \
    && echo "; priority=20\nextension=opcache.so" > $CONF_DIR/opcache.ini \
    && echo "; priority=20\nextension=pdo.so" > $CONF_DIR/pdo.ini \
    && echo "; priority=20\nextension=phar.so" > $CONF_DIR/phar.ini \
    && echo "; priority=20\nextension=posix.so" > $CONF_DIR/posix.ini \
    && echo "; priority=20\nextension=readline.so" > $CONF_DIR/readline.ini \
    && echo "; priority=20\nextension=shmop.so" > $CONF_DIRshmop.ini \
    && echo "; priority=20\nextension=sockets.so" > $CONF_DIR/sockets.ini \
    && echo "; priority=20\nextension=sysvmsg.so" > $CONF_DIR/sysvmsg.ini \
    && echo "; priority=20\nextension=sysvshm.so" > $CONF_DIR/sysvshm.ini \
    && echo "date.timezone = 'UTC'" > $CONF_DIR/timezone.ini \
    && echo "; priority=20\nextension=tokenizer.so" > $CONF_DIR/tokenizer.ini \
    && mv /php/source/$PHP_VERSION/php.ini-production /etc/php/7.3/cli/php.ini \
    && apt-get remove -y \
		bison \
        build-essential \
        libbz2-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libpspell-dev \
        libreadline-dev \
        libsodium-dev \
        libssl-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libzip-dev \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /php/source/php*

CMD ["php", "-a"]
