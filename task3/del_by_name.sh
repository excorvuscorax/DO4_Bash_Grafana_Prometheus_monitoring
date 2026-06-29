#!/bin/bash
del_by_name() {
    find /home -type d | while read -r item; 
    do
        local item_name=$(basename "$item")
	    if [[ "$item_name" =~ ^[a-z]{4,7}_[0-9]{6}$ ]]; 
        then
	        rm -rf $item
        fi
    done
}
