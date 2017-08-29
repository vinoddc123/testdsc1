Configuration telnet
{
    [CmdletBinding()]
    param ()

    Import-DscResource -ModuleName 'PSDscResources'

    WindowsFeatureSet WindowsFeatureSet1
    {
        Name = @( 'Telnet-Client', 'RSAT-File-Services' )
        Ensure = 'Present'
        IncludeAllSubFeature = $true
        LogPath = 'C:\LogPath\Log.log'
    }
}