FROM centos:7

RUN yum -y install sudo \
    git \
    curl \
    unzip; yum clean all;

# RUN git config --global credential.helper store
# RUN git config --global core.autocrlf false

# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
# RUN apt-get install -y nodejs
# RUN npm install -g npm npm-check-updates tldr @angular/cli

# RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
# RUN dpkg -i packages-microsoft-prod.deb
# RUN rm packages-microsoft-prod.deb
# RUN apt-get update
# RUN apt-get install -y powershell

# RUN curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# RUN chmod +x /usr/local/bin/docker-compose

# RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
# RUN chmod +x ./kubectl
# RUN mv ./kubectl /usr/local/bin/kubectl

# RUN curl -L https://git.io/get_helm.sh | bash
# RUN helm init --client-only

# ENV TERRAFORM_VERSION=0.12.9
# ENV TERRAFORM_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
# RUN curl -LO https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFORM_FILE
# RUN unzip $TERRAFORM_FILE
# RUN rm $TERRAFORM_FILE
# RUN mv terraform /usr/local/bin/

# ENV AZ_REPO=$(lsb_release -cs)
# RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
#     tee /etc/apt/sources.list.d/azure-cli.list
# RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl -o /etc/apt/sources.list.d/microsoft.list https://packages.microsoft.com/config/ubuntu/16.04/prod.list
# RUN apt-get update
# RUN apt-get install azure-cli

# RUN apt-get install -y dotnet-sdk-3.0
# RUN dotnet tool install --global dotnet-outdated

# RUN curl -O https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
# RUN chmod +x prettyping
# RUN mv prettyping /usr/local/bin/


RUN curl -L https://github.com/justjanne/powerline-go/releases/download/v1.15.0/powerline-go-linux-amd64 --output ~/powerline-go
RUN chmod +x ~/powerline-go
RUN mv ~/powerline-go /usr/local/bin/powerline-go

RUN yum clean all

RUN useradd -ms /bin/bash rob
RUN usermod -aG wheel rob
RUN sudo chown -R rob /home/rob

USER rob

CMD ["bash"]