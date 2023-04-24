Get-AppxPackage -AllUsers | where-object {$_.Name -notlike "*store*"} | Remove-AppxPackage
```
Get-Service | where-object {$_.StartType -eq "Automatic" -and $_.Name -notlike "*Windows*Update*"} | Stop-Service -PassThru | Set-Service -StartupType Disabled
```
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
```
$proceed = Read-Host "Press Y to proceed to remove Microsoft Store, Onedrive, Get Help and Bing Weather apps (Y/N)"

if ($proceed -eq "Y") {
    Get-AppxPackage Microsoft.WindowsStore, Microsoft.SkypeApp, Microsoft.MixedReality.Portal, Microsoft.GetHelp, Microsoft.BingWeather | Remove-AppxPackage
} else {
    Write-Host "Operation cancelled by user."
}

$proceed = Read-Host "Press Y to proceed to remove the Onedrive app. (Y/N)"

if ($proceed -eq "Y") {
    Get-AppxPackage Microsoft.OneDrive | Remove-AppxPackage
```
} else {
    Write-Host "Operation cancelled by user."
}

