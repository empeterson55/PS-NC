########################################################################################################################
# Start of the script - Description, Requirements & Legal Disclaimer
########################################################################################################################
# Written by: Joshua Stenhouse joshuastenhouse@gmail.com
# Modified by : Marc-Andre Tanguay marcandre.tanguay@n-able.com
################################################
# Description:
# This script uses a honeypot technique to detect ransomware infections by comparing 2 files, a honeypot file and a witness file. 
# If they are different, or it has been deleted/renamed it sends an email alert.
# The script should be set to run on the file server it is checking, and set to start on boot. It will then run forever on a loop on the TestInterval defined.
# The script supports detection of ransomware that changes the file data as well as changing the file extension.
################################################ 
# Legal Disclaimer:
# This script is written by Joshua Stenhouse is not supported under any support program or service. 
# All scripts are provided AS IS without warranty of any kind. 
# The author further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
# The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. 
# In no event shall its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if the author has been advised of the possibility of such damages.

########################################################################################################################
# Nothing to configure below this line - Starting the main function of the script
########################################################################################################################
################################################
# Honeypot File and Email Settings
################################################

$HoneypotDir = "C:\Users"
$HoneypotWitenessDir = "C:\ProgramData"
$HoneypotFile = "HoneypotFile.docx" 

# Setting the HoneyPot file to be the witness
$HoneypotWitnessFile = $HoneypotFile
# Getting computer name
$HostName = $env:computername

#IF FIRST RUN, DOWNLOAD THE HONEYPOT FILES
$regkey = Test-Path -Path "HKLM:\SOFTWARE\MSP"
$firstrun = $True
if($regkey -eq $True )
{
    $mspvals = get-item -path "HKLM:\software\MSP"
    foreach($mspval in $mspvals)
    {
        if($mspval.Property -eq "RansomwareDetect")
        {
            $firstrun = $False
        }
    }
}
else
{
    New-Item -Path "HKLM:\SOFTWARE\MSP"
}
if($firstrun -eq $True)
{
    "First Run. Downloading HoneyPot File"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("https://files.n-able.com/NRCNable/media/RequiredFiles/HoneypotFile.docx","$HoneypotDir\HoneypotFile.docx")
    copy-item -Path $HoneypotDir\HoneypotFile.docx $HoneypotWitenessDir\HoneypotFile.docx -Force 
    New-ItemProperty -Path "HKLM:\SOFTWARE\MSP" -Name "RansomwareDetect" -Value "1"
}


################################################
# Step 1 - Checking if File exists
################################################
# Testing to see if file exists first, the extension may of changed or it may have been deleted
$TestHoneypotPath = Test-Path "$HoneypotDir\$HoneypotFile"
$TestHoneypotPath2 = Test-Path "$HoneypotWitenessDir\$HoneypotFile"
################################################
# Step 2 - If file doesn't exist, has an encrypted file been put in it's place?
################################################
IF ($TestHoneypotPath -eq $False )
{
    # Getting most oldest written file in the directory, as any ransom note is likely newer
    $HoneyPotFileFound = Get-ChildItem $HoneypotDir | Sort {$_.LastWriteTime} | Select Name -ExpandProperty Name -First 1
    # Selecting write time
    $HoneyPotFileLastWriteTime = Get-ChildItem "$HoneypotDir\$HoneyPotFileFound" | Select -ExpandProperty lastwritetime
    # Finding owner to try identify patient 0
    $HoneyPotFileOwner = Get-ACL "$HoneypotDir\$HoneyPotFileFound" | Select -ExpandProperty owner
    # Creating email body
    $EmailBody = "FileFound: $HoneyPotFileFound
    Expecting: $HoneypotFile
    Folder: $HoneypotDir
    Server: $HostName
    Modified: $HoneyPotFileLastWriteTime
    Owner: $HoneyPotFileOwner
   Honeypot file $HoneypotDir\$HoneypotFile on $HostName has been deleted or file extension changed.
    Found $HoneyPotFileFound instead, modified by $HoneyPotFileOwner @ $HoneyPotFileLastWriteTime indicating a possbile ransomware infection."

    $HPFileStatus="Honeypot file $HoneypotDir\$HoneypotFile on $HostName has been deleted or file extension changed."
    $DetectStatus="Found $HoneyPotFileFound instead, modified by $HoneyPotFileOwner @ $HoneyPotFileLastWriteTime indicating a possbile ransomware infection."
    # Outputting to screen
 #   Write-Host $EmailBody
}
elseif($TestHoneypotPath2 -eq $False)
{
    # Getting most oldest written file in the directory, as any ransom note is likely newer
    $HoneyPotFileFound = Get-ChildItem $HoneypotWitenessDir | Sort {$_.LastWriteTime} | Select Name -ExpandProperty Name -First 1
    # Selecting write time
    $HoneyPotFileLastWriteTime = Get-ChildItem "$HoneypotWitenessDir\$HoneyPotFileFound" | Select -ExpandProperty lastwritetime
    # Finding owner to try identify patient 0
    $HoneyPotFileOwner = Get-ACL "$HoneypotWitenessDir\$HoneyPotFileFound" | Select -ExpandProperty owner
    # Creating email body
    $EmailBody = "FileFound: $HoneyPotFileFound
    Expecting: $HoneypotFile
    Folder: $HoneypotWitenessDir
    Server: $HostName
    Modified: $HoneyPotFileLastWriteTime
    Owner: $HoneyPotFileOwner
   Honeypot file $HoneypotWitenessDir\$HoneypotFile on $HostName has been deleted or file extension changed.
    Found $HoneyPotFileFound instead, modified by $HoneyPotFileOwner @ $HoneyPotFileLastWriteTime indicating a possbile ransomware infection."

    $HPFileStatus="Honeypot file $HoneypotWitenessDir\$HoneypotFile on $HostName has been deleted or file extension changed."
    $DetectStatus="Found $HoneyPotFileFound instead, modified by $HoneyPotFileOwner @ $HoneyPotFileLastWriteTime indicating a possbile ransomware infection."
    # Outputting to screen
 #   Write-Host $EmailBody
}
################################################
# Step 3 - If the Honeypot file does exist running a comparison of the Honeypot and witness files
################################################

