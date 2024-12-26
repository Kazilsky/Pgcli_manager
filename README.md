# PgCLI Manager

**PgCLI Manager** is a user-friendly Bash utility that simplifies working with PostgreSQL databases using `pgcli`.\
It allows you to manage connections, track history, and interact with databases through intuitive command-line commands.

---

## 🌟 Features

- **Connection Management**: Add, list, edit, and remove database connections effortlessly.
- **Smart Alias System**: 
  - Quick connect without 'connect' command when alias mode is enabled
  - Default connection support for instant database access
  - Automatically connect to a default database if no parameters are provided
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
  ```

1. Clone the repository:
   ```bash
   git clone https://github.com/Kazilsky/pgcli_manager.git
   cd pgcli-manager
   chmod +x pgcli_manager.sh
   ```
2. (Optional) Add an alias for easier usage:
   ```bash
   alias pgm="/path/to/pgcli-manager/pgcli_manager.sh"
   source ~/.bashrc
   ```

---

## 🔑 Alias Mode & Default Connections

### Alias Mode
Alias mode simplifies the connection process by removing the need for the `connect` command. When enabled:

- **Standard Connection**: 
  ```bash
  pgm mydb  # Instead of 'pgm connect mydb'

### Default Alias
- **Default alias provides instant connection to your preferred database without specifying any parameters**:
   ```bash
   pgm # instead of 'pgm connect [BASE]'
   ```
- **Set Default**:
   ```bash
   pgm default_alias dev_db # Sets 'dev_db' as default connection
   ```
- **Check Current Default** *(Coming soon)*:
   ```bash
   pgm default_alias # Shows which connection is currently set as default
   ```

### Combined Usage
When both features are enabled:
- **Set up your environment**:
   ```bash
   pgm alias on              # Enable alias mode
   pgm default_alias dev_db  # Set default connection
   ```
- **Quick access**:
   ```bash
   pgm prod_db              # Connects to prod_db
   pgm                       # Connects to default database (dev_db)
   ```



## 📋 Usage

1. Run the script with one of the following commands:
   ```bash
   pgm [command] [arguments]
   ```
2. You can get acquainted through `pgm help` or by running `pgm` without arguments.

### Commands:

- `add NAME DATABASE USER [PASSWORD]`: Add a new connection
- `remove NAME`: Remove an existing connection
- `list`: Show all saved connections
- `connect NAME`: Connect to a database
- `history`: Show connection history
- `alias on|off`: Enable or disable alias mode
- `default_alias NAME`: Set or show the default alias
- `help`: Show help message

### Quick examples:

- Add a new connection (password will be prompted):
  ```bash
  pgm add mydb database1 user1
  ```
- Connect to a database:
  ```bash
  pgm connect mydb
  ```
- List all connections:
  ```bash
  pgm list
  ```
- Enable alias mode:
  ```bash
  pgm alias on
  ```
- Set a default alias:
  ```bash
  pgm default_alias mydb
  ```

### Default values:

- Host: `localhost`
- Port: `5432`

---

## 📁 Configuration

- Connections are stored in `~/.pgcli_manager/connections.conf`
- History is stored in `~/.pgcli_manager/history.log`
- Alias settings are stored in `~/.pgcli_manager/alias.conf`

---

## ⚙️ Security Considerations

By default, passwords are saved in the configuration file. If you'd prefer to enter the password each time you connect, you can leave it out when adding a new connection. The script will prompt for the password securely during runtime.

---

## 🛠️ Troubleshooting

If you encounter issues with connecting to the database or any other command, try the following:

- Ensure that `pgcli` is installed and working properly.
- Double-check your configuration file (`connections.conf`) for correctness.
- If there are permission issues with configuration files, make sure they are readable and writable.

---

## 📜 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

