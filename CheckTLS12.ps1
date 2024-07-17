$protocols = [enum]::GetNames([System.Net.SecurityProtocolType])
    if($protocols -match "Tls12")
    {
        Write-Host "TLS 1.2 available on this system"
        $statusTLS12 = 0	
    }   
	else {
	Write-Host "TLS 1.2 not available on this system" 
	$statusTLS12 = 1
}
