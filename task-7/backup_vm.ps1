$vm = Get-AzureRmVM -ResourceGroupName task7

$backupcontainer = Get-AzureRmRecoveryServicesBackupContainer `
                                    -ContainerType "AzureVM" `
                                    -FriendlyName $vm.name

$item = Get-AzureRmRecoveryServicesBackupItem `
                                    -Container $backupcontainer `
                                    -WorkloadType "AzureVM"

Backup-AzureRmRecoveryServicesBackupItem -Item $item