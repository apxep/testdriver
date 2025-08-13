Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Install-Module -Name SSHSessions -force
Import-Module SSHSessions

Install-Module -Name PureStoragePowerShellSDK2 -force
Import-Module PureStoragePowerShellSDK2

Install-Module -Name PureStoragePowerShellToolkit -force
Import-Module PureStoragePowerShellToolkit

Test-Pfa2WindowsBestPractices -Repair -IncludeIscsi -Force

Add-WindowsFeature -Name Multipath-IO 

Enable-MSDSMAutomaticClaim -BusType iSCSI

Set-Service -Name MSiSCSI -StartupType Automatic -Status Running

