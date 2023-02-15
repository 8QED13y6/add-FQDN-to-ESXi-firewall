#Source : https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.security.doc/GUID-7A8BEFC8-BF86-49B5-AE2D-E400AAD81BA3.html
while read FQDN; do #Foreach line in the file
    echo "$FQDN"
    if [[ $FQDN != -* ]] #If variable $FQDN doesn't start by - then execute else nothing to do
    then

        $( nslookup $FQDN | awk '/^Address: / { print $2 }') > </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list.tmp #Add the A record returned by nslookup in the file ip.list.tmp

        if [ "($(md5sum </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list))" = "($(md5sum </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list.tmp))" ]; then #Do a checksum on both files (the existing one (ip.list) and the new one (ip.list.tmp))
            #Result than they have the same checksum so the same content
            rm ip.list.tmp #There is no need to change so we remove the tmp file
            echo "On fait rien tout va bien"
        else
            #On log les deux fichiers en un seul pour prouver la difference
            #Trouver un nom
            #This is just a log file to store the two content of ip.list andip.list.tmp
            Date=$(date '+%Y-%m-%d_%H-%M-%S')
            echo "-----$Date-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            echo "-----BEGIN IP.list-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            cat ip.list >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            echo "-----END IP.list-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            echo "-----BEGIN IP.list.tmp-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            cat ip.list.tmp >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            echo "-----END IP.list.tmp-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/IP/MergeOfIPList_$Date.log
            #On arete d'ecrire dans le fichier de log

            #Il y a des changements il faut supprimer les anciennes ip
            if [ -s </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list ] 
            then
                echo "ip.list is empty"
                echo "There is no allowedip to remove"
            else
                echo "ip.list is not empty"
                echo "Current time is"
                echo "Starting deleting allowedip from the past ip.list"
                while read allowedip; do
                    echo "$allowedip"
                    #Check if the line is not a header such as -----BEGIN IP.list-----
                    if [[ $allowedip != -* ]] #If variable IP doesn't start by - then execute else nothing to do
                    then
                        esxcli network firewall ruleset allowedip remove -i $allowedip -r=webAccess
                        esxcli network firewall ruleset allowedip remove -i $allowedip -r=vSphereClient
                        esxcli network firewall ruleset allowedip remove -i $allowedip -r=sshServer
                    else
                        echo "$allowedip is not an ip"
                    fi
                done </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list
                echo "Current time is"
                echo "Stoping deleting allowedip from the past ip.list"
            
            fi
            if [ -s </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list.tmp ]
            then
                echo "ip.list.tmp is empty"
                echo "There is no allowedip to add. IP Filtering will be desactivated"
            else
                echo "ip.list.tmp is not empty"
                echo "Current time is"
                echo "Starting adding allowedip from the new ip.list.tmp"
                while read allowedip; do
                    echo "$allowedip"
                    #Check if the line is not a header such as -----BEGIN IP.list-----
                    if [[ $allowedip != -* ]] #If variable IP doesn't start by - then execute else nothing to do
                    then
                        esxcli network firewall ruleset allowedip add -i $allowedip -r=webAccess
                        esxcli network firewall ruleset allowedip add -i $allowedip -r=vSphereClient
                        esxcli network firewall ruleset allowedip add -i $allowedip -r=sshServer
                    else
                        echo "$allowedip is not an ip"
                    fi
                done </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list.tmp
                echo "Current time is"
                echo "Stoping adding allowedip from the past ip.list.tmp"

            fi
            rm /scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list
            mv /scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list.tmp /scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list
        fi
    else
        echo "$FQDN is not an ip"
    fi    
done </scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/source.list
####################################################
while read IP; do #Foreach line in the file
    echo "$IP"
    if [[ $IP != -* ]] #If variable $FQDN doesn't start by - then execute else nothing to do
    then

        if [ "($(md5sum /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list))" = "($(md5sum /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list.tmp))" ]; then #Do a checksum on both files (the existing one (ip.list) and the new one (ip.list.tmp))
            #Result than they have the same checksum so the same content
            rm /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list.tmp #There is no need to change so we remove the tmp file
            echo "On fait rien tout va bien"
        else
            #On log les deux fichiers en un seul pour prouver la difference
            #Trouver un nom
            #This is just a log file to store the two content of ip.list andip.list.tmp
            Date=$(date '+%Y-%m-%d_%H-%M-%S')
            echo "-----$Date-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            echo "-----BEGIN IP.list-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            cat ip.list >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            echo "-----END IP.list-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            echo "-----BEGIN IP.list.tmp-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            cat ip.list.tmp >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            echo "-----END IP.list.tmp-----" >>  /scratch/ESXiFQDNFirewallRuleSet/Logs/FQDN/MergeOfIPList_$Date.log
            #On arete d'ecrire dans le fichier de log

            #Il y a des changements il faut supprimer les anciennes ip
            if [ -s /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list ] 
            then
                echo "ip.list is empty"
                echo "There is no allowedip to remove"
            else
                echo "ip.list is not empty"
                echo "Current time is"
                echo "Starting deleting allowedip from the past ip.list"
                while read allowedip; do
                    echo "$allowedip"
                    #Check if the line is not a header such as -----BEGIN IP.list-----
                    if [[ $allowedip != -* ]] #If variable IP doesn't start by - then execute else nothing to do
                    then
                        esxcli network firewall ruleset allowedip remove -i $allowedip -r=webAccess
                        esxcli network firewall ruleset allowedip remove -i $allowedip -r=vSphereClient
                        esxcli network firewall ruleset allowedip remove -i $allowedip -r=sshServer
                    else
                        echo "$allowedip is not an ip"
                    fi
                done </scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list
                echo "Current time is"
                echo "Stoping deleting allowedip from the past ip.list"
            
            fi
            if [ -s /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list.tmp ]
            then
                echo "ip.list.tmp is empty"
                echo "There is no allowedip to add. IP Filtering will be desactivated"
            else
                echo "ip.list.tmp is not empty"
                echo "Current time is"
                echo "Starting adding allowedip from the new ip.list.tmp"
                while read allowedip; do
                    echo "$allowedip"
                    #Check if the line is not a header such as -----BEGIN IP.list-----
                    if [[ $allowedip != -* ]] #If variable IP doesn't start by - then execute else nothing to do
                    then
                        esxcli network firewall ruleset allowedip add -i $allowedip -r=webAccess
                        esxcli network firewall ruleset allowedip add -i $allowedip -r=vSphereClient
                        esxcli network firewall ruleset allowedip add -i $allowedip -r=sshServer
                    else
                        echo "$allowedip is not an ip"
                    fi
                done </scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list.tmp
                echo "Current time is"
                echo "Stoping adding allowedip from the past ip.list.tmp"

            fi
            rm /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list
            mv /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list.tmp /scratch/ESXiFQDNFirewallRuleSet/sources/ip/ip.list
        fi
    else
        echo "$IP is not an ip"
    fi    
done </scratch/ESXiFQDNFirewallRuleSet/sources/ip/source.list
