FROM centos:7

# Look for installation possibilities here
# https://github.com/actions/virtual-environments/blob/master/images/linux/Ubuntu1804-README.md

RUN yum -y install sudo \
    git \
    curl \
    wget \
    telnet \
    ftp \
    bind-utils \
    traceroute \
    zip \
    unzip \
    jq \
    nano \
    python3 \
    openssl

RUN git config --global credential.helper store
RUN git config --global core.autocrlf false

# Add repo locations for powershell, dotnetsdk, azure-cli, gcloud
RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo
RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
RUN sh -c 'echo -e "[google-cloud-sdk]\nname=Google Cloud SDK\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/azure-cli.repo'

RUN yum install -y \
    powershell \
    azure-cli \
    google-cloud-sdk

# RUN dotnet tool install --global dotnet-outdated

# RUN curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# RUN chmod +x /usr/local/bin/docker-compose

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# RUN curl -L https://git.io/get_helm.sh | bash
# RUN helm init --client-only

ENV TERRAFORM_VERSION=0.12.23
ENV TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
RUN curl -LO https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILE
RUN unzip $TERRAFORM_FILE
RUN mv terraform /usr/local/bin/
RUN rm $TERRAFORM_FILE


RUN curl -L https://github.com/justjanne/powerline-go/releases/download/v1.15.0/powerline-go-linux-amd64 --output ~/powerline-go
RUN chmod +x ~/powerline-go
RUN mv ~/powerline-go /usr/local/bin/powerline-go

RUN yum clean all

CMD ["bash"]