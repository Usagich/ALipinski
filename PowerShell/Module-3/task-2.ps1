function Get-Info {
    $FreeSpace = (Get-PSDrive C).Free / 1gb
    $TopProcess = (Get-Process | Sort-Object CPU -Descending | select -First 5).Processname
    $loadCpu = (Get-WmiObject win32_processor | select LoadPercentage).LoadPercentage

    $Computers += [Ordered]@{
        FreeSpace  = $FreeSpace;
        TopProcess = $TopProcess;
        loadCpu    = $loadCpu
    }
    return $Computers
}

[string]$textPath = '.\cn.txt'
$ComputersList = (Get-Content $textPath).Split("`n|,| ")
Invoke-Command -ThrottleLimit 2 -ComputerName $ComputersList `
    -ScriptBlock ${function:Get-Info} -OutVariable var 
#| ConvertTo-Json | Out-File .\get-info.json

$var |select -ExcludeProperty RunspaceId,PSShowComputerName | ConvertTo-Json | Out-File .\get-info.json