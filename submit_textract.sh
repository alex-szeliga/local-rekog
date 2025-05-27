#!/bin/bash

if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

OUTPUT_JSON_DIR=textract_response_json

mkdir -p "$OUTPUT_JSON_DIR"

for JSON_FILE in ./textract_json_payloads/*.json; do
    if [ -f "$JSON_FILE" ]; then
        echo "submitting $JSON_FILE to Rekognition detect-labels via $AWS_SSO_PROFILE_NAME..."
        aws textract detect-document-text \
            --cli-input-json file://$JSON_FILE \
            --region $AWS_REGION \
            --profile $AWS_SSO_PROFILE_NAME > "./$OUTPUT_JSON_DIR/${JSON_FILE##*/}"
    fi
    sleep 0.5
done
