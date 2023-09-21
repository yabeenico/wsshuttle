
# Description
It runs sshuttle from WSL2, and sets up the routing table of Windows.
Since it modifies the routing table of Windows,
the admin privilege of Windows is required.
(Open WSL2 terminal with "Run as Administrator".)

# Requirements
- ipcalc
- bash >= 4.0
- sshuttle == 1.1.1

# Installation
```bash
sudo apt install -y ipcalc
pip3 install sshuttle==1.1.1 # Other version may cause "doas" error.
curl https://raw.githubusercontent.com/yabeenico/wsshuttle/main/wsshuttle | sudo install /dev/stdin /usr/local/bin/wsshuttle
```

# Usage
```bash
wsshuttle --help
wsshuttle [--delete] [--dry] [--upgrade] [--version] <sshuttle_args...>
```

# Examples

Caution!: Admin privilege of Windows is required.

Route all (0/0) packets through ssh-server except destination is 157.0.0.0/8.  
And it excludes 'IP address of ssh-server' too by specifying
-x 'IP address of ssh-server' automatically.

```bash
wsshuttle -r ssh-server -x 157.0.0.0/8 0/0
```

Disables the feature of auto specifying -x 'IP address of ssh-server'.

Deletes routing table.  
Routing table is reset when wsshuttle exits, if you have any problem, do it.

```bash
wsshuttle -r ssh-server -x 157.0.0.0/8 0/0 --delete
```

Dry-run, just prints commands.  
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

# Recommended Settings

Invoke 'wsshuttle' when hit 'sshuttle'.  
When not admin, do privilege elevation automatically. ~~
Installing 'sudo' on PowerShell is required (scoop install sudo)

```bash
sshuttle(){
    if net.exe session &>/dev/null; then # if admin
        $SHELL -ic "wsshuttle $*"
    else
        powershell.exe sudo wsl $SHELL -ic \"wsshuttle $*\"
    fi
}
```

