#Import du module "ActiveDirectory" pour pouvoir gérer l'active directory
Import-Module ActiveDirectory

#Stockage de toutes les données du fichiers CSV, passé en paramètre dans la commande powershell, dans la variable "user"
$users = Import-CSV -Path $args[0] -Delimiter ";"

#Récupération des données des utilisateurs du fichiers CSV
foreach($user in $users) {
	$firstname = $user.firstname
	$lastname = $user.lastname
	$username = $user.username
	$password = $user.password
	
	#Conversion du password en secure password
	$password = ConvertTo-SecureString $password -AsPlainText -Force
	
	#Check si l'utilisateur existe, si oui, on change toutes les données de celui-ci avec les nouvelles, si non renvoie que l'utilisateur n'existe pas
	if(Get-ADUser -F {SamAccountName -eq $username}) {
		
		#Récupère toutes les données nécessaires à un utilisateur
		$datauser = Get-ADUser -identity $username

		#Change les données le l'utilisateur avec les nouvelles données
		Set-ADUser -identity $username -Surname $lastname -GivenName $firstname -DisplayName "$lastname $firstname"

		#Change le nom de l'utilisateur avec celui donné dans le CSV
		Rename-ADObject $datauser -NewName "$lastname $firstname"

		#Change le password de l'utilisateur avec celui donnée dans le CSV qui a été au préalable secure
		Set-ADAccountPassword -identity $username -reset -NewPassword $password

		Write-Host "Les informations de l'utilisateur $username ont bien ete changees !"
	} else {
		Write-Host "L'utilisateur $username n'existe pas"
	}
}
