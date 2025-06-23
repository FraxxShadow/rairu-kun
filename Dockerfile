FROM debian

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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

# Run SSH and Localtunnel to expose the SSH port to the outside world
CMD /usr/sbin/sshd -D & lt --port 22 --subdomain my-unique-subdomain
