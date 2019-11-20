#!/bin/sh

. ~/.anybot.config.sh
mix deps.get
mkdir -p priv/static
mix phx.digest
MIX_ENV=prod mix release
