$path = Split-Path -parent $PSCommandPath
$TempKey= "HKU\TEMP"
$DefaultRegPath = "C:\Users\Default\NTUSER.DAT"
REG LOAD $TempKey $DefaultRegPath
Get-ChildItem $path -Filter *.reg | % {
    Start-Process regedit -ArgumentList "/s `"$($_.FullName)`"" -Wait
}
REG UNLOAD $TempKey

Set-WinSystemLocale en-GB
Set-WinUserLanguageList -LanguageList en-GB -Force
Set-Culture -CultureInfo en-GB
Set-WinHomeLocation -GeoId 242
Set-TimeZone "GMT Standard Time"
Set-InputLocale:en-GB
Set-WinUILanguageOverride -Language en-GB

Start-sleep -Seconds 30
Restart-Computer