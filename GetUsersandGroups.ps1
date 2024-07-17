# Get the local computer's name
$computerName = $env:COMPUTERNAME

# Create an ADSI object for the local computer
$localComputer = [ADSI]"WinNT://$computerName"

# Filter and retrieve information for local user accounts
$userInfo = $localComputer.Children | Where-Object { $_.SchemaClassName -eq 'user' } | ForEach-Object {
    # Get the user's name and remove curly braces
    $userName = $_.Name[0]

    # Get the groups that the user belongs to
    $userGroups = $_.Groups() | ForEach-Object {
        # Retrieve the group names
        $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
    }

    # Create a custom object with user information
    [PSCustomObject]@{
        UserName = $userName
        Groups   = $userGroups -join ';'
    }
}

# Display the user information
$userInfo | Format-Table -AutoSize
