FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    openssh-client ssh net-tools iputils-ping \
    sudo curl man-db vim-tiny passwd less

# clean up
RUN apt-get -qq clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create vagrant user
RUN useradd --create-home -s /bin/bash vagrant && \
    echo -n 'vagrant:vagrant' | chpasswd && \
    echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant && \
    chmod 440 /etc/sudoers.d/vagrant

# prompt
RUN echo 'export PS1="🐳 \e[0;34m$DOCKER_CONTAINER_NAME\e[0m \w # "' > /home/vagrant/.profile

# add ssh keys
RUN mkdir -p /home/vagrant/.ssh && \
    chmod 700 /home/vagrant/.ssh

ADD https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant /home/vagrant/.ssh/id_rsa
ADD https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub /home/vagrant/.ssh/id_rsa.pub

RUN cp /home/vagrant/.ssh/id_rsa.pub /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant:vagrant /home/vagrant/.ssh && \
    chmod 700 /home/vagrant/.ssh && \
    chmod 600 /home/vagrant/.ssh/authorized_keys && \
    sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers && \
    sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config && \
    sed -i -e 's/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config && \
    sed -i -e 's/.*RSAAuthentication.*/RSAAuthentication yes/g' /etc/ssh/sshd_config && \
    sed -i -e 's/.*PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config && \
    sed -i -e 's/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/g' /etc/ssh/ssh_config && \
    mkdir /var/run/sshd

# open needed ports
EXPOSE 22

# # Run the init daemon
# VOLUME [ "/sys/fs/cgroup" ]
# CMD ["/usr/sbin/init"]

# ssh deamon
CMD ["/usr/sbin/sshd", "-D"]
