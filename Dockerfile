FROM debian

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (SSH, curl, Tailscale)
RUN apt update && apt upgrade -y && apt install -y \
    ssh wget curl unzip vim python3 \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt install -y nodejs \
    && curl -fsSL https://tailscale.com/install.sh | sh

# Setup SSH (allow root login and set the password)
RUN mkdir /run/sshd \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo root:dark | chpasswd

# Expose necessary ports
EXPOSE 22

# Start SSH and Tailscale to expose SSH securely via private network
CMD /usr/sbin/sshd -D & tailscale up --authkey tskey-auth-kuhrouL5b511CNTRL-7H2iAEgaizWu6QoWcUc31Xpy9hWJKhgQA --hostname "my-unique-vps"
