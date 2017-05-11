# Docker files


## Requirements

- <a href="https://docs.docker.com/engine/installation/" target="_blank">docker</a>
- <a href="https://docs.docker.com/compose/install/" target="_blank">docker-compose</a>


## Usage

### Run

- `docker-compose start`


### Stop

- `docker-compose stop`


### Access

- web : <a href="http://localhost:80/" target="_blank">http://localhost:80</a>
- phpmyadmin : <a href="http://localhost:8080/" target="_blank">http://localhost:8080</a>


### MySQL Dumps

- build time : auto import sql files from db/entrypoint
- export : `./docker-compose-run-script.sh db-export dbname > FILENAME.sql`
- import : `./docker-compose-run-script.sh db-import dbname < FILENAME.sql`

*db_container container must be running


### Other Commands

- help: `./docker-compose-run-script.sh`
- copy and reload nginx config : `./docker-compose-run-script.sh nginx-config`
- copy and reload php config : `./docker-compose-run-script.sh php-config`
- connect to nginx container : `./docker-compose-run-script.sh nginx`
- connect to php container : `./docker-compose-run-script.sh php`
- connect to db container : `./docker-compose-run-script.sh db`
