
$EnGbDefaultFile = "en-gb-default.reg"
$EnGbWelcomeFile = "en-gb-welcome.reg"

$DefaultHKEY = "HKU\DEFAULT_USER"
$DefaultRegPath = "C:\Users\Default\NTUSER.DAT"
Set-Culture en-GB 
Set-WinSystemLocale en-GB
Set-WinHomeLocation -GeoId 242 
Set-WinUserLanguageList en-GB -Force
Set-TimeZone "GMT Standard Time"

#Write-Host "Setting Time zone to GMT Standard Time"
#tzutil /s "GMT Standard Time"

Write-Host "Loading registry keys: [$DefaultHKEY] and [$DefaultRegPath]"
$RegStatus = reg load $DefaultHKEY $DefaultRegPath
Write-Host "Importing en-gb-default.reg"
$RegStatus += reg import $EnGbDefaultFile 
Write-Host "Unloading [$DefaultHKEY]"
$RegStatus += reg unload $DefaultHKEY 
Write-Host "Importing en-gb-welcome.reg"
$RegStatus += reg import $EnGbWelcomeFile 
$RegStatus
Start-Sleep -Seconds 5
