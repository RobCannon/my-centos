$ErrorActionPreference = 'Stop'
$DistroName = 'my-centos'

# Set-WslDefaultUser from:
# https://github.com/microsoft/WSL/issues/3974
Function Set-WslDefaultUser ($distro, $user) { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); };

docker pull docker.pkg.github.com/robcannon/$DistroName/$($DistroName):master
docker run --name wsl -it -d docker.pkg.github.com/robcannon/$DistroName/$($DistroName):master
docker export --output "$DistroName.tar" wsl
docker stop wsl
docker rm wsl
wsl --unregister $DistroName
wsl --import $DistroName "$env:APPDATA\$DistroName\" ".\$DistroName.tar"
Set-WslDefaultUser $DistroName $env:USERNAME
wsl -d $DistroName -u root -- printf '[automount]\nroot = /\noptions = "metadata"' ^> /etc/wsl.conf
wsl -d $DistroName -u root -- useradd --create-home --shell /bin/bash --groups wheel --password $(openssl passwd -crypt default) $env:USERNAME
wsl -d $DistroName -- sh -c "`$(curl -fsSL https://github.com/RobCannon/my-centos/raw/master/setup.sh)"
wsl -d $DistroName