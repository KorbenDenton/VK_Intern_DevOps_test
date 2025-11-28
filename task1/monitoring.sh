#!/bin/bash
URL="http://localhost:80"                   # URL приложения для проверки
LOG="/var/log/monitoring.log"               # Файл для логов приложения
CONNECT_TIMEOUT=2                           # Таймаут на установку TCP-соединения (секунды)
MAX_TIMEOUT=5                               # Максимальное время одного HTTP-запроса (секунды)
RETRY_COUNT=3                               # Количество попыток проверки до принятия решения
SERVICE="nginx"                             # Имя сервиса, который нужно перезапускать



# Функция логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG"
}


# Проверка доступности приложения

# Флаг успешности проверки
SUCCESS=false

# Делаем несколько попыток, чтобы исключить случайные сбои
for i in $(seq 1 $RETRY_COUNT); do
    # Выполняем HTTP-запрос с таймаутами
    STATUS=$(curl -s \
        --connect-timeout $CONNECT_TIMEOUT \
        --max-time $MAX_TIMEOUT \
        -o /dev/null \
        -w "%{http_code}" \
        "$URL")
    # Проверяем код ответа
    if [ "$STATUS" = "200" ]; then
        SUCCESS=true
        break
    fi

    # Ждём немного перед повтором
    sleep 1
done


# Обработка результата
if $SUCCESS; then
    # Приложение доступно
    log "OK: Приложение работает. Код ответа $STATUS."
    exit 0
else
    # Приложение недоступно
    log "ERROR: Приложение недоступно. Код ответа: $STATUS"
fi


# Проверяем корректность конфига перед рестартом
if ! nginx -t &>/dev/null; then
    log "CRITICAL: Конфигурация nginx повреждена. Перезапуск невозможен."
    exit 1
fi


# Перезапуск сервиса
log "ACTION: Перезапуск сервиса $SERVICE..."
systemctl restart "$SERVICE"

# Проверяем, перезапустился ли сервис успешно
if systemctl is-active --quiet "$SERVICE"; then
    log "SUCCESS: Сервис $SERVICE успешно перезапущен."
else
    log "CRITICAL: Сервис $SERVICE не смог перезапуститься!"
fi

exit 0
