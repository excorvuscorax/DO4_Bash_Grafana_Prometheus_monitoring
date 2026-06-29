#!/bin/bash

compare_dates() {
    local start_date="$1"
    local start_time="$2"
    local end_date="$3"
    local end_time="$4"

    local start_timestamp=$(date -d "${start_date} ${start_time}" +%s)
    local end_timestamp=$(date -d "${end_date} ${end_time}" +%s)

    if [ "$start_timestamp" -gt "$end_timestamp" ]; 
    then
        return 1
    fi

    return 0
}

del_by_date() {
    local start_date="$1"
    local end_date="$2"
    local start_timestamp=$(date -d "$start_date" +%s)
    local end_timestamp=$(date -d "$end_date" +%s)


    find /home/ -type f 2>/dev/null | while read -r item; 
    do
        local item_creation_date=$(stat -c %y "$item" 2>/dev/null | awk -F ':' '{print $1":"$2}')

	    if [ -n "$item_creation_date" ]; 
        then
	    local item_timestamp=$(date -d "$item_creation_date" +%s)

	    if [ "$item_timestamp" -ge "$start_timestamp" ] && [ "$item_timestamp" -le "$end_timestamp" ]; 
        then
		item_dirname=$(dirname $item)
		rm -rf $item_dirname 
	    fi
	fi
    done
}

