#!/bin/sh

. ~/.anybot.secrets.sh
MIX_ENV=prod mix release