IF ($TestHoneypotPath -eq $True)
{
    # File found so comparing files
    Try
    {
        # If file is currently being encrypted the get-content can fail, so adding try command with a wait
        $ReadHoneypotFile = Get-Content "$HoneypotDir\$HoneypotFile"
    }
    Catch
    {
        Sleep 10
        $ReadHoneypotFile = Get-Content "$HoneypotDir\$HoneypotFile"
    }
}
else
{
    $ReadHoneypotFile = "NOFILE"
}

if($TestHoneypotPath2 -eq $True)
{
    Try
    {
        # If file is currently being encrypted the get-content can fail, so adding try command with a wait
        $ReadHoneypotWitenessFile = Get-Content "$HoneypotWitenessDir\$HoneypotFile"
    }
    Catch
    {
        Sleep 10
        $ReadHoneypotWitenessFile = Get-Content "$HoneypotWitenessDir\$HoneypotFile"
    }    
    # Reading witness file
}
else
{
    $ReadHoneypotWitenessFile = "NOFILE"

}

# Comparing files to check for modifications

    IF (Compare-Object $ReadHoneypotFile $ReadHoneypotWitenessFile){$HoneypotFileAltered = $TRUE}Else{$HoneypotFileAltered = $FALSE}
################################################
# Step 4 - If the Honeypot and witness files do not match
################################################
IF ($HoneypotFileAltered -eq $TRUE)
{
    IF ($TestHoneypotPath -eq $True)
    {
        $HoneyPotFileLastWriteTime = Get-ChildItem "$HoneypotDir\$HoneypotFile" | Select -ExpandProperty lastwritetime
        $HoneyPotFileOwner = Get-ACL "$HoneypotDir\$HoneypotFile" | Select -ExpandProperty owner
    }
    else
    {
        $HoneyPotFileLastWriteTime = "File Not Present"
        $HoneyPotFileOwner = "File Not Present"
    }
    # Creating email subject
    $EmailBody = "WitnessFile: $HoneypotWitenessDir\$HoneypotWitnessFile
    HoneypotFile: $HoneypotDir\$HoneypotFile
    FileAltered: $HoneypotFileAltered
    Server: $HostName
    Modified: $HoneyPotFileLastWriteTime
    Owner: $HoneyPotFileOwner
    Honeypot file $HoneypotDir\$HoneypotFile on $HostName has been modified and no longer matches the original.
    Modified by $HoneyPotFileOwner @ $HoneyPotFileLastWriteTime indicating a possbile ransomware infection."

    $HPFileStatus="Honeypot file $HoneypotDir\$HoneypotFile on $HostName has been modified and no longer matches the original."
    $DetectStatus="Modified by $HoneyPotFileOwner @ $HoneyPotFileLastWriteTime indicating a possbile ransomware infection."

    # Outputting to screen
#    Write-Host $EmailBody
}
################################################
# Step 5 - If the Honeypot and witness files MATCH then no ransomware infection detected and script loops to the start where it sleeps for the $TestInterval
################################################
# if the files were found and do match
IF ($HoneypotFileAltered -eq $FALSE)
{
# Files do match, repeating test in 
$EmailBody = "WitnessFile: $HoneypotWitenessDir\$HoneypotWitnessFile
HoneypotFile: $HoneypotDir\$HoneypotFile
FileFound: $TestHoneypotPath
FileAltered: $HoneypotFileAltered
No ransomware infection detected"

$HPFileStatus="No ransomware infection detected"
$DetectStatus="No ransomware infection detected"

#write-host $EmailBody
}
# End of Honeypot File does exist below
# End of Honeypot File does exist above
################################################
# End of script
################################################



 "State of the Honeypot Files: " + $HPFileStatus
 "Detection Status Details: " + $DetectStatus
 "Output Details: " + $EmailBody
