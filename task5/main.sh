#!/bin/bash
source ./print_log_info.sh

if [ $# -ne 1 ]; then
    echo "Error: The script must be run with 1 parameter"
    exit 1
fi

if ! [[ "$1" =~ ^[1-4]$ ]]; then
    echo "Error: Incorrect characters are specified"
    exit 1
fi

if ! ls ../04/access_*.log >/dev/null 2>/dev/null; then
    echo "Error: The logfiles is not exist"
    exit 1
fi

param=$1
case $param in
    1) print_sorted_codes;;
    2) print_uniq_ip;;
    3) print_error_codes;;
    4) print_error_codes_uniq_ip;;
esac
