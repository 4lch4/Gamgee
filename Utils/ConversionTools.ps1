<#
.SYNOPSIS
  Converts the given Hexidecimal value to Decimal.

.DESCRIPTION
  Converts the given Hexidecimal value to a Decimal value using the ToInt32
function of the Convert namespace.

.PARAMETER HexValue
  The hex value to convert.

.EXAMPLE
  PS C:\> Convert-HexToDec -HexValue '#FF00FF00'

.OUTPUTS
  System.Decimal
#>
function Convert-HexToDec {
  [CmdletBinding()]
  [OutputType([Decimal])]
  param (
    [Parameter(Mandatory = $true,
      Position = 0)]
    [ValidateScript( {
        if ($_ -match '[0123456789abcdef]{$Y}') {
          return $true
        }
        else {
          throw [System.Management.Automation.ParameterBindingException] 'The provided input is not a valid hexadecimal value.'
        }
      })]
    [Alias('Hex')]
    [String]
    $HexValue
  )

  if ($HexValue.StartsWith("#")) {
    $HexValue = $HexValue.Substring(1)
  }

  ForEach ($Value in $HexValue) {
    [Convert]::ToInt32($Value, 16)
  }
}

<#
.SYNOPSIS
  Converts the given Decimal value to Hexidecimal.

.DESCRIPTION
  Converts the given Decimal value to a Hexidecimal value.

.PARAMETER DecValue
  The decimal value to convert.

.EXAMPLE
  PS C:\> Convert-DecToHex -HexValue 16576479
#>
function Convert-DecToHex {
  [CmdletBinding()]
	param (
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateScript({
				if ($_ -match '\d{0,8}') {
					return $true
				}
				else {
					throw [System.Management.Automation.ParameterBindingException] 'The provided input is not a valid decimal value.'
				}
			})]
		[Alias('Dec', 'Decimal')]
		[Decimal[]]
		$DecimalValue
	)

	ForEach ($Value in $DecimalValue) { ("{0:x}" -f [Int]$Value).ToUpper() }
}
