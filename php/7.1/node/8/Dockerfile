FROM php:7.1-cli-jessie

LABEL maintainer="Felix Dulfer <felix@dulfer.me>" \
    php="7.1"

ENV IMAGE_USER=php
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer

USER root

WORKDIR /tmp

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    \
    \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive tzdata \
    && apt-get update \
    && apt-get upgrade -y \
    &&  DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    apt-transport-https \
    openssh-client \
    unzip \
    git \
    curl \
    libc-client-dev \
    zlib1g-dev \
    apt-utils \
    rsync \
    sudo \
    gnupg2 \
    python \
    python-dev \
    --no-install-recommends && \
    \
    \
    buildDeps=" \
    libbz2-dev \
    libmysqlclient-dev \
    libsasl2-dev \
    " \
    runtimeDeps=" \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libmemcachedutil2 \
    libpng12-dev \
    libpq-dev \
    libxml2-dev \
    libkrb5-dev \
    libmagickwand-dev \
    imagemagick \
    " && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps --no-install-recommends \
    && docker-php-ext-install -j$(nproc) exif xml xmlrpc pcntl bcmath bz2 calendar iconv intl mbstring mysqli opcache pdo_mysql pdo_pgsql pgsql soap zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) ldap \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-source delete && \
    \
    \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y mcrypt \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && pecl channel-update pecl.php.net \
    && pecl install redis mongodb xdebug apcu memcached imagick \
    && docker-php-ext-enable redis mongodb xdebug apcu memcached imagick && \
    \
    \
    { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    { \
    echo 'apc.shm_segments=1'; \
    echo 'apc.shm_size=256M'; \
    echo 'apc.num_files_hint=7000'; \
    echo 'apc.user_entries_hint=4096'; \
    echo 'apc.ttl=7200'; \
    echo 'apc.user_ttl=7200'; \
    echo 'apc.gc_ttl=3600'; \
    echo 'apc.max_file_size=1M'; \
    echo 'apc.stat=1'; \
    } > /usr/local/etc/php/conf.d/apcu-recommended.ini && \
    echo "memory_limit=512M" > /usr/local/etc/php/conf.d/zz-conf.ini && \
    \
    \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs --no-install-recommends -yqq \
    && npm i -g npm \
    && curl -o- -L https://yarnpkg.com/install.sh | bash && \
    \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    build-essential \
    apt-utils \
    libc-client-dev\
    autoconf \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    libpcre3-dev \
    pkg-config \
    re2c && \
    \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    \
    \
    adduser --disabled-password --gecos "" $IMAGE_USER && \
    echo "$IMAGE_USER  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /var/www/html && \
    chown -R $IMAGE_USER:$IMAGE_USER /var/www $HOME /tmp

# Get composer binary from composer image
COPY --from=composer:1.6 /usr/bin/composer /usr/bin/composer

# Install hirak/prestissimo for faster parallel composer installs
RUN composer global require "hirak/prestissimo:^0.3" && \
    chown -R $IMAGE_USER:$IMAGE_USER $COMPOSER_HOME

USER $IMAGE_USER

WORKDIR /var/www/html
