Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task8'
)
$location = 'West europe'
#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}
$appid = 'bfcb2a07-de28-4b77-b704-e2d5eb5395a1'
$apppass = (Get-AzureKeyVaultSecret -VaultName keytask8 -Name apppass).SecretValue
$template = "C:\git\ALipinski\task-8\kbs.json"


New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -appid $appid `
    -apppass $apppass `
    -Verbose
