#Source : https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.security.doc/GUID-7A8BEFC8-BF86-49B5-AE2D-E400AAD81BA3.html
#Functions
IP_LIST_TMP_Updater () {
    #Parameters
    Value=$1
    #Start
    #------------------------------------------------------------------------------------
    # If the last tmp file still exist because of an error we delete it. With no output.
    rm /scratch/ESXiFQDNFirewallRuleSet/sources/$Value/ip.list.tmp >/dev/null 2<&1
    #------------------------------------------------------------------------------------
    while read IP_OR_FQDN; do #Foreach line in the file
        echo "-------------------------------------------"
        echo "    Start Updating $Value/ip.list.tmp"
        echo "-------------------------------------------"
        echo ""
        #----------------------------------------------------------------------------------------------------
        # if [[ $IP_OR_FQDN != -# ]]
        # Check if the line is a comment such as ##
        #----------------------------------------------------------------------------------------------------
        if [[ $IP_OR_FQDN != -# ]]
        then
            if [[ "$Value" == "FQDN" ]]
            then
                IP_OR_FQDN_Export=$( nslookup $IP_OR_FQDN | awk '/^Address: / { print $2 }')
                echo "$IP_OR_FQDN equals $IP_OR_FQDN_Export"
            else
                IP_OR_FQDN_Export=$IP_OR_FQDN
                echo "IP equals $IP_OR_FQDN_Export"
            fi
            
            echo "$IP_OR_FQDN_Export" >> /scratch/ESXiFQDNFirewallRuleSet/sources/$Value/ip.list.tmp
        else
            echo "$IP_OR_FQDN is not an IP OR FQDN"
        fi
        echo ""
        echo "-------------------------------------------"
        echo "    Stop Updating $Value/ip.list.tmp"
        echo "-------------------------------------------"
        echo ""
        echo "Here is the temp list"    
        echo ""
        echo "#####List#####"
        cat /scratch/ESXiFQDNFirewallRuleSet/sources/$Value/ip.list.tmp
        echo "#####List#####"
        echo ""
    done </scratch/ESXiFQDNFirewallRuleSet/sources/$Value/source.list
}
firewall_ruleset_allowedip_list () {
    #Parameters
    File=$1
    Action=$2
    #Start
  
    if [ -f "$File" ];then
        if [ -s "$File" ];then
            echo "File $File exists and not empty"
            echo "Current time is  $(date '+%Y-%m-%d_%H-%M-%S')"
            echo "Starting ruleset allowedip $Action using $File"
            while read allowedip; do
                #----------------------------------------------------------------------------------------------------
                # if [[ $allowedip != -* ]]
                # Check if the line is not a header such as -----BEGIN IP.list-----
                #----------------------------------------------------------------------------------------------------
                if [[ $allowedip != -* ]]
                then
                    echo ""
                    echo "----------------------------------------------------------------------------"
                    echo ""
                    echo "esxcli network firewall ruleset allowedip $Action -i $allowedip -r=webAccess"
                    esxcli network firewall ruleset allowedip $Action -i $allowedip -r=webAccess
                    echo "esxcli network firewall ruleset allowedip $Action -i $allowedip -r=vSphereClient"
                    esxcli network firewall ruleset allowedip $Action -i $allowedip -r=vSphereClient
                    echo "esxcli network firewall ruleset allowedip $Action -i $allowedip -r=sshServer"
                    esxcli network firewall ruleset allowedip $Action -i $allowedip -r=sshServer
                    echo ""
                    echo "----------------------------------------------------------------------------"
                    echo ""
                else
                    echo "$allowedip is not an ip"
                fi
            done <$File
            echo "Current time is $(date '+%Y-%m-%d_%H-%M-%S')"
            echo "Stoping ruleset allowedip $Action using $File"
        else
            echo "File $File is empty."
        fi
    else
        echo "File $File doesn't exist. It will be created by the command mv $Path/ip.list.tmp $Path/ip.list on line  "
    fi
    #End
}
IsTheNewListSameAsLastOne () {
    #Parameters
    Value=$1

    #Var
    Date=$(date '+%Y-%m-%d_%H-%M-%S')
    Path="/scratch/ESXiFQDNFirewallRuleSet/sources/$Value"
    #DebugeOnly echo "The path is /scratch/ESXiFQDNFirewallRuleSet/sources/$Value"
    LogsPath="/scratch/ESXiFQDNFirewallRuleSet/Logs/$Value/MergeOfIPList_$Date.log"
    echo ""
    echo ##############LogsPath###############################################################
    echo "The LogsPath is /scratch/ESXiFQDNFirewallRuleSet/Logs/$Value/MergeOfIPList_$Date.log"
    echo ##############LogsPath###############################################################
    echo ""
    #Start
    #----------------------------------------------------------------------------------------------------
    #     A checksum is a value that represents the number of bits in a file.
    #     In our case the propuse is to check if the new list of ip is identique to the last one.
    #----------------------------------------------------------------------------------------------------

    if [ $(md5sum $Path/ip.list | awk '{ print $1 }') = $(md5sum $Path/ip.list.tmp | awk '{ print $1 }') ]
    then #Do a checksum on both files (the existing one (ip.list) and the new one (ip.list.tmp))
        echo "Files are the same"
        #Result than they have the same checksum so the same content
        CompareLogs "-----State eq same list----"
        rm $Path/ip.list.tmp #There is no need to change so we remove the tmp file
    else
        echo "Files are not the same"
        #On log les deux fichiers en un seul pour prouver la difference
        #This is just a log file to store the two content of ip.list andip.list.tmp
        CompareLogs "-----State eq same list----"
        firewall_ruleset_allowedip_list "$Path/ip.list" "Remove" #Ici on verifie si le fichier ip.list est vide ou non.Si il n'est pas vide il faut supprimer les ip qu'il contient des ruleset
        firewall_ruleset_allowedip_list "$Path/ip.list.tmp" "Add" #Ici on verifie si le fichier ip.list.tmp est vide ou non.Si il n'est pas vide il faut ajouter les ip qu'il contient aux ruleset
        echo  "Deleting $Path/ip.list"
        rm $Path/ip.list
        echo  "Renaming $Path/ip.list.tmp TO $Path/ip.list"
        mv $Path/ip.list.tmp $Path/ip.list
    fi
    #End
}
CompareLogs () {
    #Parameters
    State=$1
    #Start
    echo "----$Date----" >>  $LogsPath
    echo $State >>  $LogsPath
    echo "-------BEGIN IP.list-------" >>  $LogsPath
    cat $Path/ip.list >>  $LogsPath
    echo "--------END IP.list--------" >>  $LogsPath
    echo "-----BEGIN IP.list.tmp-----" >>  $LogsPath
    cat $Path/ip.list.tmp >>  $LogsPath
    echo "------END IP.list.tmp------" >>  $LogsPath
    ##########EXEMPLE###########
    #----2023-02-16_22-39-45----
    #-----State eq same list----
    #-------BEGIN IP.list-------
    #163.172.99.239
    #--------END IP.list--------
    #-----BEGIN IP.list.tmp-----
    #163.172.99.239
    #------END IP.list.tmp------
    ##########EXEMPLE###########

    #End
}
firewall_ruleset_allowed_all () {
    #Parameters
    Boolean=$1
    #Start
    #Set to true to allow all access to all IPs. Set to false to use a list of allowed IP addresses.
    echo ""
    echo "----------------------------------------------------------------------------"
    echo ""
    echo "esxcli network firewall ruleset set --allowed-all=$Boolean -r=webAccess"
    esxcli network firewall ruleset set --allowed-all=$Boolean -r=webAccess
    echo "esxcli network firewall ruleset set --allowed-all=$Boolean -r=vSphereClient"
    esxcli network firewall ruleset set --allowed-all=$Boolean -r=vSphereClient
    echo "esxcli network firewall ruleset set --allowed-all=$Boolean -r=sshServer"
    esxcli network firewall ruleset set --allowed-all=$Boolean -r=sshServer
    echo ""
    echo "----------------------------------------------------------------------------"
    echo ""
    #End
}

#START

IP_LIST_TMP_Updater "FQDN"
IP_LIST_TMP_Updater "IP"

FQDN_TMP="/scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/ip.list.tmp"
IP_TMP="/scratch/ESXiFQDNFirewallRuleSet/sources/IP/ip.list.tmp"

#Check if both tmp files are empty
if [ -f "$FQDN_TMP" -o -f "$IP_TMP" ];then
    if [ -s "$FQDN_TMP" -o -s "$IP_TMP" ];then
        echo ""
        echo "Required files exists and are not empty" #Reste du code
        echo ""
        IsTheNewListSameAsLastOne "FQDN"
        IsTheNewListSameAsLastOne "IP"
        firewall_ruleset_allowed_all FALSE
    else
        echo "File $FQDN_TMP AND/OR $IP_TMP are empty." #If yes Allow all
        firewall_ruleset_allowedip_list "/scratch/ESXiFQDNFirewallRuleSet/sources/FQDN/ip.list" "Remove"
        firewall_ruleset_allowedip_list "/scratch/ESXiFQDNFirewallRuleSet/sources/IP/ip.list" "Remove"
        firewall_ruleset_allowed_all TRUE

    fi
else
    echo "File $FQDN_TMP AND/OR $IP_TMP doesn't exist."
fi

#END
