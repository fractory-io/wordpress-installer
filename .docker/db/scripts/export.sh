#!/bin/bash

mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" "$1"
