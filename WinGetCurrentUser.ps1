$Computer = $env:COMPUTERNAME
$processinfo = @(Get-WmiObject -class win32_process -ComputerName $Computer) 
    if ($processinfo)
    {     
        $processinfo | Foreach-Object {$_.GetOwner().User} |  
        Where-Object {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} | 
        Sort-Object -Unique | 
        ForEach-Object { New-Object psobject -Property @{Computer=$Computer;LoggedOn=$_} } |  
        fl Computer,LoggedOn
    }
exit 0
