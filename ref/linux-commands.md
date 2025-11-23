# Linux Commands Reference

## Network Commands
- `ifconfig [interface] -a` - Display or configure network interface parameters
- `ip -a` - Show IP addresses and network info
- `iwconfig <interface> essid <name> mode <mode> channel <channel>` - Configure wireless network interfaces
- `netcat/nc [host] [port] -l -u -k` - Read/write network connections using TCP/UDP
- `netstat -tuln -a -r -n` - Display network connections, routing tables, interface statistics
- `nslookup <domain> -server -timeout -type=ptr` - Query DNS for domain name information
- `tcpdump -i <interface> -n -c -A` - Monitor and capture network traffic
- `whois <domain> -h -p -T` - Retrieve domain registration information
- `scp <source> <destination> -r` - Securely copy files over SSH

## Process Management
- `ps aux -e -f -u` - Show information on running processes
- `top -d <seconds> -u <user> -p <pid>` - Real-time process monitoring and system resource usage
- `kill <pid> -9 -l -s` - Terminate processes by sending signals
- `fg %<job_id> -l -n -h` - Bring background job to foreground
- `service <name> <action> --status-all --full-restart` - Manage system services (legacy)
- `systemctl <action> <service> start|stop|restart|enable|disable` - Manage systemd services and system manager

## File System & Storage
- `ls -l -a -h` - List directory contents
- `find <path> -name -type -iname -exec` - Search for files and directories
- `locate <something>` - Quickly find files by name
- `which <command> -a -s --skip-alias` - Locate executable file for a command
- `lsblk -a -p -e` - List information about block devices
- `mount <device> <mountpoint> -t -o -r` - Attach filesystem to directory tree
- `tar -cvf <archive> <files> -z -x -t` - Archive and compress files

## Text Processing & Search
- `grep "pattern" <file> -i -r -n` - Search for text patterns in files
- `awk 'pattern {action}' <file> -F -v -f` - Text processing and data extraction
- `tee [file] -a -i -p` - Read stdin and write to stdout and files
- `vim <file> -c +<line> -o` - Powerful text editor

## System Information & Hardware
- `dmesg -c -H -k` - Display kernel ring buffer messages
- `lsusb -t -v -h` - List USB devices connected to system
- `man <command> -a -k -f` - Display manual pages for commands
- `tldr <command> --update --list --random` - Simplified command examples and quick reference

## Security & Administration
- `sudo <command> -u -s -i` - Execute commands with superuser privileges

## Task Scheduling
- `crontab -e -l -r -u` - Schedule recurring tasks at specific times
- `at <time> <day>` - Schedule one-time tasks for future execution

## User Management
- `useradd <username> -u -g -G -e` - Create new user account
- `passwd <username>` - Set or change user password
- `usermod -a -G <group> <user>` - Modify user account properties
- `groupadd <groupname>` - Create new group

## Environment & Shell
- `export KEY=VALUE -p -n` - Set environment variables in shell session

## Compression & Archives
- `zip <archive> <files> -r -q -e` - Compress files into zip archive
- `tar -cvf <archive> <files> -z -x -t` - Create and extract tar archives

## Utilities
- `fzf -h -e --tac` - Interactive fuzzy finder for command-line

## Important System Files
- `/etc/passwd` - User accounts, home directories, and privileges
- `/etc/shadow` - User password hashes
- `/etc/services` - Well-known services and port numbers mapping
- `/etc/resolv.conf` - DNS resolver configuration
- `/home/user/.bash_history` - Command history for user

## Keyboard Shortcuts
- `Ctrl + C` - Interrupt running command
- `Ctrl + D` - Send EOF or exit shell
- `Ctrl + Z` - Suspend process to background
- `Ctrl + L` - Clear screen
- `Ctrl + A` - Move cursor to line beginning
- `Ctrl + E` - Move cursor to line end
- `Ctrl + U` - Delete from cursor to line start
- `Ctrl + K` - Delete from cursor to line end
- `Ctrl + R` - Search command history
