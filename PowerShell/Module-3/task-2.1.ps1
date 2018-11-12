$main = @{
    Computers = @()
}
function Get-Info {
    $FreeSpace = (Get-PSDrive C).Free / 1gb
    $TopProcess = (Get-Process | Sort-Object CPU -Descending | select -First 5).Processname
    $loadCpu = (Get-WmiObject win32_processor | select LoadPercentage).LoadPercentage
    $Computers += [Ordered]@{
        ComputerName = "$env:COMPUTERNAME";
        FreeSpace    = $FreeSpace;
        TopProcess   = $TopProcess;
        loadCpu      = $loadCpu
    }
#     $Computers = @"
#         ComputerName = "$env:COMPUTERNAME";
#         FreeSpace    = $FreeSpace;
#         TopProcess   = $TopProcess;
#         loadCpu      = $loadCpu
# "@
    return $Computers
}

[string]$textPath = '.\cn.txt'
$ComputersList = (Get-Content $textPath).Split("`n|,| ")
$main.Computers += Invoke-Command -ThrottleLimit 2 -ComputerName $ComputersList -ScriptBlock ${function:Get-Info}
# $new | ConvertTo-Json

$main | ConvertTo-Json -Depth 10