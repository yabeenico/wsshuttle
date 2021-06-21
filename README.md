
# Description
Run sshuttle from WSL2, and setup routing table of Windows.  
Because it modifies routing table of Windows,
the terminal of WSL2 is required admin privilege of Windows.  
(Open WSL2 terminal with "Run as Administrator")

# Requirements
- ipcalc
- bash >= 4.0
- sshuttle >= 1.0.5

# Installation
```bash
sudo apt install -y ipcalc
pip3 install sshuttle # Installed by apt one may be old and not working!
sudo wget https://raw.githubusercontent.com/yabeenico/wsshuttle/main/wsshuttle -O /usr/local/bin/wsshuttle
sudo chmod +x /usr/local/bin/wsshuttle
```

# Usage
```bash
wsshuttle --help
wsshuttle [--delete] [--dry] [--upgrade] [--version] <sshuttle_options...>
```

# Examples
Admin privilege of Windows is required.  
-x "IP address of ssh-server" can be omitted because it's automatically added.

```bash
wsshuttle -r ssh-server -x 157.0.0.0/8 0/0
```

Deletes routing table.  
Routing table is reset when wsshuttle exits, if you hava any problem, do it.

```bash
wsshuttle -r ssh-server -x 157.0.0.0/8 0/0 --delete
```

Dry-run, only prints commands.  
Doesn't make any changes.

```bash
wsshuttle -r ssh-server -x 157.0.0.0/8 0/0 --dry
route.exe delete 157.0.0.0 mask 255.0.0.0
route.exe delete 3.3.3.3   mask 255.255.255.255
route.exe delete 0.0.0.0   mask 128.0.0.0
route.exe delete 128.0.0.0 mask 128.0.0.0
route.exe add    157.0.0.0 mask 255.0.0.0       192.168.3.1    metric 1 if 7
route.exe add    3.3.3.3   mask 255.255.255.255 192.168.3.1    metric 1 if 7
route.exe add    0.0.0.0   mask 128.0.0.0       172.18.187.223 metric 1 if 46
route.exe add    128.0.0.0 mask 128.0.0.0       172.18.187.223 metric 1 if 46
sshuttle -l 0.0.0.0:0 -x 3.3.3.3 -r ssh-server -x 157.0.0.0/8 0/0
route.exe delete 157.0.0.0 mask 255.0.0.0
route.exe delete 3.3.3.3   mask 255.255.255.255
route.exe delete 0.0.0.0   mask 128.0.0.0
route.exe delete 128.0.0.0 mask 128.0.0.0
```

# Future Work
- Support ProxyCommand
