echo ''
echo '------'
echo 'Copy .profile'
curl -L https://github.com/RobCannon/my-centos/raw/master/.bashrc -o ~/.bashrc
echo ''

echo ''
echo '------'
echo 'Configure git'
git config --global user.name "Rob Cannon"
git config --global user.email "rob.cannon@equifax.com"
git config --global credential.helper store
echo ''

# echo ''
# echo '------'
# echo 'Linking .shh keys'
# if [ -d ~/.ssh ]; then
#     rm -rf ~/.ssh
# fi
# ln -s $USERPROFILE/.ssh ~/.ssh

gcloud config set project iaas-platf-svcs-npe-4be3
gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b

source ~/.bash_profile
echo ''
echo '------'
echo 'Boxstarter complete'
