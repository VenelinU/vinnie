Set-WinUserLanguageList -LanguageList en-GB -Force
Set-Culture -CultureInfo en-GB
Set-WinAcceptLanguageFromLanguageListOptOut -OptOut $True
Set-WinCultureFromLanguageListOptOut -OptOut $True
Set-WinDefaultInputMethodOverride -InputTip "0809:00000809"
Set-WinHomeLocation -GeoId 242
Set-WinSystemLocale -SystemLocale en-GB
Set-WinUILanguageOverride -Language en-GB
$UserLanguageList = New-WinUserLanguageList -Language en-GB
Set-WinUserLanguageList -LanguageList $UserLanguageList -Force
#Set-InputLocale:en-GB
Set-TimeZone "GMT Standard Time"

#Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $False

Start-sleep -Seconds 30
Restart-Computer