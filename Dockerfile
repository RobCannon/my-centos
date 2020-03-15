FROM centos:7

RUN yum -y install sudo \
    git \
    curl \
    wget \
    unzip \
    nano \
    python3 \
    openssl

RUN git config --global credential.helper store
RUN git config --global core.autocrlf false


RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo
RUN yum install -y powershell

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

# ENV AZ_REPO=$(lsb_release -cs)
# RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
#     tee /etc/apt/sources.list.d/azure-cli.list
# RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
# RUN apt-get update
# RUN apt-get install azure-cli

# RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
# RUN yum -y install dotnet-sdk-3.1
# RUN dotnet tool install --global dotnet-outdated

RUN curl -L https://github.com/justjanne/powerline-go/releases/download/v1.15.0/powerline-go-linux-amd64 --output ~/powerline-go
RUN chmod +x ~/powerline-go
RUN mv ~/powerline-go /usr/local/bin/powerline-go

RUN sudo hostname WSL

RUN yum clean all

CMD ["bash"]