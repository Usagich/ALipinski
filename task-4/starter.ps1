$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/1vnet-2subnets-create.json' 
$templateFilePathPar = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/1vnet-2subnets-create-parameters.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG2 -TemplateFile $templateFilePath -TemplateParameterFile -$templateFilePathPar