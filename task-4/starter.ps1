Param(
    [Parameter(Mandatory=$False)]
    [string]$resourceGroupName = 'task-4-resoure-group'
)
$Location = 'North Europe'
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$vaultname = "winadmin"
$password = "Qwertyu!"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup `
 -Name $resourceGroupName `
 -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $Location
}

New-AzureRmKeyVault `
  -VaultName $vaultname `
  -ResourceGroupName examplegroup `
  -Location $Location `
  -EnabledForTemplateDeployment
$secretvalue = ConvertTo-SecureString $password -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $vaultname -Name "examplesecret" -SecretValue $secretvalue

$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-3/main.json' 
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath
