<#
	.SYNOPSIS
		This command removes stored PSCredential from local file system.
	.DESCRIPTION
		This command removes stored PSCredential from local file system.
    .PARAMETER Target
		Reference name for credential.
    .PARAMETER StorePath
		Path on local file system where credential is stored.
	.EXAMPLE
		PS> Remove-StoredCredential -Target "Test"
#>
function Remove-StoredCredential {
    [CmdletBinding()]
    param (
        # To refer encrypted credential
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
        Remove-Item $userNameFile
        Remove-Item $passwordFile
    }
    
    end {
        
    }
}