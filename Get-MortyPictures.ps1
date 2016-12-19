<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.130
	 Created on:   	11/19/2016 10:07 AM
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
function Get-FrontMortyImages {
	[CmdletBinding()]
	param
	(
		[Parameter(Position = 0)]
		[String]
		$StorageDir = "D:\Media\Pictures\Morty\"
	)
	
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	for ($x = 2; $x -le 168; $x++) {
		$MortyCounter = "{0:D3}" -f $x
		$Url = "https://pocketmortys.net/images/large/$MortyCounter-Front.png"
		
		$FileName = "$StorageDir\Morty-$MortyCounter-Front.png"
		if ($null -eq (Get-ChildItem $FileName)) {
			$WebClient.DownloadFile($Url, $FileName)
		}
	}
}

function Get-BackMortyImages {
	[CmdletBinding()]
	param
	(
		[Parameter(Position = 0)]
		[String]
		$StorageDir = "D:\Media\Pictures\Morty\"
	)
	
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	for ($x = 2; $x -le 168; $x++) {
		$MortyCounter = "{0:D3}" -f $x
		$Url = "https://pocketmortys.net/images/large/$MortyCounter-Back.png"
		
		$FileName = "$StorageDir\Morty-$MortyCounter-Back.png"
		if ($null -eq (Get-ChildItem $FileName)) {
			$WebClient.DownloadFile($Url, $FileName)
		}
	}
}

function Get-MortySprites {
	[CmdletBinding()]
	param
	(
		[Parameter(Position = 0)]
		[String]
		$StorageDir = "D:\Media\Pictures\Morty\"
	)
	
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	for ($x = 2; $x -le 168; $x++) {
		$MortyCounter = "{0:D3}" -f $x
		
		for ($y = 1; $y -le 3; $y++) {
			[System.String]$Url = "https://pocketmortys.net/images/sprites/sprites_" + "$MortyCounter" + "_" + $y + ".png"
			[System.String]$FileName = "$StorageDir\Sprite_" + "$MortyCounter" + "_" + $y + ".png"
			if ($null -eq (Get-ChildItem $FileName)) {
				$WebClient.DownloadFile($Url, $FileName)
			}
		}
	}
}

function Get-AllMortyImages {
	Write-Output "Getting front images..."
	Get-FrontMortyImages
	
	Write-Output "Getting back images..."
	Get-BackMortyImages
	
	Write-Output "Getting sprite images..."
	Get-MortySprites
}