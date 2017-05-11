#!/bin/bash
command=$1
shift
if [ "$command" == "" ]; then
    scriptpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    echo "Usage:"
    cat $scriptpath |
        tail -n +20 |
        grep -e "^    .*) #.*$" |
        sed -e 's/) # /\t/' |
        sed -r 's/^[[:space:]]+(.*)/  \1/g' |
        awk 'BEGIN { FS = "\t" } ; { printf "%-20s %s\n", $1, $2}'
    exit 0
fi
case $command in
    clean) # Remove unused images
        docker rmi -f $(docker images | grep "<none>" | awk "{print \$3}") ;;
    kill-all) # Kill all running images
        docker kill $(docker ps -q) ;;
    nginx) # Run bash on nginx container
        docker exec -i -t $(docker ps | grep "_nginx_" | awk '{print $NF}') /bin/bash "$@" ;;
    db) # Run bash on db container
        docker exec -i -t $(docker ps | grep "_db_" | awk '{print $NF}') /bin/bash "$@" ;;
    db-exec) # Run command on db container
        docker exec -i -t $(docker ps | grep "_db_" | awk '{print $NF}') "$@" ;;
    php) # Run bash on php container
        docker exec -i -t $(docker ps | grep "_php_" | awk '{print $NF}') /bin/bash "$@" ;;
    php-exec) # Run command on php container
        docker exec -i -t $(docker ps | grep "_php_" | awk '{print $NF}') "$@" ;;
    nginx-config) # Reload nginx configuration
        docker cp .docker/nginx/config/default.conf $(docker ps | grep "_nginx_" | awk '{print $NF}'):/etc/nginx/conf.d/default.conf ; docker kill -s HUP $(docker ps | grep "_nginx_" | awk '{print $NF}') "$@" ;;
    php-config) # Reload php configuration
        docker cp .docker/php/config/php.ini $(docker ps | grep "_php_" | awk '{print $NF}'):/usr/local/etc/php/php.ini ; docker kill -s USR2 $(docker ps | grep "_php_" | awk '{print $NF}') "$@" ;;
    db-export) # Export database dump
        docker exec -i $(docker ps | grep "_db_" | awk '{print $NF}') /export.sh "$@" ;;
    db-import) # Import database dump
        docker exec -i $(docker ps | grep "_db_" | awk '{print $NF}') /import.sh "$@" ;;
    wp) # Run wp-cli on php container
        docker exec -i -t --user www-data $(docker ps | grep "_php_" | awk '{print $NF}') wp "$@" ;;
esac
