# =============================================================================
#  Created On:   2018/06/20 @ 12:22
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     ConfigTools.ps1
#  Description:  Contains the various functions responsible for maintaining
#               configuration info.
# =============================================================================

<#
.SYNOPSIS
  Set a user level environment variable.

.DESCRIPTION
  Sets a user level environment variable with the provided name and values.

.PARAMETER Name
  The name of the variable you wish to set.

.PARAMETER Value
  The value of the variable you wish to set.

.EXAMPLE
  PS C:\> Set-UserVariable -Name DISCORD_WEBHOOK -Value 'https://bit.ly/discurl'
  The variable "DISCORD_WEBHOOK" has been set with the following value:

  https://bit.ly/discurl

.NOTES
  Has a sister function, Set-MachineVariable that will let you set a machine
level environment variable if you need it available for more than one user.
#>
function Set-UserVariable {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('VariableName', 'VarName', 'Var')]
    [System.String]
    $Name,

    [Parameter(Mandatory = $true, Position = 1)]
    [System.String]
    [Alias('Data', 'Datum', 'Val')]
    $Value
  )

  if ($Name -match ' ') { Write-Error -Message 'The provided variable name contains a space. Try replacing the space with an underscore (_).' -RecommendedAction 'Replace the space with an underscore.'}
  else {
    try {
      [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::User)

      Write-Host "The variable `"$Name`" has been set with the following value:`n"
      Write-Host $Value
    } catch { Write-Error $_ }
  }
}

<#
.SYNOPSIS
  Set a machine level environment variable.

.DESCRIPTION
  Sets a machine level environment variable with the provided name and values.

.PARAMETER Name
  The name of the variable you wish to set.

.PARAMETER Value
  The value of the variable you wish to set.

.EXAMPLE
  PS C:\> Set-UserVariable -Name DISCORD_WEBHOOK -Value 'https://bit.ly/discurl'

.NOTES
  Has a sister function, Set-UserVariable that will let you set a user level
environment variable if you only need it for a specific user or don't have admin
rights.
#>
function Set-MachineVariable {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('VariableName', 'VarName', 'Var')]
    [System.String]
    $Name,

    [Parameter(Mandatory = $true, Position = 1)]
    [System.String]
    [Alias('Data', 'Datum', 'Val')]
    $Value
  )

  if ($Name -match ' ') { Write-Error -Message 'The provided variable name contains a space. Try replacing the space with an underscore (_).' -RecommendedAction 'Replace the space with an underscore.'}
  else {
    if (Get-IsUserAdmin) {
      try {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Machine)

        Write-Host "The variable `"$Name`" has been set with the following value:`n"
        Write-Host $Value
      } catch { Write-Error $_ }
    } else {
      Write-Error 'You must execute this function as an administrator as admin rights are required to add Machine level variables.'
     }
  }
}

<#
.SYNOPSIS
  Determines if the current process has administrator rights.

.DESCRIPTION
  Determines if the current process has administrator rights and returns true or
false.

.EXAMPLE
  PS C:\> Get-IsUserAdmin
  False

.EXAMPLE
  PS C:\> AmIAdmin
  True

.NOTES
  Whether or not the process is an admin is done by checking if the current
  identity is part of the built in Windows Administrator role.
#>
function Get-IsUserAdmin {
  [CmdletBinding()]
  [Alias('IsUserAdmin', 'Get-AdminStatus', 'AmIAdmin', 'IsAdmin')]
  param()


  return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
          [Security.Principal.WindowsBuiltInRole] "Administrator")
}

<#
.SYNOPSIS
  Gets a user enviornment variable and returns it.

.PARAMETER Name
  The name of the variable you want to retrieve.

.EXAMPLE
  PS C:\> Get-UserVariable -Name DISCORD_WEBHOOK
'https://bit.ly/ThisIsAShortedURLWebhook'

.NOTES
  Uses the GetEnvironmentVariable function from the Environment namespace.
#>
function Get-UserVariable {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('Var')]
    [System.String]
    $Name
  )

  return [System.Environment]::GetEnvironmentVariable($Name)
}
