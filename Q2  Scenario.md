#### 1- Verify DNS Resolution
```
cat /etc/resolv.conf
```
![[Pasted image 20250428101050.png]]

```
nslookup internal.example.com
```

![[Pasted image 20250428181023.png]]
```
nslookup internal.example.com 8.8.8.8
```

![[Pasted image 20250428181129.png]]

#### 2- Diagnose Service Reachability

Assume IP of server 10.10.10.10
Check web server (port 80 HTTP, or 443 HTTPS)  is reachable or not

```
curl -v http://10.10.10.10
curl -vk https://10.10.10.10
```

Check the server itself is listening
```
sudo netstat -tulnp | grep ':80'
```

#### 3- List All Possible Causes

| Layer        | Possible Cause                                              |
| ------------ | ----------------------------------------------------------- |
| DNS          | Wrong entry in DNS server                                   |
| DNS          | Local /etc/resolv.conf points to bad DNS                    |
| DNS          | DNS cache is outdated                                       |
| Network      | Firewall blocking port 80/443                               |
| Network      | Wrong routing between client and server                     |
| Server       | Web server (Apache/Nginx) is down                           |
| Server       | Web server is listening on wrong interface (localhost only) |

#### 4- Propose and Apply Fixes

| Problem             | How to Confirm                    | Command to Fix                                                                     |
| ------------------- | --------------------------------- | ---------------------------------------------------------------------------------- |
| DNS server is wrong | Check `/etc/resolv.conf`          | Edit `/etc/resolv.conf` or fix DNS                                                 |
| DNS cache issue     | Flush DNS cache                   | `sudo systemd-resolve --flush-caches` or restart `nscd`                            |
| Firewall blocking   | Use `telnet` or `nc` to test port | Open port using `ufw allow 80/tcp` or `firewall-cmd --add-port=80/tcp --permanent` |
| Wrong routing       | Use `traceroute`                  | Fix network routes or check VPN                                                    |
| Web server down     | Use `systemctl status apache2`    | `sudo systemctl start apache2`                                                     |
| Listening wrong     | Use `netstat` or `ss`             | Configure server to listen on `0.0.0.0`, not `127.0.0.1`                           |

#### Bonus Tasks
```
vim /etc/hosts
# add line
10.10.10.10 internal.example.com
```
![[Pasted image 20250428195507.png]]
```
nmcli connection modify "ens33" ipv4.dns "8.8.8.8"
nmcli connection up ens33
```
