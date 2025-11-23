#!/bin/sh
#
# Recon.sh
# Quick Linux system reconnaissance script for CTF and sysadmin
# Provides concise, scannable output about system state
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper function for section headers
print_section() {
    printf "\n${BLUE}═══ %s ═══${NC}\n" "$1"
}

# Helper function for info lines
print_info() {
    printf "${CYAN}  ▸${NC} %s\n" "$1"
}

# Helper function for warnings
print_warn() {
    printf "${YELLOW}  ⚠${NC} %s\n" "$1"
}

# Helper function for critical items
print_crit() {
    printf "${RED}  ✗${NC} %s\n" "$1"
}

# Helper function for success/safe items
print_safe() {
    printf "${GREEN}  ✓${NC} %s\n" "$1"
}

clear
printf "${CYAN}"
printf "╔═══════════════════════════════════════╗\n"
printf "║   Recon.sh - Quick System Recon       ║\n"
printf "╚═══════════════════════════════════════╝\n"
printf "${NC}"

# ═══════════════════════════════════════════════════════════════
# SYSTEM IDENTIFICATION
# ═══════════════════════════════════════════════════════════════
print_section "SYSTEM INFORMATION"

OS_INFO=$(cat /etc/os-release 2>/dev/null | grep "PRETTY_NAME" | cut -d'"' -f2)
[ -z "$OS_INFO" ] && OS_INFO=$(uname -s)
print_info "OS: $OS_INFO"

KERNEL=$(uname -r)
print_info "Kernel: $KERNEL"

HOSTNAME=$(hostname)
ARCH=$(uname -m)
print_info "Hostname: $HOSTNAME | Arch: $ARCH"

UPTIME=$(uptime -p 2>/dev/null || uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')
print_info "Uptime: $UPTIME"

# ═══════════════════════════════════════════════════════════════
# USER CONTEXT
# ═══════════════════════════════════════════════════════════════
print_section "USER CONTEXT"

CURRENT_USER=$(whoami)
USER_ID=$(id -u)
USER_GROUPS=$(id -Gn | tr ' ' ',')
print_info "Current: $CURRENT_USER (UID:$USER_ID) Groups: $USER_GROUPS"

# Check sudo access
if sudo -n true 2>/dev/null; then
    print_crit "SUDO: Passwordless sudo available!"
elif sudo -l 2>/dev/null | grep -q "(ALL)"; then
    print_warn "SUDO: User has sudo privileges (password required)"
else
    print_safe "SUDO: No sudo access"
fi

# Total users
TOTAL_USERS=$(cat /etc/passwd | wc -l)
SHELL_USERS=$(cat /etc/passwd | grep -E "/(bash|sh|zsh|fish)$" | wc -l)
print_info "Total users: $TOTAL_USERS | With shell access: $SHELL_USERS"

# List users with login shells (if reasonable number)
if [ $SHELL_USERS -le 10 ]; then
    LOGIN_USERS=$(cat /etc/passwd | grep -E "/(bash|sh|zsh|fish)$" | cut -d: -f1 | tr '\n' ' ')
    print_info "Shell users: $LOGIN_USERS"
fi

# Check for interesting users
PRIVILEGED_USERS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd | grep -v "^root$" | tr '\n' ' ')
if [ ! -z "$PRIVILEGED_USERS" ]; then
    print_warn "UID 0 users (besides root): $PRIVILEGED_USERS"
fi

# ═══════════════════════════════════════════════════════════════
# NETWORK SUMMARY
# ═══════════════════════════════════════════════════════════════
print_section "NETWORK"

# IP addresses
print_info "IP Addresses:"
ip -4 addr show 2>/dev/null | grep inet | awk '{print "    " $NF ": " $2}' || \
    ifconfig 2>/dev/null | grep "inet " | awk '{print "    " $2}'

