Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task7'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$templateURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/main.json'
$templateParametersURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/main-parameters.json"

Write-Host "Please enter login name for VM: "
$login = Read-Host

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
                                    -password $password `
                                    -login $login `
                                    -TemplateParameterFile $ParametersFilePath