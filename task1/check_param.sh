#!/bin/bash

if [ $# -ne 6 ]; 
then
    echo "Error: The script must have 6 parameters"
    exit 1
fi

path=$1
folder_number=$2
folder_chars=$3
file_number=$4
file_chars=$5
file_size=$6

check_param() {
    # check the 1-st parameter - path
    if [ ! -d "$path" ]; 
    then
        echo "Error: The path named "$path" does not exist"
        return 1
    fi

    # check the 2-nd and 4-th parameters - number of folders and number of files
    if ! [[ "$folder_number" =~ ^[0-9]+$ ]] || ! [[ "$file_number" =~ ^[0-9]+$ ]]; 
    then
        echo "Error: The number of folders and files must be a numeric value."
        return 1
    fi
    # check the 3-th parameter - folder characters
    if ! [[ "$folder_chars" =~ ^[a-z]{1,7}$ ]]; 
    then
        echo "Error: The folder letters contain invalid characters."
        return 1
    fi
    # check the 5-th parameter - file characters
    if ! [[ "$file_chars" =~ ^[a-z]{1,7}\.[a-z]{1,3}$ ]]; 
    then
        echo "Error: File letters contain invalid characters."
        return 1
    fi

    # check uniqueness of characters - folder and file
    if [ $(echo $folder_chars | fold -w1 | sort | uniq -d | wc -l) -ne 0 ]; 
    then
	    echo "Error: Characters among the letters in folder names are not unique."
	    return 1
    fi

    if [ $(echo ${file_chars%.*} | fold -w1 | sort | uniq -d | wc -l) -ne 0 ]; 
    then
        echo "Error: Characters among the letters in file names are not unique."
        return 1
    fi

    # check the 6-th parameter - size of file
    if ! [[ "$file_size" =~ ^([0-9]+)kb$ ]]; 
    then
        echo "Error: The file size format is incorrect."
        return 1
    fi

    check_size=${file_size%kb}
    if [ $check_size -gt 100 ]; 
    then
        echo "Error: The file size must be less than 100kb"
        return 1
    fi

    if [ $check_size -le 0 ]; 
    then
        echo "Error: The file size is incorrect"
        return 1
    fi
    
    return 0
}

check_free_space() {
    free_space_mb=$(df -m / | awk 'NR==2 {print $4}')

    if [ $free_space_mb -lt 1024 ]; 
    then
        echo "Warning: Less than 1 GB of free space left"
	return 1
    fi

    return 0
}

