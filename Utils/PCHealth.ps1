# =============================================================================
#  Created On:   2018/07/09 @ 15:48
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     Get-PCHealth.ps1
#  Description:  This script was originally written by Robert Stahl and shared
#   on the Spiceworks community site:
#   https://community.spiceworks.com/scripts/show/3765-powershell-system-health-check
#
# Any changes between the linked script and this are made by myself to make it
#   either easier on the eyes or to be more targetted to my own preferences.
#
# Notes: The purpose of this script is to run a series of health checks
#   on a given server or array of servers. The health check queries the
#   following info which is then formatted to HTML and saved in a file at
#   "C:\Logs\SERVER_NAME_Health_Report_FormattedDateTime.html":
#
#   1) System Information - name, OS, Build #, Major Service Pack Level, and Last Boot Time
#   2) Disk Information - DeviceID, Volume Name, Size in GB, Free Space in GB, Free Space in %
#   3) Application Log Information - Warnings and errors added to the Application Log within the last 24 hours
#   4) System Log Information - Warnings and errors added to the System Log within the last 24 hours
#   5) Services Information - Sorted by Start Up Type and running or not. Shows the DisplayName, Name, StartMode, and State
# =============================================================================

. $PSScriptRoot\Get-InstalledSoftware.ps1
. $PSScriptRoot\..\Network\Send-DailyReportToDiscord.ps1

#region Variable Declarations
$TOCContent = @"
<ul>
  <li><a href="#System">System Information</a></li>
  <li><a href="#Disk">Disk Information</a></li>
  <li><a href="#Application_Log">Application Log Information</a></li>
  <li><a href="#System_Log">System Log Information</a></li>
  <li><a href="#Services">Services Information</a></li>
  <li><a href="#Installed_Programs">Installed Programs Information</a></li>
  <li><a href="#Newly_Installed_Programs">Newly Installed Programs Information</a></li>
</ul>
"@

