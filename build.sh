#!/bin/sh

. ~/.anybot.config.sh
mix deps.get
MIX_ENV=prod mix release
