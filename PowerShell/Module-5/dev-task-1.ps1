Configuration InstallAll
{
    import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node $AllNodes.NodeName
    {
        Script EnableTLS12 {
            SetScript  = {
                [ Net.ServicePointManager ]::SecurityProtocol = [ Net.ServicePointManager ]::SecurityProtocol.toString() + ' , ' + [ Net.SecurityProtocolType ]::Tls12
            }
            TestScript = {
                return ([ Net.ServicePointManager ]::SecurityProtocol -match ' Tls12 ' )
            }
            GetScript  = {
                return @{
                    Result = ([ Net.ServicePointManager ]::SecurityProtocol -match ' Tls12 ' )
                }
            }
        }    
        Script DownloadMsi {
            GetScript  = 
            {
                @{
                    Result     = ('True' -in (Test-Path $AllNodes.JreOut))
                }
            }    
            SetScript  = 
            {
                Invoke-WebRequest -Uri $AllNodes.zipUri -OutFile $AllNodes.zipOut           
                Invoke-WebRequest -Uri $AllNodes.GitLastUri  -OutFile $AllNodes.GitLastOut 
                Invoke-WebRequest -Uri $AllNodes.GitOldUri -OutFile $AllNodes.GitOldOut
                Invoke-WebRequest -Uri $AllNodes.JreUri -OutFile $AllNodes.JreOut
      
            }        
            TestScript = 
            {
                $Status = ('True' -in (Test-Path $AllNodes.JreOut))
                $Status -eq $True
            }
        }
        # Package JRE {
        #     Ensure    = "Present"
        #     Name      = "Java Platform SE 8 U191"
        #     Path      = "C:\soft\JRE.msi"
        #     ProductId = ""
        #     Arguments = "/s INSTALLDIR=`"C:\soft\Java`" STATIC=1"
        # }
        # Environment  JAVA_HOME {
        #     Name      = "JAVA_HOME"
        #     Ensure    = "Present"
        #     Path      = $true
        #     Value     = "C:\soft\Java"
        #     DependsOn = "[Package]JRE"
        # }
        # Package 7-Zip {
        #     Ensure    = "Present"
        #     Name      = "7-Zip 18.05 (x64 edition)"
        #     Path      = "C:\soft\7z1805-x64.msi"
        #     ProductId = "23170F69-40C1-2702-1805-000001000000"
        #     Arguments = "INSTALLDIR=`"C:\soft\7-Zip`""
        # }
        # WindowsProcess ExtractGit_Latest {
        #     Path      = "C:\soft\7-Zip\7z.exe"
        #     Arguments = "x c:\soft\PortableGit-2.19.1-64-bit.7z.exe -oc:\soft\Git_Latest -y"
        #     DependsOn = "[Package]7-Zip"
        # }
        # WindowsProcess ExtractGit_Old {
        #     Path      = "C:\soft\7-Zip\7z.exe"
        #     Arguments = "x c:\soft\PortableGit-2.17.0-64-bit.7z.exe -oc:\soft\Git_Old -y"
        #     DependsOn = "[Package]7-Zip"
        # }
    }
}

$EnvironmentData = Import-PowerShellDataFile -Path .\Module-5\ConfigurationData.psd1

InstallAll -OutputPath "C:\soft\mof" -ConfigurationData $EnvironmentData

Start-DscConfiguration -Path "C:\soft\mof" -ComputerName localhost -Force -Verbose -wait