#Detects the uptime of a computer on my network
# Runs on Windows 7,8

Try
{
	If($args.count -eq 0) {	
		$Computer = "." }
	Else { 
		$Computer = $args[0] }  
	$ErrorActionPreference = "Stop" 
	$LBootTime = (Get-WmiObject Win32_OperatingSystem -ComputerName $Computer ).LastBootUpTime
	$UpTime = (New-TimeSpan ([System.Management.ManagementDateTimeconverter]::ToDateTime($LBootTime)) (Get-Date)) 
	Switch ($UpTime) { 
		{$_.days -eq 0}    {$Days="00:"} 
		{$_.days -gt 1}    {$Days=[string]$_.days + ":"} 
		{$_.hours -eq 0}   {$Hrs="00:"} 
		{$_.hours -gt 1}   {$Hrs=[string]$_.hours + ":"} 
		{$_.Minutes -eq 0} {$Mins="00:"} 
		{$_.Minutes -gt 1} {$Mins=[string]$_.minutes + ":"} 
		{$_.Seconds -eq 0} {$Secs="00:"} 
		{$_.Seconds -gt 1} {$Secs=[string]$_.seconds + " "} 
	} 
	"System Uptime is $Days$Hrs$Mins$Secs [dd:hh:mm:ss]"
	Write-Host ("Script Check Passed")
	Exit 0
}
Catch {
	Write-Host ("Script Check Failed")
	Exit 1001
}
