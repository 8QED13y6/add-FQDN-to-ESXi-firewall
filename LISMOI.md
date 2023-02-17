Ce code est un script en bash qui permet de mettre à jour la liste des adresses IP ou des noms de domaines (FQDN) autorisés à accéder à des serveurs VMware ESXi à travers le pare-feu de la machine. Le script contient trois fonctions :

IP_LIST_TMP_Updater (): cette fonction met à jour la liste des adresses IP ou des noms de domaine dans un fichier temporaire, qui est ensuite utilisé pour mettre à jour le fichier principal. Si le dernier fichier temporaire existe toujours en raison d'une erreur, il est supprimé. Pour chaque ligne du fichier, la fonction vérifie si elle est un commentaire, et si ce n'est pas le cas, elle utilise nslookup pour obtenir l'adresse IP correspondante pour un nom de domaine, sinon elle utilise directement l'adresse IP. La fonction ajoute ensuite l'adresse IP ou le nom de domaine à la fin du fichier temporaire.

firewall_ruleset_allowedip_list (): cette fonction lit un fichier contenant une liste d'adresses IP ou de noms de domaine autorisés, et utilise esxcli pour ajouter ces adresses à la liste des adresses IP autorisées à accéder à différents services ESXi.

IsTheNewListSameAsLastOne (): cette fonction vérifie si la nouvelle liste d'adresses IP ou de noms de domaine est identique à la liste précédente en calculant la somme de contrôle (checksum) de chaque fichier. Si les deux sommes de contrôle sont identiques, cela signifie que les deux fichiers sont identiques.

