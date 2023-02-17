> **Note**
> Link to the french version of readme bellow

https://github.com/8QED13y6/add-FQDN-to-ESXi-firewall/edit/main/LISMOI.md

# ESXiFQDNFirewallRuleSet

This Bash script contains several functions that perform actions related to updating a list of IP addresses or FQDNs that are allowed to access various firewall rulesets on VMware ESXi hosts.

The first function, IP_LIST_TMP_Updater, updates the ip.list.tmp file with new IP addresses or FQDNs from the source.list file. If the ip.list.tmp file exists due to an error, it is deleted. For each line in the source.list file, the function checks if it is a comment and then exports the IP address or FQDN. If the value is an FQDN, it uses nslookup to get the IP address. It then appends the IP address or FQDN to the ip.list.tmp file.

The second function, firewall_ruleset_allowedip_list, takes two parameters: a file name and an action. It checks if the file exists and is not empty. If it is, the function loops through each line in the file and runs a series of esxcli commands to update the firewall ruleset. It checks each line in the file to make sure it is not a header.

The third function, IsTheNewListSameAsLastOne, checks if the new list of IP addresses is identical to the previous list by calculating the checksum of the ip.list and ip.list.tmp files. If the checksums are the same, it does nothing. If they are different, it moves the ip.list.tmp file to ip.list, updates the checksum, and logs the action.

Overall, this script appears to be designed to help automate the process of updating the IP address list for firewall rulesets on VMware ESXi hosts.
