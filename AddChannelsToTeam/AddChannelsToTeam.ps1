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
$ChannelHash = $null
$ChannelHash = @{}

#Get all team channels
$ChannelArr = Get-TeamChannel -GroupId $GroupId

#Optional export all channels in group to csv
#get-teamChannel -GroupId $GroupId | export-csv file.csv

#Add Team channels to hash table (User= email is key UserId is the Teams numeric identifier)
foreach($singleChannel in $ChannelArr)
{
    $ChannelHash.add($singleChannel.DisplayName, $singleChannel.MembershipType)
}

#Read csv in
$SGObjectsArray = Import-Csv $CSVPathName


#process data
$SGObjectsArray | ForEach-Object{
    $ChannelName = $_.ChannelName
    #Check if user is already in group
    if($ChannelHash.ContainsKey($ChannelName))
    {
        Write-Host "Channel already exists: " $ChannelName
    }
    else{
        Write-Host "Channel does not exist: " $ChannelName
        try{
            #Add Channel
            Add-StudentGroup-Channel -GroupId $GroupId -ChannelName $_.ChannelName
            }
        Catch
        {
            Write-Host "Error cannot add:" $ChannelName
            #Write-Host $_.ScriptStackTrace
        }        
    }
}