<#
	.SYNOPSIS
		This command creates a new document encryption certificate.
	.DESCRIPTION
		This command creates a new document encryption certificate.
	.PARAMETER DnsName
		DnsName to use when creating certificate.
	.EXAMPLE
		PS> New-EncryptionCertificate -DnsName "kpsinghchouhan"
#>
function New-EncryptionCertificate {
    [CmdletBinding()]
    param (
        # Name for certificate
        [Parameter(Mandatory = $true)]
        [string]
        $DnsName
    )
    
    begin {
        
    }
    
    process {
        $encryptionCertificate = Get-ChildItem "Cert:\CurrentUser\My" | Where-Object { $_.Subject -eq "CN=${DnsName}" }
        if ($null -ne $encryptionCertificate) {
            Write-Host "Document encryption certificate already exists with DnsName: ${DnsName}"
            Write-Host $encryptionCertificate
            return
        }
        $params = @{
            DnsName = $DnsName
            CertStoreLocation = "Cert:\CurrentUser\My"
            KeyUsage = @("KeyEncipherment", "DataEncipherment", "KeyAgreement")
            Type = "DocumentEncryptionCert"
        }
        try {
            New-SelfSignedCertificate @params
        }
        catch {
            Write-Error "Error creating new document encryption certificate"
        }
    }
    
    end {
        
    }
}