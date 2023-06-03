#!/usr/bin/env bash

# loop through global_values.json, write aech key/value pair to platform-global-config in empc-lab vault
for key in $(jq -r 'keys_unsorted[]' global_values.json); do
    echo "write global value $key=$(jq -r --arg key $key '.[$key]' global_values.json) to op"
    op item edit 'platform-global-config' $key=$(jq -r --arg key $key '.[$key]' global_values.json) >/dev/null
done
