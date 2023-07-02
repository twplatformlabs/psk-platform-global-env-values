#!/usr/bin/env bash

export GLOBAL_VALUES=global_values.json
export VAULT=empc-lab

# loop through global_values.json, write the defined fields to the associated secret
errors=0
for key in $(jq -r 'keys_unsorted[]' $GLOBAL_VALUES); do
    fields=$(jq -r --arg key $key '.[$key]' $GLOBAL_VALUES)
    for field in $(echo $fields | jq -r 'keys_unsorted[]'); do
        value=$(echo $fields | jq -r --arg field $field '.[$field]' | base64)
        stored=$(op item get $key --vault $VAULT --fields $field )
        echo
        if [ $stored != $value ]; then
            printf "error: the stored value for $key/$field does not match the desired value.\n\n"
            printf "Stored value:\n$(echo $stored | base64 -d)\n\ndesired value\n$(echo $value | base64 -d)"
            errors=1
        fi
    done
done

if [ $errors == 1 ]; then
    exit 1
fi
