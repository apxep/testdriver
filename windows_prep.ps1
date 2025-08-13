# Windows Ansible Managed Prep
# Enables the WinRM service and sets up the HTTP listener
Enable-PSRemoting -Force

# Opens port 5985 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5985]'
    Direction   = 'Inbound'
    DisplayName = 'Windows Remote Management (HTTP-In)'
    LocalPort   = 5985
    Profile     = 'Any'
    Protocol    = 'TCP'
}
New-NetFirewallRule @firewallParams

# Allows local user accounts to be used with WinRM
# This can be ignored if using domain accounts
$tokenFilterParams = @{
    Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Name         = 'LocalAccountTokenFilterPolicy'
    Value        = 1
    PropertyType = 'DWORD'
    Force        = $true
}
New-ItemProperty @tokenFilterParams

# Create self signed certificate
$certParams = @{
    CertStoreLocation = 'Cert:\LocalMachine\My'
    DnsName           = $env:COMPUTERNAME
    NotAfter          = (Get-Date).AddYears(1)
    Provider          = 'Microsoft Software Key Storage Provider'
    Subject           = "CN=$env:COMPUTERNAME"
}
$cert = New-SelfSignedCertificate @certParams

# Create HTTPS listener
$httpsParams = @{
    ResourceURI = 'winrm/config/listener'
    SelectorSet = @{
        Transport = "HTTPS"
        Address   = "*"
    }
    ValueSet = @{
        CertificateThumbprint = $cert.Thumbprint
        Enabled               = $true
    }
}
New-WSManInstance @httpsParams

# Opens port 5986 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]'
    Direction   = 'Inbound'
    DisplayName = 'Windows Remote Management (HTTPS-In)'
    LocalPort   = 5986
    Profile     = 'Any'
    Protocol    = 'TCP'
}
New-NetFirewallRule @firewallParams

Enable-WSManCredSSP -Role Server -Force

winget install --id Microsoft.PowerShell --source winget

New-Item -Type Directory -Path C:\Demos
                                                                                                                                                                                                                                                                                                 
$dlpath = "C:\Demos\git-install.exe"

## $source = "https://git-scm.com/download/win"
$source = "https://github.com/git-for-windows/git/releases/download/v2.49.0.windows.1/Git-2.49.0-64-bit.exe"

Start-BitsTransfer $source $dlpath

Start-Process -FilePath $dlpath -ArgumentList "/SILENT","/NORESTART","/DIR=`"C:\Program Files\Git`"" -wait -NoNewWindow

Add-WindowsFeature -Name RSAT-AD-Tools -IncludeAllSubFeature

New-ADGroup -Name "Pure Admins" -SamAccountName purestorageadmins -GroupScope Global -GroupCategory Security

New-ADUser -Name "Pat Admin" -SamAccountName padmin -AccountPassword $(ConvertTo-SecureString -String "pureuser" -AsPlainText -Force) -Enabled $true
 
Add-ADGroupMember -Members padmin purestorageadmins
 
New-ADUser -Name "Bind User" -SamAccountName binduser -AccountPassword $(ConvertTo-SecureString -String "pureuser" -AsPlainText -Force) -Enabled $true


