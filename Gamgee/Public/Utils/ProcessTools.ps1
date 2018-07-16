# =============================================================================
#  Created On:   2018/06/20 @ 12:37
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     ProcessTools.ps1
#  Description:  Contains functions for handling processes on LINCLER.
# =============================================================================

<#
.SYNOPSIS
  Retrieve the process(es) with the name of the currently focused program.

.DESCRIPTION
  A detailed description of the Get-ForegroundProcess function.

.PARAMETER TimeDelay
  The TimeSpan you wish to wait before actually getting the active app.
Mostly to give you time to switch applications and verify it shows the correct
application. You can pass in a New-TimeSpan object by referencing the examples.

.PARAMETER SimpleOutput
  If enabled, only the name of the currently active application/process is returned.

.EXAMPLE
  PS C:\> Start-Sleep -Seconds 2; Get-ActiveProcess

  Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
  -------  ------    -----      -----     ------     --  -- -----------
  345      53   105664      78752      10.34   1388   1 chrome
  431      61    95380      84556      45.22   2708   1 chrome
  345      46    33084      27220       1.31   3116   1 chrome
  ...

.EXAMPLE
  PS C:\> Start-Sleep -Seconds 2; Get-ActiveApp -Simple
  chrome

.EXAMPLE
  PS C:\> Get-ActiveApp -TimeDelay (New-TimeSpan -Seconds 5) -Simple
  ConEmu64

.OUTPUTS
  System.Diagnostics.Process, System.Diagnostics.Process[]

.NOTES
  Created on 2018/06/13 @ 21:02
#>
function Get-ActiveProcess {
  [CmdletBinding()]
  [Alias('Get-ForegroundApp', 'Get-ActiveApp', 'Get-ForegroundProcess')]
  [OutputType([System.Diagnostics.Process], [System.Diagnostics.Process[]])]
  param (
    [Parameter(Position = 0)]
    [Alias('Delay', 'Sleep')]
    [System.TimeSpan]$TimeDelay,

    [Parameter(Position = 1)]
    [Alias('Simple', 'CleanOutput', 'Clean')]
    [System.Management.Automation.SwitchParameter]$SimpleOutput
  )

  begin {
    if ($TimeDelay -ne $null -and $TimeDelay.TotalMilliseconds -gt 0) {
      Start-Sleep -Milliseconds $TimeDelay.TotalMilliseconds
    }

    $CSharp = Get-Content "$(Get-ScriptDirectory)\Utils\ProcessTools.cs" -Raw
    Add-Type -TypeDefinition $CSharp -Language CSharp
  }

  process {
    $ProcessName = [Alcha.ProcessTools]::GetForegroundProcessName()

    if ($SimpleOutput.IsPresent) {
      return $ProcessName
    }
    else {
      return (Get-Process -Name $ProcessName)
    }
  }

  end {
    Write-Verbose 'Active process retrieved...'
  }
}
