
$xmlStr = @"
<gs:GlobalizationServices xmlns:gs="urn:longhornGlobalizationUnattend"> 
<!-- user list --> 
<gs:UserList>
    <gs:User UserID="Current" CopySettingsToDefaultUserAcct="true" CopySettingsToSystemAcct="true"/> 
</gs:UserList>

<gs:UserLocale> 
    <gs:Locale Name="en-GB" SetAsCurrent="true" ResetAllSettings="true"/> 
</gs:UserLocale>

<!-- system locale -->
<gs:SystemLocale Name="en-GB"/>

<gs:LocationPreferences> 
    <gs:GeoID Value="242"/> 
</gs:LocationPreferences>

<gs:MUILanguagePreferences>
	<gs:MUILanguage Value="en-GB"/>
	<gs:MUIFallback Value="en-US"/>
</gs:MUILanguagePreferences>

<gs:InputPreferences>
    <gs:InputLanguageID Action="add" ID="0809:00000809" Default="true"/>
</gs:InputPreferences>

</gs:GlobalizationServices>
"@
$outFile = "C:\Windows\Temp\Lng.xml"
$xmlStr | Out-File $outFile -Force -Encoding ascii

# Use this copy settings to system and default user 
control.exe "intl.cpl,,/f:""$($outFile)"""

$lng = "en-GB"
$location = 242

Set-WinSystemLocale $lng
Set-WinHomeLocation $location

$lngList = New-WinUserLanguageList $lng
$lngList.Add("en-US")
Set-WinUserLanguageList $lngList -Force
Set-WinUILanguageOverride $lng
Set-TimeZone "GMT Standard Time"

Start-sleep -Seconds 30
Restart-Computer