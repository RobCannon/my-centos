FROM centos:7

# Look for installation possibilities here
# https://github.com/actions/virtual-environments/blob/master/images/linux/Ubuntu1804-README.md

COPY install-tools.sh ./install-tools.sh
RUN chmod +x ./install-tools.sh && \
  ./install-tools.sh && \
  rm ./install-tools.sh

CMD ["bash"]