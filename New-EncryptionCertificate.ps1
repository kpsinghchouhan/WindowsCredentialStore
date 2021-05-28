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
        $params = @{
            DnsName = $DnsName
            CertStoreLocation = "Cert:\CurrentUser\My"
            KeyUsage = @("KeyEncipherment", "DataEncipherment", "KeyAgreement")
            Type = "DocumentEncryptionCert"
        }
        New-SelfSignedCertificate @params
    }
    
    end {
        
    }
}