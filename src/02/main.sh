#!/bin/bash

fileCheck="check_param.sh"
fileGen="gen_names.sh"
fileCreate="create_folds_and_files.sh"

if [[ -s $fileCheck ]] && [[ -s $fileGen ]] && [[ -s $fileCreate ]]
then
    start_time_sec=$(date +%s)
    start_time=$(date +%H:%M:%S)

    chmod +x $fileCheck $fileGen $fileCreate

    source ./$fileCheck
    source ./$fileGen
    source ./$fileCreate

    if ! check_param "$@"; 
    then
        exit 1
    fi

    while true; 
    do
        if ! check_free_space; 
        then
        echo "Осталось менее 1 ГБ свободного места в системе"
	    break
        fi
    create_folders "$1" "$2" "$3"
    done

    end_time_sec=$(date +%s)
    end_time=$(date +%H:%M:%S)
    exec_time_sec=$((end_time_sec - start_time_sec))
    echo "Начало работы скрипта: $start_time"
    echo "Конец работы скрипта: $end_time"
    echo "Время работы скрипта: ${exec_time_sec}s"
    echo "$start_time $end_time ${exec_time_sec}s" >> filegen.log
   

else
    echo "Error script-file is not exist"
fi