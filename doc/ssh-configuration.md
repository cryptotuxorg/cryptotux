# ssh configuration
Additional configuration to connect to the machines

## Syncing folders
For ease you can sync a local folder and the internal user folder of the machine. VIrtualBox provides a solution but I recommend `sshfs`:
- On the host, create an empty 'remote' folder (e.g. on Unix `mkdir -p ~/remote`)
- `sshfs bobby@192.168.33.10:/home/bobby ~/remote`

## Hosts
Optionnaly, you can add cryptotux as known hosts (on Unix systems `echo '192.168.33.10 cryptotux' | sudo tee -a /etc/hosts`, you will then be able to connect with `ssh bobby@cryptotux`) or add the following lines to the ssh config file, usually located on Unix systems at `~/.ssh/config`:
```
Host cryptotux
   HostName 192.168.33.10
   User bobby
   IdentitiesOnly yes
```

## Options
If you have many ssh keys, add `-o IdentitiesOnly=yes` to `ssh` and `sshfs` commands.

If you use an X server on your host OS you can access to the desktop via `ssh -X ...` too.