# Listening ports (try different methods)
if command -v ss >/dev/null 2>&1; then
    LISTEN_PORTS=$(ss -tuln 2>/dev/null | grep LISTEN | awk '{print $5}' | rev | cut -d: -f1 | rev | sort -n | uniq)
    PORT_COUNT=$(echo "$LISTEN_PORTS" | wc -l)
elif command -v netstat >/dev/null 2>&1; then
    LISTEN_PORTS=$(netstat -tuln 2>/dev/null | grep LISTEN | awk '{print $4}' | rev | cut -d: -f1 | rev | sort -n | uniq)
    PORT_COUNT=$(echo "$LISTEN_PORTS" | wc -l)
else
    LISTEN_PORTS=""
    PORT_COUNT=0
fi

if [ $PORT_COUNT -gt 0 ]; then
    # Highlight interesting ports
    INTERESTING=""
    for port in 21 22 23 25 80 443 3306 5432 6379 8080 8443; do
        if echo "$LISTEN_PORTS" | grep -q "^$port$"; then
            INTERESTING="$INTERESTING $port"
        fi
    done
    
    print_info "Listening ports: $PORT_COUNT total"
    if [ ! -z "$INTERESTING" ]; then
        print_warn "Notable ports:$INTERESTING"
    fi
    
    # Show all if not too many
    if [ $PORT_COUNT -le 15 ]; then
        print_info "All ports: $(echo $LISTEN_PORTS | tr '\n' ' ')"
    fi
else
    print_info "Listening ports: Unable to enumerate (try with elevated privileges)"
fi

# Active connections
if command -v ss >/dev/null 2>&1; then
    ESTABLISHED=$(ss -tn 2>/dev/null | grep ESTAB | wc -l)
elif command -v netstat >/dev/null 2>&1; then
    ESTABLISHED=$(netstat -tn 2>/dev/null | grep ESTABLISHED | wc -l)
else
    ESTABLISHED=0
fi
[ $ESTABLISHED -gt 0 ] && print_info "Active connections: $ESTABLISHED"

# ═══════════════════════════════════════════════════════════════
# SECURITY CHECKS
# ═══════════════════════════════════════════════════════════════
print_section "SECURITY CHECKS"

# SUID binaries (only interesting ones)
print_info "Checking SUID binaries..."
INTERESTING_SUID="nmap vim vi nano less more python perl ruby php gcc find bash sh dash"
FOUND_SUID=""

for binary in $INTERESTING_SUID; do
    SUID_BINS=$(find /usr /bin /sbin -perm -4000 -name "$binary" 2>/dev/null)
    if [ ! -z "$SUID_BINS" ]; then
        FOUND_SUID="$FOUND_SUID $(basename $SUID_BINS)"
    fi
done

if [ ! -z "$FOUND_SUID" ]; then
    print_crit "Interesting SUID binaries:$FOUND_SUID"
else
    print_safe "No obviously exploitable SUID binaries found"
fi

# Quick count of all SUID
ALL_SUID=$(find /usr /bin /sbin -perm -4000 2>/dev/null | wc -l)
print_info "Total SUID binaries: $ALL_SUID"

# Writable directories in PATH
print_info "Checking writable directories in PATH..."
WRITABLE_PATH=""
OLD_IFS="$IFS"
IFS=':'
for dir in $PATH; do
    if [ -d "$dir" ] && [ -w "$dir" ]; then
        WRITABLE_PATH="$WRITABLE_PATH $dir"
    fi
done
IFS="$OLD_IFS"

if [ ! -z "$WRITABLE_PATH" ]; then
    print_warn "Writable PATH directories:$WRITABLE_PATH"
else
    print_safe "No writable directories in PATH"
fi

# Check readable sensitive files
SENSITIVE_READABLE=""
[ -r /etc/shadow ] && SENSITIVE_READABLE="$SENSITIVE_READABLE /etc/shadow"
[ -r /etc/sudoers ] && SENSITIVE_READABLE="$SENSITIVE_READABLE /etc/sudoers"
[ -r /root/.ssh/id_rsa ] && SENSITIVE_READABLE="$SENSITIVE_READABLE /root/.ssh/id_rsa"

