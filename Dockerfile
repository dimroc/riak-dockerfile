# Pull base image.
FROM dockerfile/ubuntu

# Install and setup project dependencies
RUN sudo apt-get update && \
      sudo apt-get install -y curl lsb-release supervisor openssh-server

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN locale-gen en_US en_US.UTF-8

RUN \
  wget http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.1/ubuntu/precise/riak_1.3.1-1_amd64.deb && \
  sudo dpkg -i riak_1.3.1-1_amd64.deb

RUN sed -i.bak 's/127.0.0.1/0.0.0.0/' /etc/riak/app.config
#RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
#RUN echo 'ListenAddress 0.0.0.0' >> /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose Riak Protocol Buffers and HTTP interfaces, along with SSH
EXPOSE 8087 8098

#RUN echo 'root:basho' | chpasswd

CMD ["/usr/bin/supervisord"]
