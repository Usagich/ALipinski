Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task8'
)
$location = 'West europe'
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$template = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-8/start.ps1"

#Select subscription
Select-AzureRmSubscription -Subscriptionid $Sub

$UTCNow = (Get-Date).ToUniversalTime()
$random = $UTCNow.Millisecond

#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

#get clientid and secret fron KeyVault
$KeyVault = (Get-AzureRmKeyVault | where {$_.VaultName -like '*task8'}).VaultName

$ClientId = (Get-AzureKeyVaultSecret -VaultName $KeyVault -Name ClientId).SecretValue
$secret = (Get-AzureKeyVaultSecret -VaultName $KeyVault -Name secret).SecretValue

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateUri $template `
    -ClientId $ClientId `
    -secret $secret `
    -random $random
