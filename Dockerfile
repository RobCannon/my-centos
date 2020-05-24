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
  openssl \
  gcc-c+_ \
  make \
  jq \
  nano \
  python3 \
  ansible \
  docker-ce-cli

# Add repo locations for git, powershell, dotnetsdk, azure-cli, gcloud, nodejs
RUN sudo yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm \
  curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo; \
  rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm; \
  rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
  sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'; \
  sh -c 'echo -e "[google-cloud-sdk]\nname=Google Cloud SDK\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/azure-cli.repo' \
  curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -

RUN yum install -y \
  git \
  powershell \
  azure-cli \
  google-cloud-sdk \
  nodejs

RUN git config --global credential.helper store
RUN git config --global core.autocrlf false


RUN npm install -g cdk8s-cli

# RUN dotnet tool install --global dotnet-outdated

# RUN curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# RUN chmod +x /usr/local/bin/docker-compose

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl

# https://github.com/hashicorp/terraform/releases
ARG TERRAFORM_VERSION=0.12.23
ARG TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
RUN curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_FILE}" && \
  unzip $TERRAFORM_FILE && \
  mv terraform /usr/local/bin/ && \
  rm $TERRAFORM_FILE

# https://packer.io/downloads.html
ARG PACKER_VERSION=1.5.4
ARG PACKER_FILE="packer_${PACKER_VERSION}_linux_amd64.zip"
RUN curl -s -LO "https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_FILE}" && \
  unzip $PACKER_FILE && \
  chmod a+x packer && \
  sudo mv packer /usr/local/bin/packer && \
  rm $PACKER_FILE

# https://github.com/helm/helm/releases
ARG HELM_VERSION=3.1.2
ARG HELM_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN curl -s -LO https://get.helm.sh/$HELM_FILE && \
  tar -xvzf $HELM_FILE linux-amd64/helm --strip-components 1 && \
  chmod a+x helm && \
  mv helm /usr/local/bin/helm && \
  rm $HELM_FILE

# https://github.com/istio/istio/releases
ARG ISTIO_VERSION=1.5.0
ARG ISTIO_FILE="istioctl-${ISTIO_VERSION}-linux.tar.gz"
RUN curl -s -LO "https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/${ISTIO_FILE}" && \
  tar -xvzf $ISTIO_FILE && \
  chmod a+x istioctl && \
  mv istioctl /usr/local/bin/istioctl && \
  rm $ISTIO_FILE

# https://github.com/justjanne/powerline-go/releases
ARG POWERLINE_GO_VERSION=1.15.0
RUN curl -L "https://github.com/justjanne/powerline-go/releases/download/v${POWERLINE_GO_VERSION}/powerline-go-linux-amd64" --output ~/powerline-go && \
  chmod +x ~/powerline-go && \
  mv ~/powerline-go /usr/local/bin/powerline-go

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" --output "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  chmod 755 -R /usr/local/aws-cli && \
  rm awscliv2.zip && \
  rm -rf aws

RUN curl "https://amazon-eks.s3-us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator" --output aws-iam-authenticator && \
  chmod a+x aws-iam-authenticator && \
  mv aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN yum clean all

CMD ["bash"]