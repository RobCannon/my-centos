param( [Parameter(Mandatory = $true)][System.Security.SecureString] $SecurePassword)

$ErrorActionPreference = 'Stop'

# Set-WslDefaultUser from:
# https://github.com/microsoft/WSL/issues/3974

# See build results at
# https://github.com/RobCannon/my-centos/actions

$PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
Function Set-WslDefaultUser ($distro, $user) { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); };

docker pull docker.pkg.github.com/robcannon/my-centos/my-centos:master
docker run --name wsl --hostname WSL -it -d docker.pkg.github.com/robcannon/my-centos/my-centos:master
docker export --output my-centos.tar wsl
docker stop wsl
docker rm wsl
wsl --unregister my-centos
wsl --import my-centos "$env:APPDATA\my-centos\" .\my-centos.tar
wsl -d my-centos -u root -- printf '[automount]\nroot = /\noptions = "metadata"' ^> /etc/wsl.conf
wsl -d my-centos -u root -- useradd --create-home --shell /bin/bash --groups wheel --password $(wsl -d my-centos -u root -- openssl passwd -crypt $PlainTextPassword) $env:USERNAME

Set-WslDefaultUser my-centos $env:USERNAME
wsl -d my-centos -- sh -c "`$(curl -fsSL https://github.com/RobCannon/my-centos/raw/master/setup.sh)"
wsl -d my-centos