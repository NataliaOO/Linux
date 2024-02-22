#!/bin/bash

if [[ $# -ne 0 ]]; then
    echo "The script should run without parameters!" >&2
    exit 1
fi

# Установка Nginx
sudo apt install -y nginx
# Даем права на выполнение скрипта get_info.sh
chmod +x get_info.sh
# Копируем конфигурацию Prometheus
sudo cp ./.conf/prometheus.yml /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus.service
# Перезагружаем конфигурацию Nginx
sudo cp ./.conf/nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload

sudo cp index.html /usr/share/nginx/html/index.html
echo "Processing..." >&2

while sleep 3
do
    ./get_info.sh
    sudo cp index.html /usr/share/nginx/html/index.html
done
