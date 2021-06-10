#Set-up your user variables ONLY CHANGE THESE LINES
$GroupId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
$CSVPathName = "ClassParticipants.csv"

#Set-up and connect Teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams

#Create user hash table to check against
#First create empty Hash table
$UserHash = $null
$UserHash = @{}

#Request array of Team members from Teams (So we don't try to add team members already in Team)
$AllMembersArray = Get-TeamUser -GroupId $GroupId

#Add Team members to hash table (User= email is key UserId is the Teams numeric identifier)
foreach($singleMember in $AllMembersArray)
{
    $UserHash.add($singleMember.User, $singleMember.DisplayName)
}

#Read csv in
$ChannelObjectsArray = Import-Csv $CSVPathName

#process csv data
$ChannelObjectsArray | ForEach-Object{
    #Set student email variable
    $StudentEmail = $_.StudentEmail
    Write-Host "Attempting to add New Team Member:" $StudentEmail

    #Check if user is already in group
    if($UserHash.ContainsKey($StudentEmail))
    {
        Write-Host "User is already Team Member: " $StudentEmail
    }
    else{
        Write-Host "Team member not in group: " $StudentEmail
        try{
            #Add users
            Add-TeamUser -GroupId $GroupId -User $StudentEmail
            }
        Catch
        {
            Write-Host "Error cannot add $StudentEmail"
            #Write-Host $_.ScriptStackTrace
        }        
    }
}
