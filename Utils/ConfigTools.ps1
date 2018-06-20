# =============================================================================
#  Created On:   2018/06/20 @ 12:22
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     ConfigTools.ps1
#  Description:  Contains the various functions responsible for maintaining
#               configuration info.
# =============================================================================

function Get-Config {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $Name
  )
	
  (Get-Variable -Name $Name -Scope Script).Value
}

function Set-Config {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $Name,
		
    [Parameter(Mandatory = $true, Position = 1)]
    [System.Object]
    $Value
  )
	
  Set-Variable -Name $Name -Scope Script -Value $Value
}