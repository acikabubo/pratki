#!/bin/bash

IMIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC="$(dirname "$IMIN")"

docker build --force-rm -t pratki-heroku $SRC

docker create --rm -it \
    --name pratki-heroku \
    -v $SRC:/pratki-heroku \
    -p 5000:5000 \
    pratki-heroku bash

docker run --rm -it -p 5000:5000 pratki-heroku bash

DANGLING=$(docker images -f "dangling=true" -q)
if [ "x""$DANGLING" != "x" ]; then
    docker rmi $DANGLING
fi
docker volume ls -qf dangling=true | xargs -r docker volume rm

echo "Successfuly destroyed all containers"
exit 0
