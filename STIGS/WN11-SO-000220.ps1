<#
.SYNOPSIS
    This PowerShell script disables any printing with HTTP connections

.NOTES
    Author          : Samuel Sorto
    LinkedIn        : linkedin.com/in/SamuelSorto
    GitHub          : github.com/samuelsor
    Date Created    : 2026-06-03
    Last Modified   : 2026-06-03
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000220
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-SO-000220/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
#>

# Define the registry path and values
# Create the registry path if it does not already exist
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"

if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set NtlmMinServerSec to Enabled (1) STILL NEEDS TESTING
New-ItemProperty `
    -Path $RegistryPath `
    -Name "NtlmMinServerSec" `
    -PropertyType DWord `
    -Value 537395200 `
    -Force | Out-Null

Write-Host "NtlmMinServerSec has been set to 1." -ForegroundColor Green
