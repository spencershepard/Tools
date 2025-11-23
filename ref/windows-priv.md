## Privilege Escalation - Windows

### Enumeration
- `systeminfo` - Display system information
- `whoami /priv` - Display current user privileges
- `wmic product get name,version,vendor` - List installed software
- `cmdkey /list` - List saved credentials
- `net user` - List all users
- `net localgroup administrators` - List administrators
- `schtasks /query /fo LIST /v` - List scheduled tasks
- `sc query` - List services
- `sc qc <service>` - Query service configuration
- `reg query HKLM\SYSTEM\CurrentControlSet\Services` - Query service registry

### Finding Vulnerabilities
- `icacls <path>` - Display file/directory permissions
- `icacls <path> /grant Everyone:F` - Grant full permissions
- `takeown /f <file>` - Take ownership of file
- `find / -writable 2>/dev/null` - Find writable files
- `reg save hklm\system system.hive` - Backup system registry
- `reg save hklm\sam sam.hive` - Backup SAM registry

### Tools
- `winpeas.exe` - Windows privilege escalation enumeration
- `PrivescCheck.ps1` - PowerShell privilege escalation checker
- `wes.py systeminfo.txt` - Windows Exploit Suggester

### Red Team Testing
https://github.com/redcanaryco/invoke-atomicredteam
- `Invoke-AtomicTest <technique_id>` - Execute MITRE ATT&CK test
- `Invoke-AtomicTest <technique_id> -ShowDetails` - Show test details
- `Invoke-AtomicTest <technique_id> -CheckPrereqs` - Check prerequisites
- `Invoke-AtomicTest <technique_id> -Cleanup` - Clean up test artifacts
