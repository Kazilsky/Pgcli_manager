# PgCLI Manager

**PgCLI Manager** is a user-friendly Bash utility that simplifies working with PostgreSQL databases using `pgcli`.  
It allows you to manage connections, track history, and interact with databases through intuitive command-line commands.

---

## 🌟 Features
- **Connection Management**: Add, list, edit, and remove database connections effortlessly.
- **Secure Password Handling**: Choose to save passwords or input them securely at runtime.
- **History Tracking**: Automatically log all connections for quick reference.
- **Configuration Backup**: Import and export connection settings easily.
- **Customizable**: Modify default paths and settings in the configuration files.

---

## 📦 Installation
### Prerequisites
- `pgcli` must be installed on your system
    ```bash
    # Using pip
    pip install pgcli   
    # Or using your system package manager
    # For Ubuntu/Debian
    sudo apt-get install pgcli
    # For MacOS
    brew install pgcli

1. Clone the repository:
    ```bash
    git clone https://github.com/Kazilsky/pgcli_manager.git
    cd pgcli-manager
    chmod +x pgcli_manager.sh
2. (Optional) Add an alias for easier usage:
    ```bash 
    alias pgm="/path/to/pgcli-manager/pgcli_manager.sh" 
    source ~/.bashrc

## 📋 Usage
1. Run the script with one of the following commands:
    ```bash 
    pgm [command] [arguments]
2. You can get acquainted through ```pgm help``` or ```pgm```
### Commands:
    add NAME DATABASE USER [PASSWORD] - Add new connection
    remove NAME - Remove existing connection```
    list - Show all saved connections
    connect NAME - Connect to database
    history - Show connection history
    help - Show help message 
### Quick examples: 
    # Add new connection (password will be prompted)
    pgm add mydb database1 user1

    # Connect to database
    pgm connect mydb

    # List all connections
    pgm list
### Default values:
    Host: localhost
    Port: 5432
    
    Later, I will make it possible to easily change this if this project lives on. 
## 📁 Configuration
- Connections are stored in ~/.pgcli_manager/connections.conf
- History is stored in ~/.pgcli_manager/history.log

## ⚙️ Security Considerations
By default, passwords are saved in the file. If you'd prefer to enter the password each time you connect, you can leave it out when adding a new connection. The script will prompt for the password securely during runtime.connections.conf

To avoid saving passwords, simply leave the field blank when adding a connection. You'll be prompted for it when connecting to the database.password

## 🛠️ Troubleshooting
If you encounter issues with connecting to the database or any other command, try the following:

- Ensure that is installed and working properly.pgcli
- Double-check your configuration file () for correctness.connections.conf
- If there are permission issues with configuration files, make sure they are readable and writable.

## 📜 License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
