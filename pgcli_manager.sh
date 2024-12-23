#!/bin/bash
#run
#alias pgm='pgcli_manager.sh'

# Определение директории скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подключение зависимостей
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/utils.sh"

show_help() {
    echo "Использование: pgm [команда] [параметры]"
    echo ""
    echo "Команды:"
    echo "  add NAME DATABASE USER PASSWORD (or without) - Добавить новое подключение (host: localhost, port: 5432 по умолчанию)"
    echo "  remove NAME                       - Удалить подключение"
    echo "  list                             - Показать все подключения"
    echo "  connect NAME                      - Подключиться к базе данных"
    echo "  history                          -дите пароль: 

 Показать историю подключений"
    echo "  help                             - Показать эту справку"
    echo ""
    echo "Примеры:"
    echo "  pgm add local                    - Добавить подключение с параметрами по умолчанию"
    echo "  pgm connect local"
    echo ""
    echo "При подключении пароль будет запрошен отдельно"
}

# Инициализация конфигурации при первом запуске
initialize_config

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
    "help"|"")
        show_help
        ;;
    *)
        echo "Неизвестная команда: $1"
        echo "Используйте 'pgm help' для получения списка команд"
        ;;
esac
