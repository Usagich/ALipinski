#Create folder
"localhost;127.0.0.1;.;localhost" | Out-File $env:TEMP\cn.txt
$textPath = Get-Content "$env:TEMP\cn.txt"

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
$ComputersList = $textPath.Split("`n|,| |;")
Invoke-Command -ThrottleLimit 2 -ComputerName $ComputersList `
    -ScriptBlock ${function:Get-Info} | ConvertTo-Json | Out-File .\get-info.json

Remove-Item $env:TEMP\cn.txt