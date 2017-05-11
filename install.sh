#!/bin/bash

# DB user / password
db="example"

# Site URL
url="example.dev"

# Site title
title="Example"

# Admin user
user="admin"
password="****"
email="admin@example.dev"

# Theme name
theme="mytheme@"

read -d '' sql << EOF
    CREATE DATABASE IF NOT EXISTS $db;
    CREATE USER '$db'@'%' IDENTIFIED BY '$db';
    GRANT ALL ON $db.* TO '$db'@'%';
    FLUSH PRIVILEGES;
EOF

./docker-compose-run-script.sh db-exec mysql -u root -psecret -e "$sql"

./docker-compose-run-script.sh php-exec chown -R www-data:www-data .
./docker-compose-run-script.sh wp core download --locale=fr_FR

rm wp-config.php
./docker-compose-run-script.sh wp core config --dbname=$db --dbuser=$db --dbpass=$db --dbhost=db --skip-check
./docker-compose-run-script.sh wp core install --url=$url --title="$title" --admin_user=$user --admin_password=$password --admin_email=$email

./docker-compose-run-script.sh wp core update
./docker-compose-run-script.sh wp core update-db
./docker-compose-run-script.sh wp plugin update --all

./docker-compose-run-script.sh php-exec composer create-project roots/sage "wp-content/themes/$theme" 8.5.1
./docker-compose-run-script.sh php-exec chown -R www-data:www-data "wp-content/themes/$theme"

./docker-compose-run-script.sh wp theme activate $theme
./docker-compose-run-script.sh wp theme delete twentyseventeen
./docker-compose-run-script.sh wp theme delete twentyfifteen
./docker-compose-run-script.sh wp theme delete twentysixteen

./docker-compose-run-script.sh wp plugin delete hello
./docker-compose-run-script.sh wp plugin delete akismet
./docker-compose-run-script.sh wp plugin install wordpress-seo
./docker-compose-run-script.sh wp plugin activate wordpress-seo
./docker-compose-run-script.sh wp plugin install regenerate-thumbnails
./docker-compose-run-script.sh wp plugin activate regenerate-thumbnails
./docker-compose-run-script.sh wp plugin install
./docker-compose-run-script.sh wp plugin activate
./docker-compose-run-script.sh wp plugin install
./docker-compose-run-script.sh wp plugin activate
./docker-compose-run-script.sh wp plugin install
./docker-compose-run-script.sh wp plugin activate

./docker-compose-run-script.sh wp option update blogname "$title"
./docker-compose-run-script.sh wp option update blogdescription ""

./docker-compose-run-script.sh wp option update blog_public 1

./docker-compose-run-script.sh wp option update default_pingback_flag 0
./docker-compose-run-script.sh wp option update default_ping_status close
./docker-compose-run-script.sh wp option update default_comment_status close
./docker-compose-run-script.sh wp option update require_name_email 1
./docker-compose-run-script.sh wp option update comment_registration 1
./docker-compose-run-script.sh wp option update close_comments_for_old_posts 1
./docker-compose-run-script.sh wp option update close_comments_days_old 1
./docker-compose-run-script.sh wp option update comment_moderation 1

./docker-compose-run-script.sh wp option update permalink_structure "/%postname%/"

(cd "wp-content/themes/$theme" && npm i)
(cd "wp-content/themes/$theme" && bower install)
(cd "wp-content/themes/$theme" && gulp)
