Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task7restore'
)
$location = 'West Europe'
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

$templateRestoreURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/restore-main.json'
$storageAccountName = "task7restorestoracc"
$skuName = "Standard_LRS"


$storage = Get-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue
if (!$storage) {
    New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
        -Name $storageAccountName `
        -Location $location `
        -SkuName $skuName
}

$vault = Get-AzureRmRecoveryServicesVault
Set-AzureRmRecoveryServicesVaultContext -Vault $vault

$namedContainer = Get-AzureRmRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -Status "Registered" `
    -FriendlyName (get-azurermvm).name

$item = Get-AzureRmRecoveryServicesBackupItem `
    -Container $namedContainer `
    -WorkloadType "AzureVM"

$rp = Get-AzureRmRecoveryServicesBackupRecoveryPoint -Item $Item 

$RestoreJob = Restore-AzureRmRecoveryServicesBackupItem `
    -RecoveryPoint $RP[0] `
    -StorageAccountName $StorageAccountName `
    -StorageAccountResourceGroupName $resourceGroupName
