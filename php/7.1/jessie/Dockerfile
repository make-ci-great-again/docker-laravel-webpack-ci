FROM php:7.1-cli-jessie

LABEL maintainer="Felix Dulfer <felix@dulfer.me>" \
    php="7.1"

ENV IMAGE_USER=php
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer

USER root

WORKDIR /tmp

COPY /php/scripts/jessie/*.sh ./
RUN chmod +x *.sh

RUN bash ./apt.sh && \
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
