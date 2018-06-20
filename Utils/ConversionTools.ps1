function Convert-HexToDec {
  [CmdletBinding()]
  [OutputType([Decimal])]
  param (
    [Parameter(Mandatory = $true,
      Position = 0)]
    [ValidateScript( {
        if ($_ -match '[0123456789abcde]{$Y}') {
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
	
	ForEach ($Value in $DecimalValue) {
		("{0:x}" -f [Int]$Value).ToUpper()
	}
}
