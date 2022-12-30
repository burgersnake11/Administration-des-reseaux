#Import du module "ActiveDirectory" pour pouvoir gérer l'active directory
Import-Module ActiveDirectory

#Stockage de toutes les données du fichiers CSV, passé en paramètre dans la commande powershell, dans la variable "user"
$users = Import-CSV -Path $args[0] -Delimiter ";"

#Récupération des données des utilisateurs du fichiers CSV
foreach($user in $users) {
	$username = $user.username
	
	#Check si l'utilisateur existe, s'il existe désactive le compte, si non, on renvoie que l'utilisateur n'existe pas
	if(Get-ADUser -F { SamAccountName -eq $username}) {
		
		#Récupère la valeur de la propriété "Enable"
		$disabled = Get-ADUser -identity $username -properties * | Select -property Enabled
		$disabled = $disabled.Enabled

		#Check si l'utilisateur est "Enable", si oui, il le désactive, si non, renvoie qu'il est déjà désactivé
		if($disabled) {
			Disable-ADAccount $username
			Write-Host "L'utilisateur $username a bien ete desactive !"	
		} else {
			Write-Host "L'utilisateur $username n'est pas active !"
		}	
	} else {
		Write-Host "L'utilisateur $username n'existe pas !"
	}
}