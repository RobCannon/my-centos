$ErrorActionPreference = 'Stop'
$DistroName = 'my-centos'

# Set-WslDefaultUser from:
# https://github.com/microsoft/WSL/issues/3974
Function Set-WslDefaultUser ($distro, $user) { Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq $distro | Set-ItemProperty -Name DefaultUid -Value ((wsl -d $distro -u $user -e id -u) | Out-String); };

docker build -t $DistroName .
docker run --name fs -it -d $DistroName
docker export --output "$DistroName.tar" fs
docker stop fs
docker rm fs
wsl --unregister $DistroName
wsl --import $DistroName "$env:APPDATA\$DistroName\" ".\$DistroName.tar"
Set-WslDefaultUser $DistroName $env:USERNAME
wsl -d $DistroName