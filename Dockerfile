# Utilisation de l'image PHP-FPM officielle
FROM php:8.4-fpm

# Installer Nginx et les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    git \
    unzip \
    nginx \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install pdo pdo_mysql zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copier le code de l'application dans le conteneur
COPY . /var/www/html

# Copier le fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf  

# Définir le répertoire de travail
WORKDIR /var/www/html

# Exposer les ports pour Nginx et PHP-FPM
EXPOSE 80
EXPOSE 9000

# Exécuter composer install pour installer les dépendances PHP
RUN composer install --ignore-platform-reqs

# Lancer Nginx et PHP-FPM
CMD service nginx start && php-fpm
