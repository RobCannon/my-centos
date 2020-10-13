yum -y install \
  curl \
  wget \
  telnet \
  ftp \
  bind-utils \
  traceroute \
  zip \
  unzip \
  openssl \
  gcc-c+_ \
  make \
  nano \
  python3 \
  ansible \
  docker-ce-cli

# Add repo locations for git, jq powershell, dotnetsdk, azure-cli, gcloud, nodejs
yum -y remove git
yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
sh -c 'echo -e "[google-cloud-sdk]\nname=Google Cloud SDK\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/azure-cli.repo'
curl -sL https://rpm.nodesource.com/setup_12.x | -E bash -

yum install -y \
  git \
  jq \
  powershell \
  azure-cli \
  google-cloud-sdk \
  nodejs

git config --global credential.helper store
git config --global core.autocrlf false



# dotnet tool install --global dotnet-outdated

# curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
# chmod +x /usr/bin/docker-compose

echo ''
echo '------'
echo 'Installing terraform'
# Check for new releases at https://releases.hashicorp.com/terraform/
TERRAFORM_VERSION=0.13.4
TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
curl -s -S -LO https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILE
unzip $TERRAFORM_FILE
chmod a+x terraform
mv terraform /usr/bin/terraform
chmod a+rx /usr/bin/terraform
chown root:root /usr/bin/terraform
rm $TERRAFORM_FILE
echo ''

# echo ''
# echo '------'
# echo 'Installing terraform providers'
# pushd /tmp/terraform
# terraform init -no-color
# find .terraform/plugins -mindepth 2 -type f -iname 'terraform-provider*' -exec cp -t /usr/bin '{}' +
# chmod a+rx /usr/bin/terraform-provider*
# chown root:root /usr/bin/terraform-provider*
# popd
# rm -rf /tmp/terraform


echo ''
echo '------'
echo 'Installing terraform-ls'
# Check for new releases here: https://github.com/hashicorp/terraform-ls/releases
TERRAFORM_LS_VERSION=$(curl -s -S https://api.github.com/repos/hashicorp/terraform-ls/releases/latest | jq -r '.tag_name' | grep  -oP "(?<=v)\S+")
TERRAFORM_LS_FILE="terraform-ls_${TERRAFORM_LS_VERSION}_linux_amd64.zip"
curl -s -S -LO $(curl -s -S https://api.github.com/repos/hashicorp/terraform-ls/releases/latest | jq -r ".assets[] | select(.name == \"${TERRAFORM_LS_FILE}\") | .browser_download_url")
unzip $TERRAFORM_LS_FILE
mv terraform-ls /usr/bin/terraform-ls
chmod a+rx /usr/bin/terraform-ls
chown root:root /usr/bin/terraform-ls
rm $TERRAFORM_LS_FILE
echo ''

echo ''
echo '------'
echo 'Installing packer'
# Check for new version at https://releases.hashicorp.com/packer
PACKER_VERSION=$(curl -s -S https://api.github.com/repos/hashicorp/packer/releases/latest | jq -r '.tag_name' | grep  -oP "(?<=v)\S+")
curl -s -S -L "https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip" -o packer.zip
unzip packer.zip
chmod a+x packer
mv packer /usr/bin/
chmod a+rx /usr/bin/packer
chown root:root /usr/bin/packer
rm packer.zip
# Some cracklib package started putting a symlink for another packer in the path.  Remove it
if [ -f /usr/sbin/packer ]; then unlink /usr/sbin/packer; fi
echo ''

echo ''
echo '------'
echo 'Installing kubectl'
curl -s -S -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s -S https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
mv kubectl /usr/bin/kubectl
chmod a+rx /usr/bin/kubectl
chown root:root /usr/bin/kubectl
echo ''


echo ''
echo '------'
echo 'Installing istioctl'
# Check for new release at https://github.com/istio/istio/releases
ISTIO_VERSION=$(curl -L -s https://api.github.com/repos/istio/istio/releases | grep tag_name | sed "s/ *\"tag_name\": *\"\\(.*\\)\",*/\\1/" | grep -v -E "(alpha|beta|rc)\.[0-9]$" | sort -t"." -k 1,1 -k 2,2 -k 3,3 -k 4,4 | tail -n 1)
curl -s -S -L "https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-amd64.tar.gz" -o istioctl.tar.gz
tar -xvzf istioctl.tar.gz
mv istioctl /usr/bin/istioctl
chmod a+rx /usr/bin/istioctl
chown root:root /usr/bin/istioctl
rm istioctl.tar.gz
echo ''


echo ''
echo '------'
echo 'Installing hadolint (Dockerfile linter)'
curl -s -S -LO $(curl -s -S https://api.github.com/repos/hadolint/hadolint/releases/latest | jq -r '.assets[] | select(.name == "hadolint-Linux-x86_64") | .browser_download_url')
mv hadolint-Linux-x86_64 /usr/bin/hadolint
chmod a+rx /usr/bin/hadolint
chown root:root /usr/bin/hadolint

echo ''
echo '------'
echo 'Installing powerline-go for custom prompt'
curl -s -S -LO $(curl -s -S https://api.github.com/repos/justjanne/powerline-go/releases/latest | jq -r '.assets[] | select(.name == "powerline-go-linux-amd64") | .browser_download_url')
mv powerline-go-linux-amd64 /usr/bin/powerline-go
chmod a+rx /usr/bin/powerline-go
chown root:root /usr/bin/powerline-go

echo ''
echo '------'
echo 'Installing aws-cli'
curl -s -S "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
chmod 755 -R /usr/local/aws-cli
rm awscliv2.zip
rm -rf aws
echo ''

yum clean all
