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
	
	#Check si l'utilisateur existe déjà 
	if(Get-ADUser -F { SamAccountName -eq $username}) {
		Write-Host "Utilisateur $username deja cree"
	} else {
		#Création d'un nouvel utilisateur dans l'AD avec les données du fichiers CSV
		New-ADUser `
			-Name "$lastname $firstname" `
			-Surname $lastname `
			-SamAccountName $username `
			-GivenName $firstname `
			-DisplayName "$lastname $firstname" `
			-Enabled $true `
			-AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
			-Path "OU=utilisateurs, DC=l1-7, DC=lab" `
			-PasswordNeverExpires $true `
			-ChangePasswordAtLogon $false
	
		Write-Host "La creation de l'utilisateur $username a ete un succes !"
	}
}