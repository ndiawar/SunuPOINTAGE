# Utilisation d'une image PHP officielle
FROM php:8.4-fpm

# Installer les dépendances nécessaires pour MongoDB, libssl, etc.
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    git \
    unzip \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install pdo pdo_mysql zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copier le code de l'application dans le conteneur
COPY . /var/www/html

# Définir le répertoire de travail
WORKDIR /var/www/html

# Exécuter composer install pour installer les dépendances PHP
RUN composer install --ignore-platform-reqs

# Exposer le port 9000 (ou tout autre port utilisé par votre application)
EXPOSE 9000
