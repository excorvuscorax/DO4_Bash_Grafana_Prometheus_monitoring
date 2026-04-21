#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Установка Prometheus и Grafana ===${NC}"

# Создаем пользователя для Prometheus
echo -e "${YELLOW}Создание пользователя prometheus...${NC}"
sudo useradd --no-create-home --shell /bin/false prometheus 2>/dev/null

# Создаем директории
echo -e "${YELLOW}Создание директорий...${NC}"
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Скачиваем Prometheus
echo -e "${YELLOW}Скачивание Prometheus...${NC}"
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar xvf prometheus-2.45.0.linux-amd64.tar.gz
cd prometheus-2.45.0.linux-amd64


# Копируем бинарники
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# Копируем консоли
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles /etc/prometheus/console_libraries

# Создаем конфиг Prometheus
echo -e "${YELLOW}Настройка Prometheus...${NC}"
sudo tee /etc/prometheus/prometheus.yml > /dev/null << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Создаем systemd сервис для Prometheus
sudo tee /etc/systemd/system/prometheus.service > /dev/null << 'EOF'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.external-url=

[Install]
WantedBy=multi-user.target
EOF

# Запускаем Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Проверяем Prometheus
if sudo systemctl is-active --quiet prometheus; then
    echo -e "${GREEN}✓ Prometheus запущен на порту 9090${NC}"
else
    echo -e "${RED}✗ Ошибка запуска Prometheus${NC}"
fi

# Установка Grafana
echo -e "${YELLOW}Установка Grafana...${NC}"

# Добавляем репозиторий Grafana
sudo apt-get install -y software-properties-common wget
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Обновляем и устанавливаем
sudo apt-get update
sudo apt-get install -y grafana

# Запускаем Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Проверяем Grafana
if sudo systemctl is-active --quiet grafana-server; then
    echo -e "${GREEN}✓ Grafana запущена на порту 3000${NC}"
else
    echo -e "${RED}✗ Ошибка запуска Grafana${NC}"
fi

# Настраиваем firewall (если включен)
if command -v ufw >/dev/null 2>&1; then
    echo -e "${YELLOW}Настройка firewall...${NC}"
    sudo ufw allow 9090/tcp comment 'Prometheus'
    sudo ufw allow 3000/tcp comment 'Grafana'
fi

# Получаем IP виртуальной машины
VM_IP=$(hostname -I | awk '{print $1}')

echo ""
echo -e "${GREEN}=== УСТАНОВКА ЗАВЕРШЕНА ===${NC}"
echo ""
echo -e "${YELLOW}Prometheus:${NC} http://$VM_IP:9090"
echo -e "${YELLOW}Grafana:${NC}    http://$VM_IP:3000"
echo ""
echo -e "${YELLOW}Логин/пароль Grafana по умолчанию:${NC} admin / admin"
echo ""
echo -e "${GREEN}Для доступа с Windows используйте IP: $VM_IP${NC}"