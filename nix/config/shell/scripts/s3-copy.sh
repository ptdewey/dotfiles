#!/usr/bin/env bash

stg() {
    s3_link="${1:-}"
    output_path="${2:-}"
    
    if [ -z "$s3_link" ]; then
        s3_link=$(gum input \
            --placeholder "s3://bucket/path/to/file" \
            --prompt "S3 Link: " \
            --width 120)
        if [ -z "$s3_link" ]; then
            gum style --foreground 196 "No S3 link provided. Exiting."
            return 1
        fi 
    fi  

    s3_link="$(echo "$s3_link" | xargs)"

    if [[ "$s3_link" =~ lle ]]; then
        profile="lle"
    elif [[ "$s3_link" =~ prod ]]; then
        profile="prod"
    elif [[ "$s3_link" =~ localstack ]]; then
        profile="localstack"
    elif [[ "$s3_link" =~ (localstack|local-audit-logs) ]]; then
        profile="localstack"
    else
        profile=$(gum choose \
          --header "Select AWS Profile" "lle" "prod" "localstack")
        
        if [ -z "$profile" ]; then
          gum style --foreground 196 "No profile selected. Exiting."
          return 1
        fi
    fi

    gum style --foreground 148 "Using profile: $profile"

    gum style --foreground 212 "Running: aws s3 cp --profile=$profile $s3_link $output_path"

    aws s3 cp --profile="$profile" "$s3_link" "$output_path"

    if [ $? -eq 0 ]; then
        gum style --foreground 42 "Copy completed successfully"
    else
        gum style --foreground 196 "Copy failed"
        return 1
    fi
}
