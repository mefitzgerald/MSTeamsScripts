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
        Write-Host $_.ScriptStackTrace
    }
}

#Set-up your user variables ONLY CHANGE THESE LINES
$GroupId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
$CSVPathName = "StudentGroups.csv"

#Set-up and connect Teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams

#Read csv in
$SGObjectsArray = Import-Csv $CSVPathName

#process data
$SGObjectsArray | ForEach-Object{
    Write-Host "Attempting to create channel:" $_.GroupName
    try{
        #Add Channel
        Add-StudentGroup-Channel -GroupId $GroupId -ChannelName $_.GroupName
        }
    Catch
    {
        Write-Host "Error"
        Write-Host $_.ScriptStackTrace
    }
}