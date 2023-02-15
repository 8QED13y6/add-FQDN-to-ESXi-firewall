#How To Install


First of all create the directory where files will be stored
```
mkdir \scratch\ESXiFQDNFirewallRuleSet
```
Then download different bash script
```
curl /scratch/git/install.sh
curl /scratch/git/execute.sh
curl /scratch/git/fqdn.list
curl /scratch/git/ip.list
curl /scratch/git/local.sh.exemple
```
```
mv   /etc/rc.local.d/local.sh /etc/rc.local.d/local.sh.old #Check if persistant 
cp   /etc/rc.local.d/local.sh.exemple /etc/rc.local.d/local.sh
```
```
chmod +x /scratch/git/*.sh
chmod +x /etc/rc.local.d/local.sh
/bin/bash /scratch/git/execute.sh >> ??
```
Now edit the fqdn.list
```
vi
```
Now edit the ip_source.list
```
vi
```
