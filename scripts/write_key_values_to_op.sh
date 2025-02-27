#!/usr/bin/env bash

export GLOBAL_VALUES=global_values.json
export VAULT=platform

# loop through global_values.json, write the defined fields to the associated secret
for key in $(jq -r 'keys_unsorted[]' $GLOBAL_VALUES); do
    fields=$(jq -r --arg key $key '.[$key]' $GLOBAL_VALUES)
    for field in $(echo $fields | jq -r 'keys_unsorted[]'); do
        echo "write $key/$field"
        value=$(echo $fields | jq -r --arg field $field '.[$field]' | base64 -w 0)
        op item edit $key --vault $VAULT $field=$value >/dev/null
    done
done
