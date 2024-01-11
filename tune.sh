#!/bin/bash

set -e

# Function to upload a file
upload_file() {
    local response=$(curl --location --request POST 'https://api.openai.com/v1/files' \
                        --header "Authorization: Bearer $OPENAI_TOKEN" \
                        --form 'file=@"converted_chat_format_data.jsonl"' \
                        --form 'purpose="fine-tune"')
    echo $response
}

# Function to check the upload status
check_upload_status() {
    local response=$1
    if [[ $(jq -r '.status' <<< "$response") != "uploaded" ]]; then
        echo "File upload failed"
        exit 1
    fi
    jq -r '.id' <<< "$response"
}

# Function to initiate a fine-tuning job
start_fine_tuning_job() {
    local file_id=$1
    curl --location --request POST 'https://api.openai.com/v1/fine_tuning/jobs' \
         --header 'Content-Type: application/json' \
         --header "Authorization: Bearer $OPENAI_TOKEN" \
         --data-raw "{
             \"training_file\": \"$file_id\",
             \"model\":\"gpt-3.5-turbo-1106\",
             \"suffix\":\"transtar-locations\"
         }"
}

# Main script execution
# file_response=$(upload_file)
# file_id=$(check_upload_status "$file_response")
# start_fine_tuning_job "$file_id"
