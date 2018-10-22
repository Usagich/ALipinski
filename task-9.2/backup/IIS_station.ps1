Configuration IIS_station
{

    Import-DscResource -ModuleName xNetworking, xWebAdministration, PSDesiredStateConfiguration

    Node 'localhost'
    {
        xFirewall WebSitePortIN
        {
            Name        = 'WebSitePortIN'
            DisplayName = 'WebSitePortIN'
            Action      = 'Allow'
            Direction   = 'Inbound'
            LocalPort   = '8080'
            Protocol    = 'TCP'
            Profile     = 'Any'
            Enabled     = 'True'
        }
        
        WindowsFeature IIS 
        { 
            Ensure = “Present” 
            Name = “Web-Server” 
        } 
        
        xWebsite DefaultSite  
        { 
            Ensure          = "Present" 
            Name            = "Default Web Site" 
            State           = "Started" 
            PhysicalPath    = "C:\inetpub\wwwroot" 
            DependsOn       = "[WindowsFeature]IIS" 
        } 
        xWebsite NewWebsite 
        { 
            Ensure          = "Present" 
            Name            = "Default Web Site"
            State           = "Started" 
            PhysicalPath    = "C:\inetpub\wwwroot" 
            BindingInfo     = MSFT_xWebBindingInformation 
                             { 
                               Protocol              = "HTTP" 
                               Port                  = 8080
                             } 
            DependsOn       = "[xWebsite]DefaultSite" 
        } 
    }
}