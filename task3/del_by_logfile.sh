#!/bin/bash

del_by_logfile() {
    local logfile_path="../02/filegen.log"
    if [ ! -f "$logfile_path" ]; 
    then
        echo "Error: The logfile does not exist"
	    return 1;
    fi
    
    while IFS= read -r line; 
    do
	del_object=$(echo $line | awk '{print $1}')  
	
	if [ -z "$del_object" ]; 
    then
            continue
        fi

	if [[ "$del_object" == *"/"* ]]; 
    then
	    rm -rf "$del_object"
	fi

    done < "$logfile_path"
}

