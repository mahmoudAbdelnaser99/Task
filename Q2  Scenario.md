#### 1- Verify DNS Resolution
```
cat /etc/resolv.conf
```
![Pasted image 20250428101050](https://github.com/user-attachments/assets/2d1d9a3f-bb47-4f11-b4c2-0066ffd447be)

```
nslookup internal.example.com
```

![Pasted image 20250428181023](https://github.com/user-attachments/assets/d7d29159-20f3-4d8c-9bc7-80369500f522)
```
nslookup internal.example.com 8.8.8.8
```
![Pasted image 20250428181129](https://github.com/user-attachments/assets/bbec9fa6-5a10-453c-a6c0-a087044d193e)

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
![Pasted image 20250428195507](https://github.com/user-attachments/assets/0b0b33a8-4dfa-4f5a-961f-799b33ca9598)
```
nmcli connection modify "ens33" ipv4.dns "8.8.8.8"
nmcli connection up ens33
```
