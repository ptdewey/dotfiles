#!/usr/bin/env bash

stg() {
    output_path="${1:-.}"

    s3_link=$(gum input \
      --placeholder "s3://bucket/path/to/file" \
      --prompt "S3 Link: " \
      --width 120)

    if [ -z "$s3_link" ]; then
      gum style --foreground 196 "No S3 link provided. Exiting."
      exit 1
    fi

    if [[ "$s3_link" =~ lle ]]; then
      profile="lle"
    elif [[ "$s3_link" =~ prod ]]; then
      profile="prod"
    else
      profile=$(gum choose \
        --header "Select AWS Profile" "lle" "prod" "localstack")
      
      if [ -z "$profile" ]; then
        gum style --foreground 196 "No profile selected. Exiting."
        exit 1
      fi
    fi

    gum style --foreground 148 "Using profile: $profile"

    gum style --foreground 212 "Running: aws s3 cp --profile=$profile $s3_link $output_path"

    aws s3 cp --profile="$profile" "$s3_link" "$output_path"

    if [ $? -eq 0 ]; then
      gum style --foreground 42 "Copy completed successfully"
    else
      gum style --foreground 196 "Copy failed"
      exit 1
    fi
}
