#!/bin/bash

# Vérifier si la variable d'environnement "MAINTENANCE_MODE" est définie sur "true"
ENV_VAR_NAME="MAINTENANCE_MODE"

# Entrer en mode maintenance si la variable d'environnement est "true"
if [[ "${!ENV_VAR_NAME}" = "true" ]]; then
  echo "Entrée en mode maintenance..."
  php artisan down
fi

# Mise à jour des dépendances PHP (si le gestionnaire de dépendances composer est déjà installé)
echo "Installation des dépendances PHP avec Composer..."

# Installer l'extension MongoDB si nécessaire
echo "Installation de l'extension MongoDB pour PHP..."
apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libcurl4-openssl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Installer les dépendances PHP avec Composer (si Composer n'est pas déjà installé)
if ! command -v composer &> /dev/null; then
    echo "Composer n'est pas installé. Installation de Composer..."
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

# Exécuter composer install pour installer toutes les dépendances du projet Laravel
composer install --ignore-platform-reqs

# Construire les assets avec NPM
echo "Construction des assets avec NPM..."
npm run build

# Nettoyer les caches Laravel
echo "Nettoyage du cache Laravel..."
php artisan optimize:clear

# Mettre en cache les configurations, événements, routes et vues de Laravel
echo "Mise en cache des composants Laravel..."
php artisan config:cache
php artisan event:cache
php artisan route:cache
php artisan view:cache

# Exécuter les migrations de la base de données
echo "Exécution des migrations de la base de données..."
php artisan migrate --force

# Vérifier si la variable d'environnement est "false" ou non définie pour sortir du mode maintenance
if [[ "${!ENV_VAR_NAME}" = "false" ]] || [[ -z "${!ENV_VAR_NAME}" ]]; then
  echo "Sortie du mode maintenance..."
  php artisan up
fi
