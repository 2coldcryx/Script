# Variables de configuration
$ftpServer = "ftp://192.168.1.21/fichier.tar.gz"  # Adresse FTP complète avec chemin
$ftpUsername = "ftpuser"                         # Nom d'utilisateur FTP
$ftpPassword = "motdepasseftp"                   # Mot de passe utilisateur FTP
$localPath = "C:\Sauvegardes\fichier.tar.gz"     # Chemin local pour le fichier téléchargé

# Configuration de l'email
$smtpServer = "smtp.gmail.com"                   # Serveur SMTP
$smtpPort = 587                                  # Port SMTP
$smtpUsername = "mail"    # Adresse email de l'expéditeur
$smtpPassword = "motdepasseemail"                # Mot de passe email
$emailRecipient = "mail"  # Destinataire de l'email

# Création du répertoire local si nécessaire
if (!(Test-Path -Path (Split-Path -Path $localPath))) {
    New-Item -ItemType Directory -Path (Split-Path -Path $localPath) -Force
}

# Fonction pour envoyer un email
function Send-Email {
    param (
        [string]$Subject,
        [string]$Body
    )
    $message = @{
        To         = $emailRecipient
        From       = $smtpUsername
        Subject    = $Subject
        Body       = $Body
        SmtpServer = $smtpServer
        Port       = $smtpPort
        Credential = (New-Object PSCredential $smtpUsername, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))
        UseSsl     = $true
    }
    Send-MailMessage @message
}

# Téléchargement avec gestion des erreurs
try {
    # Création du client FTP
    $webClient = New-Object System.Net.WebClient
    $webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
    
    # Téléchargement du fichier
    $webClient.DownloadFile($ftpServer, $localPath)
    Write-Output "Téléchargement réussi : $localPath"

    # Envoi d'un email de succès
    Send-Email -Subject "Succès du téléchargement FTP" -Body "Le fichier a été téléchargé avec succès vers $localPath."
} catch {
    # Gestion des erreurs
    Write-Error "Erreur lors du téléchargement : $_"
    
    # Envoi d'un email d'erreur
    Send-Email -Subject "Échec du téléchargement FTP" -Body "Une erreur est survenue lors du téléchargement : $_"
}
