$Vault = Get-AzureRmBackupVault -Name "MyRSVault90"
$Container = Get-AzureRmBackupContainer -Vault $Vault -Type AzureVM -Name "vm1-task7"
Get-AzureRmBackupItem -Container $Container | Backup-AzureRmBackupItem

$backupcontainer = Get-AzureRmRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName "MyRSVault90"

