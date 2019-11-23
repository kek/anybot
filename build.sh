#!/bin/sh

. ~/.anybot.config.sh
mix deps.get
npm run deploy --prefix ./assets
mkdir -p priv/static
mix phx.digest
MIX_ENV=prod mix release --overwrite
