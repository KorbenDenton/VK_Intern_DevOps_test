#!/bin/bash
set -e

sudo apt update
sudo apt install -y nginx curl
systemctl enable nginx
systemctl start nginx

# Копируем файлы
cp nginx.conf /etc/nginx/nginx.conf
cp monitoring.sh /usr/local/bin/monitoring.sh
chmod +x /usr/local/bin/monitoring.sh

# Проверка конфига nginx
echo "Проверка конфигурации nginx..."
if ! sudo nginx -t; then
    echo "ОШИБКА: Невалидный nginx.conf"
    exit 1
fi

cp monitoring.service /etc/systemd/system/
cp monitoring.timer /etc/systemd/system/

# Перезагружаем systemd и запускаем
systemctl daemon-reload
systemctl enable monitoring.timer
systemctl start monitoring.timer

echo "Установка завершена. Скрипт мониторинга работает каждые 30 секунд."