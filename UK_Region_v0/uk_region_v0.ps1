param(
    [string]$lng = "en-GB"
)

if (-not [System.Environment]::Is64BitProcess)
{
    Write-Host "Not 64-bit process. Restart in 64-bit environment"

     # start new PowerShell as x64 bit process, wait for it and gather exit code and standard error output
    $sysNativePowerShell = "$($PSHOME.ToLower().Replace("syswow64", "sysnative"))\powershell.exe"

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $sysNativePowerShell
    $pinfo.Arguments = "-ex bypass -file `"$PSCommandPath`""
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.CreateNoWindow = $true
    $pinfo.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null

    $exitCode = $p.ExitCode

    $stderr = $p.StandardError.ReadToEnd()

    if ($stderr) { Write-Error -Message $stderr }

    exit $exitCode
}

Start-Transcript -Path "C:\Windows\Temp\SetLanguage.log" | Out-Null

#$lng = "en-GB"
$outFile = "C:\Windows\Temp\Lng.xml"
#https://docs.microsoft.com/en-au/windows/desktop/Intl/table-of-geographical-locations
$location = 242

Write-Host "Set language: $lng"
Write-Host "Language file: $outFile"

Set-WinSystemLocale $lng

Write-Host "Set location: $location"
Set-WinHomeLocation $location

$lngList = New-WinUserLanguageList $lng
# Add any additional keyboards
#$lngList.Add("en-US")
Set-WinUserLanguageList $lngList -Force
Set-WinUILanguageOverride $lng

$xmlStr = @"
<gs:GlobalizationServices xmlns:gs="urn:longhornGlobalizationUnattend"> 

<gs:UserList>
    <gs:User UserID="Current" CopySettingsToDefaultUserAcct="true" CopySettingsToSystemAcct="true"/> 
</gs:UserList>

<gs:UserLocale> 
    <gs:Locale Name="en-GB" SetAsCurrent="true"/> 
</gs:UserLocale>

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

$xmlStr | Out-File $outFile -Force -Encoding ascii

# Use this copy settings to system and default user 
Write-Host "Copy language settings with control.exe"
control.exe "intl.cpl,,/f:""$($outFile)"""

Set-TimeZone "GMT Standard Time"

Stop-Transcript | Out-Null
Start-sleep -Seconds 30
Restart-Computer