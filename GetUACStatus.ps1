function Get-UACStatus {
    $regKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    $regValue = 'EnableLUA'

    if (Test-Path $regKey) {
        $uacStatus = (Get-ItemProperty -Path $regKey -Name $regValue).$regValue
        if ($uacStatus -eq 0) {
            Write-Output "UAC is Disabled"
        }
        elseif ($uacStatus -eq 1) {
            Write-Output "UAC is Enabled"
        }
        else {
            Write-Output "Unable to determine UAC status"
        }
    }
    else {
        Write-Output "UAC is Enabled (Default)"
    }
}

Get-UACStatus
