FROM debian

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (SSH, curl, Node.js for Localtunnel)
RUN apt update && apt upgrade -y && apt install -y \
    ssh wget curl unzip vim python3 \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt install -y nodejs

# Install Localtunnel globally
RUN npm install -g localtunnel

# Setup SSH (allow root login and set the password)
RUN mkdir /run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo root:dark | chpasswd

# Expose necessary ports
EXPOSE 22

# Setup the entrypoint script to run both SSH and Localtunnel
RUN echo '#!/bin/bash \n\
    /usr/sbin/sshd -D & \n\
    lt --port 22 --subdomain my-unique-subdomain' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Run the entrypoint script
CMD ["/entrypoint.sh"]
