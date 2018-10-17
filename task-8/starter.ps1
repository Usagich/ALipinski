Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task8'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$templateURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-8/main.json'
$templateParametersURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-8/main-parameters.json"
#Generate random number for backup vault name
# $UTCNow = (Get-Date).ToUniversalTime()
# $random = $UTCNow.Millisecond
$location = 'West Europe'

Select-AzureRmSubscription -Subscriptionid $Sub

#Enter login name
Write-Host "Please enter login name for VM: "
$login = Read-Host
#Enter password for VM
Write-Host "Please enter password for VM: "
$password = Read-Host -AsSecureString

# $ParametersFilePath = "$env:TEMP\main-parameters.json"
# #Download from URI to %temp%
# Invoke-WebRequest -Uri $templateParametersURI -OutFile $ParametersFilePath


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
    -TemplateParameterUri $templateParametersURI `
    -Verbose

# #remove min-parameters file from temp folder
# Remove-Item $ParametersFilePath
