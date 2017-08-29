Configuration 'Install_Feature_Telnet_Client'
{
    param 
    (       
        [System.String]
        $Name = 'Telnet-Client',

        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [System.Boolean]
        $IncludeAllSubFeature = $false,

        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [ValidateNotNullOrEmpty()]
        [System.String]
        $LogPath
    )
    
    Import-DscResource -ModuleName 'PSDscResources'
    
    Node Localhost
    {
        WindowsFeature WindowsFeatureTest
        {
            Name = $Name
            Ensure = $Ensure
            IncludeAllSubFeature = $IncludeAllSubFeature
        }
    }
}