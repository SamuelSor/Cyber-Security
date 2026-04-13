# ============================================
# LM Compatibility Level Toggle Script
# ============================================

# TOGGLE:
# $true  = Secure (recommended level 5)
# $false = Insecure (level 0 - LM allowed)
$SecureLMLevel = $true

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"

function Set-LMCompatibility {
    param (
        [bool]$Secure
    )

    if ($Secure) {
        Write-Host "Setting LMCompatibilityLevel to 5 (SECURE)..." -ForegroundColor Green
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel /t REG_DWORD /d 5 /f
    } else {
        Write-Host "Setting LMCompatibilityLevel to 0 (INSECURE)..." -ForegroundColor Yellow
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LmCompatibilityLevel /t REG_DWORD /d 0 /f
    }

    # Verification
    Write-Host "`nCurrent LMCompatibilityLevel:" -ForegroundColor Cyan
    Get-ItemProperty -Path $RegPath -Name "LmCompatibilityLevel"
}

Set-LMCompatibility -Secure $SecureLMLevel
