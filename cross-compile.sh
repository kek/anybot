#!/bin/sh

docker run -v $(pwd):/src -e SECRET_KEY_BASE -e LIVE_VIEW_SIGNING_SALT bitwalker/alpine-elixir-phoenix:1.9.4 sh -c 'cd /src; ./build.sh'
