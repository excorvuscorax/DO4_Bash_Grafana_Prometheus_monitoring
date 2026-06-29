#!/bin/bash

gen_name() {
    local chars="$1"
    local date="_$(date +%d%m%y)"
    local name_length=$((RANDOM % 4 + 4))
    local name="$chars"
    
    #adding characters of the required length
    while [ ${#name} -lt $name_length ]; 
    do
        local random_char="${chars:$((RANDOM % ${#chars})):1}"
        name="${name}${random_char}"
    done
    
    #sort characters according to order in chars
    local sorted_name=""
    for ((i=0; i<${#chars}; i++)); 
    do
        local char="${chars:$i:1}"
        local count=$(echo "$name" | grep -o "$char" | wc -l)
        for ((j=0; j<count; j++)); 
        do
            sorted_name="${sorted_name}${char}"
        done
    done
    
    echo "${sorted_name}${date}"
}

# file name generation
gen_files_name() {
    local file_chars="$1"
    local name_chars="${file_chars%.*}"
    local ext_chars="${file_chars#*.}"

    local file_name=$(gen_name $name_chars) 

    local ext_length=$((RANDOM % 3 + 1))
    local file_ext="$ext_chars"
    
    #adding characters of the required length
    while [ ${#file_ext} -lt $ext_length ]; 
    do
        local random_char="${ext_chars:$((RANDOM % ${#ext_chars})):1}"
        file_ext="${file_ext}${random_char}"
    done
     
    #sort extension characters according to the order in ext_chars
    local sorted_file_ext=""
    for ((i=0; i<${#ext_chars}; i++)); 
    do
        local char="${ext_chars:$i:1}"
        local count=$(echo "$file_ext" | grep -o "$char" | wc -l)
        for ((j=0; j<count; j++)); 
        do
            sorted_file_ext="${sorted_file_ext}${char}"
        done
    done

    if [ ${#file_ext} -gt 3 ]; 
    then
        echo "${file_name}${date}.${file_ext}"
    else
        echo "${file_name}${date}.${sorted_file_ext}"
    fi
}	