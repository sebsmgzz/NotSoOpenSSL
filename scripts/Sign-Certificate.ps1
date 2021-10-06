# ============================
# Author: Sebastián M. Gzz.
# Description: Signs a certificate request with a ca certificate.
# Created: September 06, 2021
# ============================
<#
    .SYNOPSIS
    Signs a certificate request with a certificate by using openssl.
    .DESCRIPTION
    Signs a certificate request with a certificate by using openssl.
    .PARAMETER CaName
    The naming used for the ca certificate.
    .PARAMETER ReqName
    The naming used for the certificate request.
    .PARAMETER Days
    The amount of days the signature will be valid.
    .PARAMETER NoOut
    When present, the generated key will not be prompted.
    .INPUTS
    None
    .OUTPUTS
    None
    .EXAMPLE
    PS> Sign-Certificate -CaName "root" -ReqName "leaf" -Days 365
#>
param(
    [Parameter(Mandatory=$true)]
    [String]$CaName,
    [Parameter(Mandatory=$true)]
    [String]$ReqName,
    [Parameter(Mandatory=$true)]
    [Int]$Days,
    [Parameter(Mandatory=$false)]
    [Switch]$NoOut = $false
)

# Resolve paths
$dataDir = "data"
$workDir = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$configPath = [IO.Path]::Combine($workDir, $dataDir, $CaName, "$CaName.cer.json")
$caSrlPath = [IO.Path]::Combine($workDir, $dataDir, $CaName, "$CaName.srl")
$caCertPath = [IO.Path]::Combine($workDir, $dataDir, $CaName, "$CaName.cer")
$caKeyPath = [IO.Path]::Combine($workDir, $dataDir, $CaName, "$CaName.key")
$reqCertPath = [IO.Path]::Combine($workDir, $dataDir, $ReqName, "$ReqName.req")
$cerCertPath = [IO.Path]::Combine($workDir, $dataDir, $ReqName, "$ReqName.cer")

# Verify config exists, if so, read it
if( !(Test-Path $configPath) ) {
    throw [System.IO.FileNotFoundException]::new("Configuration file $configPath not found.")
}
$config = Get-Content -Raw -Path $configPath | ConvertFrom-Json

# Sign the certificate
openssl x509 -req -sha256 -days $Days -in $reqCertPath -CA $caCertPath -CAkey $caKeyPath -CAcreateserial -out $cerCertPath

# Log it
if($NoOut) {
    Write-Host "Signed successfully"
} else {
    openssl x509 -noout -text -in $cerCertPath
}

# Update signatures
$config.signatures += @{ }
$index = $config.signatures.GetUpperBound(0)
$serial = Get-Content $caSrlPath
$config.signatures[$index].to = $ReqName
$config.signatures[$index].days = $Days
$config.signatures[$index].at = [Math]::Round($(Get-Date -UFormat %s))
$config.signatures[$index].serial = $serial.toString()
$config | ConvertTo-Json | Set-Content $configPath
