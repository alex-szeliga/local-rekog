#!/bin/bash

if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

OUTPUT_JSON_DIR=rekognition_response_json

mkdir -p "$OUTPUT_JSON_DIR"

for json_file in ./rekognition_json_payloads/*.json; do
    if [ -f "$json_file" ]; then
        echo "submitting $json_file to Rekognition detect-labels via $AWS_SSO_PROFILE_NAME..."
        # aws rekognition detect-labels \
        #     --cli-input-json file://$json_file \
        #     --region us-gov-west-1 \
        #     --profile $AWS_SSO_PROFILE_NAME > "./$OUTPUT_JSON_DIR/$json_file"
    fi
    sleep 0.5
done
