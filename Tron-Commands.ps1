<#
	.NOTES
		===========================================================================
		Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.131
		Created on:   	12/11/2016 4:25 PM
		Created by:   	DevinL
		Organization: 	SAPIEN Technologies, Inc.
		Filename:     	Tron-Commands.ps1
		===========================================================================
#>

function Upload-Tron {
	param
	(
		[Parameter(Position = 0)]
		[ValidateSet('Alcha', 'Bella', 'Foo', 'Kayla', 'Raylo', 'Prim', 'Utah', 'Ronnie', 'All')]
		[String]
		$Flavor,
		
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[Alias('User')]
		[String]
		$Username = 'alcha',
		
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[Alias('Pass')]
		[String]
		$Password,
		
		[Parameter(Position = 3)]
		[String[]]
		$Files = $null,
		
		[Parameter(Mandatory = $true,
				   Position = 4)]
		[String]
		$ServerIP
	)
	
	switch ($Flavor) {
		'Alcha' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronA.js'
			break;
		}
		
		'Bella' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronB.js'
			break;
		}
		
		'Foo' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronC.js'
			break;
		}
		
		'Kayla' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronD.js'
		}
		
		'Ronnie' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronE.js'
		}
		
		'Prim' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronF.js'
		}
		
		'Raylo' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronG.js'
		}
		
		'Utah' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronH.js'
		}
		
		'All' {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronA.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronB.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronC.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronD.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronE.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronF.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronG.js', `
			'D:\Development\NodeJS\Projects\Tron\Side_Bots\TronH.js'
			break;
		}
		
		default {
			$Files = 'D:\Development\NodeJS\Projects\Tron\Tron.js'
			break;
		}
	}
	
	$FTPServer = "ftp://$ServerIP/"
	
	foreach ($FilePath in $Files) {
		$FileName = Split-Path $FilePath -Leaf
		Write-Output $FileName
		
		$WebClient = New-Object System.Net.WebClient
		$WebClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
		
		Write-Output "Uploading $FileName..."
		
		$Uri = New-Object -TypeName System.Uri($FTPServer + $FileName)
		$WebClient.UploadFile($Uri, $FilePath)
		
		Write-Output 'Upload complete.'
	}
}

function Start-Tron {
	param
	(
		[Parameter(Position = 0)]
		[Alias('Flavor')]
		[String]
		$TronFlavor,
		
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[String]
		$ServerIP
	)
	
	switch ($TronFlavor) {
		'Alcha' {
			&ssh -t "alcha@$ServerIP" "sudo service TronA start"
		}
		
		'Bella' {
			&ssh -t "alcha@$ServerIP" "sudo service TronB start"
		}
		
		'Foo' {
			&ssh -t "alcha@$ServerIP" "sudo service TronC start"
		}
		
		'Kayla' {
			&ssh -t "alcha@$ServerIP" "sudo service TronD start"
		}
		
		'Ronnie' {
			&ssh -t "alcha@$ServerIP" "sudo service TronE start"
		}
		
		'Prim' {
			&ssh -t "alcha@$ServerIP" "sudo service TronF start"
		}
		
		'Raylo' {
			&ssh -t "alcha@$ServerIP" "sudo service TronG start"
		}
		
		'Utah' {
			&ssh -t "alcha@$ServerIP" "sudo service TronH start"
		}
		
		default {
			&ssh -t "alcha@$ServerIP" "sudo service Tron start"
		}
	}
}

function Stop-Tron {
	param
	(
		[Parameter(Mandatory = $false,
				   Position = 0)]
		[Alias('Flavor')]
		[String]
		$TronFlavor
	)
	
	switch ($TronFlavor) {
		'Alcha' {
			&ssh -t "alcha@$ServerIP" "sudo service TronA stop"
		}
		
		'Bella' {
			&ssh -t "alcha@$ServerIP" "sudo service TronB stop"
		}
		
		'Foo' {
			&ssh -t "alcha@$ServerIP" "sudo service TronC stop"
		}
		
		'Kayla' {
			&ssh -t "alcha@$ServerIP" "sudo service TronD stop"
		}
		
		'Ronnie' {
			&ssh -t "alcha@$ServerIP" "sudo service TronE stop"
		}
		
		'Prim' {
			&ssh -t "alcha@$ServerIP" "sudo service TronF stop"
		}
		
		'Raylo' {
			&ssh -t "alcha@$ServerIP" "sudo service TronG stop"
		}
		
		'Utah' {
			&ssh -t "alcha@$ServerIP" "sudo service TronH stop"
		}
		
		'All' {
			&ssh -t "alcha@$ServerIP" "sudo service TronA stop"
			&ssh -t "alcha@$ServerIP" "sudo service TronB stop"
			&ssh -t "alcha@$ServerIP" "sudo service TronC stop"
		}
	}
}

function Restart-Tron {
	param
	(
		[Parameter(Mandatory = $false,
				   Position = 0)]
		[Alias('Flavor')]
		[String]
		$TronFlavor
	)
	
	switch ($TronFlavor) {
		'Alcha' {
			&ssh -t "alcha@$ServerIP" "sudo service TronA restart"
		}
		
		'Bella' {
			&ssh -t "alcha@$ServerIP" "sudo service TronB restart"
		}
		
		'Foo' {
			&ssh -t "alcha@$ServerIP" "sudo service TronC restart"
		}
		
		'Kayla' {
			&ssh -t "alcha@$ServerIP" "sudo service TronD restart"
		}
		
		'Ronnie' {
			&ssh -t "alcha@$ServerIP" "sudo service TronE restart"
		}
		
		'Prim' {
			&ssh -t "alcha@$ServerIP" "sudo service TronF restart"
		}
		
		'Raylo' {
			&ssh -t "alcha@$ServerIP" "sudo service TronG restart"
		}
		
		'Utah' {
			&ssh -t "alcha@$ServerIP" "sudo service TronH restart"
		}
		
		default {
			&ssh -t "alcha@$ServerIP" "sudo service Tron restart"
		}
	}
}

function Connect-TronServer {
	param
	(
		[Parameter(Position = 0)]
		[Alias('User')]
		[String]
		$Username = 'alcha',
		
		[Parameter(Position = 1)]
		[String]
		$ServerIP,
		
		[Switch]
		$SSH,
		
		[Switch]
		$SFTP
	)
	
	if ($SSH.IsPresent) {
		&ssh "$Username@$ServerIP"
	} elseif ($SFTP.IsPresent) {
		&sftp "$Username@$ServerIP"
	} else {
		Write-Warning 'You have to enable either the SSH or SFTP switch for cmdlet to work'
	}
}

function Connect-TronBetaServer {
	param
	(
		[Parameter(Position = 0)]
		[Alias('User')]
		[String]
		$Username = 'alcha',
		
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[Alias('IP')]
		$ServerIP,
		
		[Parameter(Position = 1)]
		[Switch]
		$SSH,
		
		[Parameter(Position = 2)]
		[Switch]
		$SFTP
	)
	
	if ($SSH.IsPresent) {
		&ssh "$Username@$ServerIP"
	} elseif ($SFTP.IsPresent) {
		&sftp "$Username@$ServerIP"
	} else {
		Write-Warning 'You have to enable either the SSH or SFTP switch for cmdlet to work'
	}
}