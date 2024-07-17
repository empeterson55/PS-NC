$sOsVer = (Get-CimInstance Win32_OperatingSystem).version

# Define the API endpoint URL
$apiEndpoint = "https://endoflife.date/api/windows.json"

# Use the Invoke-RestMethod cmdlet to call the API and retrieve the JSON response
$jsonResponse = Invoke-RestMethod -Uri $apiEndpoint

$sosexpiry =""

# Loop through each key-value pair in the JSON response and output the information
foreach ($item in $jsonResponse) 
{
    if($item.latest -eq $sOsVer )
    {
     #   "FOUND IT"
     #   $item.cycle
     #   $item.eol
     #   $item.latest
     #   $item.link
     #   $item.lts
     #   $item.releaseDate
     #   $item.support
        $sosName = $item.cycle
        $sosexpiry = $item.support
        $releasedate = $item.releaseDate
        $sossupportsite= $item.link
        $soseol = $item.eol

    }


}

if($sosexpiry -ne "")
{
#    "Information found"
    "Detected OS Version : " + $sOsVer + " - Windows " + $sosName
    "Support Expiry Date : " + $sosexpiry 
    "EOL Date : " + $soseol
    "Released OS Version DAte : " + $releasedate
    "Link to get more information : " + $sossupportsite

    $datenow = get-date
    $dateleft = [datetime]$sosexpiry - $datenow
    "Days left on support : " + [math]::round($dateleft.totaldays,0)
    $datelefteol = [datetime]$soseol - $datenow
    "Days left before EOL : " + [math]::round($dateleft.totaldays,0)

 $osname = $sOsVer + " - Windows " + $sosName
 $osexpiry = $sosexpiry 
 $osreleaseddate = $releasedate
 $oseol = $soseol
 $ossupportsite = $sossupportsite
 $osexpirydays = [math]::round($dateleft.totaldays,0)
 $oseoldays = [math]::round($datelefteol.totaldays,0)
}
else
{
 $osname = $sOsVer 
 $osexpiry = "OS Not Detected in endoflife.date api"
 $osreleaseddate = "OS Not Detected in endoflife.date api"
 $oseol = "OS Not Detected in endoflife.date api"
 $ossupportsite = "OS Not Detected in endoflife.date api"
 $osexpirydays = -10000
 $oseoldays = -10000	
}
