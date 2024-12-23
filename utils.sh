#!/bin/bash

# Цветовые схемы
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Функция инициализации конфигурации
initialize_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "# PgCLI Manager Configuration" > "$CONFIG_FILE"
        echo "# format: name|host|port|database|user|password" >> "$CONFIG_FILE"
        echo "# example: local|localhost|5432|postgres|postgres|postgres" >> "$CONFIG_FILE"
    fi
}

# Функция добавления нового подключения
add_connection() {
    local name="$1"
    local host="localhost"
    local port="5432"
    local database="$2"
    local user="$3"
    local password="${4:-}"

    if grep -q "^$name|" "$CONFIG_FILE"; then
        echo "Подключение с именем '$name' уже существует."
        echo "Хотите перезаписать его? (y/n)"
        read -r answer
        if [[ "$answer" != "y" ]]; then
            echo "Операция отменена."
            return 1
        fi
        remove_connection "$name" >/dev/null
    fi

    echo "$name|$host|$port|$database|$user|$password" >> "$CONFIG_FILE"
    echo "Подключение '$name' добавлено (user: $user)"
}



# Функция удаления подключения
remove_connection() {
    local name="$1"
    local temp_file=$(mktemp)

    grep -v "^$name|" "$CONFIG_FILE" > "$temp_file"
    mv "$temp_file" "$CONFIG_FILE"
    echo -e "${GREEN}Подключение '$name' удалено${RESET}"
}

# Функция получения списка подключений
list_connections() {
    if [[ -f "$CONFIG_FILE" ]]; then
        echo "Доступные подключения:"
        echo "---------------------"
        grep -v "^#" "$CONFIG_FILE" | while IFS="|" read -r name host port db user password; do
            echo "* $name:"
            echo "  База: $db"
            echo "  Пользователь: $user"
            echo "---------------------"
        done
    else
        echo -e "${RED}Файл конфигурации отсутствует.${RESET}"
    fi
}

# Функция подключения к базе данных
connect_to_db() {
    local name="$1"
    local connection_string=""

    if [[ -f "$CONFIG_FILE" ]]; then
        connection_string=$(grep "^$name|" "$CONFIG_FILE" | head -n1)
        if [[ -n "$connection_string" ]]; then
            IFS="|" read -r _ host port database user password <<< "$connection_string"
            echo "Подключение к базе данных:"
            echo "  База: $database"
            echo "  Пользователь: $user"
            echo "------------------------"
 
 	    # Подключаемся с паролем
            PGPASSWORD="$password" pgcli -h "$host" -p "$port" -U "$user" -d "$database"

            # Логируем успешное подключение
            log_connection "$name" "$user" "$host" "$database"
        else
            echo -e "${RED}Подключение '$name' не найдено.${RESET}"
            return 1
        fi
    else
        echo -e "${RED}Файл конфигурации отсутствует.${RESET}"
    fi
}


# Функция логирования подключений
log_connection() {
    local name="$1"
    local user="$2"
    local host="$3"
    local database="$4"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $name: $user@$host/$database" >> "$HISTORY_FILE"
}

# Функция экспорта конфигурации
export_config() {
    local target_file="$1"
    cp "$CONFIG_FILE" "$target_file"
    echo -e "${GREEN}Конфигурация сохранена в $target_file${RESET}"
}

# Функция импорта конфигурации
import_config() {
    local source_file="$1"
    cp "$source_file" "$CONFIG_FILE"
    echo -e "${GREEN}Конфигурация импортирована из $source_file${RESET}"
}

# Функция отображения истории подключений
show_history() {
    local filter="$1"
    if [[ -f "$HISTORY_FILE" ]]; then
        if [[ -n "$filter" ]]; then
            grep "$filter" "$HISTORY_FILE"
        else
            cat "$HISTORY_FILE"
        fi
    else
        echo -e "${YELLOW}История подключений пуста.${RESET}"
    fi
}
