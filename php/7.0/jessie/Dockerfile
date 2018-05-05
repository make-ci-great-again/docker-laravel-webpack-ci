FROM php:7.0-cli-jessie

LABEL maintainer="Felix Dulfer <felix@dulfer.me>" \
    php="7.0"

ENV IMAGE_USER=php
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer

USER root

WORKDIR /tmp

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive tzdata \
    && apt-get update \
    && apt-get upgrade -y \
    &&  DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    sudo \
    unzip \
    git \
    --no-install-recommends && \
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
