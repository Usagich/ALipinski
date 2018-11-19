Configuration InstallAll2
{
    import-DscResource -ModuleName 'xPSDesiredStateConfiguration'
    Node localhost
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
        xRemoteFile javaInstaller {
            DestinationPath = "c:\soft\Java3\jre-8u191-windows-x64.exe"
            Uri             = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=235727_2787e4a523244c269598db4e85c51e0c"
        }
    }
}

InstallAll2 -OutputPath C:\soft\mof2

Start-DscConfiguration -Path C:\soft\mof2 -ComputerName localhost -Force -Verbose -wait


       
