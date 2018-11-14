Get-Content "c:\Windows\Logs\DISM\DISM.log" | Select-String -SimpleMatch "warning"
Get-content -Path "c:\Windows\Logs\DISM\DISM.log" | where {$_ -match "\[0x"}