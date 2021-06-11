function Add-StudentGroup-Channel
{
    param($GroupId, $ChannelName)

    try{
        Write-Host "Creating Channel: " $ChannelName
        New-TeamChannel -GroupId $GroupId -DisplayName $ChannelName -MembershipType Private
    }
    Catch
    {
        Write-Host "Error adding channel: " $ChannelName
        #Write-Host $_.ScriptStackTrace
    }
}

#Set-up your user variables ONLY CHANGE THESE LINES
$GroupId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
$CSVPathName = "StudentGroups.csv"

#Set-up and connect Teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams

#Create user hash table to check against
#First create empty Hash table
$ChannelHash = $null
$ChannelHash = @{}

#Get all team channels
$ChannelArr = Get-TeamChannel -GroupId $GroupId

$ChannelArr.Count

#Add Team channels to hash table (User= email is key UserId is the Teams numeric identifier)
foreach($singleMember in $AllMembersArray)
{
    $ChannelArr.add($ChannelArr., $singleMember.DisplayName)
}

#Read csv in
$SGObjectsArray = Import-Csv $CSVPathName

#process data
$SGObjectsArray | ForEach-Object{
    #Add-StudentGroup-Channel -GroupId $GroupId -ChannelName $_.GroupName
}