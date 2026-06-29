#!/bin/bash

fileCheck="check_param.sh"
delDate="del_by_date.sh"
delLog="del_by_logfile.sh"
delName="del_by_name.sh"

if [[ -s $fileCheck ]] && [[ -s $delDate ]] && [[ -s $delLog ]] && [[ -s $delName ]]
then

	source ./$fileCheck
	source ./$delDate
	source ./$delLog
	source ./$delName

	if ! check_param "$@"; 
	then
    	exit 1
	fi

	del_method=$1
	case $del_method in
    	1) del_by_logfile;;
    	2)	read -p "Enter the start date and time for the creation of files (for example 2026-12-31 12:34): " start_date start_time 
			read -p "Enter the end date and time for the creation of files (for example 2026-12-31 12:36): " end_date end_time
	
		if ! check_date_input "$start_date" "$start_time"; 
		then
    	    echo "Error: Incorect the start date"
            exit 1
        fi

		if ! check_date_input "$end_date" "$end_time"; then
    	    echo "Error: Incorect the end date"
            exit 1
		fi
 
		if ! compare_dates "$start_date" "$start_time" "$end_date" "$end_time"; then
    	    echo "Error: The start date is later than the end date"
	    exit 1
		fi
        	
		del_by_date "$start_date $start_time" "$end_date $end_time";;
    	3) del_by_name;;
	esac

else
    echo "Error script-file is not exist"
fi
