#!/bin/bash
# Функция логирования
log() {
    echo -e "\e[94m[INFO]\e[0m $1"
}

# Функция для вывода ошибок
error() {
    echo -e "\e[91m[ERROR]\e[0m $1"
    exit 1
}

# Проверка запуска от root
if [[ $EUID -ne 0 ]]; then
   error "Скрипт должен быть запущен от root"
fi

log "Установка необходимых пакетов..."
/usr/bin/apt update && /usr/bin/apt upgrade -y || error "Ошибка установки пакетов"

log "Скачивание hestia..."
/usr/bin/wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh|| error "Не удалось скачать Hestia"

log "Запуск установки hestia..."
PASSWORD=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16)
HOSTNAME="curl -s "https://dns.google/resolve?name=$IPv4&type=PTR" | grep -oP '"data":\s*"\K[^"]+'"
SERVER_IP=$(/usr/bin/curl -s http://checkip.amazonaws.com)
bash hst-install.sh \
	--interactive no \
	--hostname $HOSTNAME \
    --username admin \
	--email admin@mail.com \
	--password $PASSWORD \
    --force \

echo "Панель: $SERVER_IP:8083"
echo "admin"
echo "Пароль:" $PASSWORD
echo $HOSTNAME
