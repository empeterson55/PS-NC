#Script uninstalls  a hypothetical software program on local or remote computer .
#Not Tested

Try {
    If($args.count -eq 0) 
		{$Comp=$(Get-WmiObject Win32_Computersystem).name}
	Else 
		{$Comp = $args[0]} 
    $SoftName = "Soft Name" # for example Windows Live Family Safety
	$objProduct = Get-WmiObject -ComputerName $Comp -Class Win32_Product -filter "Name='$SoftName'" 
	If ($objProduct -eq $null) {
		Write-Host "$SoftName wasn't found on $Comp" 
		Exit 1001 }
	Else { 
		$objProduct | ForEach-Object {
			$RV = $_.Uninstall() }
		$RValue = $RV.ReturnValue
		If($RValue -eq 0) {
			Write-Host "Successfully uninstalled $SoftName  from $Comp" }
		Else {
			Write-Host "Failed to uninstall $SoftName from $Comp"
			Exit 1001 }
		}
	Write-Host  "Script Check passed"
	Exit 0
	}
Catch {
	write-host  "Script Check Failed"
	Exit 1001
    }
