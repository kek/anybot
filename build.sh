#!/bin/sh

. ~/.anybot.config.sh
mix deps.get
mix phx.digest
MIX_ENV=prod mix release