$Style = @"
<style>
  BODY{ background-color: #b0c4de; }
  TABLE{ border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse; }
  TH{ border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #778899 }
  TD{ border-width: 1px; padding: 3px; border-style: solid; border-color: black; }
  tr:nth-child(odd) { background-color: #d3d3d3; }
  tr:nth-child(even) { background-color: white; }
</style>
"@
#endregion Variable Declarations

#region Helper Functions
function Initialize-HTMLReportContent {
  [CmdletBinding()]
  param ()
  $script:StatusColor = @{
    Stopped = ' bgcolor="Red">Stopped<';
    Running = ' bgcolor="Green">Running<';
  }

  $script:EventColor = @{
    Error   = ' bgcolor="Red">Error<';
    Warning = ' bgcolor="Yellow">Warning<';
  }

  $script:ReportHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h1>System Health Check</h1>' | Out-String
  $script:OSHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="System">System Information</h2>' | Out-String
  $script:DiskHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="Disk">Disk Information</h2>' | Out-String
  $script:AppLogHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="Application_Log">Application Log Information</h2>' | Out-String
  $script:SysLogHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="System_Log">System Log Information</h2>' | Out-String
  $script:ServHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="Services">Services Information</h2>' | Out-String
  $script:InstalledAppsHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="Installed_Programs">Installed Programs Information</h2>' | Out-String
  $script:NewlyInstalledAppsHead = ConvertTo-HTML -As Table -Fragment -PreContent '<h2 id="Newly_Installed_Programs">Newly Installed Programs Information</h2>' | Out-String
}

function Initialize-TimestampData {
  [CmdletBinding()]
  param ()

  $TimestampAtBoot = Get-WmiObject Win32_PerfRawData_PerfOS_System | Select-Object -ExpandProperty systemuptime
  $CurrentTimestamp = Get-WmiObject Win32_PerfRawData_PerfOS_System | Select-Object -ExpandProperty Timestamp_Object
  $Frequency = Get-WmiObject Win32_PerfRawData_PerfOS_System | Select-Object -ExpandProperty Frequency_Object

  $UptimeInSec = ($CurrentTimestamp - $TimestampAtBoot) / $Frequency
  $script:Time = (Get-Date) - (New-TimeSpan -Seconds $UptimeInSec)
  $script:FormattedDate = (Get-Date).ToString('yyyy-MM-dd')
}

function Get-Filename {
  [CmdletBinding()]
  param ()

  $LogDirDate = Get-Date -UFormat "%Y-%m"
  $FileDir = "E:\Logs\$LogDirDate"
  Write-Verbose "FileDir = $FileDir"

  if (!(Test-Path $FileDir)) {
    New-Item -Path $FileDir -ItemType Directory -Force
  }

  $Filename = "$ComputerName`_Health_Report_$FormattedDate.html"
  Write-Verbose "Filename = $Filename"

  return Join-Path -Path $FileDir -ChildPath $Filename
}

function Get-AllData {
  $Freespace = @{
    Expression = {
      [int]($_.Freespace / 1GB)
    }
    Name       = 'Free Space (GB)'
  }

  $Size = @{
    Expression = {
      [int]($_.Size / 1GB)
    }
    Name       = 'Size (GB)'
  }

  $PercentFree = @{
    Expression = {
      [int]($_.Freespace * 100 / $_.Size)
    }
    Name       = 'Free (%)'
  }

  # Gathers information for System Name, Operating System, Microsoft Build Number, Major Service Pack Installed, and the last time the system was booted
  $script:OS = Get-WmiObject -class Win32_OperatingSystem -ComputerName $ComputerName | Select-Object -Property CSName, Caption, BuildNumber, ServicePackMajorVersion, @{
    n = 'LastBootTime'; e = {
      $_.ConvertToDateTime($_.LastBootUpTime)
    }
  }
  $script:OSHtml = $scriptOS | ConvertTo-HTML -Fragment

  # Gathers information for Device ID, Volume Name, Size in Gb, Free Space in Gb, and Percent of Frree Space on each storage device that the system sees
  $script:Disk = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $ComputerName | Select-Object -Property DeviceID, VolumeName, $Size, $Freespace, $PercentFree
  $script:DiskHtml = $script:Disk | ConvertTo-Html -Fragment

  # Gathers Warning and Errors out of the Application event log.  Displays Event ID, Event Type, Source of event, Time the event was generated, and the message of the event.
  $script:AppEvent = Get-EventLog -ComputerName $ComputerName -LogName Application -EntryType "Error", "Warning" -after $script:Time | Select-Object -Property EventID, EntryType, Source, TimeGenerated, Message
  $script:AppEventHtml = $script:AppEvent | ConvertTo-Html -Fragment

  # Gathers Warning and Errors out of the System event log.  Displays Event ID, Event Type, Source of event, Time the event was generated, and the message of the event.
  $script:SysEvent = Get-EventLog -ComputerName $ComputerName -LogName System -EntryType "Error", "Warning" -After $Time | Select-Object -Property EventID, EntryType, Source, TimeGenerated, Message
  $script:SysEventHtml = $script:SysEvent | ConvertTo-Html -Fragment

  # Gathers information on Services.  Displays the service name, System name of the Service, Start Mode, and State.  Sorted by Start Mode and then State.
  $script:Service = Get-WmiObject win32_service -ComputerName $ComputerName | Select-Object DisplayName, Name, StartMode, State | Sort-Object StartMode, State, DisplayName
  $script:ServiceHtml = $script:Service | ConvertTo-Html -Fragment

  # Gathers information about Installed Applications on the Machine.
  $script:InstalledApps = Get-InstalledSoftware
  $script:InstalledAppsHtml = $script:InstalledApps | ConvertTo-Html -Fragment

  $script:NewlyInstalledApps = Get-NewlyInstalledSoftware
  $script:NewlyInstalledAppsHtml = $script:NewlyInstalledApps | ConvertTo-Html -Fragment
}

function Get-NewlyInstalledSoftware {
  [CmdletBinding()]
  param ()
  $NewlyInstalled = @()

  ForEach ($App in $script:InstalledApps) {
    if (($null -ne $App.InstallDate) -and ($App.InstallDate -match '[0-9]{8}')) {

      $Diff = (Get-Date -UFormat "%Y%m%d") - $App.InstallDate

      if ($Diff -eq 1) { $FormattedDate = [datetime]::Today.Subtract((New-TimeSpan -Days 1))}
      elseif ($Diff -eq 0) { $FormattedDate = [datetime]::Today }

      if (($Diff -eq 1) -or ($Diff -eq 0)) {
        $App.InstallDate = $FormattedDate
        Write-Debug "`$(`$App.Name) = $($App.Name); `$Diff = $Diff"
        $NewlyInstalled += $App
      }
    }
  }

  return $NewlyInstalled
}

function ConvertFrom-StringToObject {
  [CmdletBinding()]
  [Alias('csto')]
  param (
    [Parameter(Mandatory = $true, Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [Alias('Object', 'Data', 'Str')]
    [System.String]
    $ObjectString
  )

  $ObjectString = $ObjectString.Substring($ObjectString.IndexOf("{") + 1)

  $OuterObjectArray = $ObjectString.Split([System.Environment]::NewLine)

  $ObjectCollection = @{
  }

  foreach ($Line in $OuterObjectArray) {
    if ($Line -match ';') {
      $ObjectCollection += Get-SemiInnerObjects $Line
    } elseif ($Line -match ':') {
      $ObjectCollection += Get-ColonInnerObjects $Line
    }
  }

  $ObjectCollection
}

function Get-ColonInnerObjects {
  param (
    [System.String]
    $LineIn
  )

  $LineArr = $LineIn.Split(';')
  $ObjectCollection = @{
  }

  $ObjectCollection.Add($LineArr[0], $LineArr[1])

  return $ObjectCollection
}

function Get-SemiInnerObjects {
  param (
    [System.String]
    $LineIn
  )

  $LineArr = $LineIn.Split(';')
  $ObjectCollection = @{
  }

  foreach ($Item in $LineArr) {
    $Item = $Item.Trim()
    if ($Item -match '=') {
      $Name = $Item.Substring(0, $Item.IndexOf('='))
      $Value = $Item.Substring($Item.IndexOf('=') + 1)
      $ObjectCollection.Add($Name, $Value)
    } elseif ($Item -match ':') {
      $Name = $Item.Substring(0, $Item.IndexOf(':'))
      $Value = $Item.Substring($Item.IndexOf(':') + 1)
      $ObjectCollection.Add($Name, $Value)
    }
  }

  return $ObjectCollection
}
#endregion Helper Functions

function Get-PCHealth {
  [CmdletBinding()]
  [Alias('Get-Health', 'PCHealth')]
  param (
    [Parameter(Mandatory = $false,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      Position = 0)]
    [Alias('Name', 'Computer')]
    [System.String]
    $ComputerName = $env:COMPUTERNAME,

    [Parameter(Mandatory = $false,
      Position = 1)]
    [Alias('Open', 'Launch')]
    [switch]
    $OpenLog

    <#
    TODO: Add a DataOnly switch parameter that when present, only return the
    data for the PC health instead of all the fancy shit I do with it.
  #>
  )

  Write-Verbose "Generating PC Health Report..."

  Initialize-HTMLReportContent
  Initialize-TimestampData

  Get-AllData

  # Applies color coding based on cell value
  $StatusColor.Keys | ForEach-Object {
    $Service = $Service -replace ">$_<", ($StatusColor.$_)
  }

  $EventColor.Keys | ForEach-Object {
    $AppEvent = $AppEvent -replace ">$_<", ($EventColor.$_)
  }

  $EventColor.Keys | ForEach-Object {
    $SysEvent = $SysEvent -replace ">$_<", ($EventColor.$_)
  }

  $FullPath = Get-Filename
  Write-Verbose "FullPath = $FullPath"

  # Builds the HTML report for output

  $PostContent = "$script:ReportHead $TOCContent $script:OSHead $script:OSHtml $script:DiskHead $script:DiskHtml `
                $script:AppLogHead $script:AppEventHtml $script:SysLogHead $script:SysEventHtml $script:ServHead $script:ServiceHtml `
                $script:InstalledAppsHead $script:InstalledAppsHtml $script:NewlyInstalledAppsHead $script:NewlyInstalledAppsHtml"

  ConvertTo-HTML -Head $Style -PostContent $PostContent | Out-File $FullPath

  Write-Verbose 'PC Health Report generated...'

  if ($OpenLog.IsPresent) {
    Write-Verbose 'Opening the generated log file...'
    Start-Process -FilePath $FullPath
  }

  Write-Verbose 'Sending report to Discord webhook...'

  $PackagedData = @{
    InstalledApps      = $script:InstalledApps;
    NewlyInstalledApps = $script:NewlyInstalledApps;
    OS                 = $script:OS;
    Disk               = $script:Disk;
    AppEvent           = (ConvertFrom-StringToObject $script:AppEvent[0]);
    SysEvent           = $script:SysEvent;
    Service            = $script:Service;
  }

  Send-DailyReportToDiscord -Data $PackagedData
}