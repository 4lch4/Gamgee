# =============================================================================
#	 Created on:   06/16/18 @ 11:21
#	 Created by:   Alcha
#	 Organization: HassleFree Solutions, LLC
#	 Filename:     Get-InstalledSoftware.ps1
#  Notes:        Adapted from the InstalledSoftware.ps1 script available here:
#  https://powershellgallery.com/packages/InstalledSoftware/2.0/DisplayScript
# =============================================================================

<#
.SYNOPSIS
  Gets a list of installed software for each computer name provided.

.DESCRIPTION
  Analayzes the registry of each computer name provided for all of the installed
software and returns it as an array.

.PARAMETER Name
  The name(s) of the computers to get the list of installed software from.

.EXAMPLE
  PS C:\> Get-InstalledSoftware
Gets a list of all the currently installed software and returns it as an array.
#>
function Get-InstalledSoftware {
  [CmdletBinding()]
  param (
    [Alias('Computer', 'ComputerName', 'HostName')]
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [System.String[]]
    $Name = $env:COMPUTERNAME
  )

  begin {
    $LMKeys = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $LMType = [Microsoft.Win32.RegistryHive]::LocalMachine
    $CUKeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall"
    $CUType = [Microsoft.Win32.RegistryHive]::CurrentUser
  }

  process {
    foreach ($Computer in $Name) {
      $script:MasterKeys = @()

      if (!(Test-Connection -ComputerName $Computer -count 1 -quiet)) {
        Write-Error -Message "Unable to contact $Computer. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
        break
      }

      $CURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($CUType, $Computer)
      $LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMType, $Computer)

      Get-SubKeyObjects $LMKeys $LMRegKey
      Get-SubKeyObjects $CUKeys $CURegKey

      $script:MasterKeys = ($script:MasterKeys | Where-Object {
          ($null -ne $_.Name) -and ($_.SystemComponent -ne "1") -and ($null -eq $_.ParentKeyName)
        } | Select-Object ComputerName, Name, Version, UninstallCommand, InstallDate | Sort-Object Name)

      return $script:MasterKeys
    }
  }
}

<#
.SYNOPSIS
  This is an internal/private function that is only used to simplify the flow of
code within this script. Instead of having these foreach loops all within the
original function, I placed them here and call this function.
#>
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
        foreach ($SubName in $RegKey.getsubkeynames()) {
          foreach ($Sub in $RegKey.opensubkey($SubName)) {
            $script:MasterKeys += (New-Object PSObject -Property @{
                "ComputerName"     = $Computer
                "Name"             = $Sub.getvalue("displayname")
                "SystemComponent"  = $Sub.getvalue("systemcomponent")
                "ParentKeyName"    = $Sub.getvalue("parentkeyname")
                "Version"          = $Sub.getvalue("DisplayVersion")
                "UninstallCommand" = $Sub.getvalue("UninstallString")
                "InstallDate"      = $Sub.getvalue("InstallDate")
              })
          }
        }
      }
    }
  }
}

#region HTML Code
$Head = @"
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
  crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
  crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
  crossorigin="anonymous"></script>
"@

$HeaderRow = @"
<tr>
  <th>Name</th>
  <th>Version</th>
  <th>Uninstall Command</th>
</tr>`n
"@

$TopBody = @"
<h1 class="text-center display-1">Installed Software</h1>
<p class="text-center">This is a table of software installed on LINCLER as of <b>$(Get-Date -UFormat "%A, %B %d %Y @ %T")</b>.</p>
"@

$Rows = ""
#endregion HTML Code

#region HTML Functions
<#
.SYNOPSIS
  This is an internal/private function that is only used to simplify the flow of
code within this script. It returns the HTML code required to build a table
using the provided $DataRows parameter.
#>
function Get-Table {
  param (
    [Parameter(Position = 0)]
    [System.String]
    $DataRows
  )

  return @"
  $TopBody
  <table id="SoftwareTable" class="table table-sm">
    <thead>
      $HeaderRow
    </thead>

    <tbody>
      $DataRows
    </tbody>
  </table>
"@
}

<#
.SYNOPSIS
  Gets a list of installed software for each computer name provided and puts it
in an HTML file.

.DESCRIPTION
  Analayzes the registry of each computer name provided for all of the installed
software and then creates a decent looking table within an HTML file with all of
the values.

.PARAMETER Name
  The name(s) of the computers to get the list of installed software from.

.EXAMPLE
  PS C:\> Get-InstalledSoftware
Gets a list of all the currently installed software and returns it as an array.
#>
function Get-InstalledSoftwareAsHtml {
  [CmdletBinding()]
  param (
    [Alias('Computer', 'ComputerName', 'HostName')]
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    [System.String[]]
    $Name = $env:COMPUTERNAME
  )

  foreach ($Program in Get-InstalledSoftware -Name $Name) {
    $Name = $Program.Name
    $Version = $Program.Version
    $UninstallCmd = $Program.UninstallCommand

    if (Test-Path $UninstallCmd) {
      $Rows += @"
      <tr class="table-success">
        <td>$Name</td>
        <td>$Version</td>
        <td style="font-style: italic;">$UninstallCmd</td>
      </tr>`n
"@
    } elseif ($UninstallCmd -match 'MsiExec.exe') {
      $Rows += @"
      <tr class="table-warning">
        <td>$Name</td>
        <td>$Version</td>
        <td style="font-style: italic;">Start-Process -FilePath cmd.exe -ArgumentList '/c', '$UninstallCmd'</td>
      </tr>`n
"@
    } else {
      $Rows += @"
      <tr class="table-primary">
        <td>$Name</td>
        <td>$Version</td>
        <td style="font-style: italic;">& $UninstallCmd</td>
      </tr>`n
"@
    }
  }

  $Body = Get-Table $Rows
  ConvertTo-Html -Body $Body -Head $Head -Title 'Installed Software'
}
#endregion HTML Functions
