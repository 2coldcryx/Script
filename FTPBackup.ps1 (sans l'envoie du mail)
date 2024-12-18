# Définir les paramètres de connexion
$ftpServer = "ftp://10.10.121.208/ftp/uploads/backup.tar.gz" # URL complète du fichier
$ftpUser = "ftpuser"                                        # Nom d'utilisateur FTP
$ftpPassword = "root"                                       # Mot de passe FTP
$localPath = "C:\FTPDownloads\backup.tar.gz"                # Chemin local pour le fichier téléchargé

# Créer le dossier local si nécessaire
$localFolder = Split-Path -Path $localPath
if (!(Test-Path -Path $localFolder)) {
    New-Item -ItemType Directory -Path $localFolder
}

# Télécharger le fichier depuis le serveur FTP
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPassword)

    # Téléchargement du fichier
    $webClient.DownloadFile($ftpServer, $localPath)
    Write-Host "Téléchargement réussi : $localPath" -ForegroundColor Green
} catch {
    Write-Host "Erreur lors du téléchargement :" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
