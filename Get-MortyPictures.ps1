<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.130
	 Created on:   	11/19/2016 10:07 AM
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:      Get-MortyPictures.ps1
	===========================================================================
	.DESCRIPTION
		Contains the various functions for obtaining the latest pictures on the
	https://pocketmortys.net website. They're used for my profile picture 
	across my social media sites.
#>
$MortyMin = 2
$MortyMax = 174

function Get-FrontMortyImages {
	[CmdletBinding()]
	param
	(
		[Parameter(Position = 0)]
		[String]
		$StorageDir = "Z:\Media\Pictures\Rick_and_Morty"
	)
	
	if (-not (Test-Path $StorageDir)) {
		$StorageDir = New-Item -Path "C:\Temp" -ItemType Directory
	}
	
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	for ($x = $MortyMin; $x -le $MortyMax; $x++) {
		$MortyCounter = "{0:D3}" -f $x
		$Url = "https://pocketmortys.net/images/large/$MortyCounter-Front.png"
		
		$FileName = "$StorageDir\Morty_$MortyCounter`_Front.png"
		if (-not (Test-Path $FileName)) {
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
		$StorageDir = "D:\Media\Pictures\Rick_and_Morty"
	)
	
	if (-not (Test-Path $StorageDir)) {
		$StorageDir = New-Item -Path "C:\Temp" -ItemType Directory
	}
	
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	for ($x = $MortyMin; $x -le $MortyMax; $x++) {
		$MortyCounter = "{0:D3}" -f $x
		$Url = "https://pocketmortys.net/images/large/$MortyCounter-Back.png"
		
		$FileName = "$StorageDir\Morty-$MortyCounter-Back.png"
		if (-not (Test-Path $FileName)) {
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
		$StorageDir = "D:\Media\Pictures\Rick_and_Morty"
	)
	
	if (-not (Test-Path $StorageDir)) {
		$StorageDir = New-Item -Path "C:\Temp" -ItemType Directory
	}
	
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	for ($x = $MortyMin; $x -le $MortyMax; $x++) {
		$MortyCounter = "{0:D3}" -f $x
		
		for ($y = 1; $y -le 3; $y++) {
			[System.String]$Url = "https://pocketmortys.net/images/sprites/sprites_" + "$MortyCounter" + "_" + $y + ".png"
			[System.String]$FileName = "$StorageDir\Sprite_" + "$MortyCounter" + "_" + $y + ".png"
			if (-not (Test-Path $FileName)) {
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

function Get-AllPocketMortyImages {
	[CmdletBinding()]
	$CssUrl = "https://pocketmortys.net/templates/rt_mercado/css/template.css"
	$Response = Invoke-WebRequest -Uri $CssUrl
	$CssText = $Response.Content
	$StorageDir = "D:\Media\Pictures\Rick_and_Morty\Pocket_Mortys_All"
	
	$RegEx = "url\(/images(.*)\)"
	$Matches = Select-String -InputObject $CssText -Pattern $RegEx -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
	$WebClient = New-Object -TypeName System.Net.WebClient
	
	foreach ($Item in $Matches) {
		$FileLoc = $Item.substring(5, ($Item.length - 6))
		$FileName = $FileLoc.substring($FileLoc.lastindexof("/") + 1)
		$Url = "https://pocketmortys.net/$FileLoc"
		$FilePath = "$StorageDir\$FileName"
		
		if (-not (Test-Path $FilePath)) {
			Write-Verbose -Message "Currently downloading $FileName."
			$WebClient.DownloadFile($Url, $FilePath)
		}
	}
}