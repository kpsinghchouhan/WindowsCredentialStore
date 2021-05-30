<#
	.SYNOPSIS
		This command stores a PSCredential on local file system.
	.DESCRIPTION
		This command stores a a PSCredential on local file system.
        UserName is stored in plain text format while Password is
        encrypted using document encryption certificate.
	.PARAMETER Credential
		Credential to store on local file system.
    .PARAMETER EncryptionCertificateName
		Document encryption certificate to use for encryption.
    .PARAMETER Target
		Reference name for credential.
    .PARAMETER StorePath
		Path on local file system where credential will be stored.
	.EXAMPLE
		PS> $credential = Get-Credential
            New-StoredCredential -Credential $credential -EncryptionCertificateName "kpsinghchouhan" -Target "Test"
#>
function New-StoredCredential {
    [CmdletBinding()]
    param (
        # Credential to be stored
        [Parameter(Mandatory = $true)]
        [pscredential]
        $Credential,
        # Certificate name for certificate used for encryption
        [Parameter(Mandatory = $true)]
        [string]
        $EncryptionCertificateName,
        # To refer and retrieve encrypted credential
        [Parameter(Mandatory = $true)]
        [string]
        $Target,
        # Location on local system where credential will be stored
        [Parameter(Mandatory = $false)]
        [string]
        $StorePath = "${Env:HOMEDRIVE}${Env:HOMEPATH}\.CredentialStore"
    )
    
    begin {
        
    }
    
    process {
        if (-not (Test-Path $StorePath) ) {
            New-Item -Path $StorePath -ItemType "Directory"
        }
        $encryptionCertificate = Get-ChildItem "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=${DnsName}" }
        if ($null -eq $encryptionCertificate) {
            Write-Error "Document encryption certificate does not exist with name: ${EncryptionCertificateName}"
            return
        }
        $userNameFile = Join-Path -Path $StorePath -ChildPath "${Target}.UserName.txt"
        $passwordFile = Join-Path -Path $StorePath -ChildPath "${Target}.Password.txt"
        Set-Content -Path $userNameFile -Value $Credential.UserName
        $password = "$($Credential.GetNetworkCredential().Password)"
        $password | Protect-CmsMessage -To "cn=$EncryptionCertificateName" -OutFile $passwordFile
    }
    
    end {
        
    }
}