#!/bin/bash

DEFAULT_HOST="localhost"
DEFAULT_PORT="5432"

# Проверка существования .pgpass
check_pgpass() {
    if [[ ! -f ~/.pgpass ]]; then
        initial_setup
    fi
}

# Первоначальная настройка
initial_setup() {
    echo "Добро пожаловать в PgCLI Manager!"
    echo "Давайте настроим ваше первое подключение."
    
    read -p "Введите имя подключения (например, local): " name
    read -p "Введите хост (по умолчанию: $DEFAULT_HOST): " host
    host=${host:-$DEFAULT_HOST} # Устанавливаем значение по умолчанию
    
    read -p "Введите порт (по умолчанию: $DEFAULT_PORT): " port
    port=${port:-$DEFAULT_PORT} # Устанавливаем значение по умолчанию
    
    read -p "Введите имя базы данных: " database
    read -p "Введите имя пользователя: " user
    read -s -p "Введите пароль: " password
    echo # Переход на новую строку

    # Добавляем запись в .pgpass
    echo "${host}:${port}:${database}:${user}:${password}" >> ~/.pgpass
    chmod 0600 ~/.pgpass

    # Добавляем подключение в конфигурацию
    source /opt/bash_scripts/pgcli_manager/utils.sh
    add_connection "$name" "$host" "$port" "$database" "$user"
    
    echo "Настройка завершена! Теперь вы можете подключаться командой:"
    echo "pgm connect $name"
}

check_pgpass
