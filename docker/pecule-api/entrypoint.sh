#!/bin/bash

touch /var/www/html/api/releases/current/core-laravel/laravel/storage/logs/laravel.log
chgrp -R www-data /var/www/html/api/releases/current/core-laravel/laravel/storage/logs/laravel.log
chmod -R 775 /var/www/html/api/releases/current/core-laravel/laravel/storage/logs/laravel.log
service cron start


until echo "SHOW DATABASES;" | mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD | grep -q "$MYSQL_DATABASE"; do
    echo "Waiting for mysql..."
    sleep 1
done


echo "Importing data"

# check if /__provision/.provisioned exists
if [ ! -f ~/.provisioned ]; then

    echo "Running composer install"
    cd /var/www/html/api/releases/0000/core-laravel/laravel && composer install

    echo "Running migrations"
    php artisan migrate
    php artisan migrate --path=packages/Pecule/migrations/
    php artisan migrate --path=packages/Pecule/migrations/provisions/common/
    php artisan migrate --path=packages/Pecule/migrations/provisions/$PARTNER_NAME/

    echo "Provisioning database"
    # check if provision file exists
    if [ -f /__provision/$PARTNER_NAME.sql ]; then
        echo "Importing data from /__provision/$PARTNER_NAME.sql"
        cat /__provision/$PARTNER_NAME.sql | mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE
    else
        echo "No provision file found"
    fi
    touch ~/.provisioned
else
    echo "Laravel already provisioned"
fi

# check if table pecule_partners is empty
# if [ $(mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -D $MYSQL_DATABASE -e "SELECT COUNT(*) FROM pecule_partners" | tail -n 1) -eq 0 ]; then
#     echo "Importing data"
#     # check if provision file exists
#     if [ -f /__provision/$PARTNER_NAME.sql ]; then
#         echo "Importing data from /__provision/$PARTNER_NAME.sql"
#         cat /__provision/$PARTNER_NAME.sql | mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE
#     else
#         echo "No provision file found"
#     fi
# else
#     echo "Data already imported"
# fi

# cat data.sql | mysql -upecule -ppeculeCestCool$ pecule

# check if apache is running

apachectl -D FOREGROUND


# if [ ! -f /var/run/apache2/apache2.pid ]; then
#     echo "Starting apache"
#     apachectl -D FOREGROUND
# else
#     echo "Apache already running"
# fi
