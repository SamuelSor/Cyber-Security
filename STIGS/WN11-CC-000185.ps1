<#
.SYNOPSIS
    This PowerShell script disables any printing with HTTP connections

.NOTES
    Author          : Samuel Sorto
    LinkedIn        : linkedin.com/in/SamuelSorto
    GitHub          : github.com/samuelsor
    Date Created    : 2026-06-03
    Last Modified   : 2026-05-03
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-CC-000197/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
#>

# Define the registry path and values
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\
$valueName = "NoAutorun"
$valueData = 1

if(-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null

}

#Set DisableHTTPPrinting to value
New-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -PropertyType DWord -Force

#Confirm completion
Write-Host "Registry value '$valueName' set to '$valueData' at '$registryPath'"
