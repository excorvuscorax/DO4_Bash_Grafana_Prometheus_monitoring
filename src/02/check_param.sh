#!/bin/bash

if [ $# -ne 3 ]; 
then
    echo "Error: The script must have 3 parameters"
    exit 1
fi

folder_chars=$1
file_chars=$2
file_size=$3

check_param() {

    # check the 1-st parameter - folder characters
    if ! [[ "$folder_chars" =~ ^[a-z]{1,7}$ ]]; 
    then
        echo "Error: The folder letters contain invalid characters."
        return 1
    fi

    # check the 2-nd parameter - file characters
    if ! [[ "$file_chars" =~ ^[a-z]{1,7}\.[a-z]{1,3}$ ]]; 
    then
        echo "Error: File letters contain invalid characters."
        return 1
    fi

    # check uniqueness of characters - folder and file
    if [ $(echo $folder_chars | fold -w1 | sort | uniq -d | wc -l) -ne 0 ]; 
    then
	    echo "Ошибка: символы в списке букв для папок неуникальны"
	    return 1
    fi

    if [ $(echo ${file_chars%.*} | fold -w1 | sort | uniq -d | wc -l) -ne 0 ]; 
    then
        echo "Ошибка: символы в списке букв для файлов неуникальны"
        return 1
    fi

    # check the 3-th parameter - size of file
    if ! [[ "$file_size" =~ ^([0-9]+)Mb$ ]]; 
    then
        echo "Ошибка: неверный формат параметра размера файла"
        return 1
    fi

    size_num=${file_size%Mb}
    if [ $size_num -gt 100 ]; 
    then
        echo "Ошибка: размер файла не должен превышать 100Mb"
        return 1
    fi
    
    if [ $size_num -le 0 ]; 
    then
        echo "Ошибка: неверный размер файла"
        return 1
    fi
    return 0
}

check_free_space() {
    free_space_mb=$(df -m / | awk 'NR==2 {print $4}')

    if [ "$free_space_mb" -lt 1024 ]; 
    then  
        return 1
    fi
    
    return 0
}
