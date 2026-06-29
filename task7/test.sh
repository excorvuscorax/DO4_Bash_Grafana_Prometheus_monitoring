#!/bin/bash

# Скрипт для запуска stress с указанными параметрами
# stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s

echo "Запуск stress теста..."
echo "Параметры:"
echo "  - 2 CPU worker"
echo "  - 1 I/O worker"
echo "  - 1 VM worker с 32MB памяти"
echo "  - Время выполнения: 10 секунд"
echo ""

# Запуск stress
stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s

# Проверка кода возврата
if [ $? -eq 0 ]; then
    echo ""
    echo "Тест успешно завершен"
else
    echo ""
    echo "Ошибка при выполнении stress теста"
    exit 1
fi
