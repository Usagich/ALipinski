#Task 2-1	Find cmdlet that convert other cmdlets’ output into HTML 
Get-Process | ConvertTo-Html | Out-File Process.html
Invoke-Item .\Process.html

#Task 2-2	Which cmdlets could be used to write some data to file? What differences they have? 
Add-Content -Path .\test.txt -Value "Add-Content" # Можно создавать файлы или добавлять в существующий
Set-Content -Path .\test.txt -Value "Set-Content" #Перезаписывает файл
Get-Process | Export-Csv -Path .\Process.csv # Экспорт в csv
Get-Process | Export-Clixml -Path .\Process.xml # Экспорт в xml
"Out-File" | Out-File .\test.txt -Append # Можно так же создавать и добавлять в существующий, по умолчанию перезаписывает содержимое файла
Out-File -FilePath .\test.txt -Append -InputObject "Out-File" # Обычно используется в конвеере, но можно и так
Write-Output "Write-Output" >> .\test.txt # Можно переводить вывод в файл

#Task 2-3	Find cmdlets which are used to format the output 
gcm format-* | Format-Table  Name
Format-Hex
Format-Volume
Format-Custom
Format-List
Format-SecureBootUEFI
Format-Table
Format-Wide

#Task 3-1	Create new alias for your favorite command 
New-Alias -Name "info" -Value Get-Host

#Task 3-2	Show processes on your PC, which name begins with S char. 
Get-Process  "*S*"

#Task 3-3	Create new Windows Firewall rule (of your choice) 
New-NetFirewallRule -Name "Block Wireless In" -Direction Inbound -InterfaceType Wireless -Action Block

#Task 4-1	Find command to get current date and time 
Get-Date

#task 4-2	Use it to get date and time that were 100 years ago 
Get-Date -Year ((Get-Date).Year - 100)

#Task 4-3	Practice with this command to get various info about that time: what day of the week was? 
(Get-Date -Year ((Get-Date).Year - 100)).DayOfWeek

#task 4-4	Find command to get a list of hotfixes installed on your PC
Get-HotFix

#task 4-5	When was installed each of them?
Get-HotFix | ft HotFixID, InstalledOn