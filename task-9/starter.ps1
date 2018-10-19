Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task9'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
# $template = 'C:\git\ALipinski\task-9\vm_and_network.json'
$location = 'West Europe'

Select-AzureRmSubscription -Subscriptionid $Sub

# #Enter login name
# Write-Host "Please enter login name for VM: "
# $login = Read-Host
# #Enter password for VMc
# Write-Host "Please enter password for VM: "
# $password = Read-Host -AsSecureString

# $ParametersFilePath = "$env:TEMP\main-parameters.json"

# #Download from URI to %temp%
# Invoke-WebRequest -Uri $templateParametersURI -OutFile $ParametersFilePath


#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}
# #Deploy main template
# New-AzureRmResourceGroupDeployment `
#     -ResourceGroupName $resourceGroupName `
#     -TemplateFile $template `
#     # -login $login `
#     # -password $password `
#     # -TemplateParameterFile $ParametersFilePath `
#     -Verbose

#remove min-parameters file from temp folder
# Remove-Item $ParametersFilePath
$template = "C:\git\ALipinski\task-9\create-automation-account.json"
$templatePar = "C:\git\ALipinski\task-9\create-automation-account-parameters.json"

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -TemplateParameterFile $templatePar