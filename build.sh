#!/bin/sh

mix local.hex --force && \
mix deps.get && \
npm install --prefix assets && \
npm run deploy --prefix ./assets && \
mix phx.digest && \
MIX_ENV=prod mix release --overwrite
