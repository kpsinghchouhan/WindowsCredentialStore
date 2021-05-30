<#
	.SYNOPSIS
		This command retrieves stored PSCredential from local file system.
	.DESCRIPTION
		This command retrieves stored PSCredential from local file system.
    .PARAMETER Target
		Reference name for credential.
    .PARAMETER StorePath
		Path on local file system where credential is stored.
	.EXAMPLE
		PS> $credential = Get-StoredCredential -Target "Test"
#>
function Get-StoredCredential {
    [CmdletBinding()]
    param (
        # To refer and retrieve encrypted credential
        [Parameter(Mandatory = $true)]
        [string]
        $Target,
        # Location on local system where credential is stored
        [Parameter(Mandatory = $false)]
        [string]
        $StorePath = "${Env:HOMEDRIVE}${Env:HOMEPATH}\.CredentialStore"
    )
    
    begin {
        
    }
    
    process {
        $userNameFile = Join-Path -Path $StorePath -ChildPath "${Target}.UserName.txt"
        $passwordFile = Join-Path -Path $StorePath -ChildPath "${Target}.Password.txt"
        if ((-not (Test-Path $userNameFile)) -or (-not (Test-Path $userNameFile))) {
            Write-Host "Credential not found for Target: ${Target}"
            return $null
        }
        $userName = Get-Content $userNameFile
        $password = Unprotect-CmsMessage -Path $passwordFile
        $secureStringPassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential ($userName, $secureStringPassword)
        return $credential
    }
    
    end {
        
    }
}