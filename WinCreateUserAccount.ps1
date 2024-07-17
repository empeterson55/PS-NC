$computername = $env:computername   # place computername here for remote access
#Define Old Admin Account
$oldusername = 'OldAdmin'
#Define New Admin Account
$username = 'localadmin'
$password = 'AdminPassword'
$desc = 'Help Desk Local Admin Account'
$computer = [ADSI]"WinNT://$computername,computer"
#Create User And Set Password and Properties
$user = $computer.Create("user", $username)
$user.SetPassword($password)
$user.Setinfo()
$user.description = $desc
$user.setinfo()
$user.UserFlags = 65536
$user.SetInfo()
#Add User to Group
$group = [ADSI]("WinNT://$computername/administrators,group")
$group.add("WinNT://$username,user")
#Remove Old USer from Group
$group.remove("WinNT://$oldusername,user")
Clear-Host
Write-Output "Script Completed"
