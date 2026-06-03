<#
.SYNOPSIS
    This PowerShell script disables Windows Game Recording and Broadcasting

.NOTES
    Author          : Samuel Sorto
    LinkedIn        : linkedin.com/in/SamuelSorto
    GitHub          : github.com/samuelsor
    Date Created    : 2026-06-03
    Last Modified   : 2026-06-03
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000252
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-CC-000252/

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
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"

if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set AllowGameDVR to Disabled (0)
New-ItemProperty `
    -Path $RegistryPath `
    -Name "AllowGameDVR" `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

Write-Host "AllowGameDVR has been set to 0." -ForegroundColor Green
