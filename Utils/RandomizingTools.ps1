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

function Get-RandomString {
	param (
		[Parameter(Mandatory = $false,
				   Position = 0)]
		[int]
		$CharacterCount = 10
	)
	
	$RandomString = New-Object -TypeName System.Text.StringBuilder
	
	while ($RandomString.Length -le $CharacterCount) {
		[char]$RandomChar = (46 .. 57) + (65 .. 90) + (97 .. 122) | Get-Random -Count 1
		[void]$RandomString.Append($RandomChar)
	}
	
	$RandomString.ToString()
}