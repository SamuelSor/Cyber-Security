# ================================
# SMB Signing Toggle Script
# ================================

# TOGGLE: $true = Secure (enable signing), $false = Insecure (disable)
$EnableSMBSigning = $true

function Set-SMBSigning {
    param (
        [bool]$Enable
    )

    if ($Enable) {
        Write-Host "Enabling SMB Security Signature (SECURE)..." -ForegroundColor Green
        Set-SmbServerConfiguration -RequireSecuritySignature $true -EnableSecuritySignature $true -Force
    } else {
        Write-Host "Disabling SMB Security Signature (INSECURE)..." -ForegroundColor Yellow
        Set-SmbServerConfiguration -RequireSecuritySignature $false -EnableSecuritySignature $false -Force
    }

    # Verification
    Write-Host "`nCurrent SMB Configuration:" -ForegroundColor Cyan
    Get-SmbServerConfiguration | Select RequireSecuritySignature, EnableSecuritySignature
}

Set-SMBSigning -Enable $EnableSMBSigning
