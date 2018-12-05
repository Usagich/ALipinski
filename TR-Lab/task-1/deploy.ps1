Param(
  [string]$ResourceGroupName = 'test_RG_alipinski',
  [string]$Sub = 'b4d05768-e295-4195-9cdb-c07ecd987720',
  [string]$Location = 'East US',
  [string]$Path = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/TR-Lab/task-1/'
)

Write-Host "Select Subscription $sub "
Select-AzureRmSubscription -Subscriptionid $Sub

Write-Host "Check resource group"
if (!(Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
  New-AzureRmResourceGroup -Name $ResourceGroupName `
    -Location $Location
}

#Enter login for VM
Write-Host "Please enter login name for VM: "
$adminUsername = Read-Host

#Enter password for VM
Write-Host "Please enter password for VM: "
$AdminPassword = Read-Host -AsSecureString

# $Vm_Login = 'andreitest'
# $Vm_Passwd = 'Pa$$w0rd'

$Creds = @{
  adminUsername = "$adminUsername"
  AdminPassword = "$AdminPassword"
  Path          = "$Path"
}

$SplatParams = @{
  TemplateFile            = "$Path`main.json"
  ResourceGroupName       = $ResourceGroupName
  TemplateParameterObject = $Creds
}

New-AzureRmResourceGroupDeployment @SplatParams -Verbose

