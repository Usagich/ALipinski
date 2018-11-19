Configuration InstallAll
{
    import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node $AllNodes.NodeName
    {
        # Script EnableTLS12 {
        #     SetScript  = {
        #         [ Net.ServicePointManager ]::SecurityProtocol = [ Net.ServicePointManager ]::SecurityProtocol.toString() + ' , ' + [ Net.SecurityProtocolType ]::Tls12
        #     }
        #     TestScript = {
        #         return ([ Net.ServicePointManager ]::SecurityProtocol -match ' Tls12 ' )
        #     }
        #     GetScript  = {
        #         return @{
        #             Result = ([ Net.ServicePointManager ]::SecurityProtocol -match ' Tls12 ' )
        #         }
        #     }
        # }    
        # Script DownloadInstalls {
        #     GetScript  = 
        #     {
        #         @{
        #             Result     = ('True' -in (Test-Path "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"))
        #         }
        #     }    
        #     SetScript  = 
        #     {
        #         Invoke-WebRequest -Uri $using:AllNodes.zipUri -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.zipOut)"          
        #         Invoke-WebRequest -Uri $using:AllNodes.GitLastUri  -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.GitLastOut)"
        #         Invoke-WebRequest -Uri $using:AllNodes.GitOldUri -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.GitOldOut)"
        #         Invoke-WebRequest -Uri $using:AllNodes.JreUri -OutFile "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"
        #     }        
        #     TestScript = 
        #     {
        #         $Status = ('True' -in (Test-Path "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"))
        #         $Status -eq $True
        #     }
        # }
        Package JRE {
            Ensure    = "Present"
            Name      = "Java Platform SE 8 U192"
            Path      = "$($AllNodes.Out)\$($AllNodes.JreOut)"
            ProductId = "26A24AE4-039D-4CA4-87B4-2F64180192F0"
            Arguments = "/s INSTALLDIR=`"$($AllNodes.Out)\Java`" STATIC=1"
        }
        Environment  JAVA_HOME {
            Ensure    = "Present"
            Name      = "JAVA_HOME"
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
        Script ExtractGit {
            SetScript  = {
                & "C:\soft\7-Zip\7z.exe" "x" "$($using:AllNodes.Out)\$($using:AllNodes.GitOldOut)" "-o$($using:AllNodes.Out)\GitOldVersion"
                & "C:\soft\7-Zip\7z.exe" "x" "$($using:AllNodes.Out)\$($using:AllNodes.GitLastOut)" "-o$($using:AllNodes.Out)\GitLatestVersion" 
            }
            TestScript = {
                (Test-Path -Path "$($using:AllNodes.Out)\GitOldVersion")
            }
            GetScript  = {
            }
            DependsOn = "[Package]7zip"
        }
    }
}

InstallAll -ConfigurationData C:\git\ALipinski\PowerShell\Module-5\ConfigurationData.psd1 -OutputPath C:\soft\mof

Start-DscConfiguration -Path "C:\soft\mof" -ComputerName localhost -Force -Verbose -wait


       
# xRemoteFile javaInstaller {
#     DestinationPath = (Join-Path $AllNodes.Out "\Java\jreInstaller.exe")
#     Uri = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=211999"
# }