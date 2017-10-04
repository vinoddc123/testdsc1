Configuration dscconfiguration
{

Param ([string] $servername)

Import-DscResource -ModuleName PSDesiredStateConfiguration

Node localhost
  {

  WindowsFeature ADTools
    {
      Name = "RSAT-ADDS-Tools"
      Ensure = "Present"
    }
    
    Script EnsurePresent
    {
        TestScript = {
            Test-Path "C:\temp\Reboot.bat"
        }
        SetScript ={
            if (!(Test-Path "C:\temp")){
                New-Item     C:\temp -ItemType Directory -Force
            }
            "shutdown -r -t 00 -f" | Out-File "C:\temp\Reboot.bat" -Force
             
        }
        GetScript = {@{Result = "EnsurePresent"}}
    }
    

   
    Script DisableFirewall
    {
        GetScript = {
            @{
                GetScript = $GetScript
                SetScript = $SetScript
                TestScript = $TestScript
                Result = -not('True' -in (Get-NetFirewallProfile -All).Enabled)
            }
        }

        SetScript = {
            Set-NetFirewallProfile -All -Enabled False -Verbose
        }

        TestScript = {
            $Status = -not('True' -in (Get-NetFirewallProfile -All).Enabled)
            $Status -eq $True
        }
    }
    
    $Value = "TLS 1.0", "TLS 1.1", "TLS 1.2"
    foreach ($data in $Value)
    {
        $char = $data.Replace(".", "").Replace(" ","")
        Registry "EnableServer$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Server"
            ValueName = "Enabled"
            ValueType = "Dword"
            ValueData = "00000000"
            Ensure = "Present"
            Hex = $false
            Force = $true
        }

        Registry "DisabledByDefaultServer$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Server"
            ValueName = "DisabledByDefault"
            ValueType = "Dword"
            ValueData = "00000000"
            Ensure = "Present"
            Hex = $false
            Force = $true
        }

        Registry "EnableClient$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Client"
            ValueName = "Enabled"
            ValueType = "Dword"
            ValueData = "0xffffffff"
            Ensure = "Present"
            Hex = $true
            Force = $true
        }

        Registry "DisableByDefaultClient$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Client"
            ValueName = "DisabledByDefault"
            ValueType = "Dword"
            ValueData = "00000000"
            Ensure = "Present"
            Hex = $false
            Force = $true
        }
    }

    $EnabletlsVersion = "TLS 1.2"
    foreach ($data in $EnabletlsVersion)
    {
        $char = $data.Replace(".", "").Replace(" ","")
        Registry "EnableServer$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Server"
            ValueName = "Enabled"
            ValueType = "Dword"
            ValueData = "0xffffffff"
            Ensure = "Present"
            Hex = $true
            Force = $true
        }

        Registry "DisabledByDefaultServer$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Server"
            ValueName = "DisabledByDefault"
            ValueType = "Dword"
            ValueData = "00000000" 
            Ensure = "Present"
            Hex = $false
            Force = $true
        }

        Registry "EnableClient$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Client"
            ValueName = "Enabled"
            ValueType = "Dword"
            ValueData = "0xffffffff"
            Ensure = "Present"
            Hex = $true
            Force = $true
        }

        Registry "DisableByDefaultClient$char"
        {
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$data\Client"
            ValueName = "DisabledByDefault"
            ValueType = "Dword"
            ValueData = "00000000" 
            Ensure = "Present"
            Hex = $false
            Force = $true
        }
    }

    
    
  }
  }
