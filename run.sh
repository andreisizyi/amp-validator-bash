#!/bin/bash

url_file="urls.txt"
error_file="urls-with-error.txt"

check_amp() {
    url="$1"

    if [[ -n "$url" && "$url" =~ ^http ]]; then
        validation_result=$(amphtml-validator "$url")
        
        if echo "$validation_result" | grep -q "PASS"; then
            echo "URL: $url - Status: PASS"
        else
            echo "URL: $url - Status: FAIL"
            echo "$validation_result"
            echo "$url" >> "$error_file"
        fi
    fi
}

if [[ ! -f "$url_file" ]]; then
    echo "Файл с URL не найден: $url_file"
    exit 1
fi

# Clear errors file
> "$error_file"

# Read url from file
while IFS= read -r url || [[ -n "$url" ]]; do
    # Ignore empty or starting with # strings
    [[ -z "$url" || "$url" =~ ^# ]] && continue
    check_amp "$url"
done < "$url_file"