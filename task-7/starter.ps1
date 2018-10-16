Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task7'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$templateURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/main.json'
$templateParametersURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/main-parameters.json"
$vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName
$vault = get-AzureRmRecoveryServicesVault -ResourceGroupName $resourceGroupName
$StorageAccountName = 'task7storage'
#Generate random number for backup vault name
$UTCNow = (Get-Date).ToUniversalTime()
$random = $UTCNow.Millisecond
$location = 'West Europe'
$dscurl = "https://github.com/AzureLabDevOps/ALipinski/raw/master/task-7/dsc.ps1.zip"

Select-AzureRmSubscription -Subscriptionid $Sub

#Enter login name
Write-Host "Please enter login name for VM: "
$login = Read-Host
#Enter password for VM
Write-Host "Please enter password for VM: "
$password = Read-Host -AsSecureString

$ParametersFilePath = "$env:TEMP\main-parameters.json"

#Download from URI to %temp%
Invoke-WebRequest -Uri $templateParametersURI -OutFile $ParametersFilePath


#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

#Deploy main template
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateUri $templateURI `
    -login $login `
    -password $password `
    -random $random `
    -dscurl $dscurl `
    -TemplateParameterFile $ParametersFilePath `
    -Verbose

#remove min-parameters file from temp folder
Remove-Item $ParametersFilePath

#Start backup
Set-AzureRmRecoveryServicesVaultContext -Vault $vault
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -Status "Registered" `
    -FriendlyName $vm.Name

$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer `
    -WorkloadType "AzureVM"

$job = Backup-AzureRmRecoveryServicesBackupItem -Item $item
