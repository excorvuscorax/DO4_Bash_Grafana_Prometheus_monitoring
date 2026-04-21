#!/bin/bash

if [ $# -ne 1 ]; 
then
    echo "Error: The script must have 1 parameters"
    exit 1
fi

del_method=$1

check_param() {
    if ! [[ "$del_method" =~ ^[1-3]$ ]]; 
    then
        echo "Error: Incorect input method"
        return 1
    fi
    return 0
}

check_date_input() {
    local date="$1"
    local time="$2"

    if ! [[ "$date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; 
    then
        echo "Error: Incorect date format. Use format like YYYY-MM-DD"
        return 1
    fi

    if ! [[ "$time" =~ ^[0-9]{2}:[0-9]{2}$ ]]; 
    then
        echo "Error: Incorect time format. Use format like HH:MM"
        return 1
    fi

    local hour=$(echo "$time" | awk -F ':' '{print $1}')
    local minute=$(echo "$time" | awk -F ':' '{print $2}')

    if [ "$hour" -lt 0 ] || [ "$hour" -gt 23 ]; 
    then
        echo "Error: The hours can be in the range of 00-23"
        return 1
    fi

    if [ "$minute" -lt 0 ] || [ "$minute" -gt 59 ]; 
    then
        echo "Error: The minutes can be in the range of 00-59"
        return 1
    fi

    local year=$(echo "$date" | awk -F '-' '{print $1}')
    local month=$(echo "$date" | awk -F '-' '{print $2}')
    local day=$(echo "$date" | awk -F '-' '{print $3}')

    if [ "$month" -lt 1 ] || [ "$month" -gt 12 ]; 
    then
        echo "Error: The month can be in the range of 01-12"
        return 1
    fi

    local days_in_month=31
    case $month in
        02) days_in_month=28 ;;
        04|06|09|11) days_in_month=30 ;;
    esac

    if [ "$day" -lt 1 ] || [ "$day" -gt "$days_in_month" ]; then
        echo "Error: The day can be in the range of 01-$days_in_month for month $month"
        return 1
    fi

    return 0
}