if [ ! -z "$SENSITIVE_READABLE" ]; then
    print_crit "Readable sensitive files:$SENSITIVE_READABLE"
else
    print_safe "Common sensitive files not readable"
fi

# Check for interesting world-writable files in /etc
WRITABLE_ETC=$(find /etc -maxdepth 1 -type f -writable 2>/dev/null | wc -l)
if [ $WRITABLE_ETC -gt 0 ]; then
    print_warn "World-writable files in /etc: $WRITABLE_ETC"
fi

# Quick cron check
if [ -r /etc/crontab ]; then
    print_info "User has read access to /etc/crontab"
fi

# ═══════════════════════════════════════════════════════════════
# INTERESTING PROCESSES
# ═══════════════════════════════════════════════════════════════
print_section "PROCESSES & SERVICES"

# Interesting process names
INTERESTING_PROCS="apache2 httpd nginx mysql mysqld postgres redis docker containerd sshd"
FOUND_PROCS=""

for proc in $INTERESTING_PROCS; do
    if pgrep -x "$proc" >/dev/null 2>&1; then
        FOUND_PROCS="$FOUND_PROCS $proc"
    fi
done

if [ ! -z "$FOUND_PROCS" ]; then
    print_info "Notable services running:$FOUND_PROCS"
fi

# Processes running as root (count)
ROOT_PROCS=$(ps aux 2>/dev/null | grep "^root" | wc -l)
print_info "Processes running as root: $ROOT_PROCS"

# Check for containers
if command -v docker >/dev/null 2>&1; then
    DOCKER_CONTAINERS=$(docker ps 2>/dev/null | grep -v CONTAINER | wc -l)
    [ $DOCKER_CONTAINERS -gt 0 ] && print_warn "Docker containers running: $DOCKER_CONTAINERS"
fi

# ═══════════════════════════════════════════════════════════════
# FILESYSTEM
# ═══════════════════════════════════════════════════════════════
print_section "FILESYSTEM"

# Mounted filesystems
print_info "Mounted filesystems:"
df -hT 2>/dev/null | grep -v "tmpfs\|devtmpfs\|Filesystem" | awk '{print "    " $1 " (" $2 ") on " $7 " - " $6 " used"}' || \
    df -h 2>/dev/null | grep -v "tmpfs\|devtmpfs\|Filesystem" | awk '{print "    " $1 " on " $6 " - " $5 " used"}'

# Check for unusual mounts
UNUSUAL_MOUNTS=$(mount 2>/dev/null | grep -E "nfs|cifs|fuse" | wc -l)
[ $UNUSUAL_MOUNTS -gt 0 ] && print_warn "Unusual mounts detected (NFS/CIFS/FUSE): $UNUSUAL_MOUNTS"

# Home directories
HOME_DIRS=$(ls -1 /home 2>/dev/null | wc -l)
print_info "Home directories: $HOME_DIRS"

# ═══════════════════════════════════════════════════════════════
# ENVIRONMENT
# ═══════════════════════════════════════════════════════════════
print_section "ENVIRONMENT"

# Check for development tools
DEV_TOOLS=""
for tool in gcc python python3 perl ruby php node java; do
    if command -v $tool >/dev/null 2>&1; then
        DEV_TOOLS="$DEV_TOOLS $tool"
    fi
done

if [ ! -z "$DEV_TOOLS" ]; then
    print_info "Development tools:$DEV_TOOLS"
else
    print_info "Development tools: None found"
fi

# Interesting environment variables
[ ! -z "$LD_PRELOAD" ] && print_warn "LD_PRELOAD is set: $LD_PRELOAD"
[ ! -z "$LD_LIBRARY_PATH" ] && print_info "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

printf "\n${GREEN}════════════════════════════════════════${NC}\n"
printf "${GREEN}  Reconnaissance complete!${NC}\n"
printf "${GREEN}════════════════════════════════════════${NC}\n\n"
