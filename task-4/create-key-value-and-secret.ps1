Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'testRG5'
)

$vaultname = "winadmin"
$password = "ZEtyu7702954!"
$Location = "North Europe"

$resourceGroup = Get-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -ErrorAction SilentlyContinue

if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $Location
}

New-AzureRmKeyVault `
    -VaultName $vaultname `
    -ResourceGroupName $resourceGroupName `
    -Location $Location `
    -EnabledForTemplateDeployment

$secretvalue = ConvertTo-SecureString $password -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $vaultname -Name "examplesecret" -SecretValue $secretvalue