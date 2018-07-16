<#
.SYNOPSIS
  Gets a random number between the provided min and max.

.DESCRIPTION
  Gets a random number between the provided minimum and maximum values using the
Get-Random cmdlet and passing in an array containing every value between the min
and max and asking for 1 result.

.PARAMETER Min
  The smallest value you wish to retrieve (inclusive).

.PARAMETER Max
  The largest value you wish to retrieve (inclusive).

.EXAMPLE
  PS C:\> Get-RandomNumber -Min 0 -Max 10
3
#>
function Get-RandomNumber {
  param (
    [Parameter(Mandatory = $true,
      Position = 0)]
    [float]
    $Min,

    [Parameter(Mandatory = $true,
      Position = 1)]
    [float]
    $Max
  )

  $Min .. $Max | Get-Random -Count 1
}

<#
.SYNOPSIS
  Gets a random string of characters.

.DESCRIPTION
  Gets a random string of characters, if a value isn't provided for the
CharacterCount parameter, then 10 random characters are generated and returned
as the final string.

.PARAMETER CharacterCount
  The length of the string you wish to generate.

.EXAMPLE
  PS C:\> Get-RandomString
e1TtxKYU3hf

.EXAMPLE
  PS C:\> Get-RandomString -CharacterCount 15
osdAcoTJurCLZR3B
#>
function Get-RandomString {
  param (
    [Parameter(Mandatory = $false,
      Position = 0)]
    [int]
    $CharacterCount = 10
  )

  $StringBuilder = New-Object -TypeName System.Text.StringBuilder

  while ($StringBuilder.Length -le $CharacterCount) {
    [char]$RandomChar = (46 .. 57) + (65 .. 90) + (97 .. 122) | Get-Random -Count 1
    [void]$StringBuilder.Append($RandomChar)
  }

  $StringBuilder.ToString()
}

<#
.SYNOPSIS
  Reverses the provided string(s) and returns it/them.

.DESCRIPTION
  Reverses the provided string(s) by converting them to an array and calling the
[System.Array]::Reverse() method then joining the results back to a new string.

.PARAMETER InputStr
  The string(s) you wish to reverse.

.EXAMPLE
  PS C:\> Get-ReversedString -InputStr 'value1'
1eulav

.EXAMPLE
  PS C:\> Get-ReversedString -InputStr 'value1', 'value2', 'value3', 'value4'
1eulav
2eulav
3eulav
4eulav
#>
function Get-ReversedString {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true,
      Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string[]]$InputStr
  )

  $Output = New-Object String[] $InputStr.Length

  for ($x = 0; $x -lt $InputStr.Length; $x++) {
    $ArrayStr = $InputStr[$x].ToCharArray()
    [System.Array]::Reverse($ArrayStr)
    $ReversedString = -join ($ArrayStr)

    $Output[$x] = $ReversedString
  }

  return $Output
}
