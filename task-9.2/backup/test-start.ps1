$resourceGroupName = 'task9'

$template = "C:\git\ALipinski\task-9.2\add_vm.json"

$auto_acc_info = (Get-AzureRmAutomationRegistrationInfo -ResourceGroupName $resourceGroupName -AutomationAccountName 'task9automationaccount')

$registrationKey = $auto_acc_info.PrimaryKey

$registrationUrl = $auto_acc_info.Endpoint
 
$VMsName = (Get-AzureRmVM -ResourceGroupName $resourceGroupName).Name


foreach ($vmName in $VMsName) {
    New-AzureRmResourceGroupDeployment `
        -TemplateFile $template `
        -ResourceGroupName $resourceGroupName `
        -vmName $vmName `
        -registrationKey $registrationKey `
        -registrationUrl $registrationUrl `
        -Verbose
}


# foreach ($vm in $vms_name) {
#     Register-AzureRmAutomationDscNode `
#         -AutomationAccountName "task9automationaccount" `
#         -AzureVMName $vm `
#         -ResourceGroupName $resourceGroupName `
#         -NodeConfigurationName "ContosoConfiguration.webserver"
# }
