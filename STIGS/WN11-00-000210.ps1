<#
.SYNOPSIS
    This PowerShell script disables any bluetooth connections on the device

.NOTES
    Author          : Samuel Sorto
    LinkedIn        : linkedin.com/in/SamuelSorto
    GitHub          : github.com/samuelsor
    Date Created    : 2026-06-03
    Last Modified   : 2026-06-03
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000210
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-00-000210/

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
$RegistryPath = "HKLM:\\SOFTWARE\Microsoft\PolicyManager\current\device\Connectivity"

if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set AllowBluetooth to Disabled (0)
New-ItemProperty `
    -Path $RegistryPath `
    -Name "AllowBluetooth" `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

Write-Host "AllowBluetooth has been set to 0." -ForegroundColor Green
