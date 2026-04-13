# ================================
# Guest Account Management Script
# ================================

# -------- TOGGLES (EDIT THESE) --------
# Set to $true to ADD Guest to Administrators, $false to REMOVE
$AddGuestToAdmins = $false

# Set to $true to ENABLE Guest account, $false to DISABLE
$EnableGuestAccount = $false


# -------- FUNCTION: Manage Admin Group --------
function Set-GuestAdminMembership {
    param (
        [bool]$AddToAdmins
    )

    if ($AddToAdmins) {
        Write-Host "Adding Guest to Administrators group..." -ForegroundColor Green
        try {
            net localgroup Administrators Guest /add
            Write-Host "Guest successfully added to Administrators." -ForegroundColor Green
        } catch {
            Write-Host "Error adding Guest to Administrators: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Removing Guest from Administrators group..." -ForegroundColor Yellow
        try {
            net localgroup Administrators Guest /delete
            Write-Host "Guest successfully removed from Administrators." -ForegroundColor Green
        } catch {
            Write-Host "Error removing Guest from Administrators: $_" -ForegroundColor Red
        }
    }
}


# -------- FUNCTION: Enable/Disable Guest --------
function Set-GuestAccountStatus {
    param (
        [bool]$EnableAccount
    )

    if ($EnableAccount) {
        Write-Host "Enabling Guest account..." -ForegroundColor Green
        try {
            net user Guest /active:yes
            Write-Host "Guest account enabled." -ForegroundColor Green
        } catch {
            Write-Host "Error enabling Guest account: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Disabling Guest account..." -ForegroundColor Yellow
        try {
            net user Guest /active:no
            Write-Host "Guest account disabled." -ForegroundColor Green
        } catch {
            Write-Host "Error disabling Guest account: $_" -ForegroundColor Red
        }
    }
}


# -------- EXECUTION --------
Write-Host "`n=== Guest Account Configuration Script ===`n" -ForegroundColor Cyan

Set-GuestAdminMembership -AddToAdmins $AddGuestToAdmins
Set-GuestAccountStatus -EnableAccount $EnableGuestAccount

Write-Host "`n=== Script Complete ===" -ForegroundColor Cyan
