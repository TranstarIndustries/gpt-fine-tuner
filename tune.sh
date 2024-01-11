#!/bin/bash

set -e


# Function to upload a file
upload_file() {
    local file_path=$1
    local response=$(curl --location --request POST 'https://api.openai.com/v1/files' \
                        --header "Authorization: Bearer $OPENAI_TOKEN" \
                        --form 'file=@"'"$file_path"'"' \
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

check_response() {
    local response=$1
    if [[ $(jq -r '.error' <<< "$response") != "null" ]]; then
        echo "Error occured:"
        jq -r '.error' <<< "$response"
        exit 1
    fi
}

# Main script execution
file_path=$1

if [[ -z "$file_path" ]]; then
    echo "Please provide a file path"
    echo usage: ./tune.sh training_data
    exit 1
fi

file_response=$(upload_file "$file_path")
check_response "$file_response"
file_id=$(check_upload_status "$file_response")
echo Successfully uploaded training data: $file_id
job_response=$(start_fine_tuning_job "$file_id")
check_response "$job_response"
echo Successfully started fine-tuning job: $job_response
