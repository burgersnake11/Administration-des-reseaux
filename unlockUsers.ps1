#Import du module "ActiveDirectory" pour pouvoir gérer l'active directory
Import-Module ActiveDirectory

#Récupération du User étant lock 
$username = $args[0]

#Check si l'utilisateur rentré en paramètre existe bien, si oui continue le script, si non, renvoie qu'il n'existe pas
if(Get-ADUser -F { SamAccountName -eq $username}) {
	
	#Récupére la valeur de la propriété "lockedout"
	$locked = Get-ADUser -identity $username -properties * | Select -property lockedout
	$locked = $locked.lockedout
	
	#Check si l'utilisateur est bloqué ou pas, si oui il le débloque, si non, renvoie qu'il n'est pas bloqué
	if($locked) {
		Unlock-ADAccount $username
		Write-Host "L'utilisateur $username a bien ete debloque !"
	} else {
		Write-Host "L'utilisateur $username n'est pas bloque !"
	}
} else {
	Write-Host "L'utilisateur $username n'existe pas !"
}