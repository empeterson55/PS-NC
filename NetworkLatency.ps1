#Powershell Script to check network latency to a given hostname 
#User must input only HostName 

$HName = Read-Host "Please Input HostName"
$localobj = ping $HName
$i=4
while ($i -gt 0) {
$localobj[$_.Length - $i]
$i = $i -1 }
sleep(3)
Read-Host "press any key to EXIT"
