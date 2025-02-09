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


RUN a2enmod rewrite
RUN cat /etc/apache2/sites-enabled/000-default.conf
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-enabled/000-default.conf
RUN cat /etc/apache2/sites-enabled/000-default.conf
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www


RUN apt-get install -y sudo
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -aG sudo www-data


RUN apt-get update && apt-get install -y locales && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
    && unzip sonar-scanner-cli-5.0.1.3006-linux.zip -d /opt/ \
    && ln -s /opt/sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner

USER www-data


WORKDIR /var/www/html

# CMD ["apache2-foreground"]
ENTRYPOINT ["apache2-foreground"]

