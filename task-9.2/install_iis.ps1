configuration install_iis
{
    Node WebServer
    {
        WindowsFeature IIS {
            Ensure               = 'Present'
            Name                 = 'Web-Server'
            IncludeAllSubFeature	= $true
        }
    }
}