#How To Install


First of all create the directory where files will be stored
```
mkdir /scratch/addFQDNtoESXifirewall/
```
Add esxi access to download by setting httpClient ruleset to true
```
esxcli network firewall ruleset set -e true -r httpClient
```
Then download different bash script
```
wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/execute.sh -O /scratch/addFQDNtoESXifirewall/execute.sh --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/local.conf -O /scratch/addFQDNtoESXifirewall/local.conf --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/fqdn.list -O /scratch/addFQDNtoESXifirewall/fqdn.list --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/ip.list -O /scratch/addFQDNtoESXifirewall/ip.list --no-check-certificate

wget https://raw.githubusercontent.com/8QED13y6/add-FQDN-to-ESXi-firewall/main/bin/crontab.exemple  -O /scratch/addFQDNtoESXifirewall/crontab.exemple --no-check-certificate

```
```
mv   /etc/rc.local.d/local.sh /etc/rc.local.d/local.sh.old #Check if persistant 
cat   /scratch/addFQDNtoESXifirewall/local.conf >> /etc/rc.local.d/local.sh
```
```
chmod +x /scratch/addFQDNtoESXifirewall/*.sh
chmod +x /etc/rc.local.d/local.sh
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
> **Note**
If you want to compare attacks before and after installation run 
```
cat /var/log/vmkernel.log |grep -i mark:
```
These commands makes local.sh changes persistant
```
/bin/sh /etc/rc.local.d/local.sh
/bin/auto-backup.sh 
```


Delete esxi access to download by setting httpClient ruleset to false
```
esxcli network firewall ruleset set -e false -r httpClient
```
