FROM debian

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (SSH, curl, Tailscale, etc.)
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

# Script to start sshd and tailscaled
RUN echo '#!/bin/bash\n\
# Start Tailscale\n\
tailscaled &\n\
# Wait for tailscaled to initialize\n\
sleep 5\n\
# Bring up Tailscale\n\
tailscale up --authkey tskey-auth-kuhrouL5b511CNTRL-7H2iAEgaizWu6QoWcUc31Xpy9hWJKhgQA --hostname "my-unique-vps"\n\
# Start SSH\n\
/usr/sbin/sshd -D' > /start.sh

# Make the script executable
RUN chmod +x /start.sh

# Default command to start everything
CMD ["/start.sh"]
