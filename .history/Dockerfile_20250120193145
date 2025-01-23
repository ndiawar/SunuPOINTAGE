# Utilisation d'une image PHP officielle avec les dépendances nécessaires
FROM php:8.1-fpm

# Installer les dépendances nécessaires (MongoDB, libssl, etc.)
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install pdo pdo_mysql zip

# Installer les autres dépendances
RUN apt-get install -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Copier le code de votre application dans le conteneur
COPY . /var/www/html

# Définir le répertoire de travail
WORKDIR /var/www/html

# Exécuter composer install
RUN composer install --ignore-platform-reqs

# Exposer le port 9000 (ou tout autre port utilisé par votre application)
EXPOSE 9000
