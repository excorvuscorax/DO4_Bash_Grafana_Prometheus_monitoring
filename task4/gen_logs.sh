#!/bin/bash

source ./log_items.sh

gen_log() {
    local day=$1
    local index=$2
    local total=$3

    local ip=$(gen_ip)
    local status_code=${status_codes[$RANDOM % ${#status_codes[@]}]}
    local method=${methods[$RANDOM % ${#methods[@]}]}
    local timestamp=$(gen_timestamp "$day" "$index" "$total")
    local url=${urls[$RANDOM % ${#urls[@]}]}
    local bytes=1024
    local user_agent=${user_agents[$RANDOM % ${#user_agents[@]}]}
    local referer="https://google.com/"
    echo "$ip - - [$timestamp] \"$method $url HTTP/1.1\" $status_code $bytes \"$referer\" \"$user_agent\""
}

gen_logs() {
    for ((day=1; day<=5; day++)); do
	local log_file="access_${day}.log"
        local num_entries=$((RANDOM % 901 + 100))
        > "$log_file"

        for ((index=0; index<num_entries; index++)); do
            gen_log "$day" "$index" "$num_entries" >> "$log_file"
        done
    done
}