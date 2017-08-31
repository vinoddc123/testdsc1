Configuration telnet
{
    Node localhost
    param ()
    
    WindowsFeature Telnet-Client
    {
        Name = @( 'Telnet-Client)
        Ensure = 'Present'
        IncludeAllSubFeature = $true
        LogPath = 'C:\LogPath\Log.log'
    }
}
