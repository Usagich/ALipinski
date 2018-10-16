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

Write-Host "Please enter login name for VM: "
$login = Read-Host

#generate random number for backup vault name
$UTCNow = (Get-Date).ToUniversalTime()
$random = $UTCNow.Millisecond

Write-Host "Please enter password for VM: "
$password = Read-Host -AsSecureString

$ParametersFilePath = "$env:TEMP\main-parameters.json"

#Download from URI to %temp%
Invoke-WebRequest -Uri $templateParametersURI -OutFile $ParametersFilePath

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'West Europe'
}

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                    -TemplateUri $templateURI `
                                    -login $login `
                                    -password $password `
                                    -random $random `
                                    -TemplateParameterFile $ParametersFilePath `
                                    -Verbose


 
Set-AzureRmRecoveryServicesVaultContext -Vault $vault

$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" `
                                                            -Status "Registered" `
                                                            -FriendlyName $vm.Name

$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer `
                                                -WorkloadType "AzureVM"

$job = Backup-AzureRmRecoveryServicesBackupItem -Item $item


