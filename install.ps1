param( [Parameter(Mandatory = $true)][System.Security.SecureString] $SecurePassword)

$ErrorActionPreference = 'Stop'

# Set-WslDefaultUser from:
# https://github.com/microsoft/WSL/issues/3974

# See build results at
# https://github.com/RobCannon/my-centos/actions

$PlainTextPassword = ConvertFrom-SecureString -SecureString $SecurePassword -AsPlainText

Function Set-WslDefaultUser ($distro, $user) { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); };

$distributionUri = Invoke-RestMethod -uri  https://api.github.com/repos/RobCannon/my-centos/releases/latest | Select-Object -ExpandProperty assets | Select-Object -expand browser_download_url
Write-Host "Downloading release from $distributionUri"
Invoke-WebRequest $distributionUri -OutFile .\my-centos.tar.gz -UseBasicParsing
7z.exe x -bd .\my-centos.tar.gz

Write-Host "Registering distribution"
wsl --unregister my-centos
wsl --import my-centos "$env:APPDATA\my-centos\" .\my-centos.tar
Remove-Item .\my-centos.tar
Remove-Item .\my-centos.tar.gz

Write-Host "Setting up user"
wsl -d my-centos -u root -- printf '[automount]\nroot = /\noptions = "metadata"' ^> /etc/wsl.conf
wsl -d my-centos -u root -- useradd --create-home --shell /bin/bash --groups wheel --password $(wsl -d my-centos -u root -- openssl passwd -crypt $PlainTextPassword) $env:USERNAME
wsl --terminate my-centos

Set-WslDefaultUser my-centos $env:USERNAME
wsl --setdefault my-centos

Write-Host "Running personalization"
wsl -- sh -c "`$(curl -fsSL https://github.com/RobCannon/my-centos/raw/master/boxstarter.sh)"
wsl