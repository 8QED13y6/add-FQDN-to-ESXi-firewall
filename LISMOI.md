> **Note**
> Lien vers la version anglaise de lismoi en dessous

https://github.com/8QED13y6/add-FQDN-to-ESXi-firewall/blob/main/README.md

# ESXiFQDNFirewallRuleSet

Ce code est un script en bash qui permet de mettre à jour la liste des adresses IP ou des noms de domaines (FQDN) autorisés à accéder à des serveurs VMware ESXi à travers le pare-feu de la machine. Le script contient trois fonctions :

IP_LIST_TMP_Updater (): cette fonction met à jour la liste des adresses IP ou des noms de domaine dans un fichier temporaire, qui est ensuite utilisé pour mettre à jour le fichier principal. Si le dernier fichier temporaire existe toujours en raison d'une erreur, il est supprimé. Pour chaque ligne du fichier, la fonction vérifie si elle est un commentaire, et si ce n'est pas le cas, elle utilise nslookup pour obtenir l'adresse IP correspondante pour un nom de domaine, sinon elle utilise directement l'adresse IP. La fonction ajoute ensuite l'adresse IP ou le nom de domaine à la fin du fichier temporaire.

firewall_ruleset_allowedip_list (): cette fonction lit un fichier contenant une liste d'adresses IP ou de noms de domaine autorisés, et utilise esxcli pour ajouter ces adresses à la liste des adresses IP autorisées à accéder à différents services ESXi.

IsTheNewListSameAsLastOne (): cette fonction vérifie si la nouvelle liste d'adresses IP ou de noms de domaine est identique à la liste précédente en calculant la somme de contrôle (checksum) de chaque fichier. Si les deux sommes de contrôle sont identiques, cela signifie que les deux fichiers sont identiques.

# Local.conf

Ce script est destiné à être exécuté sur une machine virtuelle VMware ESXi. Il ajoute des lignes à la crontab pour planifier des tâches à exécuter périodiquement.

Le commentaire en haut du script indique que les options de configuration locales ne doivent pas être modifiées car cela peut rendre le système instable.

Le script utilise /etc/rc.local.d/local.sh pour ajouter les lignes à la crontab et redémarrer le service cron.

Le texte ASCII est généré à partir du site https://patorjk.com/software/taag/#p=display&f=Big%20Money-nw&t=FOR%20EMERGENCY%20USING%20Ivrit%20FONT et affiche "FOR EMERGENCY USING Ivrit FONT".

La ligne "/bin/kill $(cat /var/run/crond.pid)" arrête le service cron.

La ligne "/bin/cat /scratch/addFQDNtoESXifirewall/crontab.exemple >> /var/spool/cron/crontabs/root" ajoute les lignes de la crontab à la crontab root.

La ligne "/usr/lib/vmware/busybox/bin/busybox crond" redémarre le service cron.

Enfin, le script se termine avec "exit 0".

# Cron

Cette ligne est une tâche cron qui exécute un script shell /scratch/addFQDNtoESXifirewall/execute.sh toutes les minutes.

La commande est structurée comme suit :

*/1 - indique que la tâche doit être exécutée toutes les minutes. Cela équivaut à * * * * *, qui signifie "exécuter le travail toutes les minutes de toutes les heures de tous les jours du mois de tous les mois de tous les jours de la semaine".

/scratch/addFQDNtoESXifirewall/execute.sh - le chemin vers le script shell qui sera exécuté par la tâche cron.

/scratch/addFQDNtoESXifirewall/Logs/execute_$(date '+%Y-%m-%d')/execute_$(date '+%H-%M-%S').log - redirige la sortie de la commande vers un fichier journal nommé avec la date et l'heure actuelles, à la seconde près.

Ainsi, cette tâche cron exécute le script /scratch/addFQDNtoESXifirewall/execute.sh toutes les minutes, et écrit la sortie dans un nouveau fichier journal à chaque exécution.
