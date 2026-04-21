#!/bin/bash

gen_ip() {
    echo "$((RANDOM % 255+1)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 254 + 1))"
}

# 200 - OK: успешный запрос
# 201 - Created: успешное создание ресурса
# 400 - Bad Request: некорректный запрос от клиента
# 401 - Unauthorized: требуется аутентификация
# 403 - Forbidden: доступ запрещен
# 404 - Not Found: ресурс не найден
# 500 - Internal Server Error: внутренняя ошибка сервера
# 501 - Not Implemented: функционал не реализован
# 502 - Bad Gateway: ошибка шлюза
# 503 - Service Unavailable: сервис временно недоступен
status_codes=(200 201 400 401 403 404 500 501 502 503)

methods=(GET POST PUT PATCH DELETE)

gen_timestamp() {
    local day=$1
    local index=$2
    local total=$3

    local base_date="2026-02-0$day"
    local seconds_to_add=$(( (86400 * index) / total ))

    local timestamp=$(date -d "$base_date + $seconds_to_add seconds" "+%d/%b/%Y:%H:%M:%S %z")
    echo "$timestamp"
}

user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/119.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0"
    "Opera/9.80 (Windows NT 6.1; WOW64) Presto/2.12.388 Version/12.18"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/118.0"
    "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
)

urls=(
    "/index.html"
    "/about.html" 
    "/contact.html"
    "/products.html"
    "/login"
    "/register"
    "/dashboard"
    "/admin"
)


