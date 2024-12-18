# Paramètres FTP
$ftpServer = "ftp://10.10.121.208/ftp/uploads/backup.tar.gz" # URL complète du fichier
$ftpUser = "ftpuser"                                        # Nom d'utilisateur FTP
$ftpPassword = "root"                                       # Mot de passe FTP
$localPath = "C:\FTPDownloads\backup.tar.gz"                # Chemin local pour le fichier téléchargé

# Paramètres d'e-mail
$smtpServer = "smtp.gmail.com"                              # Serveur SMTP de Gmail
$smtpPort = 587                                             # Port SMTP pour TLS
$fromEmail = "fortnite.clementm@gmail.com"                  # Adresse expéditeur
$toEmail = "clementmenier1309@gmail.com"                    # Adresse destinataire
$emailSubject = "Notification : Fichier téléchargé avec succès"
$emailBody = "Le fichier 'backup.tar.gz' a été téléchargé avec succès vers : $localPath"

# Informations d'authentification SMTP
$smtpUser = "fortnite.clementm@gmail.com"                   # Nom d'utilisateur SMTP
$smtpPassword = "relfiquqwghagmmj"                          # Mot de passe d'application Gmail

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

    # Envoi de l'e-mail
    Send-MailMessage -SmtpServer $smtpServer `
                     -Port $smtpPort `
                     -UseSsl `
                     -Credential (New-Object System.Management.Automation.PSCredential($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))) `
                     -From $fromEmail `
                     -To $toEmail `
                     -Subject $emailSubject `
                     -Body $emailBody

    Write-Host "E-mail envoyé à l'administrateur : $toEmail" -ForegroundColor Green

} catch {
    Write-Host "Erreur lors du téléchargement ou de l'envoi de l'e-mail :" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
