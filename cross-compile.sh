#!/bin/sh

docker build -t local/anybot-builder -f builder.dockerfile . && \
docker run -v $(pwd):/src -e SECRET_KEY_BASE -e LIVE_VIEW_SIGNING_SALT local/anybot-builder sh -c 'cd /src; ./build.sh'
