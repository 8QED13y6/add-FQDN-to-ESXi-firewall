> **Note**
> Link to the french version of readme bellow

https://github.com/8QED13y6/add-FQDN-to-ESXi-firewall/edit/blob/LISMOI.md

# ESXiFQDNFirewallRuleSet

## Execute.sh

This Bash script contains several functions that perform actions related to updating a list of IP addresses or FQDNs that are allowed to access various firewall rulesets on VMware ESXi hosts.

The first function, IP_LIST_TMP_Updater, updates the ip.list.tmp file with new IP addresses or FQDNs from the source.list file. If the ip.list.tmp file exists due to an error, it is deleted. For each line in the source.list file, the function checks if it is a comment and then exports the IP address or FQDN. If the value is an FQDN, it uses nslookup to get the IP address. It then appends the IP address or FQDN to the ip.list.tmp file.

The second function, firewall_ruleset_allowedip_list, takes two parameters: a file name and an action. It checks if the file exists and is not empty. If it is, the function loops through each line in the file and runs a series of esxcli commands to update the firewall ruleset. It checks each line in the file to make sure it is not a header.

The third function, IsTheNewListSameAsLastOne, checks if the new list of IP addresses is identical to the previous list by calculating the checksum of the ip.list and ip.list.tmp files. If the checksums are the same, it does nothing. If they are different, it moves the ip.list.tmp file to ip.list, updates the checksum, and logs the action.

Overall, this script appears to be designed to help automate the process of updating the IP address list for firewall rulesets on VMware ESXi hosts.

## Local.conf

This script is a shell script (using the /bin/sh interpreter) that appears to add some lines to the root user's crontab file and restart the crontab service.

The script starts by defining a variable "group" with the value "host/vim/vmvisor/boot".

Next, there are several comments warning against making modifications to the script and explaining how the script is intended to be used in the ESXi operating system environment.

After the comments, the script kills the existing crontab process, adds some lines to the root user's crontab file, and restarts the crontab service using the "busybox crond" command. Finally, the script exits with a status of 0.

There are some additional comments at the end of the script with instructions on how to save and exit changes when using the vi or vim text editors.

## Cron Exemple

This line is a cron job that runs a shell script /scratch/addFQDNtoESXifirewall/execute.sh every minute.

The command is structured as follows:

*/1 - indicates that the job should be run every minute. This is equivalent to * * * * *, which means "run the job every minute of every hour of every day of the month of every month of every day of the week."

/scratch/addFQDNtoESXifirewall/execute.sh - the path to the shell script that will be executed by the cron job.

/scratch/addFQDNtoESXifirewall/Logs/execute_$(date '+%Y-%m-%d')/execute_$(date '+%H-%M-%S').log - redirects the output of the command to a log file that is named with the current date and time, down to the second.

So, this cron job runs the /scratch/addFQDNtoESXifirewall/execute.sh script every minute, and writes the output to a new log file every time it runs.
