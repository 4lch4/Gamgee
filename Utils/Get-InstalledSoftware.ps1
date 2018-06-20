# =============================================================================
#	 Created on:   06/16/18 @ 11:21
#	 Created by:   Alcha
#	 Organization: HassleFree Solutions, LLC
#	 Filename:     Get-InstalledSoftware.ps1
#  Notes:        Adapted from the InstalledSoftware.ps1 script available here:
#  https://powershellgallery.com/packages/InstalledSoftware/2.0/DisplayScript
# =============================================================================

function Get-InstalledSoftware {
  [CmdletBinding()]
  param (
    [Alias('Computer', 'ComputerName', 'HostName')]
    [Parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $true, Position = 1)]
    [System.String[]]$Name = $env:COMPUTERNAME
  )
  
  begin {
    $LMkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall", "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $LMtype = [Microsoft.Win32.RegistryHive]::LocalMachine
    $CUkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall"
    $CUtype = [Microsoft.Win32.RegistryHive]::CurrentUser
  }

  process {
    foreach ($Computer in $Name) {
      $script:MasterKeys = @()
      
      if (!(Test-Connection -ComputerName $Computer -count 1 -quiet)) {
        Write-Error -Message "Unable to contact $Computer. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
        break
      }
      
      $CURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($CUtype, $computer)
      $LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMtype, $computer)

      Get-SubKeyObjects $LMkeys $LMRegKey
      Get-SubKeyObjects $CUKeys $CURegKey
      
      $script:MasterKeys = ($script:MasterKeys | Where-Object {
          $_.Name -ne $Null -AND $_.SystemComponent -ne "1" -AND $_.ParentKeyName -eq $Null
        } | Select-Object ComputerName, Name, InstallD, Version, UninstallCommand | Sort-Object Name)
      
      return $script:MasterKeys
    }
  }
}

function Get-SubKeyObjects {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    $BaseKey,

    [Parameter(Mandatory = $true, Position = 1)]
    [Microsoft.Win32.RegistryKey]$RegistryKey
  )

  process {
    foreach ($Key in $BaseKey) {
      $RegKey = $RegistryKey.OpenSubkey($Key)
      if ($RegKey -ne $null) {
        foreach ($subName in $RegKey.getsubkeynames()) {
          foreach ($sub in $RegKey.opensubkey($subName)) {
            $script:MasterKeys += (New-Object PSObject -Property @{
                "ComputerName"     = $Computer
                "Name"             = $sub.getvalue("displayname")
                "SystemComponent"  = $sub.getvalue("systemcomponent")
                "ParentKeyName"    = $sub.getvalue("parentkeyname")
                "Version"          = $sub.getvalue("DisplayVersion")
                "UninstallCommand" = $sub.getvalue("UninstallString")
                "InstallDate"      = $sub.getvalue("InstallDate")
              })
          }
        }
      }
    }
  }
}
