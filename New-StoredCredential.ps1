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
        if (-not (Test-Path $StorePath) ) {
            New-Item -Path $StorePath -ItemType "Directory"
        }
    }
    
    process {
        $userNameFile = Join-Path -Path $StorePath -ChildPath "${Target}.UserName.txt"
        $passwordFile = Join-Path -Path $StorePath -ChildPath "${Target}.Password.txt"
        Set-Content -Path $userNameFile -Value $Credential.UserName
        $password = "$($Credential.GetNetworkCredential().Password)"
        $password | Protect-CmsMessage -To "cn=$EncryptionCertificateName" -OutFile $passwordFile
    }
    
    end {
        
    }
}