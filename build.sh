#!/bin/sh

. ~/.anybot.secrets.sh
mix deps.get
MIX_ENV=prod mix release
