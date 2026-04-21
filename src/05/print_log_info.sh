#!/bin/bash

print_sorted_codes() {
    awk '{print $0}' ../04/access_*.log | sort -k9
}

print_uniq_ip() {
    awk '{print $1}' ../04/access_*.log | sort -u
}

print_error_codes() {
    awk '$9 ~ /^[45]/ {gsub(/"/, "", $6); gsub(/"/, "", $8); print $6, $7, $8}' ../04/access_*.log
}

print_error_codes_uniq_ip() {
    awk '$9 ~ /^[45]/ {print $1}' ../04/access_*.log | sort -u
}	

