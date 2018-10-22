Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task9'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
Select-AzureRmSubscription -Subscriptionid $Sub

$storageAccountName = 'task9storage'
$skuName = "Standard_LRS"
$location = 'West Europe'
$templateAA = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-9.2/create-automation-account.json'
$templateVMs = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-9.2/vm_and_network.json'

$resourceGroup = Get-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -ErrorAction SilentlyContinue

if (!$resourceGroup) {
    New-AzureRmResourceGroup `
        -Name $resourceGroupName `
        -Location 'West Europe'
}

$storageAccount = Get-AzureRmStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -ErrorAction SilentlyContinue

if (!$storageAccount) {
    New-AzureRmStorageAccount `
        -ResourceGroupName $resourceGroupName `
        -Name $storageAccountName `
        -Location $location `
        -SkuName $skuName
}

#Enter login name for VM
Write-Host "Please enter login name for VM: "
$vm_login = Read-Host

#Enter password for VM
Write-Host "Please enter password for VM: "
$vm_passwd = Read-Host -AsSecureString

#Enter password for app registration secret
Write-Host "Enter password for app registration secret: "
$app_pass = Read-Host -AsSecureString


$application = Get-AzureRmADApplication | `
    Where-Object {$_.HomePage -like "http://task9.com"}
    
$obj_id = $application.ObjectId

$app_id = ($application.ApplicationId).Guid

$app_key = Get-AzureRmADAppCredential `
    -ObjectId $obj_id `
    -ErrorAction SilentlyContinue

if ($app_key) {
    Remove-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Force

    New-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Password $app_pass
}
else {
    New-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Password $app_pass 
}

#create Automation Account
New-AzureRmResourceGroupDeployment `
    -TemplateUri $templateAA `
    -ResourceGroupName $resourceGroupName `
    -app_id $app_id `
    -app_pass $app_pass `
    -Verbose

$automationAccountKey = ConvertTo-SecureString -AsPlainText ((Get-AzureRmAutomationAccount -ResourceGroupName $resourceGroupName | `
            Get-AzureRmAutomationRegistrationInfo).PrimaryKey) -Force

$automationAccountUrl = ConvertTo-SecureString -AsPlainText ((Get-AzureRmAutomationAccount -ResourceGroupName $resourceGroupName | `
            Get-AzureRmAutomationRegistrationInfo).Endpoint) -Force


#Create VMs andd add it to DSC AA
New-AzureRmResourceGroupDeployment `
    -TemplateUri $templateVMs `
    -ResourceGroupName $resourceGroupName `
    -vm_login $vm_login `
    -vm_passwd $vm_passwd `
    -automationAccountKey $automationAccountKey `
    -automationAccountUrl $automationAccountUrl `
    -Verbose



