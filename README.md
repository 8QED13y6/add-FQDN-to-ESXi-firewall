#How To Install


First of all create the directory where files will be stored
```
mkdir /scratch/addFQDNtoESXifirewall/
```
Add esxi access to download by setting httpClient ruleset to true
```
esxcli network firewall ruleset set -e true -r httpClient
```
Create directories
```
mkdir -p /scratch/addFQDNtoESXifirewall/bin
mkdir -p /scratch/addFQDNtoESXifirewall/sources/FQDN
mkdir -p /scratch/addFQDNtoESXifirewall/sources/IP
mkdir -p /scratch/addFQDNtoESXifirewall/Logs/FQDN
mkdir -p /scratch/addFQDNtoESXifirewall/IP

```
Then download different bash script
```
wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/execute.sh -O /scratch/addFQDNtoESXifirewall/execute.sh --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/local.sh.exemple -O /scratch/addFQDNtoESXifirewall/local.sh.exemple --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/fqdn.list -O /scratch/addFQDNtoESXifirewall/fqdn.list --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/ip.list -O /scratch/addFQDNtoESXifirewall/ip.list --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/crontab.exemple  -O /scratch/addFQDNtoESXifirewall/crontab.exemple --no-check-certificate

```
> **Note**
> ">>" is incremental and ">" is replace content
```
cp /etc/rc.local.d/local.sh /etc/rc.local.d/local.sh.old #Check if persistant 
cat /scratch/addFQDNtoESXifirewall/local.sh.exemple > /etc/rc.local.d/local.sh
```
```
chmod +x /scratch/addFQDNtoESXifirewall/*.sh
```
Now edit the fqdn.list
```
vi /scratch/addFQDNtoESXifirewall/fqdn.list
```
Now edit the ip_source.list
```
vi /scratch/addFQDNtoESXifirewall/ip.list
```
Add a message to mark events before and after installation
```
esxcli system syslog mark --message="addFQDNtoESXifirewall install.sh just ran!" 
```

These commands makes local.sh changes persistant
```
/bin/sh /etc/rc.local.d/local.sh
/bin/auto-backup.sh 
```
Add a message to mark events before and after installation
```
esxcli system syslog mark --message="addFQDNtoESXifirewall install.sh just ran!" 
```
> **Note**
If you want to compare attacks before and after installation run 
```
cat /var/log/auth.log | grep -E 'Invalid user|addFQDNtoESXifirewall'
```

Delete esxi access to download by setting httpClient ruleset to false
```
esxcli network firewall ruleset set -e false -r httpClient
```
