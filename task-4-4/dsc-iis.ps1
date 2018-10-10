Configuration Binding
{

Import-DSCResource -ModuleName PSDesiredStateConfiguration 

Import-DscResource -ModuleName xWebAdministration -Name MSFT_xWebsite

xWebsite MainHTTPWebsite  
{  
    Ensure          = "Present"  
    Name            = 'Default Web Site'
    ApplicationPool = "DefaultAppPool" 
    State           = "Started"  
    PhysicalPath    = "%SystemDrive%\inetpub\wwwroot\iisstart.htm"  
    BindingInfo     =  @(MSFT_xWebBindingInformation
                            {
                        Protocol              = 'HTTP' 
                        Port                  = '8080'
                        IPAddress             = '*'
                        HostName              = 'localhost'

                            }
                         )   
}
}