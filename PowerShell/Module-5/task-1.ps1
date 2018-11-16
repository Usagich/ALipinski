Configuration InstallApps
{
    Node localhost
    {
        Package Git {
            Ensure    = "Present"
            Name      = "Git"
            Path      = "C:\git\ALipinski\PowerShell\Module-5\PortableGit-2.19.1-64-bit.7z.exe"
            ProductId = ''

        }
    }
}
InstallApps
Start-DscConfiguration -ComputerName localhost -Path .\InstallApps\localhost.mof -Wait -Verbose

Configuration InstallGit
{
    Node localhost
    {
        Archive Git {
            Ensure    = "Present"  # You can also set Ensure to "Absent"
            Path      = "C:\git\ALipinski\PowerShell\Module-5\task-1.zip"
            Destination = "C:\git\ALipinski\PowerShell\Module-5\asdd"
        }
    }
}

InstallGit
Start-DscConfiguration -ComputerName localhost -Path .\InstallGit\ -Wait -Verbose -Force
