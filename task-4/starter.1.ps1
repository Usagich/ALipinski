$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/main.json' 
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath
