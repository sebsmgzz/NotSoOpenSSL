# ============================
# Author: Sebastián M. Gzz.
# Description: Creates a certificate.
# Created: September 06, 2021
# ============================
<#
    .SYNOPSIS
    Creates a certificate using openssl.
    .DESCRIPTION
    Creates a certificate using openssl.
    .PARAMETER Name
    The naming used for the certificate.
    .PARAMETER SignRequest
    When present, the generated certificate will actually be a certificate sign request.
    .PARAMETER NoOut
    When present, the generated certificate will not be prompted.
    .INPUTS
    None
    .OUTPUTS
    None
    .EXAMPLE
    PS> Create-Certifciate -Name "root" -SignRequest
#>
param(
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [Switch]$SignRequest = $false,
    [Parameter(Mandatory=$false)]
    [Switch]$NoOut = $false
)

# Resolve paths
$dataDir = "data"
$workDir = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$type = if($SignRequest) { "req" } else { "cer" }
$configPath = [IO.Path]::Combine($workDir, $dataDir, $Name, "$Name.$type.json")
$keyPath = [IO.Path]::Combine($workDir, $dataDir, $Name, "$Name.key")
$certPath = [IO.Path]::Combine($workDir, $dataDir, $Name, "$Name.$type")

# Verify config exists, if so, read it
if( !(Test-Path $configPath) ) {
    throw [System.IO.FileNotFoundException]::new("Configuration file $configPath not found.")
}
$config = Get-Content -Raw -Path $configPath | ConvertFrom-Json

# Create subject
$c = $config.subject.countryCode
$st = $config.subject.state
$l = $config.subject.locality
$o = $config.subject.organization
$ou = $config.subject.organizationalUnit
$cn = $config.subject.commonName
$emailAddress = $config.subject.emailAddress
$subject = "/emailAddress=$emailAddress/C=$c/ST=$st/L=$l/O=$o/OU=$ou/CN=$cn"

# Create the certificate and log contents
if($SignRequest) {
    openssl req -new -sha256 -key $keyPath -out $certPath -subj $subject
} else {
    openssl req -x509 -new -sha256 -key $keyPath -days $config.days -out $certPath -subj $subject
}

# Log contents 
if($NoOut) {
    Write-Host "Certificate generated at $certPath"
} else {
    if($SignRequest) {
        openssl req -noout -text -in $certPath
    } else {
        openssl x509 -noout -text -in $certPath
    }
}
