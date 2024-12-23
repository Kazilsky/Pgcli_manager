#!/bin/bash

# Конфигурационные параметры
CONFIG_DIR="$HOME/.pgcli_manager"
CONFIG_FILE="$CONFIG_DIR/connections.conf"
HISTORY_FILE="$CONFIG_DIR/history.log"
DEFAULT_PORT=5432

# Создание конфигурационной директории
mkdir -p "$CONFIG_DIR"
