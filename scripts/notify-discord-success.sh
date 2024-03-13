#!/bin/bash

WEBHOOK_URL=$DISCORD_WEBHOOK_URL

curl -H "Content-Type: application/json" \
     -X POST \
     -d '{"content": "Build succeeded! :white_check_mark:"}' \
     $WEBHOOK_URL