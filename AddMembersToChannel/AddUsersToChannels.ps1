function Add-Users-To-Channel
{
    param($GroupId, $ChannelName, $ChannelMember)

    try{
        Add-TeamChannelUser -GroupId $GroupId -DisplayName $ChannelName -User $ChannelMember
    }
    Catch
    {
        Write-Host "Error adding user to channel: " $ChannelMember
        #Write-Host $_.ScriptStackTrace
    }
}

#Set-up your user variables ONLY CHANGE THESE LINES
$GroupId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
$CSVPathName = "XXXXXXXXXX.csv"

#Set-up and connect Teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams

#Read csv in
$SGObjectsArray = Import-Csv $CSVPathName


#process data
$SGObjectsArray | ForEach-Object{
    #For my purposes I'm working with a csv file with 2-3 students on single row
    Write-Host "Attempting to add student1 email:" $_.Member1Email $_.ChannelName
    Add-Users-To-Channel -GroupId $GroupId -ChannelName $_.ChannelName -ChannelMember $_.Member1Email

    #Add next student to the group
    Write-Host "Attempting to add student2 email:" $_.Member2Email $_.ChannelName
    Add-Users-To-Channel -GroupId $GroupId -ChannelName $_.ChannelName -ChannelMember $_.Member2Email

    #There may not be a 3rd member so we need to check before we attempt to add 
    if ([string]::IsNullOrEmpty($_.Member3Email))
    {
        Write-Host "Channel Group only has 2 members"
    }
    else
    {
        Write-Host "Attempting to add student3 email:" $_.Member3Email $_.ChannelName
        Add-Users-To-Channel -GroupId $GroupId -ChannelName $_.ChannelName -ChannelMember $_.Member3Email
    }
}