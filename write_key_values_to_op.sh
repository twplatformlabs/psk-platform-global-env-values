for key in $(cat global_values.json | jq -r 'keys_unsorted[]'); do
    echo $key
    jq -r --arg key $key '.[$key]' global_values.json
done

#jq -r 'keys[] as $k | "\($k), \(.[$k] | .ip)"' global_values.json

#  op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-secret-access-key=$(echo $PSKNonprodServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n) >/dev/null