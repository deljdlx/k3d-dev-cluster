FROM php:8.3-apache
RUN apt-get update \
    && apt-get install -y vim \
    && apt-get install -y cron \
    && apt-get install -y git \
    && apt-get install -y lsb-release \
    && apt-get install -y wget \
    && apt-get install -y tree \
    && apt-get install -y zip \
    && apt-get install -y curl \
    && apt-get install -y unzip \
    && apt-get install -y jq \
    && apt-get install -y ntp \
    && apt-get install -y imagemagick\
    && apt-get install -y gnupg2 \
    && apt-get install -y build-essential \
    && apt-get install -y libzip-dev \
    && apt-get install -y libpng-dev \
    && apt-get install -y libjpeg-dev \
    && apt-get install -y libfreetype6-dev \
    && apt-get install -y libmemcached-dev \
    && apt-get install zlib1g-dev \
    && apt-get install -y libxml2-dev \
    && apt-get install -y  libssl-dev \
    && apt-get update && apt-get install -y sqlite3 libsqlite3-dev\
    && apt-get update && apt-get install -y telnet\
    && apt-get install -y default-mysql-client \
    # =========================================
    && pecl install xdebug memcached \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip mysqli intl pdo pdo_sqlite pdo_mysql \
    && docker-php-ext-enable xdebug memcached \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # =========================================
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # =========================================
    && apt-get update && apt-get install -y nodejs npm \
    # =========================================
    &&  git config --global user.email "root@docker" \
    &&  git config --global user.name "Root Docker"

RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Passer à l'utilisateur www-data
USER www-data


WORKDIR /var/www/html

# CMD ["apache2-foreground"]
ENTRYPOINT ["apache2-foreground"]

