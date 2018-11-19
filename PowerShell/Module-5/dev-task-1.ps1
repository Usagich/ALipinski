Configuration InstallAll
{
    import-DscResource -ModuleName 'xPSDesiredStateConfiguration'
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
        #         Test-Path "$($using:AllNodes.Out)\$($using:AllNodes.JreOut)"
        #     }
        # }
        xRemoteFile Zip {
            DestinationPath = "$($AllNodes.Out)\$($AllNodes.zipOut)"
            Uri             = $AllNodes.zipUri
        }
        xPackage 7zip {
            Ensure    = "Present"
            Name      = "7-Zip 18.05 (x64 edition)"
            Path      = "$($AllNodes.Out)\$($AllNodes.zipOut)"
            ProductId = "23170F69-40C1-2702-1805-000001000000"
            Arguments = "INSTALLDIR=`"$($AllNodes.Out)\7-Zip`""
            DependsOn = "[xRemoteFile]Zip"
        }
        xRemoteFile GitLastOut {
            DestinationPath = "$($AllNodes.Out)\$($AllNodes.GitLastOut)"
            Uri             = $AllNodes.GitLastUri
        }
        xRemoteFile GitOldOut {
            DestinationPath = "$($AllNodes.Out)\$($AllNodes.GitOldOut)"
            Uri             = $AllNodes.GitOldUri
        }
        Script ExtractGit {
            SetScript  = {
                & "C:\soft\7-Zip\7z.exe" "x" "$($using:AllNodes.Out)\$($using:AllNodes.GitOldOut)" "-o$($using:AllNodes.Out)\GitOldVersion"
                & "C:\soft\7-Zip\7z.exe" "x" "$($using:AllNodes.Out)\$($using:AllNodes.GitLastOut)" "-o$($using:AllNodes.Out)\GitLatestVersion"
            }
            TestScript = {
                (Test-Path -Path "$($using:AllNodes.Out)\GitOldVersion") -and `
                (Test-Path -Path "$($using:AllNodes.Out)\GitLatestVersion")
            }
            GetScript  = {
            }
            DependsOn  = "[xPackage]7zip", "[xRemoteFile]GitLastOut", "[xRemoteFile]GitOldOut"
        }
        Environment  GIT {
            Ensure    = "Present"
            Name      = "GIT"
            Path      = $true
            Value     = "$($AllNodes.Out)\GitLatestVersion"
            DependsOn = "[Script]ExtractGit"
        }
        xRemoteFile JreOut {
            DestinationPath = "$($AllNodes.Out)\$($AllNodes.JreOut)"
            Uri             = $AllNodes.JreUri
        } 
        xPackage JRE {
            Ensure    = "Present"
            Name      = "Java Platform SE 8 U192"
            Path      = "$($AllNodes.Out)\$($AllNodes.JreOut)"
            ProductId = "26A24AE4-039D-4CA4-87B4-2F64180191F0"
            Arguments = "/s INSTALLDIR=`"$($AllNodes.Out)\Java`" STATIC=1"
            DependsOn = "[xRemoteFile]JreOut"
        }
        Environment  JAVA_HOME {
            Ensure    = "Present"
            Name      = "JAVA_HOME"
            Path      = $true
            Value     = "$($AllNodes.Out)\Java"
            DependsOn = "[xPackage]JRE"
        }
    }
}

InstallAll -ConfigurationData .\ConfigurationData.psd1 -OutputPath C:\soft\mof

Start-DscConfiguration -Path C:\soft\mof -ComputerName localhost -Force -Verbose -wait