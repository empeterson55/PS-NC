$raidvalues = get-wmiobject -class win32_systemdriver | where-object {$_.displayname -like "*mraid*"}
Write-Host "Raid Config Status is " $raidvalues.Status
Sleep(7)
