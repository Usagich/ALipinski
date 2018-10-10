Configuration Task 
{
    param ($MachineName)

    Import-DscResource -ModuleName xNetworking, xWebAdministration, PSDesiredStateConfiguration

    Node $MachineName {

        xFirewall WebSitePortIN {
            Name        = 'IIS'
            DisplayName = 'IIS'
            Action      = 'Allow'
            Direction   = 'Inbound'
            LocalPort   = '8080'
            Protocol    = 'TCP'
            Profile     = 'Any'
            Enabled     = 'True'
        }

        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
        }

        WindowsFeature ASP {
            Ensure = "Present"
            Name   = "Web-Asp-Net45"
        }

        WindowsFeature WebServerManagementConsole {
            Name   = "Web-Mgmt-Console"
            Ensure = "Present"
        }
        
        xWebsite MainHTTPWebsite {  
            Ensure          = "Present"  
            Name            = 'Default Web Site'
            ApplicationPool = "DefaultAppPool" 
            State           = "Started"  
            PhysicalPath    = "%SystemDrive%\inetpub\wwwroot\iisstart.htm"  
            BindingInfo     = @(MSFT_xWebBindingInformation {
                    Protocol  = 'HTTP' 
                    Port      = '8080'
                    IPAddress = '*'
                    HostName  = 'localhost'

                }
            )   
        }
    }
}