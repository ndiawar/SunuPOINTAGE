# /bin/bash

# Installez les dépendances nécessaires pour MongoDB
apt-get update && apt-get install -y libssl-dev libcurl4-openssl-dev

# Installez l'extension MongoDB pour PHP
pecl install mongodb
docker-php-ext-enable mongodb

# Si nécessaire, installez d'autres extensions PHP
docker-php-ext-install pdo pdo_mysql zip

# Vérifiez si l'extension MongoDB est bien installée
php -m | grep mongodb

# Exécuter le reste du processus de déploiement
if [[ "${MAINTENANCE_MODE}" = "true" ]]; then
  php artisan down
fi

# Exécution des commandes pour construire l'application
npm install
npm run build

# Installer les dépendances PHP avec Composer
composer install --ignore-platform-reqs

# Effectuer les migrations si nécessaire
php artisan migrate --force

# Revenir en mode normal si la maintenance est terminée
if [[ "${MAINTENANCE_MODE}" = "false" ]]; then
  php artisan up
fi
