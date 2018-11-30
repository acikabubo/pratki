#!/bin/bash

# Scripts path
IMIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC="$(dirname "$IMIN")"

docker network create pratki-net

docker run --name pratki-db --network=pratki-net \
    -v $SRC/pg/data:/var/lib/postgresql/data -p 6543:5432 \
    -e POSTGRES_PASSWORD=postgres -d postgres:11-alpine -c fsync=off

docker run --name pratki-redis --network=pratki-net \
    -p 6379:6379 \
    -d redis:alpine

docker build --force-rm -t pratki-heroku \
    --build-arg USER=$USER \
    --build-arg UID=`id -u $USER` \
    --build-arg GID=`id -g $GROUP` \
    $SRC

docker create --rm -it \
    --name pratki-heroku \
    -v $SRC:/pratki-heroku \
    -v $SRC/supervisor/pratki.conf:/etc/supervisor/conf.d/pratki.conf \
    -v $SRC/supervisor/supervisord.conf:/etc/supervisor/supervisord.conf \
    --hostname server \
    --network pratki-net \
    -p 5000:5000 \
    -e DATABASE_URL='postgres://vzdnqoovnvgmgu:1582147d7b2ff4ee88b52ca47a48064cafb997fcea0d78bbac3cebf76fc7bbbe@ec2-54-217-235-159.eu-west-1.compute.amazonaws.com:5432/d8kstj8qf9g683' \
    pratki-heroku tmux new -s server bash

docker run \
    --name pratki-nginx \
    -p 80:80 \
    -p 443:443 \
    -p 5555:5555 \
    -p 9001:9001 \
    --network pratki-net \
    -v $SRC/nginx/nginx.conf:/etc/nginx/conf.d/default.conf \
    -v $SRC/nginx/ssl/pratki-heroku.crt:/etc/nginx/pratki-heroku.crt \
    -v $SRC/nginx/ssl/pratki-heroku.key:/etc/nginx/pratki-heroku.key \
    -v $SRC/nginx/.htpasswd:/etc/nginx/.htpasswd \
    -v $SRC/nginx/html/401.html:/usr/share/nginx/html/401.html \
    -v $SRC/nginx/html/502.html:/usr/share/nginx/html/502.html \
    -d nginx:stable-alpine sh -c "while true; do nginx -g 'daemon off;'; sleep 1; done"

docker start -a -i pratki-heroku

docker rm -f pratki-nginx
docker rm -f pratki-db
docker rm -f pratki-redis

DANGLING=$(docker images -f "dangling=true" -q)
if [ "x""$DANGLING" != "x" ]; then
    docker rmi $DANGLING
fi
docker volume ls -qf dangling=true | xargs -r docker volume rm

echo "Successfuly destroyed all containers"
exit 0
