# Utiliser une image PHP officielle avec support CLI
FROM php:8.3-cli


# Installer les extensions nécessaires pour Composer et MariaDB
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Installer Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && rm composer-setup.php

# Installer les extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_mysql

# Définir le dossier de travail
WORKDIR /app

# Copier le script PHP de génération de données
COPY docker/faker-mysql-php/populate_db.php /app/

# Copier le fichier composer.json et installer Faker
COPY docker/faker-mysql-php/composer.json /app/
RUN /usr/local/bin/composer install --no-interaction --no-progress --no-scripts


# Exécuter le script au démarrage du container
CMD ["php", "/app/populate_db.php"]


