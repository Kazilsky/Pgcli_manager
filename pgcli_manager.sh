#!/bin/bash
#run
#alias pgm='pgcli_manager.sh'

# Определение директории скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подключение зависимостей
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/utils.sh"

show_help() {
    echo "Usage: pgm [command] [parameters]"
    echo ""
    echo "Commands:"
    echo "  add NAME DATABASE USER [PASSWORD]   - Add a new connection (default: host=localhost, port=5432)"
    echo "  remove NAME                        - Remove a connection"
    echo "  list                              - List all connections"
    echo "  connect NAME                      - Connect to a database"
    echo "  history                           - Show connection history"
    echo "  alias on|off                      - Toggle alias mode"
    echo "  default_alias NAME                - Set or display the default alias"
    echo "  help                              - Show this help message"
    echo ""
    echo "Examples:"
    echo "  pgm add local postgres postgres   - Add a connection named 'local'"
    echo "  pgm connect local                 - Connect to 'local' database"
    echo ""
    echo "If a password is required, it will be prompted separately unless specified."
}

# Инициализация конфигурации при первом запуске
initialize_config
load_alias_settings

case "$1" in
    "add")
        if [[ $# -eq 5 ]]; then
	    # Если переданы все 5 аргументов, добавляем с паролем
	    add_connection "$2" "$3" "$4" "$5"
	elif [[ $# -eq 4 ]]; then
	    # Если переданы только 4 аргумента, добавляем без пароля (пустая строка)
	    add_connection "$2" "$3" "$4" ""
	else
	    echo "Использование: pgm add NAME DATABASE USER [password]"
	    echo "Например: pgm add NAME postgres postgres"
	fi
        ;;
    "remove")
        if [[ $# -eq 2 ]]; then
            remove_connection "$2"
        else
            echo "Использование: pgm remove NAME"
        fi
        ;;
    "list")
        list_connections
        ;;
    "connect")
        if [[ $# -eq 2 ]]; then
            connect_to_db "$2"
        else
            echo "Использование: pgm connect NAME"
        fi
        ;;
    "history")
        if [[ -f "$HISTORY_FILE" ]]; then
            echo "История подключений:"
            echo "-------------------"
            cat "$HISTORY_FILE"
        else
            echo "История подключений пуста"
        fi
        ;;
    "help")
        show_help
        ;;
    "alias")
        if [[ $# -eq 2 ]]; then
            alias_toggle "$2"
        else
            echo "Использование: pgm alias on|off"
        fi
        ;;
    "default_alias")
        if [[ $# -eq 2 ]]; then
            set_default_alias "$2"
        else
            echo "Использование: pgm default_alias NAME"
        fi
        ;;
    "")
        if [[ "$alias_enabled" == "on" && -n "$default_alias" ]]; then
            connect_to_db "$default_alias"
        else
            show_help
        fi
        ;;
    *)
        if [[ "$alias_enabled" == "on" && -z "$1" && -n "$default_alias" ]]; then
            # Алиас включён, вызываем шаблонное соединение
            echo "Using default alias: $default_alias"
            connect_to_database "$default_alias"
        elif [[ "$alias_enabled" == "on" && -n "$1" ]]; then
            # Алиас включён, но передано имя соединения
            connect_to_db "$1"
        elif [[ -z "$1" && -n "$default_alias" ]]; then
            # Алиас выключен, но используется стандартный шаблон
            echo "Connecting to default alias: $default_alias"
            connect_to_db "$default_alias"
        else
            echo "Неизвестная команда: $1"
            echo "Используйте 'pgm help' для получения списка команд"
        fi
        ;;
esac
