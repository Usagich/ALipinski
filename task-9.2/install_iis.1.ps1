configuration install_iis_
{
    Node WebServer
    {
        WindowsFeature IIS {
            Ensure               = 'Present'
            Name                 = 'Web-Server'
            IncludeAllSubFeature	= $true
        }
    }
    WindowsFeature AspNet45 {
        Ensure = "Present"
        Name   = "Web-Asp-Net45"
    }
}