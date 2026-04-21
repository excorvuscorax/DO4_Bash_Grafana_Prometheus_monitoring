#!/bin/bash

create_folders() {
    local path="$1"
    local folder_number="$2"
    local folder_chars="$3"
    local file_number="$4"
    local file_chars="$5"
    local file_size="$6"

    for (( i=1; i <= folder_number; i++ ))
    do
        local folder_name=""
        local full_folder_path=""
        
	local tries=0
        while [ $tries -lt 10 ]; do
            folder_name=$(gen_name "$folder_chars")
            full_folder_path="${path}/${folder_name}"
            if [ ! -d "$full_folder_path" ]; then
                break
            fi
            ((tries++))
        done
    	
	if ! check_free_space; then
            return 1
        fi

	mkdir $full_folder_path 2>/dev/null
	if [ -d $full_folder_path ]; then
            echo "$full_folder_path $(date "+%d.%m.%Y %H:%M:%S")" >> filegen.log
        fi
    	create_files "$full_folder_path" "$file_number" "$file_chars" "$file_size"
    done
}

create_files() {
    local folder_path="$1"
    local file_number="$2"
    local file_chars="$3"
    local file_size="$4"
    local size_num=${file_size%kb}
    
    for (( j=1; j <= file_number; j++ ))
    do
        local file_name=""
        local full_file_path=""
        local tries=0
        
        while [ $tries -lt 10 ]; do
            file_name=$(gen_files_name "$file_chars")
            full_file_path="${folder_path}/${file_name}"
            
            if [ ! -f "$full_file_path" ]; then
                break
            fi
            ((tries++))
        done
   
        if ! check_free_space; then
            return 1
        fi

	fallocate -l "${size_num}K" "$full_file_path" 2>/dev/null     
	if [ -f "$full_file_path" ]; then
            echo "$full_file_path $(date "+%d.%m.%Y %H:%M:%S") ${size_num}K" >> filegen.log
        fi
    done
}
