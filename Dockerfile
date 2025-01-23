# Utiliser l'image PHP avec Apache
FROM php:8.2-apache
# Installation des dépendances nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    unzip \
    netcat-openbsd \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql
# Installation de l'extension MongoDB
RUN pecl install mongodb && docker-php-ext-enable mongodb
# Copier les fichiers Laravel dans le répertoire du serveur Apache
COPY ./ /var/www/html/
# Copier le script wait-for-it.sh dans le conteneur
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
# Donner les permissions d'exécution au script wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Vérifier si l'utilisateur www-data existe déjà
RUN if id "www-data" >/dev/null 2>&1; then \
        echo "User www-data already exists"; \
    else \
        useradd -ms /bin/bash www-data; \
    fi
# Définir les permissions pour l'utilisateur non-root
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html
# Installer Composer et les dépendances Laravel
WORKDIR /var/www/html
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader
# Ajouter le package mongodb/laravel-mongodb
RUN composer require mongodb/laravel-mongodb
# Changer l'utilisateur par défaut
USER www-data
# Exposer le port 80
EXPOSE 80
# Commande de démarrage avec wait-for-it.sh pour attendre MongoDB
CMD ["sh", "-c", "/usr/local/bin/wait-for-it.sh mongodb:27017 -- php artisan migrate && apache2-foreground"]
