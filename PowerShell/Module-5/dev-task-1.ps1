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
        Script DownloadInstalls {
            GetScript  = 
            {
                @{
                    Result     = ('True' -in (Test-Path "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"))
                }
            }    
            SetScript  = 
            {
                Invoke-WebRequest -Uri $using:AllNodes.zipUri -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.zipOut)"          
                Invoke-WebRequest -Uri $using:AllNodes.GitLastUri  -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.GitLastOut)"
                Invoke-WebRequest -Uri $using:AllNodes.GitOldUri -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.GitOldOut)"
                Invoke-WebRequest -Uri $using:AllNodes.JreUri -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"
      
            }        
            TestScript = 
            {
                $Status = ('True' -in (Test-Path "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"))
                $Status -eq $True
            }
        }
        Package JRE {
            Ensure    = "Present"
            Name      = "Java Platform SE 8 U191"
            Path      = "$($AllNodes.Out)\$($AllNodes.JreOut)"
            ProductId = ""
            Arguments = "/s INSTALLDIR=`"$($AllNodes.Out)\Java`" STATIC=1"
        }
        Environment  JAVA_HOME {
            Name      = "JAVA_HOME"
            Ensure    = "Present"
            Path      = $true
            Value     = "$($AllNodes.Out)\Java"
            DependsOn = "[Package]JRE"
        }
        Package 7zip {
            Ensure    = "Present"
            Name      = "7-Zip 18.05 (x64 edition)"
            Path      = "$($AllNodes.Out)\$($AllNodes.zipOut)"
            ProductId = "23170F69-40C1-2702-1805-000001000000"
            Arguments = "INSTALLDIR=`"$($AllNodes.Out)\7-Zip`""
        }
        # WindowsProcess ExtractGit_Latest {
        #     Path      = "$($using:AllNodes.Out)\7-Zip\7z.exe"
        #     Arguments = "x $($using:AllNodes.Out)\PortableGit-2.19.1-64-bit.7z.exe -o$($using:AllNodes.Out)\Git_Latest -y"
        #     DependsOn = "[Package]7-Zip"
        # }
        # WindowsProcess ExtractGit_Old {
        #     Path      = "$($using:AllNodes.Out)\7-Zip\7z.exe"
        #     Arguments = "x $($using:AllNodes.Out)\PortableGit-2.17.0-64-bit.7z.exe -o$($using:AllNodes.Out)\Git_Old -y"
        #     DependsOn = "[Package]7-Zip"
        # }
        Package Git1 {
            Ensure    = "Present"  
            Path      = "$($AllNodes.Out)\7-Zip\7z.exe"
            Name      = "GItlatest"
            ProductId = ''
            dependson = '[Package]7zip'
            Arguments = "x $($AllNodes.Out)\$($AllNodes.GitLastOut) -o$($AllNodes.Out)\GitLastVersion"
        }
        Package Git2 {
            Ensure    = "Present"  
            Path      = "$($AllNodes.Out)\7-Zip\7z.exe"
            Name      = "GIT"
            ProductId = ''
            dependson = '[Package]7zip'
            Arguments = "x $($AllNodes.Out)\$($AllNodes.GitOldOut) -o$($AllNodes.Out)\GitOldVersion"
        }
    }
}

InstallAll -ConfigurationData .\ConfigurationData.psd1 -OutputPath C:\soft\mof

Start-DscConfiguration -Path "C:\soft\mof" -ComputerName localhost -Force -Verbose -wait