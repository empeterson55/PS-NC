Try {
	If($args.count -eq 2) { 
		Write-Host "Please Input User Name of Account you want delete." 
		Exit 1001
		} 
	Else{
		$UA = $args[0]
		$cmd = "net user " + $UA + " /del"
		Invoke-Expression $cmd
		Write-Host  "Script Check passed"
		Exit 0 
		}
}
Catch {
	write-host  "Script Check Failed"
	Exit 1001 
}
