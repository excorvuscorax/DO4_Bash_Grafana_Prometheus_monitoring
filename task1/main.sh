#!/bin/bash

fileCheck="check_param.sh"
fileGen="gen_names.sh"
fileCreate="create_folds_and_files.sh"


if [[ -s $fileCheck ]] && [[ -s $fileGen ]] && [[ -s $fileCreate ]]
then
        chmod +x $fileCheck $fileGen $fileCreate

    source ./$fileCheck
    source ./$fileGen
    source ./$fileCreate

    if ! check_param "$@"; then
        exit 1
    fi

    if ! check_free_space; then
        exit 1
    fi

    create_folders "$1" "$2" "$3" "$4" "$5" "$6"

else
     echo "Error script-file is not exist"
fi