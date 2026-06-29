#!/bin/bash

create_folders() {
    local folder_chars="$1"
    local file_chars="$2"
    local file_size="$3"    

    local folder_count=$((RANDOM % 90 + 10))
    for (( i=1; i <= folder_count; i++ ))
    do
        local folder_name=""
	    local folder_path=$(find /home/ -type d 2>/dev/null | shuf -n 1)
        if [[ "$folder_path" == *"bin"* ]]; 
        then
	    continue
	fi
	
	local tries=0
        while [ $tries -lt 10 ]; 
        do
            folder_name=$(gen_name "$folder_chars")
            full_folder_path="${folder_path}/${folder_name}"
            if [ ! -d "$full_folder_path" ]; 
            then
                break
            fi
            ((tries++))
        done
	
	if ! check_free_space; 
    then
            return 1
        fi
    	
	mkdir $full_folder_path 2>/dev/null
	if [ -d $full_folder_path ]; 
    then
	    echo "$full_folder_path $(date "+%d.%m.%Y %H:%M:%S")" >> filegen.log
	fi
	create_files "$full_folder_path" "$file_chars" "$file_size"
    done
}

create_files() {
    local folder_path="$1"
    local file_count=$((RANDOM % 90 + 10))
    local file_chars="$2"
    local file_size="$3"
    local size_num=${file_size%Mb}
    
    for (( j=1; j <= file_count; j++ ))
    do
        local file_name=""
        local full_file_path=""
        local tries=0
        
        while [ $tries -lt 10 ]; 
        do
            file_name=$(gen_files_name "$file_chars")
            full_file_path="${folder_path}/${file_name}"
            
            if [ ! -f "$full_file_path" ]; 
            then
                break
            fi
            ((tries++))
        done
   
	    if ! check_free_space; 
        then
            return 1
        fi

        fallocate -l "${size_num}M" "$full_file_path" 2>/dev/null 
	if [ -f "$full_file_path" ]; 
    then
	    echo "$full_file_path $(date "+%d.%m.%Y %H:%M:%S") ${size_num}M" >> filegen.log
        fi
    done
}