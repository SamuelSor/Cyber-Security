# ============================================
# RDP NLA Toggle Script (with verification)
# ============================================

# TOGGLE: $true = Secure (NLA enabled), $false = Insecure (NLA disabled)
$EnableNLA = $true

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"

function Set-RDPNLA {
    param (
        [bool]$Enable
    )

    if ($Enable) {
        Write-Host "Enabling RDP Network Level Authentication (SECURE)..." -ForegroundColor Green
        Set-ItemProperty -Path $RegPath -Name "UserAuthentication" -Value 1 -Force
    } else {
        Write-Host "Disabling RDP Network Level Authentication (INSECURE)..." -ForegroundColor Yellow
        Set-ItemProperty -Path $RegPath -Name "UserAuthentication" -Value 0 -Force
    }

    # Verification
    Write-Host "`nVerifying setting..." -ForegroundColor Cyan
    $result = Get-ItemProperty -Path $RegPath -Name "UserAuthentication"

    if ($result.UserAuthentication -eq 1) {
        Write-Host "Result: SECURE (UserAuthentication = 1)" -ForegroundColor Green
    } elseif ($result.UserAuthentication -eq 0) {
        Write-Host "Result: INSECURE (UserAuthentication = 0)" -ForegroundColor Red
    } else {
        Write-Host "Unexpected value detected: $($result.UserAuthentication)" -ForegroundColor Magenta
    }
}

Set-RDPNLA -Enable $EnableNLA
