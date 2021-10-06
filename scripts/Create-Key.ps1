# ============================
# Author: Sebastián M. Gzz.
# Description: Creates a key.
# Created: September 06, 2021
# ============================
<#
    .SYNOPSIS
    Creates a key using openssl.
    .DESCRIPTION
    Creates a key using openssl.
    .PARAMETER Name
    The naming used for the key.
    .PARAMETER NoOut
    When present, the generated key will not be prompted.
    .INPUTS
    None
    .OUTPUTS
    None
    .EXAMPLE
    PS> Create-Key -Name "root" -NoOut
#>
param(
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [Switch]$NoOut = $false
)

# Resolve paths
$dataDir = "data"
$workDir = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$configPath = [IO.Path]::Combine($workDir, $dataDir, $Name, "$Name.key.json")
$keyPath = [IO.Path]::Combine($workDir, $dataDir, $Name, "$Name.key")

# Verify config exists, if so, read it
if( !(Test-Path $configPath) ) {
    throw [System.IO.FileNotFoundException]::new("Configuration file $configPath not found.")
}
$config = Get-Content -Raw -Path $configPath | ConvertFrom-Json

# Create the key
openssl ecparam -genkey -name $config.ellipticCurve -out $keyPath

# Log contents 
if($NoOut) {
    Write-Host "Key generated at $keyPath"
} else {
    openssl ecparam -noout -text -in $keyPath
}
